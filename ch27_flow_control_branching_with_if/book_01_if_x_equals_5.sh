#!/bin/bash
# =============================================================================
# CET 2390 Operating Systems Laboratory: a textbook script, explained
# Script:   the chapter's first if example (the book gives it no name), from
#           The Linux Command Line (TLCL 19.01), chapter 27, "if"
# Code:     William Shotts. Explanations: Prof. Hernan Lozano, CityTech (CUNY)
# =============================================================================
#
# WHAT IT DOES
#   Stores 5 in the variable x, then uses if and else to print whether x equals
#   5. It is the book's pseudocode "If X = 5, say so; otherwise, say it is not"
#   written in bash, and the first script in the book that makes a choice.
#
# HOW IT WORKS
#   1. `x=5` stores the value 5 in the variable x (no spaces around the =).
#   2. `if [ "$x" -eq 5 ]; then` runs the command `[ "$x" -eq 5 ]` and looks at
#      how that command ended. Every command ends with a number called its
#      exit status: 0 means success, and any other number means failure. `if`
#      runs the lines after `then` only when the status is 0.
#   3. `[` is a command: another name for the command `test`. Its only job is
#      to check the expression between the brackets and end with status 0 if
#      the expression is true, or 1 if it is false. It prints nothing. Here the
#      expression is `"$x" -eq 5`, "is the number in x equal to 5?"; `-eq`
#      compares whole numbers. The `]` is just test's last argument.
#   4. `echo "x equals 5."` runs, because the test ended with status 0.
#   5. `else` starts the lines that run when the test fails: here
#      `echo "x does not equal 5."`, which is skipped this time.
#   6. `fi` ("if" spelled backwards) ends the if statement.
#   The book prints this example without a #!/bin/bash line; line 1 is added
#   so the file runs as a script.
#
# NEW IN THIS SCRIPT
#   exit status     the number (0 to 255) a command ends with; 0 means success
#   $?              holds the exit status of the last command: try echo $?
#   if ... fi       runs the then lines when the command after if succeeds
#   else            the lines that run when that command fails
#   [ expression ]  the test command: status 0 if the expression is true, 1 if
#                   false. [ needs a space after it, and ] needs one before it
#   -eq             "is equal to", for whole numbers (integers)
#
# RUN IT
#   chmod u+x book_01_if_x_equals_5.sh
#   ./book_01_if_x_equals_5.sh
#
# OUTPUT
#   x equals 5.
#
# TRY THIS
#   - Copy the script (cp book_01_if_x_equals_5.sh try.sh) and, in the copy,
#     change x=5 to x=0. Predict the line it prints, then run ./try.sh.
#   - Change it to x=05. Does 05 equal 5? (-eq compares numbers, not text.)
#   - Change it to x=five. Bash prints an error that ends in "integer
#     expression expected", then one more line. Which branch ran, and why?
#     (Hint: test ends with status 2 when it cannot compare, and 2 is not 0.)
#   - At the prompt, type [ 3 -eq 5 ] and then echo $? . What number do you
#     see, and what does it mean?
#
# Below the line: the book's code, unchanged (TLCL is licensed CC BY-NC-ND 3.0;
# see LICENSE.md).
# ---------------------------------------------------------------------------
x=5

if [ "$x" -eq 5 ]; then
    echo "x equals 5."
else
    echo "x does not equal 5."
fi
