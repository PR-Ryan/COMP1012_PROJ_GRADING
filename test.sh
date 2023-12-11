#!/bin/bash

# Define the base directory containing student directories
BASE_DIR=".."
GRADING_DIR="${BASE_DIR}/grading_tools"

ADMIN_USERNAME="admin"
ADMIN_PASSWORD="ZDHH"
NEW_USER_USERNAME="newuser"
NEW_USER_PASSWORD="newpassword"
STUDENT_ID_1="001"
STUDENT_ID_2="002"
ASSIGNMENT_ID_1="assignment1"
ASSIGNMENT_ID_2="assignment2"

SUBMISSION_TEST_FILE_1="${GRADING_DIR}/${ASSIGNMENT_ID_1}/submission_test_file_1.txt"
SUBMISSION_TEST_FILE_2="${GRADING_DIR}/${ASSIGNMENT_ID_1}/submission_test_file_2.txt"

SUBMISSION_TEST_FILE_3="${GRADING_DIR}/${ASSIGNMENT_ID_2}/submission_test_file_3.txt"
SUBMISSION_TEST_FILE_4="${GRADING_DIR}/${ASSIGNMENT_ID_2}/submission_test_file_4.txt"


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
#NEWLINE
NL="\n"




# Function to run a test and log its output
run_test() {
    student_dir=$1
    test_description=$2
    print_output=$3
    command=$4

    echo -e "\n"
    echo "--------------------Test: $test_description, Command: $command--------------------"
    if [ "$print_output" = true ]; then
        cd "$student_dir" && eval $command
    else
        cd "$student_dir" && eval $command > /dev/null  
    fi
    exit_status=$?
    if [ $exit_status -ne 0 ]; then
        echo -e "\nUnexpected Exit: $exit_status\n"
        # Base_Score=$((Base_Score-3))
    fi

}


ADMIN_LOGIN="${ADMIN_USERNAME}${NL}${ADMIN_PASSWORD}${NL}"
# Iterate over each student directory and run tests
for dir in "$BASE_DIR"/*; do
    if [ -d "${dir}" ]; then  # Check if it's a directory

        GRAD_JSON_FILE="${dir}/grades.json"
        OUTPUT_FILE="${dir}/test_results.txt"
        > "$OUTPUT_FILE"
        # Redirect output
        exec > "$OUTPUT_FILE" 2>&1

        echo "--------------------Running test for $dir --------------------"

        ###################### Test Login with Correct Password ######################
        run_test "${dir}" "Login with admin and show start prompt" true \
        "echo -e '${ADMIN_LOGIN}${EXIT}${NL}' | python main.py"

        ###################### Show Help Information ######################
        run_test "${dir}" "Show Help Information" true \
        "echo -e '${ADMIN_LOGIN}${HELP}${NL}${EXIT}${NL}' | python main.py"

        ###################### Add a user ######################
        run_test "${dir}" "Adding a new user" false \
        "echo -e '${ADMIN_LOGIN}${ADD_USER}${NL}${NEW_USER_USERNAME}${NL}${NEW_USER_PASSWORD}${NL}${EXIT}${NL}' | python main.py"

        ###################### Login with new user ######################
        run_test "${dir}" "Login with new user" true \
        "echo -e '${NEW_USER_USERNAME}${NL}${NEW_USER_PASSWORD}${NL}${EXIT}${NL}' | python main.py"

        # run_test "${dir}" "Adding a new user with semicolon and login" "echo -e 'newuser${NL}newpassword;${NL}${EXIT}${NL}' | python main.py"
        # run_test "${dir}" "Login with original user" "echo -e '${ADMIN_LOGIN}${EXIT}${NL}'  | python main.py"

        ###################### Test Exit ######################
        run_test "${dir}" "Test Exit" false \
        "echo -e '${ADMIN_LOGIN}${EXIT}${NL}' | python main.py"

        ###################### Store a Submission: 2 for assignment 1 and 2 for assignment 2 ######################
        run_test "${dir}" "Store a submission for ${STUDENT_ID_1} ${ASSIGNMENT_ID_1}" false \
        "echo -e '${ADMIN_LOGIN}${ADD_SUBMISSION}${NL}${STUDENT_ID_1}${NL}${ASSIGNMENT_ID_1}${NL}${SUBMISSION_TEST_FILE_1}${NL}${EXIT}${NL}' | python main.py"

        if [ ! -d "${dir}/data" ]; then
            echo "Directory ${dir}/data does not exist."
        else
            TARGET_FILE="${dir}/data/${STUDENT_ID_1}_${ASSIGNMENT_ID_1}.txt"
            if [ ! -f "$TARGET_FILE" ]; then
                echo "File $TARGET_FILE does not exist."
            else
                # echo "File $TARGET_FILE exists."
                if cmp -s "$SUBMISSION_TEST_FILE_1" "$TARGET_FILE"; then
                    echo "The contents of $SUBMISSION_TEST_FILE_1 and $TARGET_FILE are identical."
                else
                    echo "The contents of $SUBMISSION_TEST_FILE_1 and $TARGET_FILE differ."
                fi
            fi
        fi

        run_test "${dir}" "Store a submission ${STUDENT_ID_2} ${ASSIGNMENT_ID_1}" false \
        "echo -e '${ADMIN_LOGIN}${ADD_SUBMISSION}${NL}${STUDENT_ID_2}${NL}${ASSIGNMENT_ID_1}${NL}${SUBMISSION_TEST_FILE_2}${NL}${EXIT}${NL}' | python main.py"

        run_test "${dir}" "Store a submission ${STUDENT_ID_1} ${ASSIGNMENT_ID_2}" false \
        "echo -e '${ADMIN_LOGIN}${ADD_SUBMISSION}${NL}${STUDENT_ID_1}${NL}${ASSIGNMENT_ID_2}${NL}${SUBMISSION_TEST_FILE_2}${NL}${EXIT}${NL}' | python main.py"

        run_test "${dir}" "Store a submission ${STUDENT_ID_2} ${ASSIGNMENT_ID_2}" false \
        "echo -e '${ADMIN_LOGIN}${ADD_SUBMISSION}${NL}${STUDENT_ID_2}${NL}${ASSIGNMENT_ID_2}${NL}${SUBMISSION_TEST_FILE_2}${NL}${EXIT}${NL}' | python main.py"

        ###################### Grad a submission: student 2 with assignment 2 is not graded ######################
        run_test "${dir}" "Grad and store a submission for ${STUDENT_ID_1} ${ASSIGNMENT_ID_1}" false \
        "echo -e '${ADMIN_LOGIN}${GRAD_SUBMISSION}${NL}${STUDENT_ID_1}${NL}${ASSIGNMENT_ID_1}${NL}90${NL}${STORE_GRADES_TO_JSON}${NL}${GRAD_JSON_FILE}${NL}{EXIT}${NL}' | python main.py"

        run_test "${dir}" "Grad and store a submission for ${STUDENT_ID_2} ${ASSIGNMENT_ID_1}" false \
        "echo -e '${ADMIN_LOGIN}${GRAD_SUBMISSION}${NL}${STUDENT_ID_2}${NL}${ASSIGNMENT_ID_1}${NL}80${NL}${STORE_GRADES_TO_JSON}${NL}${GRAD_JSON_FILE}${NL}${EXIT}${NL}' | python main.py"

        run_test "${dir}" "Grad and store a submission for ${STUDENT_ID_1} ${ASSIGNMENT_ID_2}" false \
        "echo -e '${ADMIN_LOGIN}${GRAD_SUBMISSION}${NL}${STUDENT_ID_1}${NL}${ASSIGNMENT_ID_2}${NL}70${NL}${STORE_GRADES_TO_JSON}${NL}${GRAD_JSON_FILE}${NL}${EXIT}${NL}' | python main.py"


        ###################### List all submissions: ######################
        run_test "${dir}" "Listing all submissions" true \
        "echo -e '${ADMIN_LOGIN}${LIST_ALL_SUBMISSIONS}${NL}${EXIT}${NL}' | python main.py"

        ###################### List ungraded submissions ######################
        run_test "${dir}" "Listing ungraded submissions" true \
        "echo -e '${ADMIN_LOGIN}${LIST_UNGRADED_SUBMISSIONS}${NL}${EXIT}${NL}' | python main.py"



        ###################### Display average score ######################
        run_test "${dir}" "Displaying average score for assignment1" true \
        "echo -e '${ADMIN_LOGIN}${DISPLAY_AVERAGE_SCORE}${NL}${ASSIGNMENT_ID_1}${NL}${EXIT}${NL}' | python main.py"

        run_test "${dir}" "Displaying average score for assignment2" true \
        "echo -e '${ADMIN_LOGIN}${DISPLAY_AVERAGE_SCORE}${NL}${ASSIGNMENT_ID_2}${NL}${EXIT}${NL}' | python main.py"

        run_test "${dir}" "Displaying average score for all" true \
        "echo -e '${ADMIN_LOGIN}${DISPLAY_AVERAGE_SCORE}${NL}ALL${NL}${EXIT}${NL}' | python main.py"



        ###################### Display highest score ######################
        run_test "${dir}" "Displaying highest scoring student" true \
        "echo -e '${ADMIN_LOGIN}${DISPLAY_HIGHEST_SCORE}${NL}${EXIT}${NL}' | python main.py"


        ###################### Display students below a threshold ######################
        run_test "${dir}" "Displaying students below a threshold for ${ASSIGNMENT_ID_1}" true \
        "echo -e '${ADMIN_LOGIN}${DISPLAY_BELOW_THRESHOLD}${NL}${ASSIGNMENT_ID_1}${NL}50${NL}${EXIT}${NL}' | python main.py"

        # > "$GRAD_JSON_FILE"
        ###################### Store Grades to a JSON File ######################
        # run_test "${dir}" "Storing grades to a JSON file" false "echo -e '${ADMIN_LOGIN}${STORE_GRADES_TO_JSON}${NL}${GRAD_JSON_FILE}${NL}${EXIT}${NL}' | python main.py"

        ###################### Retrieve Grades from a JSON File ######################
        run_test "${dir}" "Retrieving grades from a JSON file" true \
        "echo -e '${ADMIN_LOGIN}${RETRIEVE_GRADES_FROM_JSON}${NL}${GRAD_JSON_FILE}${NL}${LIST_ALL_SUBMISSIONS}${NL}${EXIT}${NL}' | python main.py"

        ###################### Delete a submission ######################
        run_test "${dir}" "Deleting a submission" true \
        "echo -e '${ADMIN_LOGIN}${DELETE_SUBMISSION}${NL}${STUDENT_ID_1}${NL}${ASSIGNMENT_ID_1}${NL}${EXIT}${NL}' | python main.py"

        exit
    fi
    
done
