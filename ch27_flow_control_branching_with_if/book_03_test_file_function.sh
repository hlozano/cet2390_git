#!/bin/bash
# =============================================================================
# CET 2390 Operating Systems Laboratory: a textbook script, explained
# Script:   test_file, the function version of test-file, from The Linux
#           Command Line (TLCL 19.01), chapter 27, "File Expressions"
# Code:     William Shotts. Explanations: Prof. Hernan Lozano, CityTech (CUNY)
# =============================================================================
#
# WHAT IT DOES
#   The same checks as test-file (book_02_test_file.sh), packed into a shell
#   function named test_file, the way you would put them inside a larger
#   program. Run as it is, it prints the same three lines as book_02.
#
# HOW IT WORKS
#   1. `test_file () {` ... `}` defines a function (chapter 26): bash stores
#      the lines between the braces under the name test_file. Defining a
#      function runs nothing.
#   2. Inside the braces is book_02's code, line for line, with two changes:
#      `exit 1` became `return 1`, and the final `exit` is gone.
#   3. `return 1` ends only the function and hands exit status 1 back to the
#      line that called it. An `exit 1` here would end the whole script.
#   4. When the file exists, the function reaches its closing } with no
#      return. A function that ends that way returns the status of the last
#      command it ran: here 0.
#   5. The book prints only the function. The last two lines below the rule,
#      the comment that starts with `# added:` and the call `test_file`, are
#      not in the book: they were added so the file does something when you
#      run it. The call is the script's last command, so the script ends with
#      the function's exit status.
#   What the pair shows: book_02 and book_03 do the same checks and print the
#   same lines. The difference is who gets stopped: exit stops the script,
#   return stops only the function and lets the script carry on.
#
# NEW IN THIS SCRIPT
#   return N   ends a function now and gives the caller exit status N
#   return     without N: the status of the last command the function ran
#
# RUN IT
#   chmod u+x book_03_test_file_function.sh
#   ./book_03_test_file_function.sh
#   echo $?
#
# OUTPUT
#   /home/student/.bashrc is a regular file.
#   /home/student/.bashrc is readable.
#   /home/student/.bashrc is writable.
#   0
#   (Run by a user named student; you will see your own home folder.)
#
# TRY THIS
#   - Copy the script (cp book_03_test_file_function.sh try.sh). In the copy,
#     change FILE=~/.bashrc to FILE=/nowhere, and add this line at the end:
#         echo "back from test_file, status $?"
#     Predict both lines of output, then run ./try.sh.
#   - In the same copy, change `return 1` to `exit 1` and run it again. Why
#     does the "back from test_file" line no longer print?
#
# Below the line: the book's code, unchanged (TLCL is licensed CC BY-NC-ND 3.0;
# see LICENSE.md).
# ---------------------------------------------------------------------------
test_file () {

    # test-file: Evaluate the status of a file

    FILE=~/.bashrc

    if [ -e "$FILE" ]; then
        if [ -f "$FILE" ]; then
            echo "$FILE is a regular file."
        fi
        if [ -d "$FILE" ]; then
            echo "$FILE is a directory."
        fi
        if [ -r "$FILE" ]; then
            echo "$FILE is readable."
        fi
        if [ -w "$FILE" ]; then
            echo "$FILE is writable."
        fi
        if [ -x "$FILE" ]; then
            echo "$FILE is executable/searchable."
        fi
    else
        echo "$FILE does not exist"
        return 1
    fi

}
# added: call the function; the script then ends with the function's exit status
test_file
