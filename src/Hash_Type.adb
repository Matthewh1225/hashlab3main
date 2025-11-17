package body Hash_Type is

   subtype Hash_Sum is Long_Long_Integer;

   function Pair_Value(Key : String; Left_Index : Integer) return Hash_Sum is
   begin
      return Hash_Sum(Character'Pos(Key(Left_Index))) * 256 +
             Hash_Sum(Character'Pos(Key(Left_Index + 1)));
   end Pair_Value;

   function BurrisHash (Key : String) return Integer is
      Start_Position : constant Integer := Key'First;
      First_Char     : constant Hash_Sum := Hash_Sum(Character'Pos(Key(Start_Position)));
      Fifth_Char     : constant Hash_Sum := Hash_Sum(Character'Pos(Key(Start_Position + 4)));
      Third_Fourth   : constant Hash_Sum := Pair_Value(Key, Start_Position + 2);
      Fifth_Sixth    : constant Hash_Sum := Pair_Value(Key, Start_Position + 4);
      Burris_Result : Hash_Sum;
   begin
      -- HA = abs( (str(1:1) + str(5:5)) / 517 + str(3:4) / 217 + str(5:6) / 256 )
      Burris_Result := abs((First_Char + Fifth_Char) / 517 + Third_Fourth / 217 + Fifth_Sixth / 256);
      return Integer(Burris_Result);
   end BurrisHash;

   procedure Pair_Hash (Key : String; Hash_Index : out Integer) is
      Weights : constant array (0 .. 7) of Integer :=
        (131, 113, 101, 89, 79, 71, 61, 53);
      Weighted_Sum : Hash_Sum := 0;
   begin
      -- Sequential pairing: (1,2), (3,4), ... (15,16)
      -- Each pair weighted by descending prime for better distribution
      for Pair_Index in 0 .. 7 loop
         Weighted_Sum := Weighted_Sum + 
           Pair_Value(Key, Key'First + Pair_Index * 2) * Hash_Sum(Weights(Pair_Index));
      end loop;
      
      Hash_Index := Integer(abs(Weighted_Sum));
   end Pair_Hash;

end Hash_Type;
