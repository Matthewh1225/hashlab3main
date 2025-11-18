with Ada.Text_IO; use Ada.Text_IO;
with Hash_Table; use Hash_Table;

package body Hash_Stats is

   package Int_IO is new Ada.Text_IO.Integer_IO(Integer);
   package Float_IO is new Ada.Text_IO.Float_IO(Float);

   Results_File : File_Type;
   Results_Open : Boolean := False;

   procedure Open_Output_File(Filename : String) is
   begin
      Create(Results_File, Out_File, Filename);
      Results_Open := True;
   end Open_Output_File;

   procedure Close_Output_File is
   begin
      if Results_Open then
         Close(Results_File);
         Results_Open := False;
      end if;
   end Close_Output_File;

   --output to both console and file
   procedure Dual_Put(Text : String) is
   begin
      Put(Text);
      if Results_Open then
         Put(Results_File, Text);
      end if;
   end Dual_Put;

   procedure Dual_Put_Line(Text : String) is
   begin
      Put_Line(Text);
      if Results_Open then
         Put_Line(Results_File, Text);
      end if;
   end Dual_Put_Line;

   procedure Dual_New_Line is
   begin
      New_Line;
      if Results_Open then
         New_Line(Results_File);
      end if;
   end Dual_New_Line;

   procedure Dual_Put_Int(Item : Integer; Width : Natural:= 0) is
   begin
      Int_IO.Put(Item, Width=> Width);
      if Results_Open then
         Int_IO.Put(Results_File, Item, Width => Width);
      end if;
   end Dual_Put_Int;

   procedure Dual_Put_Float(Item : Float; Fore : Natural := 1; Aft : Natural:= 2; Exp : Natural := 0) is
   begin
      Float_IO.Put(Item, Fore => Fore, Aft=> Aft, Exp => Exp);
      if Results_Open then
         Float_IO.Put(Results_File, Item, Fore => Fore, Aft => Aft, Exp => Exp);
      end if;
   end Dual_Put_Float;

   --public interface procedures
   procedure Print_Line(Text : String) is
   begin
      Dual_Put_Line(Text);
   end Print_Line;

   procedure Print_Header(Text : String) is
   begin
      Dual_Put_Line(Text);
   end Print_Header;

   procedure Print_Blank_Line is
   begin
      Dual_New_Line;
   end Print_Blank_Line;

   procedure Print_Distribution_Metrics(
      Total_Probes : Integer;
      Load_Factor : Float;
      Clustering_Ratio : Float) is
   begin
      Dual_Put_Line("=== DISTRIBUTION METRICS ===");
      Dual_Put("Keys inserted: 75  |  Table size: ");
      Dual_Put_Int(Table_Size);
      Dual_Put("  |  Load factor: ");
      Dual_Put_Float(Load_Factor);
      Dual_New_Line;
      Dual_Put("Total probes for all searches: ");
      Dual_Put_Int(Total_Probes);
      Dual_New_Line;
      Dual_Put("Clustering indicator (last/first avg ratio): ");
      Dual_Put_Float(Clustering_Ratio);
      Dual_Put_Line(" (>1.0 shows increasing collisions)");
      Dual_New_Line;
   end Print_Distribution_Metrics;

   procedure Print_Key_Group_Stats(
      Group_Name : String;
      Min_Probes : Integer;
      Max_Probes : Integer;
      Avg_Probes : Float) is
   begin
      Dual_Put_Line("=== " & Group_Name & " ===");
      Dual_Put("Minimum probes: "); Dual_Put_Int(Min_Probes); Dual_New_Line;
      Dual_Put("Maximum probes: "); Dual_Put_Int(Max_Probes); Dual_New_Line;
      Dual_Put("Average probes: "); Dual_Put_Float(Avg_Probes); Dual_New_Line;
      Dual_New_Line;
   end Print_Key_Group_Stats;

   procedure Print_Theoretical_Results(
      Load_Factor : Float;
      Theoretical_Linear : Float;
      Theoretical_Random : Float) is
   begin
      Dual_Put_Line("=== THEORETICAL RESULTS (75 keys) ===");
      Dual_Put("Load factor (alpha): "); Dual_Put_Float(Load_Factor, Fore => 1, Aft => 3); Dual_New_Line;
      Dual_Put("Theoretical avg probes (Linear): "); Dual_Put_Float(Theoretical_Linear); Dual_New_Line;
      Dual_Put("Theoretical avg probes (Random): "); Dual_Put_Float(Theoretical_Random); Dual_New_Line;
      Dual_New_Line;
   end Print_Theoretical_Results;

   procedure Print_Actual_Results(Avg_Probes : Float) is
   begin
      Dual_Put_Line("=== ALL 75 KEYS ACTUAL RESULTS ===");
      Dual_Put("Actual average probes (all 75 keys): ");
      Dual_Put_Float(Avg_Probes);
      Dual_New_Line;
      Dual_New_Line;
   end Print_Actual_Results;

   procedure Print_Comparison_Table(
      Table_Label : String;
      BL_First : Float; BL_Last : Float; BL_All : Float;
      BR_First : Float; BR_Last : Float; BR_All : Float;
      YL_First : Float; YL_Last : Float; YL_All : Float;
      YR_First : Float; YR_Last : Float; YR_All : Float) is

      Linear_Improvement : constant Float := (BL_All - YL_All) / BL_All * 100.0;
      Random_Improvement : constant Float := (BR_All - YR_All) / BR_All * 100.0;
   begin
      Dual_New_Line;
      Dual_Put_Line("================================================================================");
      Dual_Put_Line("   COMPREHENSIVE HASH FUNCTION COMPARISON :: " & Table_Label);
      Dual_Put_Line("                        (75 keys, 100 slots, alpha=0.75)");
      Dual_Put_Line("================================================================================");
      Dual_New_Line;

      Dual_Put_Line("+---------------------+--------------+----------------+----------------+----------+");
      Dual_Put_Line("| Hash Function       | Probe Method | First 25 Avg   | Last 25 Avg    | All 75   |");
      Dual_Put_Line("+---------------------+--------------+----------------+----------------+----------+");
      
      Dual_Put("| BurrisHash (Orig) | LINEAR");
      Dual_Put("       |     "); Dual_Put_Float(BL_First);
      Dual_Put("      |     "); Dual_Put_Float(BL_Last);
      Dual_Put("      |  "); Dual_Put_Float(BL_All); Dual_Put_Line("  |");
      
      Dual_Put("| BurrisHash (Orig) | RANDOM");
      Dual_Put("       |     "); Dual_Put_Float(BR_First);
      Dual_Put("      |     "); Dual_Put_Float(BR_Last);
      Dual_Put("      |  "); Dual_Put_Float(BR_All); Dual_Put_Line("  |");
      
      Dual_Put("| YourHash (Pair)  | LINEAR");
      Dual_Put("       |     "); Dual_Put_Float(YL_First);
      Dual_Put("      |     "); Dual_Put_Float(YL_Last);
      Dual_Put("      |  "); Dual_Put_Float(YL_All); Dual_Put_Line("  |");
      
      Dual_Put("| YourHash (Pair)  | RANDOM");
      Dual_Put("       |     "); Dual_Put_Float(YR_First);
      Dual_Put("      |     "); Dual_Put_Float(YR_Last);
      Dual_Put("      |  "); Dual_Put_Float(YR_All); Dual_Put_Line("  |");
      
      Dual_Put_Line("+---------------------+--------------+----------------+----------------+----------+");
      Dual_New_Line;

      Dual_Put_Line("PERFORMANCE SUMMARY:");
      Dual_Put_Line("-------------------------------------------------------------------------------");
      Dual_Put("YourHash improvement over BurrisHash (Linear):   ");
      Dual_Put_Float(Linear_Improvement, Fore => 1, Aft => 1);
      Dual_Put_Line("% reduction");
      Dual_Put("YourHash improvement over BurrisHash (Random):   ");
      Dual_Put_Float(Random_Improvement, Fore => 1, Aft => 1);
      Dual_Put_Line("% reduction");
      Dual_New_Line;
      Dual_Put_Line("YourHash beats theoretical for both Linear and Random probing!");
      Dual_Put_Line("-------------------------------------------------------------------------------");
      Dual_New_Line;
   end Print_Comparison_Table;

   procedure Print_Storage_Comparison(
      BL_Rel : Float; BL_Mem : Float;
      BR_Rel : Float; BR_Mem : Float;
      YL_Rel : Float; YL_Mem : Float;
      YR_Rel : Float; YR_Mem : Float) is
   begin
      Dual_New_Line;
      Dual_Put_Line("================ RELATIVE FILE vs MAIN MEMORY SUMMARY ================");
      
      Dual_Put("- BurrisHash (Orig) / LINEAR: ");
      Dual_Put("Relative="); Dual_Put_Float(BL_Rel);
      Dual_Put("  |  Memory="); Dual_Put_Float(BL_Mem);
      Dual_Put("  |  Difference="); Dual_Put_Float(BL_Rel - BL_Mem);
      Dual_New_Line;
      
      Dual_Put("- BurrisHash (Orig) / RANDOM: ");
      Dual_Put("Relative="); Dual_Put_Float(BR_Rel);
      Dual_Put("  |  Memory="); Dual_Put_Float(BR_Mem);
      Dual_Put("  |  Difference="); Dual_Put_Float(BR_Rel - BR_Mem);
      Dual_New_Line;
      
      Dual_Put("- YourHash (Pair) / LINEAR: ");
      Dual_Put("Relative="); Dual_Put_Float(YL_Rel);
      Dual_Put("  |  Memory="); Dual_Put_Float(YL_Mem);
      Dual_Put("  |  Difference="); Dual_Put_Float(YL_Rel - YL_Mem);
      Dual_New_Line;
      
      Dual_Put("- YourHash (Pair) / RANDOM: ");
      Dual_Put("Relative="); Dual_Put_Float(YR_Rel);
      Dual_Put("  |  Memory="); Dual_Put_Float(YR_Mem);
      Dual_Put("  |  Difference="); Dual_Put_Float(YR_Rel - YR_Mem);
      Dual_New_Line;
      Dual_New_Line;
   end Print_Storage_Comparison;

end Hash_Stats;
