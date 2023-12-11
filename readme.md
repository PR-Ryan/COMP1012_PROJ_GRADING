Log in
If : admin\nZDHH\n3\n +10
Else: +0
 
Guidance for users:
        	If : admin\nZDHH\n1\n +10
        	Else: +0
 
Add a user
        	if : admin\nZDHH\n2\nnewuser\nnewpassword\n3\n +5
                    	if : newuser\nnewpassword\n3\n +5
                    	else: +0
        	else: +0
 
Add submission
Create a folder named “data”
1. 	 
        	If : copy existing submission path to data success +2.5
                    	If : name of the copied file == ‘{student id}_{assignment id}.txt’ +1.25
                                	If: copied file content == original one +1.25
        	        	        	else : +0
                    	else : +0
        	else: +0
 
2. 	 
If : copy non-existing submission path to data prompt the user +2.5
if :  let user enter choice again +2.5
else: +0
 
Grade a submission
1. 	 
        	If : grade the submission has content and shown content +2.5
                    	If : can receive score and no error+2.5
                    	else : +0
        	else: +0
 
2. 	 
If : grade the submission doesn’t have content and prompt user +2.5
if :  let user enter choice again +2.5
else: +0
 
List all submission
Firstly update a submission with a new grade and test here
        	If : show all submission+5
                    	If : Grade updated is shown+2.5
                                	If : Submission with no grade shown ‘/’ +2.5
                                	else : +0
                    	else : +0
        	else: +0
 
List all submission have not been graded
If : show all submission+5
                    	If : submission include assignment id and student id+2.5
                                	If : same submission with no grade shown separately +2.5
                                	else : +0
                    	else : +0
else: +0
 
Display the average score
Grade some submission
1. 	 
        	If : input ‘ALL’ will give average score of all submission+2.5
        	else: +0
 
2. 	 
If : input an id will give average score of submission of that submission+2.5
else: +0
           
        	3.
        	Clear all grade
If : input ‘ALL’ will give 0 +1.25
        	If : input an id will give 0 +1.25
        	else: 0
else: +0
 
4.
If : enter an id not in the existing id list and system exist +2.5
Else: 0
 
Display the student who has the highest score
Grade some submission
If : Record of the highest score achiever in each assignments is listed +5
                    	If : No grade shown ‘\’+5
                    	else : +0
else: +0
 
 
Display the student whose score is less than a threshold
If : enter id and threshold show  assignment id, student id and score +5
                    	If : not been graded submission id will return invalid choice; try again+2.5
                                	If : enter an id not in the existing id list return invalid assignment id+2.5
                                	else : +0
                    	else : +0
else: +0
 
Store the grade to a JSON file
If : successfully store the file as json file +10
else: + 0
 
Retrieve grade from a JSON file
If : successfully recover the stored file +10
else: + 0
 
Delete a submission and its grade
If : successfully delete the submission +10
else: + 0
 
 
 
 
 
 
 
 
 
 
 
 
           
                       

