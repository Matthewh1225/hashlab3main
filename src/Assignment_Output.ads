
with Hash_Table; use Hash_Table;
with Key_Loader; use Key_Loader;

package Assignment_Output is

   procedure Print_Scenario_Results
     (Storage_Label : String;Hash_Label : String; Probe_Label: String;  Key : Key_Array;  Key_Count : Natural);
   -- Print memory dump showing hash table slots
   procedure Print_Hash_Table_Contents(Storage_Label: String;Hash_Label : String;Probe_Label: String);
   -- Print theoretical vs actual comparison
   procedure Print_Theoretical_Comparison (Probe_Method : String;Load_Factor: Float; Actual_Avg : Float);
   
   procedure Run_Assignment_Tests (Keys : Key_Array);

end Assignment_Output;