#!/bin/bash
# =============================================================================
# CET 2390 Operating Systems Laboratory: a textbook script, explained
# Script:   arith-loop, from The Linux Command Line (TLCL 19.01), chapter 34,
#           "Logic"
# Code:     William Shotts. Explanations: Prof. Hernan Lozano, CityTech (CUNY)
# =============================================================================
#
# WHAT IT DOES
#   Prints a table of the numbers 0 to 10 with their squares and cubes. The
#   loop ends through the ternary operator, a one-line if/else inside (( )).
#
# HOW IT WORKS
#   1. `finished=0` and `a=0` set the starting values.
#   2. `printf "a\ta**2\ta**3\n"` and `printf "=\t====\t====\n"` print the
#      two heading lines. \t is a tab, which lines up the columns; \n ends
#      the line.
#   3. `until ((finished)); do`: inside (( )), 0 counts as false and any
#      other number as true. until keeps looping while its test is false
#      (chapter 29), so the loop runs while finished is 0.
#   4. `b=$((a**2))` and `c=$((a**3))`: ** is the power operator, so b is the
#      square of a and c its cube.
#   5. `printf "%d\t%d\t%d\n" "$a" "$b" "$c"` prints one row: three whole
#      numbers separated by tabs.
#   6. `((a<10?++a:(finished=1)))` is the ternary operator: TEST ? THIS :
#      THAT. If a<10 is true, it runs ++a (add 1 to a); otherwise it runs
#      finished=1, and the until test ends the loop. After the row for 10,
#      a<10 is false, so 10 is the last row.
#   The parentheses around finished=1 are required. Without them, bash
#   reads the expression the wrong way and reports "attempted assignment to
#   non-variable".
#
# NEW IN THIS SCRIPT
#   **                    power: 2**3 is 8
#   TEST ? THIS : THAT    the ternary operator, inside (( ))
#   ((finished))          true when finished is not 0
#
# RUN IT
#   chmod u+x book_06_arith_loop.sh
#   ./book_06_arith_loop.sh
#
# OUTPUT
#   a       a**2    a**3
#   =       ====    ====
#   0       0       0
#   1       1       1
#   2       4       8
#   3       9       27
#   4       16      64
#   5       25      125
#   6       36      216
#   7       49      343
#   8       64      512
#   9       81      729
#   10      100     1000
#
# TRY THIS
#   - Which one change makes the table stop at 5? Predict the last row.
#   - At the prompt, type a=0; ((a<1?++a:--a)); echo $a twice. What does
#     each run do to a? (The book calls this a toggle.)
#   - At the prompt: a=10; finished=0; ((a<10?++a:finished=1)). Read the
#     error message, then add the parentheses.
#
# Below the line: the book's code, unchanged (TLCL is licensed CC BY-NC-ND 3.0;
# see LICENSE.md).
# ---------------------------------------------------------------------------

# arith-loop: script to demonstrate arithmetic operators

finished=0
a=0
printf "a\ta**2\ta**3\n"
printf "=\t====\t====\n"

until ((finished)); do
    b=$((a**2))
    c=$((a**3))
    printf "%d\t%d\t%d\n" "$a" "$b" "$c"
    ((a<10?++a:(finished=1)))
done
