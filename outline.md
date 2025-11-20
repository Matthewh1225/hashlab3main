Hash Lab  COSC 3319  Fall  2025    Burris



Due: All classes prior to 8:00 A.M. December 2.  Late labs will not be accepted!  Early submissions are appreciated. 



For your convenience a file of 200+ random words and names (Words200D16) has been provided on Blackboard.  The first line (data) is a string of digits allowing you to verify the lines are exactly 16 characters in an ASCII  text editor. Each line of text in the file is exactly 16 characters in length with the word left justified padded with spaces.  You may utilize any code developed in class directly in the lab.  While not initially apparent, this lab will be more of a thought problem than coding problem.  A careful examination of the sample code utilized in class will reveal a great deal of the code required for the lab has already been developed in class.  Indeed, with so many examples, I assume you should be able to complete the “A” option code with little trouble.  Hence grading will emphasize professional evaluation and presentation of results .  Be professional grade!





"C" Option:

Assume a hash table of size 100 created as a direct (relative) access file (~page 188 in the hymnal) in auxiliary storage.  For convenience, assume the characters in the key are numbered 1 through 16.  “My” hash address must be calculated as follows using Wallgol:  



HA = abs(   ( str(1:1)  + str(5:5)  ) / 517 + str(3:4)  / 217 + str(5:6) / 256  )



Given: str = “ABCDEFGHIJKLMNOP”:  



HA = abs(   ( A  + E) / 517 + CD  ]  + CD / 217  + EF / 256  )



 

All alphabetic/numeric characters in a key are 8 bit ASCII, left justified.  Keys containing less than 16 alphabetic/numeric characters are padded with spaces on the right to a total of 16 characters.



I have never used this function.  It should be substantially less than optimal, generating a plethora of collisions.  All characters and character strings must be treated as ASCII integers in all steps of the calculation (cast or coercion)!  You may use the slice operator or simple subscripting depending on how you define the keys.  You must use a highlighter to mark all  code implementing the calculation for my hash function and your hash function.  I will not grade the lab if you have not marked the code as required!



I recommend using a long_integer to hold the intermediate results of hash calculations.  A “slice” in Ada allows the user to treat a substring as a single unit.  If “str” has the value “ABCD” then str(2..3) refers to the characters in positions 2 through 3 as a group from the string str, i.e., ”BC.”  str(2..2) would be the second character in the string, i.e., “B”.  I am assuming you have instantiated appropriate functions (coercion/cast) which convert character strings (8 bits per ASCII character) to long integers (32 bits or 64 bits) so overflow will not occur in the sum.    



Each entry placed in the hash table must be a record with at least 3 fields.  The first field is the key, the second the initial hash address, and the third field is the number of probes to insert the key in the table counting the initial hash address as the first probe (sum of first probe plus the number of collisions for insertion).  The text data file must be processed using traditional file operations (open/close, ~ page 187 in the hymnal).  You may not use I/O redirection for either the data file or text file holding the results you will need to complete your report required for the discussion.  Your program will read one sequential file, create and use a direct/relative access hash file and print results to a text file used to write your report.



Create a random access (direct file) hash table in main memory with space for 100 records numbered 1 thru 100.  Use the data file to place 75 records into the hash table.  Use the linear probe technique developed in class to handle collisions.  Next look up the first 25 keys placed in the table.  Print the minimum, maximum, and average number of probes required to locate the first 25 keys placed in the table.  Now search for the last 25 keys placed in the table.  Print the minimum, maximum, and average number of probes required to locate the last 25 keys placed in the table.  Print the contents of the entire hash table in ascending direct/relative record number order clearly indicating open entries (this should allow you to see any primary/secondary clustering effect).  



Calculate and print the theoretical expected number of probes to locate a random item in the table.  Explain your empirical results in light of the theoretical results.  Your grade point will be highly dependent on your explanation!



Now search for all 75 keys in the table.  Calculate and print the theoretical expected number of probes to locate a random item in the table.  Next calculate the actual average number of probes to find all keys in the table.  YOU MUST PHYSICALLY SEARCH FOR EACH KEY TO CALCULATE THE STATISTICS or use the data previously collected!  Discuss the empirical results in light of the theoretical results.  Your grade points will be highly dependent on your explanation!



D)	Repeat A and B above but use the random probe for handling collisions as developed in class.  Exhibit the appropriate statistics in your table.  Your grade points will be highly dependent on your explanation!



Present all your results in a single neat tabular typed table.  Compare your results to the theoretical results for all 100 keys.  If there are differences, please explain why.  I expect you to physically verify your hash function is calculating the correct hash addresses for my hash function.  A professional always verifies their work is accurate.  You may not ask a friend,  enemy, hire a consultant, apply unreasonable pressure to tutors or anyone else for help.  You may not look them up on the internet or an AI.  Providing someone else with the results will not only cause them to fail the lab and possibly the course but you as well.  You may however teach others to use a calculator, spreadsheet, log tables, other techniques, explain ASCII or details of computer architecture.  You may help others with coding and logic errors.   You may not share your code!



My required hash function has multiple weaknesses.  Criticize my hash functions specific weaknesses on a technical basis.  To receive full credit, you must state clearly and explicitly why my hash function was less than optimal!  I will not be impressed by a statement such as “the table size is a power of the base” etcetera unless you can specifically tie the failure to my hash function and data processed.



Based on your criticism, write a better hash function.  You must explain explicitly why your hash function should be better from both a theoretical and empirical standpoint based on your previous explanation of why my functions failings.  You will not receive credit for simply writing a hash function that performs better.  



Implement your hash function and generate the same results as required for parts A thru F presented in tabular format for comparison.  Formally evaluate the results as part of your lab (typed evaluation).  The results for all results of the lab should appear in a single table.  



Shame on you if your hash function’s performance does not exceed at least my hash for both the linear and random probe.  It is possible to exceed the theoretical performance values with sufficient thought.  Script Kiddies may have trouble evaluating the failures of my hash function and creating a better function.  Looking for “engineers/professionals!”





"B" Option:

First complete the "C" option.  Now complete the "C" option using a main memory hash table.  Hint:  Replacing “write” with “hashTab( J ) x.”   Replace “read” with  x  hashTab( J)” The rest of the code is essentially the same.



Generate the same results as required for parts A thru E presented in tabular format for comparison.  You must provide a professional discussion of the combined results using the table to substantiate your conclusions.





"A" Option:



You must compute all hash addresses using a function for my hash and a procedure for your hash.  C++ and Java have procedures but calls them functions.  All data is passed through the function parameter list (preferably call-by-value in C++, or ”in” in Ada)  Results are also passed via the parameter list in C++ (call-by-reference in C++, “out” or “inout” in Ada).  You may use functions and procedures for the other grading options if desired.  It is acceptable to implement the hash functions directly in the code for “C and B” Options.  Programming actual language function including restrictions on how parameters are passed.  Prototypes follow for Ada, Java, “C,” and C++.  Samples follow in Wallgol:



function BurrisHash( parms: in <type>) return HA begin °°°end;

procedure YourHash( parm1, parms: in <type>; HA: out <type> ) begin °°°end;



For Ada, “In” is the equivalent of call by value in Java, “C,” and C++.  This is an important safe coding technique.  “Call-by-Value” protects against modifying “VALUE” parameters from accidental or malicious modification (Trojan Horse – injection for you red team members) in the invoking subprogram.  “InOut” is close to call-by-reference” in Java, “C” and C++.  Call-by-reference does not protect from the Trojan Horse.



 “Out” allows the procedure/function to return a value to the invoking program.  The invoking program or task cannot inadvertently pass information to the invoked program.  Opposite of call-by-value.



“Inout” is similar to “call by reference” in sequential programming in Java, “C,” and C++.  The difference is for multi-tasking.  “Inout” has an especially important security role for Ada in real time systems (primary reason for which Ada was developed and utilized).  Nothing is changed/updated in the invoking task by the invoked task until the “procedure/function/task” returns!”  For example, assume the main code for the spaceship invokes a separate task to modify its course.  In Java, “C,” and C++ if a call parameter passed by reference is modified in the invoked task it is actually physically modifying the parameter(s) in the main program.  If the task incurs an error and terminates you have lost the original data required for the next attempt to adjust course.  For “inout” parameters in Ada the task must complete successfully for the modifications to occur in the main program.  “Inout” helps insure safe programming allowing the main calling task to recover and restart task that failed with all original data intact.



“C”/C++ and Java support procedures but retain the keyword “function.”  The typical prototype for the equivalent of an Ada “procedure” is “void function( parm1, parm2: integer; result1*, result2*: integer ) { --- }



Parm1 and parm2 are input parameters required for result calculation.  Frequently call-by-value (CBV).  Result1 and result2 are the values to be returned to the invoking program hence must be of type “reference” (call-by-reference or CBR).



Require format all grading options when printing the contents of the hash table for both the linear and random probe:



What is stored in the table.  For example, the results of “your” hash function.  You only have to print the contents of the hash table for my hash functions, not yours!











REPORT ALL GRADING OPTIONS



Results of the lab must be submitted in the following order.  



A cover sheet clearly stating the grading option you have completed, your name and days your class meets.



A single table containing all results for all grading options completed followed by discussion (explanation of results) for the grading option.



The code for the grading option.



Next include the required memory contents with locations from 1 through 128 including the key (in its final resting spot), and number of probes to store/locate the key in ascending numeric order from 1 through 128.  Do this for both the linear and random probes.  



Repeat the above steps for the “B” Option.  Combine the discussion for both the “C” and ”B” options.



Repeat the above steps for the “A” Option.  Combine the discussion for the “C,” ” B”  and “A” options.



You must make it easy for me to locate the results.  You can do this by numbering the pages and including a table of contents on the cover page.  Alternately, some form of tabs braking up the sections in the specified order.  Many have accomplished this in the past using scotch tape tabs.






YOU ARE THE EXPERT - I AM THE CLIENT.  Convenience me you have done a professional job!





Partial Sample Table “C” Option





“C” Option:



Average number of probes to locate all keys in the table!



For the B” option, include/compare the “C” option results table for the relative file with the results for the “B” option main memory table.  Include both tables when submitting the “A” option.



A professional verifies their hash function to be sure it is calculating hash addresses correctly.  Hint:  Compare your hand calculation of hash addresses with those produced by your code.  Use your knowledge of the character set to do the calculations by hand.  If you are not verifying results, you are not a professional.




Sample Code C/B/A Options!



with direct_io;  --in file SampleRelativeHashFile.adb

with Ada.Text_IO;



procedure SampleRelativeHashFile is



   type String5 is array(1..5) of Character;  -- type String16 is array(1..16) of Character;

   type rec is record                                         -- using stream I/O

      age:integer;

      empName:String5;

   end record;



   empty:String5 := "Empty";



   package IIO is new Ada.text_io.Integer_IO(Integer);

   use IIO;



   package IO_Direct is new Direct_io(rec);

   use IO_Direct;



   pt: Positive_count;  --a file pointer are positive numbers.

   f1:file_type;  -- from file_type direct_IO



   rec1: rec;

   tempRec: rec;



   hashAddr: Positive_Count;

   P: Integer;



   -- hashTable: array(1..10) of rec; -- declare a main memory table. ***

                                      -- B/A options.

   begin

      create(f1, inout_file,"RelativeFile");  --Associate logical file name

                              --with actual file nane in auxiliary storage.



      -- Iitialize hash file empty with table size = 10

      rec1.age := 0;

      rec1.empName := empty;

      -- reset(f1);



      for pt in positive_count range 1..10 loop

           write(f1,rec1,pt);  --hashTable( pt ) := rec1; for main memory table.***

      end loop;                -- for B/A options

      close(f1);



      -- exhibit entire file is empty

      open(f1,inout_file,"RelativeFile");



      for pt in positive_count range 1..10 loop

           read(f1,rec1,pt);  -- rec1 := hashTable( pt ); for main memory table. ***

                              -- for B/A options

           P := Integer(pt);  -- coerse positive count to integer

           IIO.put( P, 3 );  Ada.Text_IO.put("  ");

           -- following print loop makes a good function or procedure declared as "inline."

           for J in 1..5 loop Ada.Text_IO.put(rec1.empName(J)); end loop;

           iio.put(rec1.age); Ada.text_io.new_line;

      end loop;





      -- Sample insert Joe, age 22 at 5 

      hashAddr := 5 + 10 / 2 - 5;   -- Compute hashAddr for Joe at locstion 5.

      rec1.age := 22;

      rec1.empName := "Joe  ";



      write(f1,rec1,hashAddr);  -- write to direct/relative file.  



      Ada.Text_IO.new_line(2);

     -- Show joe is in the file at 5

      for pt in positive_count range 1..6 loop

           read(f1,rec1,pt);

           P := Integer(pt);  -- coerce from positive_count to integer.

           IIO.put( P, 3 );  Ada.Text_IO.put("  ");

           for J in 1..5 loop Ada.Text_IO.put(rec1.empName(J)); end loop;

           iio.put(rec1.age); Ada.text_io.new_line;

      end loop;



      -- Sample write detecting potential collision.

      -- If a collision occurs place record at previous location pt - 1.



      rec1.age := 18;

      rec1.empName := "Mary ";

      Pt := 5;

      read(f1,tempRec, pt);

      if(tempRec.empName = empty) then  --A collision has occurred.

         write(f1,rec1, pt);

      else

         write(f1,rec1,pt + 1);  -- incomplete, just assumed the next space was available!

      end if;



      -- Show Mary was placed at 4 due to Joe occupying position 5.

      Ada.Text_IO.new_line(2);

      for pt in positive_count range 1..6 loop

           read(f1,rec1,pt);

           P := Integer(pt);

           IIO.put( P, 3 );  Ada.Text_IO.put("  ");

           for J in 1..5 loop Ada.Text_IO.put(rec1.empName(J)); end loop;

           iio.put(rec1.age); Ada.text_io.new_line;

      end loop;



end SampleRelativeHashFile;








Sample output: C:> SampleRelativeHashFile > result



  1  Empty          0

  2  Empty          0

  3  Empty          0

  4  Empty          0

  5  Empty          0

  6  Empty          0





  1  Empty          0

  2  Empty          0

  3  Empty          0

  4  Empty          0

  5  Joe              22

  6  Empty          0





  1  Empty          0

  2  Empty          0

  3  Empty          0

  4  Empty          0

  5  Joe              22

  6  Mary          18










Hint:

with ada.text_io;

use ada.text_io;

with ada.unchecked_conversion;

procedure chartestConvert is

  function chartointeger is new ada.unchecked_conversion(character,integer);



  package integerIO is new ada.text_IO.integer_IO(integer);

  use integerIO;



  key: String(1..10) := "ABCDEFGHIJ";

  keyString: String(1..2);



  charA, charB, aChar: character;

  sum, J, K: integer;



begin

  charA := key(1);

  put( charA); new_line;

  charB := key(2);

  put( charB); new_line;



  put( chartointeger( charA ) );

  put( chartointeger( charB ) );

  new_line(2);



  J := chartointeger( charA ); put("J = "); put(J); new_line;

  K := chartointeger( charB ); put("K = "); put(K); new_line;

  new_line(2);



  sum := J * 100 + K;

  put("sum = "); put( sum );

  new_line(2);



  -- Another approach.

  aChar := 'B';  --Remember there is a difference between characters and strings in most languages.

  if( aChar = 'A') then 

      put( 65 );

  else if( aChar = 'B') then

           put( 66 );

           -- etcetera

       end if;

  end if;



end;



-- output

--A

--B

--     65     66

--

--

--J =     65

--K =     66

--

--sum =     6566

--

--

--     66

Hash
address | Contents at the address | Original hash address | Final hash address | Number of probes to store/retrieve

1 | Joe | 1 | 1 | 1

2 | Mary | 74 | 2 | 26

3 |  |  |  | 

°°° | °°° | °°° | °°° | °°°

100 | Zorro | 57 | 75 | 2

 | My Hash Linear | My Hash Linear | Your Hash Linear | Your Hash Linear | My Hash Random | My Hash Random | Your Hash Random | Your Hash Random | 

First 25 | 1st 25 | Last 25 | 1st 25 | Last 25 | 1st 25 | Last 25 | 1st 25 | Last 25 | 

Min Probe |  |  |  |  |  |  |  |  | 

Max |  |  |  |  |  |  |  |  | 

Average |  |  |  |  |  |  |  |  | 

Theoretical |  |  |  |  |  |  |  |  | 

 | My Hash Linear | Your Hash Linear | My Hash Random | Your Hash Random

Average all keys! |  |  |  | 