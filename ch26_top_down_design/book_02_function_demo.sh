#!/bin/bash
# =============================================================================
# CET 2390 Operating Systems Laboratory: a textbook script, explained
# Script:   shell function demo, from The Linux Command Line (TLCL 19.01),
#           chapter 26, "Shell Functions" (the book gives it no file name)
# Code:     William Shotts. Explanations: Prof. Hernan Lozano, CityTech (CUNY)
# Layout:   the book prints line numbers 1 to 14 beside the code; they are not
#           part of the script and are left out below the line.
# =============================================================================
#
# WHAT IT DOES
#   Prints Step 1, Step 2 and Step 3. The middle line comes from a shell function
#   named step2, so the script shows the path bash takes when it calls one.
#
# HOW IT WORKS
#   1. `function step2 {` ... `}` is a function definition: a name, then a group
#      of commands between braces. A shell function is a small script inside your
#      script that you run by its name, like any command. Bash reads the
#      definition and remembers it, but runs nothing yet.
#   2. This is the book's formal form, with the word function. The simpler form,
#      `step2 () {` ... `}`, does exactly the same; the book prefers it and uses it
#      in the next listing. The parentheses always stay empty: in this course a
#      function takes nothing in, and works with the script's own variables.
#   3. Execution starts at `echo "Step 1"`, the first command outside the
#      definition (the book's comment marks it: Main program starts here).
#   4. `step2` on a line by itself is a call: bash runs the commands inside the
#      function, so `echo "Step 2"` prints.
#   5. `return` ends the function, and bash goes back to the line after the call,
#      `echo "Step 3"`. (The closing brace would end the function too; return
#      makes the end easy to see.)
#   6. The book traces this script by its line numbers: execution begins at line
#      12, line 13 calls step2, control moves to lines 6 and 7, then back to line
#      14. In this file the study header comes first: add 63 to a book line number
#      (book line 12, echo "Step 1", is line 75 here). `cat -n` shows the numbers.
#   7. A function must be defined above the line that calls it. Bash reads from
#      top to bottom, and a name it has not met yet is looked up as a program on
#      the disk, which gives command not found.
#
# NEW IN THIS SCRIPT
#   function name { ... }   defines a function (the formal form)
#   name () { ... }         defines a function (the simpler, preferred form)
#   name                    calls the function: runs the commands inside it
#   return                  ends the function; bash goes back to the caller
#
# RUN IT
#   chmod u+x book_02_function_demo.sh
#   ./book_02_function_demo.sh
#   cat -n book_02_function_demo.sh     (shows the script with line numbers)
#
# OUTPUT
#   Step 1
#   Step 2
#   Step 3
#
# TRY THIS
#   - In a copy, call step2 twice in a row. How many times does Step 2 print?
#   - Move the step2 call up, so it comes right after # Shell function demo,
#     above the definition. Run it. What error appears, and does Step 2 print?
#   - Rewrite the first line of the definition as step2 () { and run it again.
#     Does anything change? Then delete the return line: does anything change?
#
# Below the line: the book's code, unchanged (TLCL is licensed CC BY-NC-ND 3.0;
# see LICENSE.md).
# ---------------------------------------------------------------------------

# Shell function demo

function step2 {
    echo "Step 2"
    return
}

# Main program starts here

echo "Step 1"
step2
echo "Step 3"
