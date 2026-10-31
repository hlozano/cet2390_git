#!/bin/bash
# =============================================================================
# CET 2390 Operating Systems Laboratory: a textbook script, explained
# Script:   test-integer3, from The Linux Command Line (TLCL 19.01), chapter 27,
#           "Combining Expressions"
# Code:     William Shotts. Explanations: Prof. Hernan Lozano, CityTech (CUNY)
# =============================================================================
#
# WHAT IT DOES
#   Says whether the number in INT (50) lies in the range MIN_VAL to MAX_VAL
#   (1 to 100), with both ends counted as inside the range.
#
# HOW IT WORKS
#   1. `MIN_VAL=1`, `MAX_VAL=100` and `INT=50` store the limits and the value.
#   2. `if [[ "$INT" =~ ^-?[0-9]+$ ]]; then` is the integer check from
#      test-integer2 (book_06).
#   3. `if [[ "$INT" -ge "$MIN_VAL" && "$INT" -le "$MAX_VAL" ]]; then` joins
#      two expressions with `&&` (AND) inside one [[ ]]. The whole test is true
#      only when both parts are true: INT is at least MIN_VAL, and INT is at
#      most MAX_VAL.
#   4. True: "50 is within 1 to 100." False: "... is out of range."
#   5. The last else (the integer check failed) prints the error on standard
#      error and exits with status 1. Its lines are indented 8 spaces in the
#      book; bash ignores indentation, which is there only for people.
#
# NEW IN THIS SCRIPT
#   A && B   inside [[ ]]: AND, true only when A and B are both true
#   A || B   inside [[ ]]: OR, true when at least one of them is true
#   The same && and || also go between two whole commands, where they decide
#   whether the second command runs at all: cmd1 && cmd2 runs cmd2 only if
#   cmd1 succeeded, cmd1 || cmd2 only if it failed ("Control operators" in
#   the README).
#
# RUN IT
#   chmod u+x book_08_test_integer3.sh
#   ./book_08_test_integer3.sh
#
# OUTPUT
#   50 is within 1 to 100.
#
# TRY THIS
#   - Copy the script (cp book_08_test_integer3.sh try.sh). In the copy,
#     change INT=50 to INT=100, then INT=101, then INT=0. Predict each answer
#     before you run ./try.sh. Is 100 inside the range?
#   - Try INT=fifty. Which else runs, and what does echo $? show afterwards?
#   - Rewrite the range test in your copy as
#     (( INT >= MIN_VAL && INT <= MAX_VAL )). Do the answers change?
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
    if [[ "$INT" -ge "$MIN_VAL" && "$INT" -le "$MAX_VAL" ]]; then
        echo "$INT is within $MIN_VAL to $MAX_VAL."
    else
        echo "$INT is out of range."
    fi
else
        echo "INT is not an integer." >&2
        exit 1
fi
