#!/bin/bash
# =============================================================================
# CET 2390 Operating Systems Laboratory: a textbook script, explained
# Script:   read-single (first version), from The Linux Command Line
#           (TLCL 19.01), chapter 28, "read - Read Values from Standard Input"
# Code:     William Shotts. Explanations: Prof. Hernan Lozano, CityTech (CUNY)
# =============================================================================
#
# WHAT IT DOES
#   Calls read without naming a variable. The whole line you type goes into
#   the shell variable REPLY, and the script prints it between quotes.
#
# HOW IT WORKS
#   1. `echo -n "Enter one or more values > "` prints the question.
#   2. `read` with no variable name stores the whole line in REPLY, a variable
#      bash provides for exactly this. The line is not split into words, and
#      REPLY even keeps the spaces at the start and end of the line (a named
#      variable, as in book_02, loses those).
#   3. `echo "REPLY = '$REPLY'"` prints it between single quotes, so you can
#      see every space.
#
# NEW IN THIS SCRIPT
#   read          with no variable named, the line goes into REPLY
#   REPLY         the shell variable that holds the answer of a bare read
#
# RUN IT
#   chmod u+x book_04_read_single.sh
#   ./book_04_read_single.sh                          then type a b c d
#   ./book_04_read_single.sh <<< "   spaced   out   "
#
# OUTPUT
#   Typed at the keyboard:
#     Enter one or more values > a b c d
#     REPLY = 'a b c d'
#   Fed with the here string (the question prints, the typing does not):
#     Enter one or more values > REPLY = '   spaced   out   '
#
# TRY THIS
#   - In a copy, change read to read line and the echo to print $line. Feed
#     it "   spaced   out   " again: which spaces are gone now?
#   - In a copy, put a second read right after the first one, then type two
#     different lines. Which one does REPLY hold at the end? Why is REPLY a
#     poor place to keep an answer you need later?
#
# Below the line: the book's code, unchanged (TLCL is licensed CC BY-NC-ND 3.0;
# see LICENSE.md).
# ---------------------------------------------------------------------------

# read-single: read multiple values into default variable

echo -n "Enter one or more values > "
read

echo "REPLY = '$REPLY'"
