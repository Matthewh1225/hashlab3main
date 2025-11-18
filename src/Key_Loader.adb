with Ada.Text_IO; use Ada.Text_IO;

package body Key_Loader is

   procedure Load_Keys (Items : out Key_Array) is
      Source_File           : File_Type;
      Key_Buffer            : String(1 .. 16);
      Last_Character_Index  : Natural;
      Loaded_Key_Count      : Natural:= 0;
      Is_All_Digits         : Boolean;
   begin
      Open(Source_File, In_File, "src/Words200D16.txt");
      while not End_Of_File(Source_File) and Loaded_Key_Count < Items'Length loop
         Key_Buffer:= (others => ' ');
         Get_Line(Source_File, Key_Buffer, Last_Character_Index);

         --Skip all-digit lines (record-length indicators)
         Is_All_Digits:= True;
         for Position in Key_Buffer'First .. Last_Character_Index loop
            if Key_Buffer(Position) not in '0' .. '9' then
               Is_All_Digits := False;
               exit;
            end if;
         end loop;
         
         if not Is_All_Digits then
            Loaded_Key_Count:= Loaded_Key_Count + 1;
            Items(Loaded_Key_Count):= Key_Buffer;
         end if;
      end loop;
      Close(Source_File);
   end Load_Keys;

end Key_Loader;
