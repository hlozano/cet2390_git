#!/bin/bash
# =============================================================================
# CET 2390 Operating Systems Laboratory: a textbook script, explained
# Script:   test-integer2, from The Linux Command Line (TLCL 19.01), chapter 27,
#           "A More Modern Version of test"
# Code:     William Shotts. Explanations: Prof. Hernan Lozano, CityTech (CUNY)
# =============================================================================
#
# WHAT IT DOES
#   test-integer (book_05) made safe: before any number test, it checks that
#   INT really holds a whole number. If it does not, the script says so on
#   standard error and stops with exit status 1, instead of a wrong answer.
#
# HOW IT WORKS
#   1. `if [[ "$INT" =~ ^-?[0-9]+$ ]]; then` is the new first test. `[[ ]]` is
#      bash's newer test command: it understands every expression [ ] does,
#      plus the operator `=~`, which is true when the text on its left matches
#      the regular expression (a pattern that describes text) on its right.
#   2. Read the pattern one piece at a time:
#        ^        the start of the text
#        -?       an optional minus sign (? means "zero or one of the thing
#                 just before me")
#        [0-9]+   one or more digits (+ means "one or more")
#        $        the end of the text
#      So -5, 0 and 42 match; abc, 3.5, +7 and an empty value do not.
#   3. The pattern is not in quotes, on purpose. In quotes, bash would look
#      for the exact characters ^-?[0-9]+$ and the test would never be true.
#   4. When INT matches, the then part runs book_05's number tests, unchanged.
#      When it does not, the else at the bottom prints "INT is not an
#      integer." on standard error and runs `exit 1`.
#   What changed from book_05: the -z check at the top is gone, because the
#   pattern already rejects an empty value, and every number test moved inside
#   the new if. For INT=-5 the output is the same; for INT=abc, book_05 gave a
#   wrong answer and book_06 refuses the value.
#
# NEW IN THIS SCRIPT
#   [[ expression ]]   bash's newer test: everything [ ] does, plus =~ and ==.
#                      It works in bash, but not in plain sh
#   string =~ regex    true if the string matches the regular expression
#   string == pattern  inside [[ ]]: true if the string matches a wildcard
#                      pattern, as in [[ $FILE == *.txt ]] (see the README)
#
# RUN IT
#   chmod u+x book_06_test_integer2.sh
#   ./book_06_test_integer2.sh
#
# OUTPUT
#   INT is negative.
#   INT is odd.
#
# TRY THIS
#   - Copy the script (cp book_06_test_integer2.sh try.sh). In the copy,
#     change INT=-5 to INT=abc, the value that fooled book_05. Predict the
#     output and the exit status (echo $?), then run ./try.sh.
#   - Try INT=3.5, then INT=+7. Does each one match the pattern? Read the
#     pattern again, piece by piece, before you run it.
#   - Set INT=-5 again and put double quotes around the pattern in your copy:
#     "^-?[0-9]+$". What does the script say now, and why?
#
# Below the line: the book's code, unchanged (TLCL is licensed CC BY-NC-ND 3.0;
# see LICENSE.md).
# ---------------------------------------------------------------------------

# test-integer2: evaluate the value of an integer.

INT=-5

if [[ "$INT" =~ ^-?[0-9]+$ ]]; then
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
else
    echo "INT is not an integer." >&2
    exit 1
fi
