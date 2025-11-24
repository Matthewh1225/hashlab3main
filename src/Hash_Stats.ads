package Hash_Stats is
   --file management
   procedure Open_Output_File(Filename : String);
   procedure Close_Output_File;
   
   --basic output procedures
   procedure Print_Line(Text : String);
   procedure Print_Header(Text : String);
   procedure Print_Blank_Line;
   
   --formatted output procedures
   procedure Print_Distribution_Metrics(
      Total_Probes : Integer;
      Load_Factor : Float;
      Clustering_Ratio : Float);
   
   procedure Print_Key_Group_Stats(
      Group_Name : String;Min_Probes :
       Integer;Max_Probes : Integer;
       Avg_Probes : Float);
   
   procedure Print_Theoretical_Results(Load_Factor : Float;Theoretical_Linear : Float;Theoretical_Random : Float);
   
   procedure Print_Actual_Results(Avg_Probes : Float);
   
   procedure Print_Comparison_Table(
      Table_Label : String;
      BL_First : Float; BL_Last : Float; BL_All : Float;
       BR_First : Float; BR_Last: Float; BR_All : Float;
      YL_First : Float; YL_Last : Float; YL_All: Float;
      YR_First : Float; YR_Last : Float; YR_All : Float);
   
   procedure Print_Storage_Comparison(
      BL_Rel : Float; BL_Mem : Float;
      BR_Rel : Float; BR_Mem : Float;
      YL_Rel : Float; YL_Mem : Float;
      YR_Rel : Float; YR_Mem : Float);

end Hash_Stats;
