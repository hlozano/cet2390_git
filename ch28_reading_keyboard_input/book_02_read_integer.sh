#!/bin/bash
# =============================================================================
# CET 2390 Operating Systems Laboratory: a textbook script, explained
# Script:   read-integer, from The Linux Command Line (TLCL 19.01), chapter 28,
#           "read - Read Values from Standard Input"
# Code:     William Shotts. Explanations: Prof. Hernan Lozano, CityTech (CUNY)
# =============================================================================
#
# WHAT IT DOES
#   The integer tests of book_01_test_integer2.sh, but the number now comes
#   from the keyboard: the script prints a question, waits for you to type a
#   line, and then tests what you typed. No more editing the file.
#
# HOW IT WORKS
#   1. `echo -n "Please enter an integer -> "` prints the question. -n means
#      "no newline at the end", so the cursor waits on the same line as the
#      question.
#   2. `read int` stops the script and waits for one line of standard input
#      (what you type, up to the Enter key). It stores that line in the
#      variable int. There is no $ in front of int here: read fills the
#      variable, it does not use its value.
#   3. From here on the code is book_01's, with every INT changed to $int, and
#      each message prints the number itself ("$int is positive.").
#   4. The shape check `[[ "$int" =~ ^-?[0-9]+$ ]]` matters more now: a person
#      can type anything, and this test keeps words and empty answers away
#      from the number tests. Anything that fails it gets "Input value is not
#      an integer." on standard error and exit status 1.
#
# NEW IN THIS SCRIPT
#   read var      wait for one line of input and store it in the variable var
#   echo -n       print without the newline at the end, so the answer is
#                 typed on the same line as the question
#   cmd <<< text  a here string: hands text (and an Enter after it) to the
#                 command as its input, as if you had typed it. Used in RUN IT
#                 to answer the question without typing; explained fully in
#                 book_08_read_ifs.sh.
#
# RUN IT
#   chmod u+x book_02_read_integer.sh
#   ./book_02_read_integer.sh            then type 5 and press Enter
#   ./book_02_read_integer.sh <<< 5      the same answer, fed with a here string
#
# OUTPUT
#   Typed at the keyboard (the 5 is what you typed; Enter moves to a new line):
#     Please enter an integer -> 5
#     5 is positive.
#     5 is odd.
#   Fed with <<< 5: the question still prints (echo -n is ordinary output),
#   but nothing typed appears on the screen, so the first answer line joins
#   the question:
#     Please enter an integer -> 5 is positive.
#     5 is odd.
#   Other answers: -8 prints "-8 is negative." and "-8 is even."; 0 prints
#   "0 is zero."; five, 4.5 or a bare Enter print "Input value is not an
#   integer." and the script ends with exit status 1 (echo $? shows it).
#
# TRY THIS
#   - Type "    7" (spaces, then 7). What happens to the spaces? (read drops
#     spaces at the start and end of the line when it fills a named variable.)
#   - Type -0. Zero, negative or positive? Why? (-eq compares numbers.)
#   - Type 08. It prints "08 is positive." and then bash stops with
#     "value too great for base (error token is "08")". Inside $(( )) a
#     number that starts with 0 is read in base 8 (octal), where 8 is not a
#     digit. The shape check cannot catch this; which test still worked?
#
# Below the line: the book's code, unchanged (TLCL is licensed CC BY-NC-ND 3.0;
# see LICENSE.md).
# ---------------------------------------------------------------------------

# read-integer: evaluate the value of an integer.

echo -n "Please enter an integer -> "
read int

if [[ "$int" =~ ^-?[0-9]+$ ]]; then
    if [ "$int" -eq 0 ]; then
        echo "$int is zero."
    else
        if [ "$int" -lt 0 ]; then
            echo "$int is negative."
        else
            echo "$int is positive."
        fi
        if [ $((int % 2)) -eq 0 ]; then
            echo "$int is even."
        else
            echo "$int is odd."
        fi
    fi
else
    echo "Input value is not an integer." >&2
    exit 1
fi
