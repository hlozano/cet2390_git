#!/bin/bash
# =============================================================================
# CET 2390 Operating Systems Laboratory: a textbook script, explained
# Script:   test-integer4, from The Linux Command Line (TLCL 19.01), chapter 27,
#           "Combining Expressions"
# Code:     William Shotts. Explanations: Prof. Hernan Lozano, CityTech (CUNY)
# =============================================================================
#
# WHAT IT DOES
#   Turns test-integer3's question around: is INT outside the range 1 to 100?
#   It prints "50 is in range." because 50 is not outside it.
#
# HOW IT WORKS
#   1. The limits, the value and the =~ integer check are book_08's.
#   2. `if [[ ! ("$INT" -ge "$MIN_VAL" && "$INT" -le "$MAX_VAL") ]]; then`
#      puts book_08's range test in parentheses with `!` (NOT) in front. !
#      reverses a test: true becomes false and false becomes true. So this
#      test is true exactly when INT is NOT inside the range.
#   3. The parentheses group the two expressions, so ! applies to the whole
#      AND. Without them, ! would reverse only the first expression,
#      "$INT" -ge "$MIN_VAL", and the test would ask a different question.
#   4. Because the question is reversed, so are the messages: the then part
#      prints "... is outside 1 to 100." and the else part "... is in range."
#
# NEW IN THIS SCRIPT
#   ! expression   NOT: true when the expression is false, and false when true
#   ( ... )        inside [[ ]]: groups expressions, as in algebra
#
# RUN IT
#   chmod u+x book_10_test_integer4.sh
#   ./book_10_test_integer4.sh
#
# OUTPUT
#   50 is in range.
#
# TRY THIS
#   - Copy the script (cp book_10_test_integer4.sh try.sh). In the copy,
#     change INT=50 to INT=101, then INT=0, then INT=1. Predict each answer
#     before you run ./try.sh.
#   - Remove the two parentheses in your copy, so the test reads
#     [[ ! "$INT" -ge "$MIN_VAL" && "$INT" -le "$MAX_VAL" ]], and run it with
#     INT=101. Which answer is now wrong, and why?
#   - Ask the same question without !, using || (OR): "INT is less than
#     MIN_VAL, or INT is greater than MAX_VAL". Check it with 0, 50 and 101.
#
# Below the line: the book's code, unchanged (TLCL is licensed CC BY-NC-ND 3.0;
# see LICENSE.md).
# ---------------------------------------------------------------------------

# test-integer4: determine if an integer is outside a
# specified range of values.

MIN_VAL=1
MAX_VAL=100

INT=50

if [[ "$INT" =~ ^-?[0-9]+$ ]]; then
    if [[ ! ("$INT" -ge "$MIN_VAL" && "$INT" -le "$MAX_VAL") ]]; then
        echo "$INT is outside $MIN_VAL to $MAX_VAL."
    else
        echo "$INT is in range."
    fi
else
        echo "INT is not an integer." >&2
        exit 1
fi
