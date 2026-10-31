#!/bin/bash
# =============================================================================
# CET 2390 Operating Systems Laboratory: a textbook script, explained
# Script:   ul-declare, from The Linux Command Line (TLCL 19.01), chapter 34,
#           "Case Conversion"
# Code:     William Shotts. Explanations: Prof. Hernan Lozano, CityTech (CUNY)
# =============================================================================
#
# WHAT IT DOES
#   Takes the word you type after the script's name and prints it twice: once
#   in uppercase and once in lowercase, however you typed it.
#
# HOW IT WORKS
#   1. `declare -u upper` gives the variable upper the uppercase attribute:
#      whatever is assigned to it is stored in capital letters.
#   2. `declare -l lower` does the same for lowercase.
#   3. `if [[ $1 ]]; then`: $1 is the first word typed after the script's
#      name, and [[ ]] with a value and no operator is true when that value is
#      not empty. With no word, the script prints nothing.
#   4. `upper="$1"` and `lower="$1"` assign the same word to both variables;
#      each stores it in its own case.
#   5. `echo "$upper"` and `echo "$lower"` print the two results.
#   Converting input to one standard form before you use it is called
#   normalizing: after it, Yes, YES and yes are the same answer.
#
# NEW IN THIS SCRIPT
#   declare -u NAME   NAME always stores uppercase
#   declare -l NAME   NAME always stores lowercase
#
# RUN IT
#   chmod u+x book_02_ul_declare.sh
#   ./book_02_ul_declare.sh aBc
#   (aBc is the first word after the script's name, so it becomes $1.)
#
# OUTPUT
#   ABC
#   abc
#
# TRY THIS
#   - Run ./book_02_ul_declare.sh hello World, then
#     ./book_02_ul_declare.sh "hello World". Why does the first print only
#     HELLO and hello?
#   - Run it with no word at all. Which line decides that nothing prints?
#   - At the prompt: declare -u shout; shout="quiet please"; echo "$shout"
#
# Below the line: the book's code, unchanged (TLCL is licensed CC BY-NC-ND 3.0;
# see LICENSE.md).
# ---------------------------------------------------------------------------

# ul-declare: demonstrate case conversion via declare

declare -u upper
declare -l lower

if [[ $1 ]]; then
        upper="$1"
        lower="$1"
        echo "$upper"
        echo "$lower"
fi
