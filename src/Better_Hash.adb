with Hash_Table; use Hash_Table;

package body Better_Hash is

   -- Hash as a procedure with out parameter
   procedure Pair_Hash (Key : in String; Hash_Index : out Integer) is
      -- Descending prime weights make early character pairs more influential
      Weights : constant array (0 .. 7) of Integer :=
        (131, 113, 101, 89, 79, 71, 61, 53);

      Hash_Value : Integer := 0;
      Left_Character  : Integer;
      Right_Character : Integer;
      Combined_Pair_Value : Integer;
      Starting_Position : constant Integer := Key'First;
   begin
      -- Sequential pairing: (1,2), (3,4), ... (15,16)
      for Pair_Index in 0 .. 7 loop
         Left_Character  := Character'Pos(Key(Starting_Position + Pair_Index * 2));
         Right_Character := Character'Pos(Key(Starting_Position + Pair_Index * 2 + 1));
         
         -- Combine two characters into one value
         Combined_Pair_Value := Left_Character * 256 + Right_Character;
         
         -- Sum weighted pairs
         Hash_Value := Hash_Value + Combined_Pair_Value * Weights(Pair_Index);
      end loop;
      
      -- Map to table index range (0 .. Table_Size - 1)
      Hash_Index := Hash_Value mod Table_Size;
   end Pair_Hash;

end Better_Hash;

