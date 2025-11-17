with Interfaces; use Interfaces;
--hello

package body Better_Hash is

   --  B) Your hash as a procedure with out parameter
   procedure Pair_Hash (Key : in String; Hash_Index : out Integer) is
      -- prime weights decneding to provide higher varince in early pairs
      Weights : constant array (0 .. 7) of Integer :=
        (131, 113, 101, 89, 79, 71, 61, 53);
      Table_Modulus : constant Unsigned_64 := 100;

      Hash_Accumulator : Unsigned_64 := 0;
      Left_Char   : Integer;
      Right_Char  : Integer;
      Pair_Value       : Unsigned_64;
      First_Index      : constant Integer := Key'First;
   begin
    
      --  Sequential pairing: (1,2)... (15,16)
      for Pair_Index in 0 .. Weights'Last loop
         Left_Char  := Character'Pos (Key (First_Index + Pair_Index * 2));
         Right_Char := Character'Pos (Key (First_Index + Pair_Index * 2 + 1));
         -- Combine characters into 16-bit value
         Pair_Value := Unsigned_64 (Left_Char * 2**8 + Right_Char);
         --  Simple weighted accumulation
         Hash_Accumulator := Hash_Accumulator + Pair_Value * Unsigned_64 (Weights (Pair_Index));

         Hash_Accumulator := Hash_Accumulator xor Shift_Right(Hash_Accumulator, 5); -- right shift 5 bits
         Hash_Accumulator := Hash_Accumulator * 71;      -- multiply by prime
         Hash_Accumulator :=  Hash_Accumulator xor Shift_Left(Hash_Accumulator, 13);-- left shift 13 bits 
      end loop;
      --  Final reduction to table index range
      Hash_Index := Integer (Hash_Accumulator mod Table_Modulus);
   end Pair_Hash;

end Better_Hash;

