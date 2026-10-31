#!/bin/bash
# =============================================================================
# CET 2390 Operating Systems Laboratory: a textbook script, explained
# Script:   test-string, from The Linux Command Line (TLCL 19.01), chapter 27,
#           "String Expressions"
# Code:     William Shotts. Explanations: Prof. Hernan Lozano, CityTech (CUNY)
# =============================================================================
#
# WHAT IT DOES
#   Looks at the text stored in ANSWER. If it is empty, the script complains
#   and stops with exit status 1; otherwise it says whether the answer is
#   yes, no, maybe, or something else.
#
# HOW IT WORKS
#   1. `ANSWER=maybe` stores the text to check. (Chapter 28's read command
#      lets a script ask the person running it; here the value is fixed.)
#   2. `if [ -z "$ANSWER" ]; then` asks "is ANSWER empty (zero length)?"
#   3. If it is, `echo "There is no answer." >&2` prints the message on
#      standard error, the output channel meant for error messages (`>&2`
#      sends echo's output there; chapter 6 covers redirection), and `exit 1`
#      stops the script with status 1. This if has no else: when ANSWER is not
#      empty, the script simply goes on to the next line.
#   4. `if [ "$ANSWER" = "yes" ]; then` compares two strings (pieces of text):
#      `=` is true when they are exactly the same, letter for letter.
#   5. `elif` means "else if": a new test, tried only when every test above it
#      failed. The script tries "yes", then "no", then "maybe". The first test
#      that is true runs its echo, and bash skips the rest of the chain.
#   6. `else` catches every other value: "The answer is UNKNOWN."
#   7. One `fi` closes the whole chain, however many elif lines it has.
#
# NEW IN THIS SCRIPT
#   string expressions  tests on text
#     -z string           the string is empty (its length is zero)
#     -n string           the string is not empty
#     s1 = s2             the two strings are the same (bash also accepts ==)
#     s1 != s2            the two strings are different
#   elif                "else if": one more test, tried only if those above
#                       it failed
#   >&2                 sends a command's output to standard error
#
# RUN IT
#   chmod u+x book_04_test_string.sh
#   ./book_04_test_string.sh
#
# OUTPUT
#   The answer is MAYBE.
#
# TRY THIS
#   - Copy the script (cp book_04_test_string.sh try.sh). In the copy, change
#     ANSWER=maybe to ANSWER=yes, then to ANSWER=YES. Predict the line each
#     time before you run ./try.sh. Why do the two answers differ?
#   - Change it to ANSWER=perhaps. Which branch runs?
#   - Change it to ANSWER= (nothing after the =). Predict the output, run the
#     copy, then type echo $? to see the exit status.
#
# Below the line: the book's code, unchanged (TLCL is licensed CC BY-NC-ND 3.0;
# see LICENSE.md).
# ---------------------------------------------------------------------------

# test-string: evaluate the value of a string

ANSWER=maybe

if [ -z "$ANSWER" ]; then
    echo "There is no answer." >&2
    exit 1
fi

if [ "$ANSWER" = "yes" ]; then
    echo "The answer is YES."
elif [ "$ANSWER" = "no" ]; then
    echo "The answer is NO."
elif [ "$ANSWER" = "maybe" ]; then
    echo "The answer is MAYBE."
else
    echo "The answer is UNKNOWN."
fi
