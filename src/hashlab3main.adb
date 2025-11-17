with Key_Loader; use Key_Loader;
with Hash_Stats;
-- Main program for Hash Lab 3
procedure Hashlab3main is
   Keys : Key_Array;
begin
   Load_Keys(Keys);
   Hash_Stats.Run_All_Tests(Keys);
end Hashlab3main;