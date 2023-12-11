# Project Grading
## Log In
If : admin\nZDHH\n3\n +10  
Else: +0
## Guidance for users
If : admin\nZDHH\n1\n3\n +10  
Else: +0
## Add a user
if : admin\nZDHH\n2\nnewuser\nnewpassword\n3\n +5  
&emsp;&emsp;if : newuser\nnewpassword\n3\n +5  
&emsp;&emsp;else: +0  
else: +0
## Add submission
### Create a folder named “data”
If : copy existing submission path to data success +2.5  
&emsp;&emsp;If : name of the copied file == ‘{student id}_{assignment id}.txt’ +1.25  
&emsp;&emsp;&emsp;&emsp;If: copied file content == original one +1.25  
&emsp;&emsp;&emsp;&emsp;else : +0  
&emsp;&emsp;else : +0  
else: +0  

If : copy non-existing submission path to data return error +2.5  
&emsp;&emsp;If : return error and let user enter choice again +2.5  
&emsp;&emsp;else: +0  
else: +0
## Grade a submission
If : grade the submission has content and shown content +2.5  
&emsp;&emsp;If : can receive score and no error+2.5  
&emsp;&emsp;else : +0  
else: +0  

If : grade the submission doesn’t have content and return error +2.5  
&emsp;&emsp;If : return error and let user enter choice again +2.5  
&emsp;&emsp;else: +0  
else: +0
## List all submission
### Firstly update a submission with a new grade and test here
If : show all submission +5  
&emsp;&emsp;If : Grade updated is shown +2.5  
&emsp;&emsp;&emsp;&emsp;If : Submission with no grade shown ‘/’ +2.5  
&emsp;&emsp;&emsp;&emsp;else : +0  
&emsp;&emsp;else : +0  
else: +0  
## List all submission have not been graded
If : show all submission +5  
&emsp;&emsp;If : submission include assignment id and student id +2.5  
&emsp;&emsp;&emsp;&emsp;If : same submission with no grades shown seperately ‘/’ +2.5  
&emsp;&emsp;&emsp;&emsp;else : +0  
&emsp;&emsp;else : +0  
else: +0  
## Display the average score
### Grade some submission
1.    
If : input ‘ALL’ will give average score of all submission +2.5  
Else: +0  
2.  
If : input an id will give average score of all submission +2.5  
Else: +0
### Clear all grades
3.  
If : input ‘ALL’ will give 0 +1.25  
&emsp;&emsp;If : input an id will give 0 +1.25
&emsp;&emsp;else : +0  
else: +0  
4.    
If : enter an id not in the existing id list and system exist +2.5  
Else: +0
## Display the student who has the highest score
### Grade some submission
If : Record of the highest score achiever in each assignments is listed +5  
&emsp;&emsp;If : No grade shown ‘\’ +5  
&emsp;&emsp;else : +0   
else: +0  
## Display the student whose score is less than a threshold!
If : enter id and threshold show  assignment id, student id and score +5  
&emsp;&emsp;If : not been graded submission id will return invalid choice; try again +2.5  
&emsp;&emsp;&emsp;&emsp;If : enter an id not in the existing id list return invalid assignment id +2.5  
&emsp;&emsp;&emsp;&emsp;else : +0  
&emsp;&emsp;else : +0  
else: +0  
## Store the grade to a JSON file
If : successfully store the file as json file +10
Else: +0
## Retrieve grade from JSON file
If : successfully retrieve the json file +10
Else: +0
## Delete a submission and its grade
If : successfully delete the submission +10
Else: +0







