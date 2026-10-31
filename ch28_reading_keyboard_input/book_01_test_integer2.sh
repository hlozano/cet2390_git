#!/bin/bash
# =============================================================================
# CET 2390 Operating Systems Laboratory: a textbook script, explained
# Script:   test-integer2, from The Linux Command Line (TLCL 19.01), chapter 28,
#           opening paragraphs (the book first shows it in chapter 27,
#           "A More Modern Version of test")
# Code:     William Shotts. Explanations: Prof. Hernan Lozano, CityTech (CUNY)
# =============================================================================
#
# WHAT IT DOES
#   Says whether the number stored in the variable INT is zero, negative or
#   positive, and even or odd. Chapter 28 opens with this chapter 27 script to
#   show what is missing: the number, -5, is written into the file, so testing
#   another number means editing the script. The rest of the chapter fixes
#   that by letting the script ask (book_02_read_integer.sh is next).
#
# HOW IT WORKS
#   1. `INT=-5` stores the value to test. There is no $ when you give a
#      variable a value; there is one when you use the value (`"$INT"`).
#   2. `[[ "$INT" =~ ^-?[0-9]+$ ]]` checks the shape of the value first. =~
#      compares the text with a regular expression (a pattern for text):
#      ^ is the start, -? an optional minus sign, [0-9]+ one or more digits,
#      $ the end. So -5 and 42 pass; 4.5, five and an empty value fail.
#   3. Only after the shape check do the number tests run:
#      `[ "$INT" -eq 0 ]` (equal to zero) and `[ "$INT" -lt 0 ]` (less than
#      zero). Run on a word, they would fail with "integer expression
#      expected"; the shape check keeps words away from them.
#   4. `$((INT % 2))` is arithmetic: % gives the remainder after dividing by 2.
#      A remainder of 0 means even; anything else (1, or -1 for a negative
#      number) means odd.
#   5. A value that is not an integer gets a message sent to standard error
#      (`>&2`, the channel meant for error messages) and `exit 1`: a non-zero
#      exit status tells whoever ran the script that it failed.
#
# NEW IN THIS SCRIPT
#   Nothing new: this is chapter 27's code. It is here to show the problem
#   the read command solves.
#
# RUN IT
#   chmod u+x book_01_test_integer2.sh
#   ./book_01_test_integer2.sh
#
# OUTPUT
#   INT is negative.
#   INT is odd.
#
# TRY THIS
#   - Copy it (cp book_01_test_integer2.sh mine.sh), change INT=-5 to INT=0,
#     then to INT=8, and run the copy each time. Predict both outputs first.
#     Why does 0 print only one line?
#   - Set INT=five in your copy. What prints, and what does echo $? show
#     right after the run?
#   - Count how many times you edited the file to test three numbers. That
#     is the problem chapter 28 solves: open book_02_read_integer.sh next.
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
