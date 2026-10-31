#!/bin/bash
# =============================================================================
# CET 2390 Operating Systems Laboratory: a textbook script, explained
# Script:   read-default, from The Linux Command Line (TLCL 19.01), chapter 28,
#           "Options"
# Code:     William Shotts. Explanations: Prof. Hernan Lozano, CityTech (CUNY)
# =============================================================================
#
# WHAT IT DOES
#   Asks for your user name with the answer already filled in: your login
#   name. Press Enter to accept it, or edit it first. The script then prints
#   the answer.
#
# HOW IT WORKS
#   1. `read -e -p "What is your user name? " -i $USER` prints the prompt and
#      puts the value of USER (the variable that holds your login name) on
#      the input line, as if you had typed it already.
#   2. -i "text" sets that default answer. It works only together with -e,
#      which turns on Readline: the same line editing you have at the prompt
#      (arrow keys, Backspace, Ctrl-a for the start of the line). Without -e,
#      -i is ignored.
#   3. No variable is named, so the answer lands in REPLY, which the echo
#      line prints between quotes.
#   Two things the book does not say:
#   - The default appears only when a person types at a terminal. Fed by a
#     here string or a pipe, read takes the fed line as it is: an empty line
#     gives REPLY = ''.
#   - The book writes $USER without quotes. If USER is empty or unset (Git
#     Bash on Windows does not set it), -i has nothing after it, read fails
#     with "read: -i: option requires an argument", and the script still
#     prints You answered: ''. The safe form in your own scripts is
#     -i "$USER".
#
# NEW IN THIS SCRIPT
#   read -e          use Readline: edit the answer with the arrow keys
#   read -i "text"   start with text as the answer (needs -e)
#   $USER            the variable that holds your login name
#
# RUN IT
#   chmod u+x book_07_read_default.sh
#   ./book_07_read_default.sh             press Enter without typing
#   ./book_07_read_default.sh <<< ""      fed an empty line: no default
#
# OUTPUT
#   At the keyboard, pressing only Enter (the machine used here has the user
#   name student; you see your own, which whoami also prints):
#     What is your user name? student
#     You answered: 'student'
#   Fed an empty line (no prompt, no default):
#     You answered: ''
#
# TRY THIS
#   - Run it, press Backspace a few times, type another name, press Enter.
#     What lands in REPLY?
#   - Run it and press the Left arrow, then Ctrl-a, then Ctrl-e. Which keys
#     move the cursor, and why does that work here (-e)?
#   - In a copy, remove -e and run it. Does the default still appear?
#
# Below the line: the book's code, unchanged (TLCL is licensed CC BY-NC-ND 3.0;
# see LICENSE.md).
# ---------------------------------------------------------------------------

# read-default: supply a default value if user presses Enter key.

read -e -p "What is your user name? " -i $USER
echo "You answered: '$REPLY'"
