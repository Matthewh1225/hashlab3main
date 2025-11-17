package Key_Loader is
   subtype Key_Index_Range is Positive range 1 .. 75;
   type Key_Array is array(Key_Index_Range) of String(1 .. 16);

   procedure Load_Keys (Items : out Key_Array);
end Key_Loader;
