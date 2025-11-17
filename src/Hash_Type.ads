package Hash_Type is
   -- Instructor's BurrisHash formula implemented as a pure function
   function BurrisHash (Key : String) return Integer;

   -- Student-designed hash exposed as a procedure with an out parameter
   procedure Pair_Hash (Key : String; Hash_Index : out Integer);
end Hash_Type;
