#!/bin/bash
# Directory Tree:
# -BASE_DIR
#    -22100372d   
#    -.......
#    -COMP1012_PROJ_GRADING

# Define the base directory containing student directories
BASE_DIR=".."
GRADING_DIR="${BASE_DIR}/COMP1012_PROJ_GRADING"
STUDENT_SCORE_FILE="${GRADING_DIR}/student_score.txt"
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


ADMIN_LOGIN="${ADMIN_USERNAME}${NL}${ADMIN_PASSWORD}${NL}"


# Function to run a test and log its output
run_test() {
    student_dir=$1
    test_description=$2
    command=$3
    echo -e "\n"
    echo "--------------------Test: $test_description, Command: $command--------------------"
    # if [ "$print_output" =  ]; then
    #     cd "$student_dir" && eval $command
    # else
    #     cd "$student_dir" && eval $command > /dev/null  
    # fi
    cd "$student_dir" && eval $command
    exit_status=$?
    return $exit_status
}

GLOBAL_OUTPUTS="None"
run_and_check() {
    student_dir=$1
    test_description=$2
    command=$3
    echo -e "\n"
    echo "--------------------Test: $test_description, Command: $command--------------------"
    # if [ "$print_output" =  ]; then
    #     cd "$student_dir" && eval $command
    # else
    #     cd "$student_dir" && eval $command > /dev/null  
    # fi
    GLOBAL_OUTPUTS=$(cd "$student_dir" && eval $command)
    echo -e ${GLOBAL_OUTPUTS}
    exit_status=$?
    return $exit_status

}



> "${STUDENT_SCORE_FILE}"
# Iterate over each student directory and run tests
for dir in "$BASE_DIR"/*; do
    if [ -d "${dir}" ]; then  # Check if it's a directory
        base_score=10 # for exit function
        summary="Exit function: 10/10"
        temp_score=0
        if [ ! -f "${SUBMISSION_TEST_FILE_1}" ]; then
            cp "${GRADING_DIR}/backup/submission_test_file_1.txt" "${SUBMISSION_TEST_FILE_1}"
        fi
        if [ ! -f "${SUBMISSION_TEST_FILE_2}" ]; then
            cp "${GRADING_DIR}/backup/submission_test_file_2.txt" "${SUBMISSION_TEST_FILE_2}"
        fi
        if [ ! -f "${SUBMISSION_TEST_FILE_3}" ]; then
            cp "${GRADING_DIR}/backup/submission_test_file_3.txt" "${SUBMISSION_TEST_FILE_3}"
        fi
        if [ ! -f "${SUBMISSION_TEST_FILE_4}" ]; then
            cp "${GRADING_DIR}/backup/submission_test_file_4.txt" "${SUBMISSION_TEST_FILE_4}"
        fi

        GRAD_JSON_FILE="${dir}/grades.json"
        OUTPUT_FILE="${dir}/test_results.txt"
        > "$OUTPUT_FILE"
        # Redirect output
        exec > "$OUTPUT_FILE" 2>&1

        echo "--------------------Running test for $dir --------------------"

        ###################### Test Login with Correct Password ######################
        run_test "${dir}" "Login with admin and show start prompt"  \
        "echo -e '${ADMIN_LOGIN}${EXIT}${NL}' | python main.py"
        if [ $? -ne 0 ]; then
            echo -e "\nUnexpected Exit: $?\n"
            temp_score=0
        else
            temp_score=5
        fi
        base_score=$((base_score+temp_score))
        summary="${summary}\nLogin with admin and show start prompt: ${temp_score}/5"



        ###################### Show Help Information ######################
        run_test "${dir}" "Show Help Information"  \
        "echo -e '${ADMIN_LOGIN}${HELP}${NL}${EXIT}${NL}' | python main.py"
        if [ $? -ne 0 ]; then
            echo -e "\nUnexpected Exit: $?\n"
            temp_score=0
        else
            temp_score=5
        fi
        base_score=$((base_score+temp_score))
        summary="${summary}\nShow Help Information: ${temp_score}/5"





        ###################### Add a user ######################
        run_test "${dir}" "Adding a new user"  \
        "echo -e '${ADMIN_LOGIN}${ADD_USER}${NL}${NEW_USER_USERNAME}${NL}${NEW_USER_PASSWORD}${NL}${EXIT}${NL}' | python main.py"
        if [ $? -ne 0 ]; then
            echo -e "\nUnexpected Exit: '$?'\n"
            temp_score=0
        else
            temp_score=5
        fi
        base_score=$((base_score+temp_score))
        summary="${summary}\nAdding a new user: ${temp_score}/5"


        ###################### Login with new user ######################
        run_test "${dir}" "Login with new user"  \
        "echo -e '${NEW_USER_USERNAME}${NL}${NEW_USER_PASSWORD}${NL}${EXIT}${NL}' | python main.py"
        if [ $? -ne 0 ]; then
            echo -e "\nUnexpected Exit: '$?'\n"
            temp_score=0
        else
            temp_score=5
        fi
        base_score=$((base_score+temp_score))
        summary="${summary}\nLogin with new user: ${temp_score}/5"

        ###################### Test Exit ######################
        # run_test "${dir}" "Test Exit"  \
        # "echo -e '${ADMIN_LOGIN}${EXIT}${NL}' | python main.py"



        # make data dir for them if not exist
        if [ ! -d "${dir}/data" ]; then
            mkdir "${dir}/data"
        fi
        ###################### Store a Submission: 2 for assignment 1 and 2 for assignment 2 ######################
        run_test "${dir}" "Add and store a submission for ${STUDENT_ID_1} ${ASSIGNMENT_ID_1}"  \
        "echo -e '${ADMIN_LOGIN}${ADD_SUBMISSION}${NL}${STUDENT_ID_1}${NL}${ASSIGNMENT_ID_1}${NL}${SUBMISSION_TEST_FILE_1}${NL}${EXIT}${NL}' | python main.py"
        if [ $? -ne 0 ]; then
            echo -e "\nUnexpected Exit: '$?'\n"
            temp_score=0
        else
            TARGET_FILE="${dir}/data/${STUDENT_ID_1}_${ASSIGNMENT_ID_1}.txt"
            if [ ! -f "$TARGET_FILE" ]; then
                echo "File $TARGET_FILE does not exist."
                temp_score=0
            else
                # echo "File $TARGET_FILE exists."
                if cmp -s "$SUBMISSION_TEST_FILE_1" "$TARGET_FILE"; then
                    echo "The contents of $SUBMISSION_TEST_FILE_1 and $TARGET_FILE are identical."
                    temp_score=10
                else
                    echo "The contents of $SUBMISSION_TEST_FILE_1 and $TARGET_FILE differ."
                    temp_score=5
                fi
            fi
        fi
        base_score=$((base_score+temp_score))
        summary="${summary}\nAdd and store a submission for ${STUDENT_ID_1} ${ASSIGNMENT_ID_1}: ${temp_score}/10"


        run_test "${dir}" "Store a submission ${STUDENT_ID_2} ${ASSIGNMENT_ID_1}"  \
        "echo -e '${ADMIN_LOGIN}${ADD_SUBMISSION}${NL}${STUDENT_ID_2}${NL}${ASSIGNMENT_ID_1}${NL}${SUBMISSION_TEST_FILE_2}${NL}${EXIT}${NL}' | python main.py"

        run_test "${dir}" "Store a submission ${STUDENT_ID_1} ${ASSIGNMENT_ID_2}"  \
        "echo -e '${ADMIN_LOGIN}${ADD_SUBMISSION}${NL}${STUDENT_ID_1}${NL}${ASSIGNMENT_ID_2}${NL}${SUBMISSION_TEST_FILE_3}${NL}${EXIT}${NL}' | python main.py"

        run_test "${dir}" "Store a submission ${STUDENT_ID_2} ${ASSIGNMENT_ID_2}"  \
        "echo -e '${ADMIN_LOGIN}${ADD_SUBMISSION}${NL}${STUDENT_ID_2}${NL}${ASSIGNMENT_ID_2}${NL}${SUBMISSION_TEST_FILE_4}${NL}${EXIT}${NL}' | python main.py"







        ###################### Grad a submission: student 2 with assignment 2 is not graded ######################
        run_test "${dir}" "Grad and store a submission for ${STUDENT_ID_1} ${ASSIGNMENT_ID_1}"  \
        "echo -e '${ADMIN_LOGIN}${GRAD_SUBMISSION}${NL}${STUDENT_ID_1}${NL}${ASSIGNMENT_ID_1}${NL}90${NL}${STORE_GRADES_TO_JSON}${NL}${GRAD_JSON_FILE}${NL}${EXIT}${NL}' | python main.py"

        run_test "${dir}" "Grad and store a submission for ${STUDENT_ID_2} ${ASSIGNMENT_ID_1}"  \
        "echo -e '${ADMIN_LOGIN}${GRAD_SUBMISSION}${NL}${STUDENT_ID_2}${NL}${ASSIGNMENT_ID_1}${NL}80${NL}${STORE_GRADES_TO_JSON}${NL}${GRAD_JSON_FILE}${NL}${EXIT}${NL}' | python main.py"

        run_test "${dir}" "Grad and store a submission for ${STUDENT_ID_1} ${ASSIGNMENT_ID_2}"  \
        "echo -e '${ADMIN_LOGIN}${GRAD_SUBMISSION}${NL}${STUDENT_ID_1}${NL}${ASSIGNMENT_ID_2}${NL}70${NL}${STORE_GRADES_TO_JSON}${NL}${GRAD_JSON_FILE}${NL}${EXIT}${NL}' | python main.py"

        ###################### List all submissions: ######################
        run_and_check "${dir}" "Listing all submissions"  \
        "echo -e '${ADMIN_LOGIN}${LIST_ALL_SUBMISSIONS}${NL}${EXIT}${NL}' | python main.py"
        if [ $? -ne 0 ]; then
            echo -e "\nUnexpected Exit: '$?'\n"
            temp_score=0
        else
            temp_score=0
            if echo "$GLOBAL_OUTPUTS" | grep -iq "${ASSIGNMENT_ID_1}" && echo "$GLOBAL_OUTPUTS" | grep -iq "${STUDENT_ID_1}" && echo "$GLOBAL_OUTPUTS" | grep -q "90"; then
                echo "Found '${ASSIGNMENT_ID_1}' student '${STUDENT_ID_1}' with number 90"
                temp_score=$((temp_score+5))
            else
                echo "'${ASSIGNMENT_ID_1}'  student '${STUDENT_ID_1}' with number 90 not found"
            fi

            if echo "$GLOBAL_OUTPUTS" | grep -iq "${ASSIGNMENT_ID_1}" && echo "$GLOBAL_OUTPUTS" | grep -iq "${STUDENT_ID_2}" && echo "$GLOBAL_OUTPUTS" | grep -q "80"; then
                echo "Found '${ASSIGNMENT_ID_1}' student '${STUDENT_ID_2}' with number 80"
                temp_score=$((temp_score+5))
            else
                echo "'${ASSIGNMENT_ID_1}'  student '${STUDENT_ID_2}' with number 80 not found"
            fi

            if echo "$GLOBAL_OUTPUTS" | grep -iq "${ASSIGNMENT_ID_2}" && echo "$GLOBAL_OUTPUTS" | grep -iq "${STUDENT_ID_1}" && echo "$GLOBAL_OUTPUTS" | grep -q "70"; then
                echo "Found '${ASSIGNMENT_ID_2}' student '${STUDENT_ID_1}' with number 70"
                temp_score=$((temp_score+5))
            else
                echo "'${ASSIGNMENT_ID_2}'  student '${STUDENT_ID_1}' with number 70 not found"
            fi

            if echo "$GLOBAL_OUTPUTS" | grep -iq "${ASSIGNMENT_ID_2}" && echo "$GLOBAL_OUTPUTS" | grep -iq "${STUDENT_ID_2}" && echo "$GLOBAL_OUTPUTS" | grep -q "/"; then
                echo "Found '${ASSIGNMENT_ID_2}' student '${STUDENT_ID_2}' with number /"
                temp_score=$((temp_score+5))
            else
                echo "'${ASSIGNMENT_ID_2}'  student '${STUDENT_ID_2}' with number / not found"
            fi
        fi
        base_score=$((base_score+temp_score))
        summary="${summary}\nGrad and listing all submissions: ${temp_score}/20"




        # ###################### List ungraded submissions ######################
        # run_test "${dir}" "Listing ungraded submissions"  \
        # "echo -e '${ADMIN_LOGIN}${LIST_UNGRADED_SUBMISSIONS}${NL}${EXIT}${NL}' | python main.py"



        ###################### Display average score ######################
        run_and_check "${dir}" "Displaying average score for assignment1"  \
        "echo -e '${ADMIN_LOGIN}${RETRIEVE_GRADES_FROM_JSON}${NL}${GRAD_JSON_FILE}${NL}${DISPLAY_AVERAGE_SCORE}${NL}${ASSIGNMENT_ID_1}${NL}${EXIT}${NL}' | python main.py"
        if [ $? -ne 0 ]; then
            echo -e "\nUnexpected Exit: '$?'\n"
            temp_score=0
        else
            if  echo "$GLOBAL_OUTPUTS" | grep -q "85"; then
                echo "Found average score for '${ASSIGNMENT_ID_1}' with number 85"
                # base_score=$((base_score+5))
                temp_score=5
            else
                temp_score=0
            fi
        fi
        base_score=$((base_score+temp_score))
        summary="${summary}\nDisplaying average score for assignment1: ${temp_score}/5"

        

        # run_test "${dir}" "Displaying average score for assignment2"  \
        # "echo -e '${ADMIN_LOGIN}${DISPLAY_AVERAGE_SCORE}${NL}${ASSIGNMENT_ID_2}${NL}${EXIT}${NL}' | python main.py"

        # if  echo "$GLOBAL_OUTPUTS" | grep -q "70"; then
        #     echo "Found average score for '${ASSIGNMENT_ID_2}' with number 70"
        #     base_score=$((base_score+5))
        # else
        #     echo "average score for '${ASSIGNMENT_ID_2}' with number 70 not found"
        # fi

        run_test "${dir}" "Displaying average score for all"  \
        "echo -e '${ADMIN_LOGIN}${RETRIEVE_GRADES_FROM_JSON}${NL}${GRAD_JSON_FILE}${NL}${DISPLAY_AVERAGE_SCORE}${NL}ALL${NL}${EXIT}${NL}' | python main.py"
        if [ $? -ne 0 ]; then
            echo -e "\nUnexpected Exit: '$?'\n"
            temp_score=0
        else
            if  echo "$GLOBAL_OUTPUTS" | grep -q "80"; then
                echo "Found average score for all with number 80"
                temp_score=5
            else
                temp_score=0
            fi
        fi
        base_score=$((base_score+temp_score))
        summary="${summary}\nDisplaying average score for all: ${temp_score}/5"



        ###################### Display highest score student ######################
        run_and_check "${dir}" "Displaying highest scoring student"  \
        "echo -e '${ADMIN_LOGIN}${RETRIEVE_GRADES_FROM_JSON}${NL}${GRAD_JSON_FILE}${NL}${DISPLAY_HIGHEST_SCORE}${NL}${EXIT}${NL}' | python main.py"
        if [ $? -ne 0 ]; then
            echo -e "\nUnexpected Exit: '$?'\n"
            temp_score=0
        else
            temp_score=0
            if  echo echo "$GLOBAL_OUTPUTS" | grep -iq "${ASSIGNMENT_ID_1}" && echo "$GLOBAL_OUTPUTS" | grep -iq "${STUDENT_ID_1}"; then
                echo "Found highest scoring student '${STUDENT_ID_1}' for '${ASSIGNMENT_ID_1}'"
                temp_score=$((temp_score+5))
            fi
            if  echo echo "$GLOBAL_OUTPUTS" | grep -iq "${ASSIGNMENT_ID_2}" && echo "$GLOBAL_OUTPUTS" | grep -iq "${STUDENT_ID_1}"; then
                echo "Found highest scoring student '${STUDENT_ID_1}' for '${ASSIGNMENT_ID_2}'"
                temp_score=$((temp_score+5))
            fi
        fi
        base_score=$((base_score+temp_score))
        summary="${summary}\nDisplaying highest scoring student: ${temp_score}/10"


        ###################### Display students below a threshold ######################
        run_and_check "${dir}" "Displaying students below a threshold 85 for ${ASSIGNMENT_ID_1}"  \
        "echo -e '${ADMIN_LOGIN}${RETRIEVE_GRADES_FROM_JSON}${NL}${GRAD_JSON_FILE}${NL}${DISPLAY_BELOW_THRESHOLD}${NL}${ASSIGNMENT_ID_1}${NL}85${NL}${EXIT}${NL}' | python main.py"
        if [ $? -ne 0 ]; then
            echo -e "\nUnexpected Exit: '$?'\n"
            temp_score=0
        else
            if  echo echo "$GLOBAL_OUTPUTS" | grep -iq "${STUDENT_ID_2}"; then
                echo "Found student '${STUDENT_ID_2}' below threshold 85 for '${ASSIGNMENT_ID_1}'"
                temp_score=10
            else
               temp_score=0
            fi
        fi
        base_score=$((base_score+temp_score))
        summary="${summary}\nDisplaying students below a threshold 85 for ${ASSIGNMENT_ID_1}: ${temp_score}/10"


        # ###################### Retrieve Grades from a JSON File ######################
        # run_test "${dir}" "Retrieving grades from a JSON file"  \
        # "echo -e '${ADMIN_LOGIN}${RETRIEVE_GRADES_FROM_JSON}${NL}${GRAD_JSON_FILE}${NL}${LIST_ALL_SUBMISSIONS}${NL}${EXIT}${NL}' | python main.py"
        ###################### Delete a submission ######################
        run_test "${dir}" "Deleting a submission"  \
        "echo -e '${ADMIN_LOGIN}${DELETE_SUBMISSION}${NL}${STUDENT_ID_1}${NL}${ASSIGNMENT_ID_1}${NL}${EXIT}${NL}' | python main.py"
        if [ $? -ne 0 ]; then
            echo -e "\nUnexpected Exit: '$?'\n"
            temp_score=0
        else
            TARGET_FILE="${dir}/data/${STUDENT_ID_1}_${ASSIGNMENT_ID_1}.txt"
            if [ ! -f "$TARGET_FILE" ]; then
                echo "File $TARGET_FILE does not exist."
                temp_score=10
            else
                echo "File $TARGET_FILE exists."
                temp_score=0
            fi
        fi
        base_score=$((base_score+temp_score))
        summary="${summary}\nDeleting a submission: ${temp_score}/10"

        echo -e "${dir} ${base_score}\n" >> "${STUDENT_SCORE_FILE}"
        echo -e "${summary}" >> "${STUDENT_SCORE_FILE}"
        echo -e "\n------------------------------------------------\n" >> "${STUDENT_SCORE_FILE}"
    fi
    
done
