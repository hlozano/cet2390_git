#!/bin/bash
# =============================================================================
# CET 2390 Operating Systems Laboratory: a textbook script, explained
# Script:   local-vars, from The Linux Command Line (TLCL 19.01), chapter 26,
#           "Local Variables"
# Code:     William Shotts. Explanations: Prof. Hernan Lozano, CityTech (CUNY)
# =============================================================================
#
# WHAT IT DOES
#   Shows the difference between a global variable and a local one: two
#   functions each set their own foo, and the foo of the main program stays 0.
#
# HOW IT WORKS
#   1. `foo=0` at the top makes a global variable. Every variable so far has been
#      global: once assigned, it exists for the rest of the script, inside
#      functions too, and any part of the script can change it.
#   2. In funct_1, `local foo` makes a new variable named foo that belongs to
#      funct_1 alone. While funct_1 runs, the name foo means this local one; the
#      global foo is hidden, not changed.
#   3. `foo=1` sets the local foo, and the echo prints funct_1: foo = 1.
#   4. When funct_1 ends, its local foo disappears and the global foo, still 0,
#      is visible again.
#   5. funct_2 does the same with its own local foo, set to 2.
#   6. The main program, the five lines at the bottom, prints the global foo
#      before and after each call: it is 0 every time.
#   7. Why it matters: a function that keeps its variables local cannot change the
#      variables of the script around it, so it can be copied into another script
#      safely.
#   8. The comment after `local foo` starts at the #. A # starts a comment only at
#      the beginning of a word, so the space before it matters: `local foo#` makes
#      bash complain that foo# is not a valid name.
#
# NEW IN THIS SCRIPT
#   global variable   assigned anywhere; seen and changed by the whole script
#   local name        inside a function: a variable that exists only while that
#                     function runs; it hides a global with the same name
#
# RUN IT
#   chmod u+x book_04_local_vars.sh
#   ./book_04_local_vars.sh
#
# OUTPUT
#   global:  foo = 0
#   funct_1: foo = 1
#   global:  foo = 0
#   funct_2: foo = 2
#   global:  foo = 0
#
# TRY THIS
#   - In a copy, delete the line local foo from funct_1 only. Write down the five
#     lines you expect, then run it. Which lines changed, and why?
#   - Add echo "funct_2 starts: foo = $foo" as the first line inside funct_2,
#     above local foo. Which foo does it print?
#   - Type local foo=5 at the prompt, outside any function. What does bash say?
#
# Below the line: the book's code, unchanged (TLCL is licensed CC BY-NC-ND 3.0;
# see LICENSE.md).
# ---------------------------------------------------------------------------

# local-vars: script to demonstrate local variables

foo=0   # global variable foo

funct_1 () {

    local foo # variable foo local to funct_1

    foo=1
    echo "funct_1: foo = $foo"
}

funct_2 () {

    local foo # variable foo local to funct_2

    foo=2
    echo "funct_2: foo = $foo"
}

echo "global:  foo = $foo"
funct_1
echo "global:  foo = $foo"
funct_2
echo "global:  foo = $foo"
