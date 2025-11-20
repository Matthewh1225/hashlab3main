with Ada.Text_IO; use Ada.Text_IO;

package body Key_Loader is

   procedure Load_Keys (Items : out Key_Array) is
      Source_File  : File_Type;
      Key_Buffer: String(1 .. 16);
      Last_Character_Index : Natural;
      char_Count: Natural:= 0;
      Is_Digits : Boolean;
   begin
      Open(Source_File, In_File, "src/Words200D16.txt");
      while not End_Of_File(Source_File) and char_Count < Items'Length loop
      --Initialize Key_Buffer to all spaces 
         Key_Buffer:= (others => ' ');
         Get_Line(Source_File, Key_Buffer, Last_Character_Index);

         --Skip record-length indicator
         Is_Digits:= True;
         for Position in Key_Buffer'First .. Last_Character_Index loop
            if Key_Buffer(Position) not in '0' .. '9' then
               Is_Digits := False;
               exit;
            end if;
         end loop;
         
         if not Is_Digits then
            char_Count:= char_Count + 1;
            Items(char_Count):= Key_Buffer;
         end if;
      end loop;
      Close(Source_File);
   end Load_Keys;
end Key_Loader;
