with Ada.Text_IO; use Ada.Text_IO;
with Key_Loader; use Key_Loader;
with Hash_Table; use Hash_Table;

procedure Memory_Dump_Generator is
   Keys : Key_Array;
   
   procedure Generate_Dump(Hash_Func : Hash_Function_Type; 
                          Probe : Probe_Method;
                          Storage : Storage_Mode;
                          Filename : String) is
      Header_Text : constant String := 
        "Hash Function: " & (if Hash_Func = Original_Hash then "BurrisHash" else "Pair_Hash") &
        " | Probe: " & (if Probe = Linear then "LINEAR" else "RANDOM") &
        " | Storage: " & (if Storage = Main_Memory then "Main Memory" else "Relative File");
   begin
      -- Configure and build table
      Set_Hash_Function(Hash_Func);
      Set_Storage_Mode(Storage);
      Set_Probe_Method(Probe);
      Create_Table;
      
      -- Insert all keys
      for I in Keys'Range loop
         Insert_Key(Keys(I));
      end loop;
      
      -- Display to screen (will be redirected to file)
      Put_Line("================================================================================");
      Put_Line("                     MEMORY TABLE DUMP: " & Filename);
      Put_Line("================================================================================");
      Display_HashTable(Header_Text);
      New_Line;
      Close_Table;
   end Generate_Dump;
   
begin
   Load_Keys(Keys);
   
   Put_Line("Generating BurrisHash memory dumps...");
   Put_Line("Run with output redirection: Memory_Dump_Generator > memory_dumps.txt");
   New_Line;
   
   -- Generate 4 BurrisHash dumps (as required by assignment)
   Generate_Dump(Original_Hash, Linear, Main_Memory, "BurrisHash_Linear_MainMemory");
   Generate_Dump(Original_Hash, Random_Probe, Main_Memory, "BurrisHash_Random_MainMemory");
   Generate_Dump(Original_Hash, Linear, Relative_File, "BurrisHash_Linear_RelativeFile");
   Generate_Dump(Original_Hash, Random_Probe, Relative_File, "BurrisHash_Random_RelativeFile");
   
   Put_Line("================================================================================");
   Put_Line("All 4 memory dumps generated above");
   Put_Line("================================================================================");
   
end Memory_Dump_Generator;
