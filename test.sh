#!/bin/bash

# Define the base directory containing student directories
BASE_DIR="/home/ryan/project_DATA/allocated/allocated_2"
GRADING_DIR="${BASE_DIR}/grading_tools"

ADMIN_USERNAME="admin"
ADMIN_PASSWORD="ZDHH"
NEW_USER_USERNAME="newuser"
NEW_USER_PASSWORD="newpassword"
STUDENT_ID_1="001"
STUDENT_ID_2="002"
ASSIGNMENT_ID_1="ASSIGNMENT_1"
ASSIGNMENT_ID_2="ASSIGNMENT_2"


SUBMISSION_TEST_FILE_1="${GRADING_DIR}/submission_test_file_1.txt"
SUBMISSION_TEST_FILE_2="${GRADING_DIR}/submission_test_file_2.txt"
GRAD_JSON_FILE="${GRADING_DIR}/grades.json"
OUTPUT_FILE="${GRADING_DIR}/test_results.txt"

HELP=1
ADD_USER=2
EXIT=3
ADD_SUBMISSION=4
GRAD_SUBMISSION=5
LIST_ALL_SUBMISSIONS=6
LIST_UNGRADED_SUBMISSIONS=7
DISPLAY_AVERAGE_SCORE=8
DISPLAY_HIGHEST_SCORE=9
DISPLAY_BELOW_THRESHOLD=10
STORE_GRADES_TO_JSON=12
RETRIEVE_GRADES_FROM_JSON=13
DELETE_SUBMISSION=14
NEWLINE="\n"



# Clear the output file if it already exists
> "$OUTPUT_FILE"

# Redirect output
exec > "$OUTPUT_FILE" 2>&1

# Function to run a test and log its output
run_test() {
    student_dir=$1
    test_description=$2
    command=$3
    echo "--------------------Test: $test_description, Command: $command--------------------"
    cd "$student_dir" && eval $command  
    exit_status=$?
    if [ $exit_status -ne 0 ]; then
        echo -e "\nUnexpected Exit: $exit_status\n"
        # Base_Score=$((Base_Score-3))
    fi

}


ADMIN_LOGIN="${ADMIN_USERNAME}${NEWLINE}${ADMIN_PASSWORD}${NEWLINE}"
# Iterate over each student directory and run tests
for dir in "$BASE_DIR"/*; do
    if [ -d "${dir}" ]; then  # Check if it's a directory

        echo "--------------------Running test for $dir --------------------"

        ###################### Test Login with Correct Password ######################
        run_test "${dir}" "Login with admin and show start prompt" "echo -e '${ADMIN_LOGIN}${EXIT}${NEWLINE}' | python main.py"

        ###################### Show Help Information ######################
        run_test "${dir}" "Show Help Information" "echo -e '${ADMIN_LOGIN}${HELP}${NEWLINE}${EXIT}${NEWLINE}' | python main.py"

        ###################### Add a user ######################
        run_test "${dir}" "Adding a new user" "echo -e '${ADMIN_LOGIN}${ADD_USER}${NEWLINE}${NEW_USER_USERNAME}${NEWLINE}${NEW_USER_PASSWORD}${NEWLINE}${EXIT}${NEWLINE}' | python main.py"

        ###################### Login with new user ######################
        run_test "${dir}" "Login with new user" "echo -e '${NEW_USER_USERNAME}${NEWLINE}${NEW_USER_PASSWORD}${NEWLINE}${EXIT}${NEWLINE}' | python main.py"

        # run_test "${dir}" "Adding a new user with semicolon and login" "echo -e 'newuser${NEWLINE}newpassword;${NEWLINE}${EXIT}${NEWLINE}' | python main.py"
        # run_test "${dir}" "Login with original user" "echo -e '${ADMIN_LOGIN}${EXIT}${NEWLINE}'  | python main.py"

        ###################### Test Exit ######################
        run_test "${dir}" "Test Exit" "echo -e '${ADMIN_LOGIN}${EXIT}${NEWLINE}' | python main.py"

        ###################### Store a Submission ######################
        run_test "${dir}" "Storing a submission" "echo -e '${ADMIN_LOGIN}${ADD_SUBMISSION}${NEWLINE}${STUDENT_ID_1}${NEWLINE}{ASSIGNMENT_ID_1}${NEWLINE}${SUBMISSION_TEST_FILE_1}${NEWLINE}${EXIT}${NEWLINE}' | python main.py"
        if [ ! -d "${dir}/data" ]; then
            echo "Directory ${dir}/data does not exist."
            # Base_Score=$((Base_Score-3))
        else
            TARGET_FILE="${dir}/data/${STUDENT_ID_1}_${ASSIGNMENT_ID_1}.txt"
            if [ ! -f "$TARGET_FILE" ]; then
                echo "File $TARGET_FILE does not exist."
                # Base_Score=$((Base_Score-3))
            else
                echo "File $TARGET_FILE exists."
                
                if cmp -s "$SUBMISSION_TEST_FILE_1" "$TARGET_FILE"; then
                    echo "The contents of $SUBMISSION_TEST_FILE_1 and $TARGET_FILE are identical."
                else
                    echo "The contents of $SUBMISSION_TEST_FILE_1 and $TARGET_FILE differ."
                    # Base_Score=$((Base_Score-5))
                fi
            fi
        fi


        ###################### Grad a submission ######################
        run_test "${dir}" "Grading a submission" "echo -e '${ADMIN_LOGIN}${GRAD_SUBMISSION}${NEWLINE}${STUDENT_ID_1}${NEWLINE}${ASSIGNMENT_ID_1}${NEWLINE}90${NEWLINE}${EXIT}${NEWLINE}' | python main.py"


        ###################### List all submissions ######################
        run_test "${dir}" "Storing a submission" "echo -e '${ADMIN_LOGIN}${ADD_SUBMISSION}${NEWLINE}${STUDENT_ID_2}${NEWLINE}${ASSIGNMENT_ID_1}${NEWLINE}${SUBMISSION_TEST_FILE_2}${NEWLINE}${EXIT}${NEWLINE}' | python main.py"
        run_test "${dir}" "Listing all submissions" "echo -e '${ADMIN_LOGIN}${LIST_ALL_SUBMISSIONS}${NEWLINE}${EXIT}${NEWLINE}' | python main.py"

        ###################### List ungraded submissions ######################
        run_test "${dir}" "Listing ungraded submissions" "echo -e '${ADMIN_LOGIN}${LIST_UNGRADED_SUBMISSIONS}${NEWLINE}${EXIT}${NEWLINE}' | python main.py"



        ###################### Display average score ######################
        run_test "${dir}" "Grading a submission" "echo -e '${ADMIN_LOGIN}${GRAD_SUBMISSION}${NEWLINE}${STUDENT_ID_2}${NEWLINE}${ASSIGNMENT_ID_1}${NEWLINE}80${NEWLINE}${EXIT}${NEWLINE}' | python main.py"

        run_test "${dir}" "Displaying average score" "echo -e '${ADMIN_LOGIN}${DISPLAY_AVERAGE_SCORE}${NEWLINE}ALL${NEWLINE}${EXIT}${NEWLINE}' | python main.py"



        ###################### Display highest score ######################
        run_test "${dir}" "Displaying highest scoring student" "echo -e '${ADMIN_LOGIN}${DISPLAY_HIGHEST_SCORE}${NEWLINE}3' | python main.py"


        ###################### Display students below a threshold ######################
        run_test "${dir}" "Displaying students below a threshold" "echo -e '${ADMIN_LOGIN}${DISPLAY_BELOW_THRESHOLD}${NEWLINE}${ASSIGNMENT_ID_1}${NEWLINE}50${NEWLINE}${EXIT}${NEWLINE}' | python main.py"

        > "$GRAD_JSON_FILE"
        ###################### Store Grades to a JSON File ######################
        run_test "${dir}" "Storing grades to a JSON file" "echo -e '${ADMIN_LOGIN}${DISPLAY_BELOW_THRESHOLD}${NEWLINE}${GRAD_JSON_FILE}${NEWLINE}${EXIT}${NEWLINE}' | python main.py"

        ###################### Retrieve Grades from a JSON File ######################
        run_test "${dir}" "Retrieving grades from a JSON file" "echo -e '${ADMIN_LOGIN}${RETRIEVE_GRADES_FROM_JSON}${NEWLINE}${GRAD_JSON_FILE}${NEWLINE}${LIST_ALL_SUBMISSIONS}${NEWLINE}${EXIT}${NEWLINE}' | python main.py"

        ###################### Delete a submission ######################
        run_test "${dir}" "Deleting a submission" "echo -e '${ADMIN_LOGIN}${DELETE_SUBMISSION}${NEWLINE}${STUDENT_ID_1}${NEWLINE}${ASSIGNMENT_ID_1}${NEWLINE}${EXIT}${NEWLINE}' | python main.py"
        exit
    fi
    
done
