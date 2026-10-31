#!/bin/bash
# =============================================================================
# CET 2390 Operating Systems Laboratory: a textbook script, explained
# Script:   test-integer, from The Linux Command Line (TLCL 19.01), chapter 27,
#           "Integer Expressions"
# Code:     William Shotts. Explanations: Prof. Hernan Lozano, CityTech (CUNY)
# =============================================================================
#
# WHAT IT DOES
#   Looks at the number stored in INT (-5) and says whether it is zero,
#   negative or positive and, when it is not zero, whether it is even or odd.
#
# HOW IT WORKS
#   1. `INT=-5` stores the value to check.
#   2. `if [ -z "$INT" ]; then` is the same guard as in test-string (book_04):
#      when INT is empty, the script prints an error on standard error and
#      stops with `exit 1`.
#   3. `if [ "$INT" -eq 0 ]; then` compares INT with 0 as numbers. If INT is
#      0, the script prints "INT is zero." and skips the whole else part.
#   4. Inside the else are two separate if statements that both run, one
#      after the other. The first, `[ "$INT" -lt 0 ]` ("less than 0?"),
#      picks negative or positive.
#   5. The second, `[ $((INT % 2)) -eq 0 ]`, picks even or odd. `$((INT % 2))`
#      is arithmetic expansion: bash replaces it with the remainder of INT
#      divided by 2 (% means remainder). Even numbers leave 0; odd numbers
#      leave 1, or -1 when negative. For -5 the remainder is -1, so the test
#      is false and "INT is odd." prints. (Chapter 34 covers arithmetic.)
#
# NEW IN THIS SCRIPT
#   integer expressions  compare whole numbers
#     -eq / -ne            equal / not equal
#     -lt / -le            less than / less than or equal
#     -gt / -ge            greater than / greater than or equal
#   $(( ))               arithmetic expansion: replaced by the result
#   %                    the remainder after division: $((7 % 2)) is 1
#
# RUN IT
#   chmod u+x book_05_test_integer.sh
#   ./book_05_test_integer.sh
#
# OUTPUT
#   INT is negative.
#   INT is odd.
#
# TRY THIS
#   - Copy the script (cp book_05_test_integer.sh try.sh). In the copy, change
#     INT=-5 to INT=0, then INT=12, then INT=-4. Predict the lines each time,
#     then run ./try.sh.
#   - Change it to INT=abc and predict. Bash prints "integer expression
#     expected" twice, and then the script says abc is positive and even! Each
#     failed test ends with status 2, so its else lines run; and inside $(( ))
#     bash reads abc as the name of a variable, which is unset, so it counts as
#     0. The next script, test-integer2, fixes this weak spot.
#   - At the prompt, compare [ 05 -eq 5 ]; echo $? with [ 05 = 5 ]; echo $?
#     One compares numbers and one compares text: which is which?
#
# Below the line: the book's code, unchanged (TLCL is licensed CC BY-NC-ND 3.0;
# see LICENSE.md).
# ---------------------------------------------------------------------------

# test-integer: evaluate the value of an integer.

INT=-5

if [ -z "$INT" ]; then
    echo "INT is empty." >&2
    exit 1
fi

if [ "$INT" -eq 0 ]; then
    echo "INT is zero."
else
    if [ "$INT" -lt 0 ]; then
        echo "INT is negative."
    else
        echo "INT is positive."
    fi
    if [ $((INT % 2)) -eq 0 ]; then
        echo "INT is even."
    else
        echo "INT is odd."
    fi
fi
