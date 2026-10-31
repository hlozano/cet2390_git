#!/bin/bash
# =============================================================================
# CET 2390 Operating Systems Laboratory: a textbook script, explained
# Script:   simple_counter, from The Linux Command Line (TLCL 19.01),
#           chapter 33, "for: C Language Form"
# Code:     William Shotts. Explanations: Prof. Hernan Lozano, CityTech (CUNY)
# =============================================================================
#
# WHAT IT DOES
#   Counts from 0 to 4, one number per line, with the C language form of for:
#   the loop for counting.
#
# HOW IT WORKS
#   1. `for (( i=0; i<5; i=i+1 )); do` holds three arithmetic expressions
#      inside (( )), separated by semicolons:
#        i=0     runs once, before the first pass;
#        i<5     is tested before every pass; the loop ends the moment it is
#                false;
#        i=i+1   runs at the end of every pass.
#   2. `echo $i` prints the current value.
#   3. The passes: i is 0, 1, 2, 3, 4. Then i becomes 5, i<5 is false, and the
#      loop ends. Five lines, from 0 to 4, not from 1 to 5.
#   Inside (( )) a name is read as a variable, so you write i, not $i, as in
#   the (( )) test of chapter 27. The book points out that this loop does the
#   same work as a while loop (chapter 29):
#       (( i=0 ))
#       while (( i<5 )); do
#           echo $i
#           (( i=i+1 ))
#       done
#
# NEW IN THIS SCRIPT
#   for (( start; test; step )); do ... done   the C language form of for
#   i++   inside (( )), the same as i=i+1 (many scripts write it this way)
#
# RUN IT
#   chmod u+x book_04_simple_counter.sh
#   ./book_04_simple_counter.sh
#
# OUTPUT
#   0
#   1
#   2
#   3
#   4
#
# TRY THIS
#   - Make it print 1 to 5. Which of the three expressions must change?
#   - Make it print 0 2 4 6 8 (one per line). Change only the step.
#   - In a copy, add echo "after the loop: $i" below done. Predict the value.
#
# Below the line: the book's code, unchanged (TLCL is licensed CC BY-NC-ND 3.0;
# see LICENSE.md).
# ---------------------------------------------------------------------------

# simple_counter: demo of C style for command

for (( i=0; i<5; i=i+1 )); do
    echo $i
done
