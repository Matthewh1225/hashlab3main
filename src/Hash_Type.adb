with Interfaces; use Interfaces;
package body Hash_Type is
--convert/sum pair of chars to long long int
   function Pair_Value(Key : String; Left_Index :Integer) return Long_Long_Integer is
   begin
      return Long_Long_Integer(Character'Pos(Key(Left_Index))) * 256+ Long_Long_Integer(Character'Pos(Key(Left_Index + 1)));
   end Pair_Value;
   pragma Inline(Pair_Value);

   function BurrisHash (Key :String) return Integer is
      Pos : constant Integer := Key'First;
   begin
      --HA = abs( (str(1:1) + str(5:5)) / 517 + str(3:4) / 2**17 + str(5:6) / 256 )
      return Integer(abs((Long_Long_Integer(Character'Pos(Key(Pos)))+ Long_Long_Integer(Character'Pos(Key(Pos + 4)))) / 517 + Pair_Value(Key, Pos + 2) / 2**17 + Pair_Value(Key, Pos + 4) / 256));
   end BurrisHash;
   --pair chars(1,2...15,16), multiply by weights, bit shift, then mod into final hash
   procedure Pair_Hash (Key : String; Hash_Index : out Integer) is
   --array of prime weights for each pair,decendin
      Weights : constant array (0 .. 7) of Integer:=(191,167,131,83,59,31,17,7);
      Sum : Unsigned_64:= 0;
   begin
      for I in 0 .. 7 loop
         Sum:= Sum + Unsigned_64(Pair_Value(Key, Key'First + I * 2) * Long_Long_Integer(Weights(I)));
         -- right shift by  bits
         Sum := Sum xor (Sum / 2**7);
         --left shift by 13 bits
         Sum:=Sum xor (Sum * 2**13);
      end loop;--mod to recudce number size before its converted
      Hash_Index := Integer(abs(Long_Long_Integer(Sum mod 2**7)));
   end Pair_Hash;
end Hash_Type;
