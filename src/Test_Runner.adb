with Ada.Text_IO; use Ada.Text_IO;
with Ada.Numerics.Elementary_Functions;
with Hash_Table; use Hash_Table;
with Key_Loader; use Key_Loader;
with Hash_Stats;

package body Test_Runner is

   --statistics record for each test scenario
   type Test_Stats is record
      first_25_avg : Float;
      last_25_avg : Float;
      all_75_avg : Float;
      theoretical : Float;
      theoretical_random : Float;
      first_25_min : Integer;
      first_25_max : Integer;
      last_25_min : Integer;
      last_25_max : Integer;
   end record;

   type Mode_Stats_Array is array (Storage_Mode, Hash_Function_Type, Probe_Method) of Test_Stats;

   procedure Run_Hash_Scenario(
      Selected_Probe_Method   : Probe_Method;
      Probe_Method_Label      : String;
      Selected_Hash_Function  : Hash_Function_Type;
      Hash_Label_Text         : String;
      Storage_Mode_Selection  : Storage_Mode;
      Storage_Label_Text      : String;
      Scenario_Stats          : out Test_Stats;
      Input_Keys              : in Key_Array) is

      total_probes     : Integer := 0;
      current_probes   : Integer;
      first_total      : Integer := 0;
      last_total       : Integer:= 0;
      Load_Factor      : constant Float := 0.75;
      First_Block_End  : constant Positive := 25;
      Last_Block_Start : constant Positive := 51;
   begin
      Set_Storage_Mode(Storage_Mode_Selection);

      Hash_Stats.Print_Header("\n========================================");
      Hash_Stats.Print_Header(Storage_Label_Text & " :: " & Hash_Label_Text & " + " & Probe_Method_Label & " PROBING");
      Hash_Stats.Print_Header("========================================");
      Hash_Stats.Print_Blank_Line;

      Set_Hash_Function(Selected_Hash_Function);
      Set_Probe_Method(Selected_Probe_Method);
      Create_Table;

      for Key_Index in Input_Keys'Range loop
         Insert_Key(Input_Keys(Key_Index));
      end loop;

      Hash_Stats.Print_Line("Inserted 75 keys into hash table");
      Hash_Stats.Print_Blank_Line;

      Hash_Stats.Print_Line("=== HASH FUNCTION DETAILS ===");
      if Selected_Hash_Function = Original_Hash then
         Hash_Stats.Print_Line("Algorithm: BurrisHash - uses char positions 1,5 and pairs 3-4, 5-6");
         Hash_Stats.Print_Line("Formula: HA = (char[1] + char[5])/517 + pair[3:4]/2**17 + pair[5:6]/256");
         Hash_Stats.Print_Line("Characteristic: Simple arithmetic with fixed divisors, may cluster");
      else
         Hash_Stats.Print_Line("Algorithm: YourHash - sequential pair accumulation with weighted sum");
         Hash_Stats.Print_Line("Strategy: 8 character pairs (1-2, 3-4, ... 15-16) weighted by primes");
         Hash_Stats.Print_Line("Weights: [191, 167, 131, 83, 59, 31, 17, 7] - descending for balance");
         Hash_Stats.Print_Line("Method: ASCII values concatenated as decimals (e.g., 'ab' -> 9798) then weighted");
         Hash_Stats.Print_Line("Goal: Better distribution across table, reduce clustering");
      end if;
      Hash_Stats.Print_Blank_Line;

      Scenario_Stats.first_25_min := Integer'Last;
      Scenario_Stats.first_25_max:= Integer'First;
      Scenario_Stats.last_25_min := Integer'Last;
      Scenario_Stats.last_25_max  := Integer'First;

      for Key_Index in Input_Keys'Range loop
         current_probes := Search_Key(Input_Keys(Key_Index));
         total_probes:= total_probes + current_probes;

         --track first and last 25 keys stats
         if Key_Index <= First_Block_End then
            first_total := first_total + current_probes;
            Scenario_Stats.first_25_min := Integer'Min(Scenario_Stats.first_25_min, current_probes);
            Scenario_Stats.first_25_max := Integer'Max(Scenario_Stats.first_25_max, current_probes);
         elsif Key_Index >= Last_Block_Start then
            last_total:= last_total + current_probes;
            Scenario_Stats.last_25_min:= Integer'Min(Scenario_Stats.last_25_min, current_probes);
            Scenario_Stats.last_25_max := Integer'Max(Scenario_Stats.last_25_max, current_probes);
         end if;
      end loop;

      Scenario_Stats.first_25_avg := Float(first_total) / 25.0;
      Scenario_Stats.last_25_avg  := Float(last_total) / 25.0;
      Scenario_Stats.all_75_avg   := Float(total_probes) / 75.0;

      --calcualte theoretical expected probes
      Scenario_Stats.theoretical := 0.5 * (1.0 + 1.0 / (1.0 - Load_Factor));
      Scenario_Stats.theoretical_random :=
         -1.0 / Load_Factor * Ada.Numerics.Elementary_Functions.Log(1.0 - Load_Factor, 10.0);

      Hash_Stats.Print_Distribution_Metrics(
         total_probes,
         Load_Factor,
         Scenario_Stats.last_25_avg / Scenario_Stats.first_25_avg);

      Hash_Stats.Print_Key_Group_Stats("FIRST 25 KEYS",Scenario_Stats.first_25_min,Scenario_Stats.first_25_max, Scenario_Stats.first_25_avg);

      Hash_Stats.Print_Key_Group_Stats("LAST 25 KEYS",Scenario_Stats.last_25_min,Scenario_Stats.last_25_max,Scenario_Stats.last_25_avg);

      Hash_Stats.Print_Theoretical_Results(Load_Factor,Scenario_Stats.theoretical,Scenario_Stats.theoretical_random);

      Hash_Stats.Print_Actual_Results(Scenario_Stats.all_75_avg);

      Hash_Stats.Print_Line("EMPIRICAL vs THEORETICAL ANALYSIS:");
      Hash_Stats.Print_Line("With load factor 0.75, linear probing shows clustering.");
      Hash_Stats.Print_Line("Later insertions encounter more collisions.");
      Hash_Stats.Print_Line("Empirical results may vary from theoretical due to");
      Hash_Stats.Print_Line("hash function distribution and clustering effects.");
      Hash_Stats.Print_Blank_Line;

      Display_HashTable(Storage_Label_Text & " | " & Hash_Label_Text & " + " & Probe_Method_Label & " Probing");
      Close_Table;
   end Run_Hash_Scenario;

   procedure Run_All_Tests(Test_Keys : in Key_Array) is
      All_Stats : Mode_Stats_Array;

      procedure Run_Mode(Mode : Storage_Mode) is
         Mode_Name : constant String := (case Mode is 
            when Relative_File => "Relative File",
            when Main_Memory  =>"Main Memory");
      begin
         Run_Hash_Scenario(Linear, "LINEAR", Original_Hash, "BurrisHash (Orig)", Mode, Mode_Name,  All_Stats(Mode, Original_Hash, Linear), Test_Keys);

         Run_Hash_Scenario(Random_Probe, "RANDOM", Original_Hash, "BurrisHash (Orig)", Mode, Mode_Name, All_Stats(Mode, Original_Hash, Random_Probe), Test_Keys);

         Run_Hash_Scenario(Linear, "LINEAR", Pair_Hash, "YourHash (Pair)", Mode, Mode_Name, All_Stats(Mode, Pair_Hash, Linear), Test_Keys);

         Run_Hash_Scenario(Random_Probe, "RANDOM", Pair_Hash, "YourHash (Pair)",Mode, Mode_Name, All_Stats(Mode, Pair_Hash, Random_Probe), Test_Keys);

         Hash_Stats.Print_Comparison_Table(
            Mode_Name,
            All_Stats(Mode, Original_Hash, Linear).first_25_avg,
            All_Stats(Mode, Original_Hash, Linear).last_25_avg,
            All_Stats(Mode, Original_Hash, Linear).all_75_avg,
            All_Stats(Mode, Original_Hash, Random_Probe).first_25_avg,
            All_Stats(Mode, Original_Hash, Random_Probe).last_25_avg,
            All_Stats(Mode, Original_Hash, Random_Probe).all_75_avg,
            All_Stats(Mode, Pair_Hash, Linear).first_25_avg,
            All_Stats(Mode, Pair_Hash, Linear).last_25_avg,
            All_Stats(Mode, Pair_Hash, Linear).all_75_avg,
            All_Stats(Mode, Pair_Hash, Random_Probe).first_25_avg,
            All_Stats(Mode, Pair_Hash, Random_Probe).last_25_avg,
            All_Stats(Mode, Pair_Hash, Random_Probe).all_75_avg);
      end Run_Mode;
   begin
      Hash_Stats.Open_Output_File("results_hashtable.txt");

      Run_Mode(Relative_File);
      Run_Mode(Main_Memory);
      
      Hash_Stats.Print_Storage_Comparison(
         All_Stats(Relative_File, Original_Hash, Linear).all_75_avg,
         All_Stats(Main_Memory, Original_Hash, Linear).all_75_avg,
         All_Stats(Relative_File, Original_Hash, Random_Probe).all_75_avg,
         All_Stats(Main_Memory, Original_Hash, Random_Probe).all_75_avg,
         All_Stats(Relative_File, Pair_Hash, Linear).all_75_avg,
         All_Stats(Main_Memory, Pair_Hash, Linear).all_75_avg,
         All_Stats(Relative_File, Pair_Hash, Random_Probe).all_75_avg,
         All_Stats(Main_Memory, Pair_Hash, Random_Probe).all_75_avg);

      Hash_Stats.Close_Output_File;
   end Run_All_Tests;

end Test_Runner;
