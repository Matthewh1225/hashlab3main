with Ada.Numerics.Discrete_Random;
with Ada.Text_IO; use Ada.Text_IO;
with Better_Hash;

package body Hash_Table is
   
   package Int_IO is new Ada.Text_IO.Integer_IO(Integer);
   
   -- Random number generator for random probing
   subtype Offset_Range is Integer range 1 .. Table_Size;
   package Random_Offset is new Ada.Numerics.Discrete_Random(Offset_Range);
   use Random_Offset;
   
   random_generator : Generator;
   hash_file : Hash_IO.File_Type;
   hash_array : array (1 .. Table_Size) of Hash_Record;
   current_method : Probe_Method := Linear;
   current_hash_function : Hash_Function_Type := Original_Hash;
   current_storage : Storage_Mode := Relative_File;
   file_is_open : Boolean := False;

   function Next_Slot(Current_Slot : Integer) return Integer is
   begin
      if current_method = Linear then
         return (Current_Slot mod Table_Size) + 1;
      else
         return ((Current_Slot + Random(random_generator) - 1) mod Table_Size) + 1;
      end if;
   end Next_Slot;
   
   -- A) BurrisHash: Original hash function as a function
   -- HA = abs((str(1:1) + str(5:5)) / 517 + str(3:4) / 217 + str(5:6) / 256)
   function Original_Hash_Function(key : String) return Integer is
      char_position_1, char_position_5 : Integer;
      char_positions_3_and_4, char_positions_5_and_6 : Integer;
      hash_value : Integer;
      First_Position : constant Integer := key'First;
   begin
      -- Get character values
      char_position_1 := Character'Pos(key(First_Position));
      char_position_5 := Character'Pos(key(First_Position + 4));
      
      -- Two-character combinations as integers
      char_positions_3_and_4 := Character'Pos(key(First_Position + 2)) * 256 + Character'Pos(key(First_Position + 3));
      char_positions_5_and_6 := Character'Pos(key(First_Position + 4)) * 256 + Character'Pos(key(First_Position + 5));
      
      -- Apply formula
      hash_value := (char_position_1 + char_position_5) / 517 + char_positions_3_and_4 / 217 + char_positions_5_and_6 / 256;
      
      -- Map to table range
      return (hash_value mod Table_Size) + 1;
   end Original_Hash_Function;
   
   procedure Read_Slot(Slot : Integer; Data : out Hash_Record) is
   begin
      if current_storage = Relative_File then
         Hash_IO.Read(hash_file, Data, Hash_IO.Positive_Count(Slot));
      else
         Data := hash_array(Slot);
      end if;
   end Read_Slot;

   procedure Write_Slot(Slot : Integer; Data : Hash_Record) is
   begin
      if current_storage = Relative_File then
         Hash_IO.Write(hash_file, Data, Hash_IO.Positive_Count(Slot));
      else
         hash_array(Slot) := Data;
      end if;
   end Write_Slot;

   -- Dispatcher that routes to the selected hash function
   function Hash_Function(key : String) return Integer is
   begin
      case current_hash_function is
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
      current_hash_function := hash_func;
   end Set_Hash_Function;
   
   procedure Set_Storage_Mode(mode : Storage_Mode) is
   begin
      if current_storage = Relative_File and mode = Main_Memory then
         Close_Table;
      end if;
      current_storage := mode;
   end Set_Storage_Mode;
   
   procedure Set_Probe_Method(method : Probe_Method) is
   begin
      current_method := method;
      if method = Random_Probe then
         Reset(random_generator);
      end if;
   end Set_Probe_Method;
   
   procedure Create_Table is
      record_data : Hash_Record;
   begin
      record_data.key := (others => ' ');
      record_data.initial_hash := 0;
      record_data.probe_count := 0;

      if current_storage = Relative_File then
         if file_is_open then
            Hash_IO.Close(hash_file);
            file_is_open := False;
         end if;

         Hash_IO.Create(hash_file, Hash_IO.InOut_File, "hashtable");
         file_is_open := True;
         
         for Slot_Number in 1 .. Table_Size loop
            Hash_IO.Write(hash_file, record_data);
         end loop;
      else
         for Slot_Number in 1 .. Table_Size loop
            hash_array(Slot_Number) := record_data;
         end loop;
      end if;
   end Create_Table;
   
   procedure Insert_Key(key : String) is
      current_slot : Integer;
      probe_count : Integer := 1;
      record_data : Hash_Record;
      Initial_Hash_Value : constant Integer := Hash_Function(key);
   begin
      current_slot := Initial_Hash_Value;
      
      loop
         Read_Slot(current_slot, record_data);
         
         if record_data.key = (1..16 => ' ') then
            record_data.key := key;
            record_data.initial_hash := Initial_Hash_Value;
            record_data.probe_count := probe_count;
            Write_Slot(current_slot, record_data);
            exit;
         end if;
         
         probe_count := probe_count + 1;
         
         current_slot := Next_Slot(current_slot);
      end loop;
   end Insert_Key;
   
   function Search_Key(key : String) return Integer is
      current_slot : Integer;
      probe_count : Integer := 1;
      record_data : Hash_Record;
      Probe_Limit : constant Integer := Table_Size * 2;
   begin
      current_slot := Hash_Function(key);
      
      loop
         Read_Slot(current_slot, record_data);
         
         if record_data.key = key then
            return probe_count;
         end if;
         
         if record_data.key = (1..16 => ' ') then
            return probe_count;
         end if;
         
         probe_count := probe_count + 1;
         
         if probe_count > Probe_Limit then
            return probe_count;
         end if;
         
         current_slot := Next_Slot(current_slot);
      end loop;
   end Search_Key;
   
   procedure Dump_Table(header : String) is
      record_data : Hash_Record;
   begin
      Put_Line("=== " & header & " ===");
      for Slot_Number in 1 .. Table_Size loop
         Read_Slot(Slot_Number, record_data);
         Put("Slot");
         Int_IO.Put(Slot_Number, Width => 4);
         Put(": ");
         if record_data.key = (1 .. 16 => ' ') then
            Put_Line("EMPTY");
         else
            Put(record_data.key);
            Put(" | InitHash=");
            Int_IO.Put(record_data.initial_hash, Width => 4);
            Put(" | Probes=");
            Int_IO.Put(record_data.probe_count, Width => 3);
            New_Line;
         end if;
      end loop;
      New_Line;
   end Dump_Table;
   
   procedure Close_Table is
   begin
      if current_storage = Relative_File and file_is_open then
         Hash_IO.Close(hash_file);
         file_is_open := False;
      end if;
   end Close_Table;
   
end Hash_Table;