with Ada.Text_IO; use Ada.Text_IO;

package body Key_Loader is

   procedure Load_Keys (Items : out Key_Array) is
      Source_File  : File_Type;
      Key_Buffer: String(1 .. 16);
      Last_Character_Index : Natural;
      char_Count: Natural:= 0;
   begin
      Open(Source_File, In_File, "src/Words200D16.txt");
      while not End_Of_File(Source_File) and char_Count < Items'Length loop
      -- Key_Buffer to all spaces 
         Key_Buffer:= (others => ' ');
         Get_Line(Source_File, Key_Buffer, Last_Character_Index);

         char_Count:= char_Count + 1;
         Items(char_Count):= Key_Buffer;
      end loop;
      Close(Source_File);
   end Load_Keys;
end Key_Loader;
