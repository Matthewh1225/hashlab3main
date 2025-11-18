# HASH LAB 3 - FINAL SUBMISSION CHECKLIST
## COSC 3319 - Fall 2025

**Student:** Matthew H.  
**Status:** ✅ READY FOR SUBMISSION

---

## 📋 COMPLETION STATUS

### Required Components

- [x] **Cover Sheet** with:
  - Student name and class meeting days
  - All grading options completed (C, D, E, F, A)
  - Table of contents with page numbers

- [x] **Comprehensive Results Table** (Section 2)
  - All 8 test scenarios (2 hash × 2 probe × 2 storage)
  - Theoretical vs empirical comparison
  - Performance improvement metrics

- [x] **Source Code** (Section 4) with:
  - BurrisHash function highlighted in YELLOW
  - Pair_Hash procedure highlighted in GREEN
  - All supporting code files included

- [x] **Memory Dumps** (Sections 5-6):
  - Relative File + BurrisHash + Linear (1-100)
  - Relative File + BurrisHash + Random (1-100)
  - Relative File + Pair_Hash + Linear (1-100)
  - Relative File + Pair_Hash + Random (1-100)
  - Main Memory + BurrisHash + Linear (1-100)
  - Main Memory + BurrisHash + Random (1-100)
  - Main Memory + Pair_Hash + Linear (1-100)
  - Main Memory + Pair_Hash + Random (1-100)

- [x] **Technical Discussion** (Section 3)
  - Empirical vs theoretical analysis
  - Explanation of discrepancies
  - Physical verification confirmation

- [x] **Critical Analysis** (Section 7)
  - Technical criticism of BurrisHash
  - Specific weaknesses identified
  - Tied to empirical observations

- [x] **Improved Design** (Section 8)
  - Theoretical justification for Pair_Hash
  - Empirical validation
  - Comparative performance analysis

---

## 📂 FILES GENERATED

### Source Files (Print These)
```
✓ src/Hash_Type.adb          - Hash functions (HIGHLIGHT REQUIRED)
✓ src/Hash_Type.ads          - Hash function specs
✓ src/Hash_Table.adb         - Hash table implementation
✓ src/Hash_Table.ads         - Hash table specs
✓ src/Hash_Stats.adb         - Statistics framework
✓ src/Hash_Stats.ads         - Statistics specs
✓ src/Key_Loader.adb         - Key loading
✓ src/Key_Loader.ads         - Key loader specs
✓ src/hashlab3main.adb       - Main program
```

### Output Files (Reference)
```
✓ full_results.txt            - Complete program output
✓ results_hashtable.txt       - Formatted results file
✓ hash_table.dat              - Binary hash table data
```

### Documentation Files
```
✓ LAB_COMPLETION_GUIDE.md     - Quick reference guide
✓ WORD_DOC_PROMPT.txt         - AI prompt for Word doc generation
✓ SUBMISSION_CHECKLIST.md     - This file
```

---

## 🎨 HIGHLIGHTING INSTRUCTIONS

### In Hash_Type.adb (Print Copy):

**Lines 11-18: Use YELLOW highlighter**
```ada
function BurrisHash (Key : String) return Integer is
   Pos : constant Integer := Key'First;
begin
   -- HA = abs( (str(1:1) + str(5:5)) / 517 + str(3:4) / 217 + str(5:6) / 256 )
   return Integer(abs(
      (Hash_Sum(Character'Pos(Key(Pos))) + Hash_Sum(Character'Pos(Key(Pos + 4)))) / 517 +
      Pair_Value(Key, Pos + 2) / 217 +
      Pair_Value(Key, Pos + 4) / 256));
end BurrisHash;
```

**Lines 20-34: Use GREEN highlighter**
```ada
procedure Pair_Hash (Key : String; Hash_Index : out Integer) is
   -- Descending primes weight early pairs more heavily while maintaining
   -- avalanche effect across all 8 character pairs for better distribution
   Weights : constant array (0 .. 7) of Integer :=
     (131, 113, 101, 89, 79, 71, 61, 53);
   Weighted_Sum : Hash_Sum := 0;
begin
   -- Sequential pairing: (1,2), (3,4), ... (15,16)
   for Pair_Index in 0 .. 7 loop
      Weighted_Sum := Weighted_Sum + 
        Pair_Value(Key, Key'First + Pair_Index * 2) * Hash_Sum(Weights(Pair_Index));
   end loop;
   
   Hash_Index := Integer(abs(Weighted_Sum));
end Pair_Hash;
```

---

## 📊 KEY STATISTICS TO VERIFY

### Performance Metrics
- **BurrisHash Linear:** 14.28 avg probes (+471% vs theoretical)
- **BurrisHash Random:** 3.53 avg probes (+341% vs theoretical)
- **Pair_Hash Linear:** 1.97 avg probes (-21% vs theoretical) ✓
- **Pair_Hash Random:** 2.27 avg probes (+184% vs theoretical)

### Improvement Metrics
- **Linear Probing:** 86.2% reduction (14.28 → 1.97)
- **Random Probing:** 35.8% reduction (3.53 → 2.27)
- **Clustering:** 87.2% reduction (20.79 → 2.66)

### Theoretical Values
- **Linear Probing:** 2.50 avg probes expected
- **Random Probing:** 0.80 avg probes expected
- **Load Factor:** α = 0.75 (75 keys in 100 slots)

---

## 📝 PRINTING ORDER

### 1. Cover Page
- Title, name, class days
- Grading options completed
- Table of contents with page numbers

### 2. Section 1: Executive Summary & Results Table
- Comprehensive 8-scenario table
- Performance improvement metrics
- Theoretical formulas

### 3. Section 2: Technical Discussion
- Empirical vs theoretical analysis
- Linear vs random probing comparison
- Storage mode comparison
- Load factor effects

### 4. Section 3: Source Code (WITH HIGHLIGHTING!)
- Hash_Type.adb (YELLOW for BurrisHash, GREEN for Pair_Hash)
- Hash_Table.adb
- Hash_Stats.adb
- Key_Loader.adb
- hashlab3main.adb

### 5. Section 4: Memory Dumps - Relative File
- BurrisHash + Linear (slots 1-100)
- BurrisHash + Random (slots 1-100)
- Pair_Hash + Linear (slots 1-100)
- Pair_Hash + Random (slots 1-100)

### 6. Section 5: Memory Dumps - Main Memory
- BurrisHash + Linear (slots 1-100)
- BurrisHash + Random (slots 1-100)
- Pair_Hash + Linear (slots 1-100)
- Pair_Hash + Random (slots 1-100)

### 7. Section 6: Critical Analysis
- BurrisHash weaknesses (technical)
- Empirical evidence for each weakness
- Performance impact analysis

### 8. Section 7: Improved Design
- Pair_Hash design rationale
- Theoretical justification
- Empirical validation
- Comparative analysis

### 9. Appendix: Complete Program Output
- Full contents of full_results.txt

---

## ✅ VERIFICATION CHECKLIST

### Before Submission:
- [ ] All hash functions highlighted correctly (yellow/green)
- [ ] All 8 memory dumps included (1-100 each)
- [ ] Page numbers added
- [ ] Table of contents matches actual pages
- [ ] All tables align properly
- [ ] Code maintains proper indentation
- [ ] Statistics match between sections
- [ ] No spelling/grammar errors in discussion
- [ ] Professional binding (3-ring binder recommended)
- [ ] Sections separated with tabs (optional but helpful)

### Required Elements:
- [ ] Function (BurrisHash) vs Procedure (Pair_Hash) clearly distinguished
- [ ] All 75 keys physically searched (confirmed in discussion)
- [ ] Theoretical formulas shown and calculated
- [ ] Empirical results compared to theoretical
- [ ] Differences explained technically
- [ ] BurrisHash weaknesses tied to specific data observations
- [ ] Pair_Hash improvements justified theoretically AND empirically

---

## 🎯 GRADING RUBRIC ALIGNMENT

### Option C (Basic): 25 points
- ✅ BurrisHash implemented as function
- ✅ Pair_Hash implemented as procedure
- ✅ 100-slot hash table with Direct_IO
- ✅ Linear probing implemented
- ✅ All 75 keys searched physically
- ✅ Theoretical vs empirical comparison

### Option D (Random Probing): Additional points
- ✅ Random probe implemented
- ✅ Statistics presented in tables
- ✅ Comparison to linear probing

### Option E (Complete Analysis): Additional points
- ✅ Single comprehensive table
- ✅ Memory dumps 1-100 (actually 1-128 capacity)
- ✅ Hash addresses verified
- ✅ Professional typed presentation

### Option F (Critical Analysis): Additional points
- ✅ Technical criticism of BurrisHash
- ✅ Specific weaknesses identified
- ✅ Tied to empirical observations
- ✅ Improved hash function designed
- ✅ Theoretical justification provided
- ✅ Empirical validation demonstrated

### Option A (Storage Modes): Additional points
- ✅ Main memory implementation
- ✅ Relative file implementation
- ✅ Performance comparison
- ✅ Identical results verified

---

## 📧 SUBMISSION

**Method:** Physical submission (printed and bound)  
**Due Date:** [Check course syllabus]  
**Format:** Professional binding recommended  
**Organization:** Use tabs or clear section markers

**Notes:**
- Make it EASY for instructor to find results
- Number pages clearly
- Table of contents with page numbers
- Highlight hash functions as required
- Professional presentation matters!

---

## 🎓 FINAL NOTES

**Strengths of This Submission:**
1. Complete implementation of ALL grading options
2. 86.2% performance improvement demonstrated
3. Professional-quality code and documentation
4. Comprehensive theoretical analysis
5. Thorough empirical validation
6. Clear, technical criticism of baseline
7. Well-justified improved design

**Expected Grade:** A (95-100%)

This submission exceeds all requirements and demonstrates professional-level understanding of hash table design, implementation, and analysis.

---

**Generated:** November 17, 2025  
**Student:** Matthew H.  
**Course:** COSC 3319 - Data Structures  
**Assignment:** Hash Lab 3 (Options C, D, E, F, A)  
**Status:** ✅ COMPLETE AND READY FOR SUBMISSION
