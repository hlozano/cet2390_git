#!/bin/bash
# =============================================================================
# CET 2390 Operating Systems Laboratory: a textbook script, explained
# Script:   test-integer3 coded with test, from The Linux Command Line
#           (TLCL 19.01), chapter 27, "Combining Expressions"
# Code:     William Shotts. Explanations: Prof. Hernan Lozano, CityTech (CUNY)
# =============================================================================
#
# WHAT IT DOES
#   The same range check as test-integer3 (book_08), with the range test
#   written for the older test command, [ ], as the book shows next. The
#   output is the same.
#
# HOW IT WORKS
#   1. Every line is book_08's code except one:
#      `if [ "$INT" -ge "$MIN_VAL" -a "$INT" -le "$MAX_VAL" ]; then`
#   2. Inside [ ], AND is spelled `-a` (and OR is spelled -o). && cannot go
#      inside [ ]: bash reads && itself, as the control operator, so it cuts
#      the test in two and [ never receives its closing ].
#   3. The book prints only this new if block. This file is assembled: the
#      book's test-integer3 listing with its inner if block replaced by the
#      book's "We could have also coded this using test" version.
#   What the pair shows: [[ A && B ]] and [ A -a B ] give the same answers.
#   [ ] works in every shell, because it is the standard (POSIX) form; [[ ]]
#   belongs to bash, is easier to write and harder to break, and the book
#   prefers it for new scripts. The first test still needs [[ ]], because
#   [ ] has no =~.
#
# NEW IN THIS SCRIPT
#   A -a B   inside [ ]: AND, true when both are true
#   A -o B   inside [ ]: OR, true when at least one is true
#   On a current system, the manual page for test (man test) calls -a and -o
#   "inherently ambiguous" and suggests [ A ] && [ B ] instead. They still
#   work in bash, as this script shows.
#
# RUN IT
#   chmod u+x book_09_test_integer3_with_test.sh
#   ./book_09_test_integer3_with_test.sh
#
# OUTPUT
#   50 is within 1 to 100.
#
# TRY THIS
#   - Copy the script (cp book_09_test_integer3_with_test.sh try.sh). In the
#     copy, change INT=50 to INT=1, then INT=101. Predict each answer: the
#     same as book_08's?
#   - Set INT=50 again and replace -a with && inside the [ ]. Run it. What
#     does bash say, and why is the answer now wrong?
#   - Write the test as two [ ] commands joined by &&:
#         if [ "$INT" -ge "$MIN_VAL" ] && [ "$INT" -le "$MAX_VAL" ]; then
#     Does it work? Here && joins two whole commands.
#
# Below the line: the book's code, unchanged (TLCL is licensed CC BY-NC-ND 3.0;
# see LICENSE.md).
# ---------------------------------------------------------------------------

# test-integer3: determine if an integer is within a
# specified range of values.

MIN_VAL=1
MAX_VAL=100

INT=50

if [[ "$INT" =~ ^-?[0-9]+$ ]]; then
    if [ "$INT" -ge "$MIN_VAL" -a "$INT" -le "$MAX_VAL" ]; then
        echo "$INT is within $MIN_VAL to $MAX_VAL."
    else
        echo "$INT is out of range."
    fi
else
        echo "INT is not an integer." >&2
        exit 1
fi
