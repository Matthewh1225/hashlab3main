with Ada.Text_IO; use Ada.Text_IO;

package body Key_Loader is

   function Is_Record_Length_Indicator(Buffer : String; Last_Index : Natural) return Boolean is
      subtype Positive_Index is Integer range Buffer'First .. Buffer'Last;
      Trimmed_Upper : Positive_Index;
   begin
      if Last_Index = 0 then
         return False;
      end if;

      Trimmed_Upper := Positive_Index(Last_Index);
      for Position in Buffer'First .. Trimmed_Upper loop
         if Buffer(Position) not in '0' .. '9' then
            return False;
         end if;
      end loop;
      return True;
   end Is_Record_Length_Indicator;

   procedure Load_Keys (Items : out Key_Array) is
      Source_File           : File_Type;
      Key_Buffer            : String(1 .. 16);
      Last_Character_Index  : Natural;
      Loaded_Key_Count      : Natural := 0;
   begin
      Open(Source_File, In_File, "src/Words200D16.txt");
      while not End_Of_File(Source_File) and Loaded_Key_Count < Items'Length loop
         Key_Buffer := (others => ' ');
         Get_Line(Source_File, Key_Buffer, Last_Character_Index);

         if not Is_Record_Length_Indicator(Key_Buffer, Last_Character_Index) then
            Loaded_Key_Count := Loaded_Key_Count + 1;
            Items(Loaded_Key_Count) := Key_Buffer;
         end if;
      end loop;
      Close(Source_File);
   end Load_Keys;

end Key_Loader;
