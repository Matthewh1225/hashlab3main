with Ada.Text_IO; use Ada.Text_IO;
with Key_Loader;use Key_Loader;
with Assignment_Output;use Assignment_Output;
--Main program for Hash Lab 3
procedure hashlab3main_assignment is
   Keys : Key_Array (1 .. 100);
   Loaded_Count : Natural;
begin
   Put_Line ("Loading keys from file...");
   Load_Keys ("Words200D16.txt", Keys, Loaded_Count);
   Put_Line ("Loaded" & Natural'Image (Loaded_Count) & " keys successfully.");
   
   Run_Assignment_Tests (Keys);
      
end hashlab3main_assignment;