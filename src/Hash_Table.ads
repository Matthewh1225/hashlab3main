with Ada.Direct_IO;

package Hash_Table is
   
   Table_Size : constant Positive := 100;

   type Hash_Record is record
      key : String(1..16);
      initial_hash : Integer;
      probe_count : Integer;
   end record;
   
   package Hash_IO is new Ada.Direct_IO(Hash_Record);
   
   type Probe_Method is (Linear, Random_Probe);
   type Hash_Function_Type is (Original_Hash, Pair_Hash);
   type Storage_Mode is (Relative_File, Main_Memory);
   
   procedure Set_Probe_Method(method : Probe_Method);
   procedure Set_Hash_Function(hash_func : Hash_Function_Type);
   procedure Set_Storage_Mode(mode : Storage_Mode);
   procedure Create_Table;
   procedure Insert_Key(key : String);
   function Search_Key(key : String) return Integer;
   procedure Dump_Table(header : String);
   procedure Close_Table;
   
end Hash_Table;