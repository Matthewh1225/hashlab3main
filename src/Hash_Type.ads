package Hash_Type is
   --  BurrisHash formula function
   function BurrisHash (Key : String) return Integer;
   --my Hash procedure
   procedure Pair_Hash (Key : String; Hash_Index : out Integer);
end Hash_Type;
