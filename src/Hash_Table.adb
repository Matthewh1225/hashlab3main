with Ada.Numerics.Discrete_Random;
with Ada.Text_IO; use Ada.Text_IO;
with Better_Hash;

package body Hash_Table is
   
   package Int_IO is new Ada.Text_IO.Integer_IO(Integer);
   
   -- Random number generator for random probing
   subtype Offset_Range is Integer range 1 .. Table_Size;
   package Random_Offset is new Ada.Numerics.Discrete_Random(Offset_Range);
   use Random_Offset;
   
   Probe_Generator : Generator;
   Table_File : File_Type;
   Memory_Table : array (1 .. Table_Size) of Hash_Record;
   File_Cache : array (1 .. Table_Size) of Hash_Record;
   Cache_Is_Loaded : Boolean := False;
   Active_Probe_Method : Probe_Method := Linear;
   Active_Hash_Function : Hash_Function_Type := Original_Hash;
   Active_Storage_Mode : Storage_Mode := Relative_File;
   File_Is_Open : Boolean := False;

   function Next_Slot(Current_Slot : Integer) return Integer is
   begin
      if Active_Probe_Method = Linear then
         return (Current_Slot mod Table_Size) + 1;
      else
         return ((Current_Slot + Random(Probe_Generator) - 1) mod Table_Size) + 1;
      end if;
   end Next_Slot;
   
   procedure Persist_Cache_To_File is
   begin
      if not File_Is_Open then
         return;
      end if;

      Reset(Table_File, Out_File);
      for Slot in File_Cache'Range loop
         Put(Table_File, File_Cache(Slot).Stored_Key);
         Put(Table_File, " ");
         Int_IO.Put(Table_File, File_Cache(Slot).Initial_Hash_Index, Width => 0);
         Put(Table_File, " ");
         Int_IO.Put(Table_File, File_Cache(Slot).Probe_Count, Width => 0);
         New_Line(Table_File);
      end loop;
      Reset(Table_File, In_File);
   end Persist_Cache_To_File;
   
   procedure Load_File_To_Cache is
      Key_String : String(1 .. 16);
   begin
      if not File_Is_Open then
         return;
      end if;

      Reset(Table_File, In_File);
      for Slot in File_Cache'Range loop
         Get(Table_File, Key_String);
         Int_IO.Get(Table_File, File_Cache(Slot).Initial_Hash_Index);
         Int_IO.Get(Table_File, File_Cache(Slot).Probe_Count);
         File_Cache(Slot).Stored_Key := Key_String;
      end loop;
      Cache_Is_Loaded := True;
   end Load_File_To_Cache;
   
   -- BurrisHash hash function 
   -- HA = abs((str(1:1) + str(5:5)) / 517 + str(3:4) / 217 + str(5:6) / 256)
   function Original_Hash_Function(key : String) return Integer is
      First_Character_Value  : Integer;
      Fifth_Character_Value  : Integer;
      Third_Fourth_Pair_Value : Integer;
      Fifth_Sixth_Pair_Value  : Integer;
      Formula_Result : Integer;
      Starting_Position : constant Integer := key'First;
   begin
      -- Get individual character values
      First_Character_Value := Character'Pos(key(Starting_Position));
      Fifth_Character_Value := Character'Pos(key(Starting_Position + 4));
      
      -- Combine character pairs into single values
      Third_Fourth_Pair_Value := Character'Pos(key(Starting_Position + 2)) * 256 + 
                                 Character'Pos(key(Starting_Position + 3));
      Fifth_Sixth_Pair_Value  := Character'Pos(key(Starting_Position + 4)) * 256 + 
                                 Character'Pos(key(Starting_Position + 5));
      
      -- Apply BurrisHash formula
      Formula_Result := (First_Character_Value + Fifth_Character_Value) / 517 + 
                        Third_Fourth_Pair_Value / 217 + 
                        Fifth_Sixth_Pair_Value / 256;
      
      -- Map to table range (1 to Table_Size)
      return (Formula_Result mod Table_Size) + 1;
   end Original_Hash_Function;
   
   procedure Read_Slot(Slot : Integer; Data : out Hash_Record) is
   begin
      if Active_Storage_Mode = Relative_File then
         if not Cache_Is_Loaded then
            Load_File_To_Cache;
         end if;
         Data := File_Cache(Slot);
      else
         Data := Memory_Table(Slot);
      end if;
   end Read_Slot;

   procedure Write_Slot(Slot : Integer; Data : Hash_Record) is
   begin
      if Active_Storage_Mode = Relative_File then
         if not Cache_Is_Loaded then
            Load_File_To_Cache;
         end if;
         File_Cache(Slot) := Data;
         Persist_Cache_To_File;
      else
         Memory_Table(Slot) := Data;
      end if;
   end Write_Slot;

   -- Dispatcher that routes to the selected hash function
   function Hash_Function(key : String) return Integer is
   begin
      case Active_Hash_Function is
         when Original_Hash =>
            return Original_Hash_Function(key);
         when Pair_Hash =>
            declare
               Hash_Index : Integer;
            begin
               Better_Hash.Pair_Hash(key, Hash_Index);
               return (Hash_Index mod Table_Size) + 1;
            end;
      end case;
   end Hash_Function;
   
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
      if method = Random_Probe then
         Reset(Probe_Generator);
      end if;
   end Set_Probe_Method;
   
   procedure Create_Table is
      record_data : Hash_Record;
   begin
      record_data.Stored_Key := (others => ' ');
      record_data.Initial_Hash_Index := 0;
      record_data.Probe_Count := 0;

      if Active_Storage_Mode = Relative_File then
         if File_Is_Open then
            Close(Table_File);
            File_Is_Open := False;
         end if;

         -- Initialize cache
         for Slot in File_Cache'Range loop
            File_Cache(Slot) := record_data;
         end loop;
         Cache_Is_Loaded := True;
         
         Create(Table_File, Out_File, "hashtable.txt");
         File_Is_Open := True;
         Persist_Cache_To_File;
      else
         for Slot_Number in 1 .. Table_Size loop
            Memory_Table(Slot_Number) := record_data;
         end loop;
      end if;
   end Create_Table;
   
   procedure Insert_Key(key : String) is
      Current_Slot : Integer;
      Probes_Taken : Integer := 1;
      Slot_Data : Hash_Record;
      Initial_Hash_Index : constant Integer := Hash_Function(key);
   begin
      Current_Slot := Initial_Hash_Index;
      
      loop
         Read_Slot(Current_Slot, Slot_Data);
         
         if Slot_Data.Stored_Key = (1 .. 16 => ' ') then
            Slot_Data.Stored_Key := key;
            Slot_Data.Initial_Hash_Index := Initial_Hash_Index;
            Slot_Data.Probe_Count := Probes_Taken;
            Write_Slot(Current_Slot, Slot_Data);
            exit;
         end if;
         
         Probes_Taken := Probes_Taken + 1;
         Current_Slot := Next_Slot(Current_Slot);
      end loop;
   end Insert_Key;
   
   function Search_Key(key : String) return Integer is
      Current_Slot : Integer;
      Probes_Taken : Integer := 1;
      Slot_Data : Hash_Record;
      Probe_Limit : constant Integer := Table_Size * 2;
   begin
      Current_Slot := Hash_Function(key);
      
      loop
         Read_Slot(Current_Slot, Slot_Data);
         
         if Slot_Data.Stored_Key = key then
            return Probes_Taken;
         end if;
         
         if Slot_Data.Stored_Key = (1 .. 16 => ' ') then
            return Probes_Taken;
         end if;
         
         Probes_Taken := Probes_Taken + 1;
         
         if Probes_Taken > Probe_Limit then
            return Probes_Taken;
         end if;
         
         Current_Slot := Next_Slot(Current_Slot);
      end loop;
   end Search_Key;
   
   procedure Dump_Table(header : String) is
      Slot_Data : Hash_Record;
      Slot_Is_Empty : Boolean;
   begin
      Put_Line("=== " & header & " ===");
      Put_Line("Hash      Contents at          Original hash    Final hash    Number of probes");
      Put_Line("address   the address          address          address       to store/retrieve");
      Put_Line("--------------------------------------------------------------------------------");
      
      for Slot_Number in 1 .. Table_Size loop
         Read_Slot(Slot_Number, Slot_Data);
         Slot_Is_Empty := Slot_Data.Stored_Key = (1 .. 16 => ' ');
         
         -- Hash address
         Int_IO.Put(Slot_Number, Width => 4);
         Put("      ");
         
         -- Contents (key)
         if Slot_Is_Empty then
            Put("                    ");
         else
            Put(Slot_Data.Stored_Key);
            Put("    ");
         end if;
         
         -- Original hash address
         if Slot_Is_Empty then
            Put("                 ");
         else
            Int_IO.Put(Slot_Data.Initial_Hash_Index, Width => 4);
            Put("             ");
         end if;
         
         -- Final hash address
         if Slot_Is_Empty then
            Put("              ");
         else
            Int_IO.Put(Slot_Number, Width => 4);
            Put("          ");
         end if;
         
         -- Number of probes
         if not Slot_Is_Empty then
            Int_IO.Put(Slot_Data.Probe_Count, Width => 4);
         end if;
         New_Line;
      end loop;
      New_Line;
   end Dump_Table;
   
   procedure Close_Table is
   begin
      if Active_Storage_Mode = Relative_File and File_Is_Open then
         Close(Table_File);
         File_Is_Open := False;
         Cache_Is_Loaded := False;
      end if;
   end Close_Table;
   
end Hash_Table;