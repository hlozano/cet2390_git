#!/bin/bash
# =============================================================================
# CET 2390 Operating Systems Laboratory: a textbook script, explained
# Script:   test-integer4 coded with test, from The Linux Command Line
#           (TLCL 19.01), chapter 27, "Combining Expressions"
# Code:     William Shotts. Explanations: Prof. Hernan Lozano, CityTech (CUNY)
# =============================================================================
#
# WHAT IT DOES
#   The same "outside the range?" check as test-integer4 (book_10), written
#   for the older test command, [ ], as the book shows next. The output is
#   the same.
#
# HOW IT WORKS
#   1. Every line is book_10's code except one:
#      `if [ ! \( "$INT" -ge "$MIN_VAL" -a "$INT" -le "$MAX_VAL" \) ]; then`
#   2. NOT is `!` in both [ ] and [[ ]]; AND becomes -a, as in book_09.
#   3. The parentheses need a backslash: `\(` and `\)`. [ is an ordinary
#      command, so bash reads the whole line first, and to bash a bare ( has
#      a meaning of its own (here, a syntax error). The backslash tells bash
#      "this is just the character (", so [ receives it as one more argument.
#      Inside [[ ]] there is no such problem, because bash reads [[ ]] itself.
#      Each \( and \) needs spaces around it, like any other argument.
#   4. This file is assembled: the book's test-integer4 listing with its inner
#      if block replaced by the book's "Coding this with test" version. The
#      book breaks that if line before `then` to fit the page; here it is one
#      line, and it runs the same.
#   What the pair shows: [[ ! ( A && B ) ]] and [ ! \( A -a B \) ] give the
#   same answers. The [[ ]] version needs no backslashes, one more reason the
#   book prefers [[ ]] for new scripts.
#
# NEW IN THIS SCRIPT
#   \( ... \)   grouping inside [ ]: the parentheses are escaped with \ (or
#               quoted) so that bash passes them on to test
#
# RUN IT
#   chmod u+x book_11_test_integer4_with_test.sh
#   ./book_11_test_integer4_with_test.sh
#
# OUTPUT
#   50 is in range.
#
# TRY THIS
#   - Copy the script (cp book_11_test_integer4_with_test.sh try.sh). In the
#     copy, change INT=50 to INT=100, then INT=101. Predict each answer: is
#     100 outside the range?
#   - Delete the two backslashes in your copy and run it. What does bash say?
#     Does any line of the if statement run?
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
    if [ ! \( "$INT" -ge "$MIN_VAL" -a "$INT" -le "$MAX_VAL" \) ]; then
        echo "$INT is outside $MIN_VAL to $MAX_VAL."
    else
        echo "$INT is in range."
    fi
else
        echo "INT is not an integer." >&2
        exit 1
fi
