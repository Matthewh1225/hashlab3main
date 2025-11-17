with Ada.Text_IO; use Ada.Text_IO;

package body Key_Loader is

   procedure Load_Keys (Items : out Key_Array) is
      Text_File            : File_Type;
      Line_Buffer          : String(1 .. 16);
      Last_Character_Index : Natural;
   begin
      Open(Text_File, In_File, "src/Words200D16.txt");
      for Key_Index in Items'Range loop
         exit when End_Of_File(Text_File);
         Get_Line(Text_File, Line_Buffer, Last_Character_Index);
         Items(Key_Index) := Line_Buffer;
      end loop;
      Close(Text_File);
   end Load_Keys;

end Key_Loader;
