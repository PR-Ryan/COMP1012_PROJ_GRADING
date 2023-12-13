### Modify the following files
#### util.py
```python
def exit():
	sys.exit(1)
-->
def exit():
	sys.exit(0)

```
### Usage
```bash
  bash grading.sh
```
### Grading Rules
- test case 1: login with admin account +5
- test case 2: show help info +5
- test case 3: add a new user +5
- test case 4: login with new user +5 
- test case 5: add a submission for 001 assignment1 +5
- test case 6: grade and list all submissions +20
  - assignment 1, student 1, score 90 +5 
  - assignment 1, student 2, score 80 +5
  - assignment 2, student 1, score 70 +5
  - assignment 2, student 2, score /  +5
- test case 7: display average score for assignment1 5/5
- test case 8: display average score for all 0/5
- test case 9: display highest scoring student 10/10
  - assignment 1, student 1 +5
  - assignment 2, student 1 +5
- test case 10: display students below a threshold 85 for assignment1 10/10
- test case 11: delete a submission 10/10

#### Notes
- If the program raise error, 0 for the test case.
- We give 10 by default for exit function.
- We generate test log locate within each student's folder with name "test_results.txt" for further checking.
- A "student_score.txt" will generate score summary for each student in the grading folder.  