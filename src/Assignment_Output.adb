
with Ada.Text_IO;   use Ada.Text_IO;
with Ada.Integer_Text_IO;    use Ada.Integer_Text_IO;
with Ada.Float_Text_IO;  use Ada.Float_Text_IO;
with Ada.Numerics.Elementary_Functions;  use Ada.Numerics.Elementary_Functions;
with Hash_Type;   use Hash_Type;

package body Assignment_Output is

   -- linear: E = (1/2)(1 + 1/(1-a))=2.5 at a=.75
   function  Theoretical_Linear (Load_Factor : Float) return Float is
   begin
      return 0.5 * ( 1.0 + 1.0 / (1.0-Load_Factor));
   end Theoretical_Linear;

   -- random:  E= -ln(1-a)/a = 1.85 at a=.75
   function Theoretical_Random(Load_Factor: Float) return Float is
   begin
      return   -Log(1.0 - Load_Factor) / Load_Factor;
   end Theoretical_Random;

   procedure   Print_Scenario_Results
     (Storage_Label : String;Hash_Label : String;Probe_Label : String;Keys: Key_Array;Key_Count : Natural)
   is
      Probe_Count: Natural;
      Total_Probes: Natural  :=0;
      Min_Probes: Natural := Natural'Last;
      Max_Probes: Natural := 0;
      Found : Boolean;

   begin
      Put_Line("========================================");
      Put_Line(Storage_Label & " | " & Hash_Label & " | "  & Probe_Label);
      Put_Line("========================================");

      -- insert keys
      for I in 1..Key_Count loop

         Insert(Keys(I), Probe_Count, Found);

         Total_Probes := Total_Probes + Probe_Count;

         if Probe_Count < Min_Probes then
            Min_Probes := Probe_Count;
         end if;

         if Probe_Count > Max_Probes then
            Max_Probes := Probe_Count;
         end if;

      end loop;

      declare
         Avg   : Float := Float(Total_Probes) / Float(Key_Count);
         Load  : Float := Float(Key_Count) / Float(Get_Table_Size) ;
         T  : Float;
      begin
         if Probe_Label = "LINEAR" then
            T := Theoretical_Linear(Load);
         else
            T := Theoretical_Random(Load);
         end if;

         Put_Line("Inserted" & Natural'Image(Key_Count) & " keys");
         Put_Line("");

         Put("Min probes: "); Put(Min_Probes, 3); New_Line;
         Put("Max probes: "); Put(Max_Probes, 3); New_Line;
         Put("Avg probes: "); Put(Avg, Fore=>3, Aft=>2, Exp=>0); New_Line;
         Put_Line("");

         Put("Theoretical: "); Put(T, Fore=>3, Aft=>2, Exp=>0); New_Line;
         Put_Line("");
      end;

   end Print_Scenario_Results;

   procedure Print_Hash_Table_Contents
      (Storage_Label:String;Hash_Label:String; Probe_Label:String)
   is
   begin
      Put_Line("");
      Put_Line("========================================");
      Put_Line("TABLE: " & Storage_Label &
               " | " & Hash_Label & " + " & Probe_Label);
      Put_Line("========================================");
      Put_Line("Hash      Contents at          Original hash    Final hash    Probes");
      Put_Line("address   the address          address          address       to store");
      Put_Line("--------------------------------------------------------------------------");

      Dump_Table;

      Put_Line("");
   end Print_Hash_Table_Contents;

   procedure Print_Theoretical_Comparison
      (Probe_Method : String;Load_Factor : Float; Actual_Avg : Float)
   is
      T  : Float;
      Dif : Float;
   begin
      Put_Line("");
      Put_Line("THEORETICAL vs ACTUAL");
      Put_Line("");

      if Probe_Method = "LINEAR" then
         T := Theoretical_Linear(Load_Factor);
         Put_Line("Linear probing formula: E = (1/2)(1 + 1/(1-a))");
      else
         T := Theoretical_Random(Load_Factor);
         Put_Line("Random probing formula: E = -ln(1-a) / a");
      end if;

      Put_Line("");
      Put("Load factor: "); Put(Load_Factor,3,2,0); New_Line;

      Put("Theoretical: "); Put(T,3,2,0); Put_Line(" probes");
      Put("Actual:   "); Put(Actual_Avg,3,2,0); Put_Line(" probes");

      Put_Line("");

      Dif := ((Actual_Avg - T) / T) * 100.0;
      Put("Difference:  ");
      if Dif >= 0.0 then Put("+"); end if;
      Put(Dif,3,1,0);
      Put_Line ("%");
      Put_Line("");
   end Print_Theoretical_Comparison;

   procedure Run_Assignment_Tests (Keys : Key_Array) is
      Key_Count  : constant Natural := 75;
      Load : constant Float:= 0.75;

      Total  : Natural;
      Count:Natural;
      Found : Boolean;
      Avg  : Float;

   begin


      Initialize_Table(Relative_File_Storage, BurrisHash_Function, Linear_Probing);
      Print_Scenario_Results("Relative File", "BurrisHash", "LINEAR",Keys, Key_Count);
      Print_Hash_Table_Contents("Relative File", "BurrisHash", "LINEAR");

      Total:=0;
      for I in 1 .. Key_Count loop
         Search(Keys(I), Count, Found);
         Total := Total + Count;
      end loop;
      Avg := Float(Total)/Float(Key_Count);
      Print_Theoretical_Comparison("LINEAR", Load, Avg);


      Initialize_Table(Relative_File_Storage, BurrisHash_Function, Random_Probing);
      Print_Scenario_Results("Relative File","BurrisHash","RANDOM", Keys,Key_Count);
      Print_Hash_Table_Contents("Relative File","BurrisHash","RANDOM");

      Total := 0;
      for I in 1..Key_Count loop
         Search(Keys(I), Count, Found);
         Total:=Total+Count;
      end loop;
      Avg := Float(Total)/Float(Key_Count);
      Print_Theoretical_Comparison("RANDOM", Load, Avg);

      Initialize_Table(Main_Memory_Storage, BurrisHash_Function, Linear_Probing);
      Print_Scenario_Results("Main Memory","BurrisHash","LINEAR",  Keys, Key_Count);
      Print_Hash_Table_Contents("Main Memory","BurrisHash","LINEAR");

      Total := 0;
      for I in 1..Key_Count loop
         Search(Keys(I), Count, Found);
         Total := Total + Count;
      end loop;
      Avg := Float(Total)/Float(Key_Count);
      Print_Theoretical_Comparison("LINEAR", Load, Avg);


      Initialize_Table(Main_Memory_Storage, BurrisHash_Function, Random_Probing);
      Print_Scenario_Results("Main Memory","BurrisHash","RANDOM",  Keys, Key_Count);
      Print_Hash_Table_Contents("Main Memory","BurrisHash","RANDOM");

      Total := 0;
      for I in 1..Key_Count loop
         Search(Keys(I), Count, Found);
         Total := Total + Count;
      end loop;
      Avg := Float(Total) / Float(Key_Count);
      Print_Theoretical_Comparison("RANDOM", Load, Avg);

   end Run_Assignment_Tests;

end Assignment_Output;
