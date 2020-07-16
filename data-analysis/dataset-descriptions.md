# Overview
- [1 - Toward Measuring Program Comprehension with Functional Magnetic Resonance Imaging](#1---toward-measuring-program-comprehension-with-functional-magnetic-resonance-imaging)
- [2 - A Look into Programmers’ Heads](#2---a-look-into-programmers-heads)
- [3 - Learning a Metric for Code Readability](#3---learning-a-metric-for-code-readability)
- [4 - An Empirical Investigation of the Influence of a Type of Side Effects on Program Comprehension](#4---an-empirical-investigation-of-the-influence-of-a-type-of-side-effects-on-program-comprehension)
- [5 - An Empirical Study on Program Comprehension with Reactive Programming](#5---an-empirical-study-on-program-comprehension-with-reactive-programming)
- [6 - Automatically Assessing Code Understandability](#6---automatically-assessing-code-understandability)
- [7 - Shorter identifier names take longer to comprehend](#7---shorter-identifier-names-take-longer-to-comprehend)
- [8 - Syntax, Predicates, Idioms - What Really Affects Code Complexity?](#8---syntax-predicates-idioms---what-really-affects-code-complexity)
- [9 - The Role of Method Chains and Comments in Software Readability and Comprehension---An Experiment](#9---the-role-of-method-chains-and-comments-in-software-readability-and-comprehension---an-experiment)
- [10 - Understanding misunderstandings in source code](#10---understanding-misunderstandings-in-source-code)

# Studies
## 1 - Toward Measuring Program Comprehension with Functional Magnetic Resonance Imaging
### Background
- Main Focus: 
  - Find suitable source code snippets for a follow-up comprehension study in an fMRI scanner
- Understandability construct:
  - A participant "understands" a code snippet if they compute an output correctly.
  - "... we force participants to use **bottom-up comprehension**, which means that participants analyze source code statement by statement to determine a program's purpose."
- Demographic:
  - 41 second-year students from a software-engineering course
- Pilot study for Dataset 2 (A look into programmer's heads)
- [Link to Dataset](https://tinyurl.com/ProgramComprehensionAndfMRI/)

### Code
- Programming Language:
  - Java
- Code Type:
  - 23 short code snippets 
  - Taken from first-year courses at university
- Obfuscated identifier names (e.g. the result is just named "result" and gives no indication about its content) to force bottom-up comprehension

### Measures
- Comprehension Task: Calculating output
- Measures:
  - Correctness. Correctness of the determined output.
  - Time. Time to determine the output. Taken from the point the code snippet is shown until the participant submits the answer.
- Measures were taken using [PROPHET](https://github.com/feigensp/Prophet)
-  Code is shown alongside the field to enter the output and the elapsed time.

## 2 - A Look into Programmers’ Heads
### Background
- Main Focus: 
  - Is functional magnetic resonance imaging (fMRI) feasible for soundly measuring program comprehension.
- Understandability construct:
  - A participant "understands" a code snippet if they when they compute an output correctly.
  - "... we force participants to use **bottom-up comprehension**, which means that participants analyze source code statement by statement to determine a program's purpose."
- Demographic:
  - 17 computer-science and mathematics students, undergraduate level of programming and Java experience.
- [Link to Dataset](https://tinyurl.com/ProgramComprehensionAndfMRI/)

### Code
- Programming Language:
  - Java
- Code Type:
  - 12 short code snippets 
  - Taken from first-year courses at university, pre-selected through two pilot studies
- Obfuscated identifier names (e.g. the result is just named "result" and gives no indication about its content) to force bottom-up comprehension
- Subset of the code from dataset 1
- Snippets were pre-selected to be of a similar length and difficulty.

### Measures
- Comprehension Task:
  - Calculating output.
  - For each snippet, the output calculation task was followed by a task of locating syntax errors in a different snippet for which "no understanding was required". Then the same for the next snippet and so on.
  - Comprehension time was limited to 60 seconds with a 30 second resting period between each task.
  - Fixed order of showing the snippets.
- Measures:
  - Concentration level. Indicated by the brain deactivation strength measured through fMRI.
  - Time. Time taken from the point the code snippet is shown until the participant confirms they understood the snippet or the time runs out.
- Measures were taken using [PROPHET](https://github.com/feigensp/Prophet)
-  Code is shown alongside the field to enter the output and the elapsed time.

## 3 - Learning a Metric for Code Readability

### Background
- Main Focus: 
  - Find correlations between their readability metric created on the basis of the data set and external notions of software quality.
- Understandability construct:
  - They specifically measured perceived readability, but describe readability basically the same way other studies describe understandability.
  - "We define readability as a human judgment of **how easy a text is to understand**."
  - Focus on the “low-level” details of readability, eliminating context and complexity. (= bottom-up comprehension?)
  - Clicking on a “help” link reminded users that they should score the snippets “based on their estimation of readability” and that “readability is their judgment about **how easy a block of code is to understand**.”
- Demographic:
  - 120 students with varying experience with reading and writing code (first-year to graduate)
- [Link to Dataset](http://www.arrestedcomputing.com/readability/)

### Code
- Programming Language:
  - Java
- Code Type:
  - 100 short code snippets (avg. 7.7 lines)
  - Generated from five open source projects

### Measures
- Comprehension Task:
  - Rating readability
  - Fixed order of 100 snippets for each participant, shown with syntax highlighting.
- Measures:
  - Readability Rating. Less readable 1 - 5 More readable. Participants score each snippet based on their personal estimation of readability. When users clicked help, they were reminded that “readability is their judgment about how easy a block of code is to understand.”


## 4 - An Empirical Investigation of the Influence of a Type of Side Effects on Program Comprehension
### Background
- Main Focus: 
  - Investigating the impacts of a type of side effect on program comprehension. Comparing comprehension of snippets with and without side effects.
- Understandability construct:
  - TBD
- Demographic:
  -  students of the third and fourth year of the BS degree in computer science and experienced professionals
- [Link to Dataset](http://www.sc.ehu.es/jiwdocoj/sef/sef.htm)

### Code
- Programming Language:
  - C
- Code Type:
  - 20 short code snippets
- 4A: 12 simple snippets (answered both by students and experts)
- 4B: 8 complex snippets (answered just by students)
- 4C: Both combined 

### Measures
- Comprehension Task:
  - Answering comprehension questions
  - Crossover design, two groups with both treatments (SE/SEF) but in a different order
  - Questions are shown alongside the code snippets
- Measures:
  - Correctness. Number of correct answers.
  - Time. Time spent answering the questions.

## 5 - An Empirical Study on Program Comprehension with Reactive Programming
### Background
- Main Focus: 
  - Comparing the comprehensibility of code written in the object-oriented and reactive programming style.
- Understandability construct:
  - Impact on program comprehension
  - "their understanding of reactive functionalities was measured"
  - "finding the correct answer requires to understand the (whole) reactive logic of the application"
- Demographic:
  - 38 students from a software engineering course (4th year)
- [Link to Dataset](http://www.stg.tu-darmstadt.de/research/)
- Between-subjects

### Code
- Programming Language:
  - Scala
- Code Type:
  - 20 complex code snippets (10 reactive, 10 object-oriented), knowledgeable in Java and somewhat knowledgeable in Scala

### Measures
- Comprehension Task:
  - Answering one question about the application behavior
  - Code is shown alongside the question using `WebCompr`
  - Subjects were encouraged to provide an answer as quickly a possible, but time only becomes relevant if the result is correct.
  - Upper time limit of 5 or 10 minutes depending on the task
- Measures:
  - Correctness. Subject correctly understood the behavior of the application and provided the right answer.
  - Time. Time taken to complete the task, answering the question about application behavior.


## 6 - Automatically Assessing Code Understandability
### Background
- Main Focus: 
  - Finding a metric to assess code understandability by correlating existing metrics with measures of understandability from experiments.
- Understandability construct:
  - "assess the **understandability of code snippets**"
  - "actual understandability of the code"
  - "estimate the effort required to understand a given piece of code"
- Demographic:
  - 63 developers
- [Link to Dataset](https://dibt.unimol.it/report/understandability-tse)

### Code
- Programming Language:
  - Java
- Code Type:
  - 50 code snippets from open-source projects

### Measures
- Comprehension Task:
  - Task 1: First, participants are asked whether they understood the snippet. (PBU, TNPU)
  - Task 2: If they answer yes, they are asked three verification questions. (AU)
- Measures:
  - PBU (Perceived Binary Understandability). 1 if the participant said they understood the snippet, 0 if not. (Task 1)
  - TNPU (Time Needed for Perceived Understandability). Time in seconds taken by the participant to answer whether they understood the snippet. (Task 1)
  - AU (Actual Understandability). Percentage of the three verification questions which are correct. If the participant answered said they did not understand the snippet earlier, the value is 0. (Task 2)
  - TAU (Timed Actual Understandability). Composite variable of the time taken by the participant to answer whether they understood the snippet (TNPU from Task 1) and the percentage of correct answers to the verification questions (AU from Task 2).
  - BD50 (Binary Deceptiveness). Composite variable of AU and PBU. If PBU (Perceived Binary Understandability) is 1 but AU (Actual Understdandability) is <50 %, then the snippet is seen as deceptive and BD50 is 1. This means the developer was deceived and incorrectly assumed they understood the snippet. Otherwise it is 0.

## 7 - Shorter identifier names take longer to comprehend
### Background
- Main Focus:
  - Investigate the effect of different indentifier naming styles on program comprehension
- Understandability construct:
  - "program comprehension rather than the perceptual processing of code"
  - Operationalizing the **performance of comprehension** by measuring how long developers investigated a snippet of code until they found a semantic defect.
  - "Code can only be corrected if it is understood."
- Demographic:
  - 72 professional developers
- [Link to Dataset](http://brains-on-code.org/)
- within-subjects
- experiment was conducted online
- **Note**: Only the data for the semantic tasks was used as the authors only consider them true comprehension tasks. The syntactic tasks were used as control tasks where no comprehension was required.

### Code
- Programming Language:
  - C#
- Code Type:
  - Short code snippets containing a self-contained static function with a length of 15 lines

### Measures
- Comprehension Task:
  - Looking for semantic defects in source code snippets
  - Three semantic defects, then three syntax errors as a control task for each participant
- Measures:
  - First Impression. Time taken until the participant indicated that they found the defect.
  - Thinking Time. Time to enter the line number, description and correction. Measured by how long the corresponding dialogue box was open.
  - Duration. Both First Impression and thinking time combined.

## 8 - Syntax, Predicates, Idioms - What Really Affects Code Complexity?
### Background
- Main Focus: 
  - Compare the impact of different code structures (e.g. if, for etc.) on program comprehension
- Understandability construct:
  - "the ability to understand code written by others"
  - "**interpret code snippets with similar functionality but different structures**"
  - "snippets that that longer to understand or produce more errors are considered harder"
  - They differentiate between interpretation (low-level) and comprehension (high-level). But do not limit their study to one or the other.
- Demographic:
  - 220 professional programmers
- [Link to Dataset](https://github.com/shulamyt/break-the-code/tree/icpc17)
- "**We also found that metrics of time to understanding and errors made are not necessarily equivalent.**"
- "**results imply that metrics like MCC (McCabe's Cyclomatic Complexity) that assign the same complexity to all branching instructions may be too simplistic.**"
- Online experiment
- Data was provided both in csv and sql format. However, the csv files only contained the time data. To get all data, we used the sql database backup and exported the results ourselves.

### Code
- Programming Language:
  - JavaScript
- Code Type:
  - 40 short code snippets with different structure

### Measures
- Comprehension Task:
  - Calculate the output of a code snippet
  - The code is shown alongside the field to enter the output.
- Measures:
  - Time. Time taken to calculate the output.
  - Correctness. 1 if the answer is correct, 0 if it is wrong.

## 9 - The Role of Method Chains and Comments in Software Readability and Comprehension---An Experiment
### Background
- Main Focus: 
  - Investigate the role of method chains and code comments in software readability and comprehension
- Understandability construct:
  - Cloze tests to measure comprehension. (Filling in blanks)
  - "If a subject has understood the overall purpose, behavior and flow of the code, it will be easier to provide an answer that is syntactically and semantically correct."
- Demographic:
  - 104 second year computer science students
- [Link to Dataset](https://www.bth.se/om-bth/organisation/fakulteten-for-datavetenskaper/dipt/jurgen-borstler-supplementary-materials/)

### Code
- Programming Language:
  - Java
- Code Type:
  - 30 code snippets from public Java projects.
  - Snippets with and without method chains. Snippets with good or bad or no comments.

### Measures
- Comprehension Task:
  - Task 1: Read and rate the readability of the snippet.
  - Task 2: Cloze test and second rating.
  - Cloze test: Parts of the code is blanked out and the subject has to fill in the blanks with suitable code.
- Measures:
  - R1. Rating 1-5 of readability by the participant after reading the snippet. (Task 1)
  - Tr. Time to read the code until the participant submitted their readability rating. (Task 1)
  - Sr. Reading speed in characters per second. (Task 1)
  - R2. Rating 1-5 of readability by the participant after completing the cloze test. (Task 2)
  - Ta. Time to complete the task i.e. fill in the blanks. (Task 2)
  - Acc. Correctness of the cloze test. (Task 2)
  - Sa. Answering speed in characters per second. (Task 2)

## 10 - Understanding misunderstandings in source code
### Background
- Main Focus:
  - Validate the set of atoms of confusion posed by the authors by evaluating whether they impact the amount of errors in hand-evaluated output of code snippets
- Understandability construct:
  - They define "confusion" as the thing that happens when a human calculates the output of a program differently from a machine. This is similar to how other studies measure understandability.
- Demographic:
  - 73 students with varying programming experience
- [Link to Dataset](https://atomsofconfusion.com/2016-snippet-study/)
- Atom Existence Experiment

### Code
- Programming Language:
  - C++
- Code Type:
  - 126 short code snippets designed to be minimal while still exhibiting the atom. (avg. **8 lines of code**)

### Measures
- Comprehension Task:
  - Calculate the output.
- Measures:
  - Correct. Correctness of the calculated output.
  - Duration. Time taken to calculate the output. Note: Milliseconds were converted to seconds to fit with the data from the other studies.
