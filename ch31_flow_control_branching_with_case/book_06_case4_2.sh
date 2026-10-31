#!/bin/bash
# =============================================================================
# CET 2390 Operating Systems Laboratory: a textbook script, explained
# Script:   case4-2, from The Linux Command Line (TLCL 19.01), chapter 31,
#           "Performing Multiple Actions"
# Code:     William Shotts. Explanations: Prof. Hernan Lozano, CityTech (CUNY)
# =============================================================================
#
# WHAT IT DOES
#   The character tester from book_05_case4_1.sh, changed so that it reports
#   every class the character belongs to, not only the first.
#
# HOW IT WORKS
#   1. `read -n 1` and `echo` are the same as in case4-1: one keypress goes
#      into REPLY, then the cursor moves to a new line.
#   2. The eight patterns are the same, in the same order.
#   3. The only change: every branch ends in `;;&` instead of `;;`. `;;&`
#      means "run this branch, then keep testing the patterns below it". So
#      after "lower case", case goes on to test [[:alpha:]], [[:digit:]] and
#      the rest, and prints a line for each one that matches.
#   4. After the last pattern has been tested, case ends.
#   `;;&` arrived in bash 4.0. Linux Mint and Ubuntu ship bash 5
#   (bash --version shows yours). Use `;;` in a menu, where one answer means
#   one action; use `;;&` only when a value can belong to several categories.
#
# NEW IN THIS SCRIPT
#   ;;&   end a branch, then keep testing the patterns below (bash 4.0 and later)
#
# RUN IT
#   chmod u+x book_06_case4_2.sh
#   ./book_06_case4_2.sh
#
# OUTPUT
#   You pressed the a key:
#   Type a character > a
#   'a' is lower case.
#   'a' is alphabetic.
#   'a' is a visible character.
#   'a' is a hexadecimal digit.
#   Pressing 7 prints three lines: a digit, a visible character, a
#   hexadecimal digit.
#
# TRY THIS
#   - Press A (capital). Which line changes, compared with a?
#   - Press ! and then the space bar (one run each). How many lines does each
#     print? Then press f and g: why does f give four lines but g only three?
#   - In a copy, change only the [[:alpha:]] line back to ;; and press a.
#     Which lines still print, and why do the ones below it stop?
#
# Below the line: the book's code, unchanged (TLCL is licensed CC BY-NC-ND 3.0;
# see LICENSE.md).
# ---------------------------------------------------------------------------

# case4-2: test a character

read -n 1 -p "Type a character > "
echo
case "$REPLY" in
    [[:upper:]])    echo "'$REPLY' is upper case." ;;&
    [[:lower:]])    echo "'$REPLY' is lower case." ;;&
    [[:alpha:]])    echo "'$REPLY' is alphabetic." ;;&
    [[:digit:]])    echo "'$REPLY' is a digit." ;;&
    [[:graph:]])    echo "'$REPLY' is a visible character." ;;&
    [[:punct:]])    echo "'$REPLY' is a punctuation symbol." ;;&
    [[:space:]])    echo "'$REPLY' is a whitespace character." ;;&
    [[:xdigit:]])   echo "'$REPLY' is a hexadecimal digit." ;;&
esac
