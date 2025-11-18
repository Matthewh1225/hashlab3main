with Key_Loader; use Key_Loader;
with Test_Runner;
--Main program for Hash Lab 3
procedure Hashlab3main is
   Keys : Key_Array;
begin
   Load_Keys(Keys);
   Test_Runner.Run_All_Tests(Keys);
end Hashlab3main;