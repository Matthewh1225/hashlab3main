with Ada.Direct_IO;
with Ada.Numerics.Discrete_Random;
with Ada.Text_IO; use Ada.Text_IO;
with Hash_Type;

package body Hash_Table is

   package Int_IO is new Ada.Text_IO.Integer_IO(Integer);

   subtype Slot_Index is Positive range 1 .. Table_Size;
   subtype Offset_Range is Integer range 1 .. Table_Size;

   package Relative_File_IO is new Ada.Direct_IO(Hash_Record);
   Hash_File    : Relative_File_IO.File_Type;
   File_Is_Open : Boolean := False;

   package Probe_Offsets is new Ada.Numerics.Discrete_Random(Offset_Range);
   Probe_Generator : Probe_Offsets.Generator;

   Empty_Key    : constant String(1 .. 16) := (others => ' ');
   Empty_Record : constant Hash_Record :=
     (Stored_Key => Empty_Key,
      Initial_Hash_Index => 0,
      Probe_Count => 0);

   Active_Probe_Method  : Probe_Method := Linear;
   Active_Hash_Function : Hash_Function_Type := Original_Hash;
   Active_Storage_Mode  : Storage_Mode := Relative_File;

   Memory_Table : array (Slot_Index) of Hash_Record := (others => Empty_Record);

   procedure Initialize_Relative_File is
   begin
      if File_Is_Open then
         Relative_File_IO.Close(Hash_File);
         File_Is_Open := False;
      end if;

      Relative_File_IO.Create(Hash_File, Relative_File_IO.Inout_File, "hash_table.dat");
      File_Is_Open := True;
      for Slot in Slot_Index loop
         Relative_File_IO.Write(Hash_File, Empty_Record);
      end loop;
      Relative_File_IO.Reset(Hash_File, Relative_File_IO.Inout_File);
   end Initialize_Relative_File;

   function Is_Empty(Slot_Value : Hash_Record) return Boolean is
   begin
      return Slot_Value.Stored_Key = Empty_Key;
   end Is_Empty;

   function Next_Slot(Current_Slot : Slot_Index) return Slot_Index is
   begin
      if Active_Probe_Method = Linear then
         return Slot_Index((Current_Slot mod Table_Size) + 1);
      else
         return Slot_Index(((Current_Slot + Probe_Offsets.Random(Probe_Generator) - 1) mod Table_Size) + 1);
      end if;
   end Next_Slot;

   function Hash_Function(Key_Value : String) return Slot_Index is
      Base_Value : Integer;
   begin
      case Active_Hash_Function is
         when Original_Hash =>
            Base_Value := Hash_Type.BurrisHash(Key_Value);
         when Pair_Hash =>
            Hash_Type.Pair_Hash(Key_Value, Base_Value);
      end case;

      return Slot_Index((abs(Base_Value) mod Table_Size) + 1);
   end Hash_Function;

   procedure Read_Slot(Slot : Slot_Index; Data : out Hash_Record) is
   begin
      if Active_Storage_Mode = Relative_File then
         Relative_File_IO.Set_Index(Hash_File, Relative_File_IO.Positive_Count(Slot));
         Relative_File_IO.Read(Hash_File, Data);
      else
         Data := Memory_Table(Slot);
      end if;
   end Read_Slot;

   procedure Write_Slot(Slot : Slot_Index; Data : Hash_Record) is
   begin
      if Active_Storage_Mode = Relative_File then
         Relative_File_IO.Set_Index(Hash_File, Relative_File_IO.Positive_Count(Slot));
         Relative_File_IO.Write(Hash_File, Data);
      else
         Memory_Table(Slot) := Data;
      end if;
   end Write_Slot;

   procedure Set_Hash_Function(hash_func : Hash_Function_Type) is
   begin
      Active_Hash_Function := hash_func;
   end Set_Hash_Function;

   procedure Set_Storage_Mode(mode : Storage_Mode) is
   begin
      if Active_Storage_Mode = Relative_File and mode = Main_Memory then
         Close_Table;
      end if;
      Active_Storage_Mode := mode;
   end Set_Storage_Mode;

   procedure Set_Probe_Method(method : Probe_Method) is
   begin
      Active_Probe_Method := method;
      Probe_Offsets.Reset(Probe_Generator);
   end Set_Probe_Method;

   procedure Create_Table is
   begin
      if Active_Storage_Mode = Relative_File then
         Initialize_Relative_File;
      else
         for Slot in Slot_Index loop
            Memory_Table(Slot) := Empty_Record;
         end loop;
      end if;
   end Create_Table;

   procedure Insert_Key(Key_Value : String) is
      Initial_Slot : constant Slot_Index := Hash_Function(Key_Value);
      Current_Slot : Slot_Index := Initial_Slot;
      Probes_Taken : Integer := 1;
      Slot_Data    : Hash_Record;
   begin
      loop
         Read_Slot(Current_Slot, Slot_Data);
         exit when Is_Empty(Slot_Data);

         Probes_Taken := Probes_Taken + 1;
         Current_Slot := Next_Slot(Current_Slot);
      end loop;

      Slot_Data.Stored_Key := Key_Value;
      Slot_Data.Initial_Hash_Index := Integer(Initial_Slot);
      Slot_Data.Probe_Count := Probes_Taken;
      Write_Slot(Current_Slot, Slot_Data);
   end Insert_Key;

   function Search_Key(Key_Value : String) return Integer is
      Current_Slot : Slot_Index := Hash_Function(Key_Value);
      Slot_Data    : Hash_Record;
   begin
      for Probes in 1 .. Table_Size loop
         Read_Slot(Current_Slot, Slot_Data);

         if Slot_Data.Stored_Key = Key_Value or else Is_Empty(Slot_Data) then
            return Probes;
         end if;

         Current_Slot := Next_Slot(Current_Slot);
      end loop;

      return Table_Size;
   end Search_Key;

   procedure Dump_Table(header : String) is
         Slot_Data   : Hash_Record;
         Print_Limit : constant Integer := Integer'Min(Table_Size, 128);
         subtype Output_Slots is Slot_Index
            range Slot_Index'First .. Slot_Index(Print_Limit);
   begin
      Put_Line("=== " & header & " ===");
      Put_Line("Hash      Contents at          Original hash    Final hash    Number of probes");
      Put_Line("address   the address          address          address       to store/retrieve");
      Put_Line("--------------------------------------------------------------------------------");

      for Slot_Number in Output_Slots loop
         Read_Slot(Slot_Number, Slot_Data);

         Int_IO.Put(Slot_Number, Width => 4);
         Put("      ");

         if Is_Empty(Slot_Data) then
            Put("                    ");
         else
            Put(Slot_Data.Stored_Key);
            Put("    ");
         end if;

         if Is_Empty(Slot_Data) then
            Put("                 ");
         else
            Int_IO.Put(Slot_Data.Initial_Hash_Index, Width => 4);
            Put("             ");
         end if;

         if Is_Empty(Slot_Data) then
            Put("              ");
         else
            Int_IO.Put(Slot_Number, Width => 4);
            Put("          ");
         end if;

         if not Is_Empty(Slot_Data) then
            Int_IO.Put(Slot_Data.Probe_Count, Width => 4);
         end if;

         New_Line;
      end loop;
      New_Line;
   end Dump_Table;

   procedure Close_Table is
   begin
      if File_Is_Open then
         Relative_File_IO.Close(Hash_File);
         File_Is_Open := False;
      end if;
   end Close_Table;

end Hash_Table;