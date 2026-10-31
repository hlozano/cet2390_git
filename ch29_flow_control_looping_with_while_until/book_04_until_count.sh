#!/bin/bash
# =============================================================================
# CET 2390 Operating Systems Laboratory: a textbook script, explained
# Script:   until-count, from The Linux Command Line (TLCL 19.01), chapter 29,
#           "until"
# Code:     William Shotts. Explanations: Prof. Hernan Lozano, CityTech (CUNY)
# =============================================================================
#
# WHAT IT DOES
#   The same output as book_01_while_count.sh, written with until instead of
#   while: the numbers 1 to 5, then "Finished."
#
# HOW IT WORKS
#   1. `count=1` sets the start value, as before.
#   2. `until [[ "$count" -gt 5 ]]; do` is the opposite of while: until runs
#      the body as long as the test FAILS (a non-zero exit status), and stops
#      as soon as it succeeds. So the test is turned around: -le 5 ("still 5
#      or less") became -gt 5 ("greater than 5", the moment to stop).
#   3. For count 1 to 5, 1 -gt 5 ... 5 -gt 5 all fail, so the body runs:
#      print, then add 1.
#   4. At 6 the test 6 -gt 5 succeeds, until stops, and "Finished." prints.
#   Read while as "as long as ..." and until as "up to the moment that ...".
#   Any while loop can be written as an until loop by turning the test
#   around; choose the one whose test reads most clearly. You will write
#   while far more often.
#
# NEW IN THIS SCRIPT
#   until test; do ... done   repeat the body for as long as the test fails
#   -gt                       greater than
#
# RUN IT
#   chmod u+x book_04_until_count.sh
#   ./book_04_until_count.sh
#
# OUTPUT
#   1
#   2
#   3
#   4
#   5
#   Finished.
#
# TRY THIS
#   - In a copy, change until to while and leave the test alone. Predict the
#     output, then run it. Why does only Finished. print?
#   - In a copy, start with count=6. What prints? Does until also check its
#     test before the first pass?
#   - Change -gt 5 to -eq 5. How many numbers print now, and why?
#
# Below the line: the book's code, unchanged (TLCL is licensed CC BY-NC-ND 3.0;
# see LICENSE.md).
# ---------------------------------------------------------------------------

# until-count: display a series of numbers

count=1

until [[ "$count" -gt 5 ]]; do
    echo "$count"
    count=$((count + 1))
done
echo "Finished."
