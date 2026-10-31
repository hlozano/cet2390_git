#!/bin/bash
# =============================================================================
# CET 2390 Operating Systems Laboratory: a textbook script, explained
# Script:   read-single (second version; the book keeps the same name), from
#           The Linux Command Line (TLCL 19.01), chapter 28, "Options"
# Code:     William Shotts. Explanations: Prof. Hernan Lozano, CityTech (CUNY)
# =============================================================================
#
# WHAT IT DOES
#   The same program as book_04_read_single.sh, written with read -p: the
#   prompt moves into the read command, so two lines become one.
#
# HOW IT WORKS
#   1. `read -p "Enter one or more values > "` prints the prompt and then
#      waits for a line, in one command. It replaces the echo -n line and the
#      read line of book_04. This is the form to use in your own scripts.
#   2. No variable is named, so the line goes into REPLY, as in book_04.
#   3. `echo "REPLY = '$REPLY'"` prints it.
#   One difference shows when you do not type the answer yourself: read -p
#   prints its prompt only when the input comes from a terminal (a person at
#   the keyboard). It also prints the prompt on standard error, not standard
#   output. Fed by a here string or a pipe, the script shows no prompt at all.
#
# NEW IN THIS SCRIPT
#   read -p "text"    print text as a prompt, then wait on the same line
#
# RUN IT
#   chmod u+x book_05_read_single.sh
#   ./book_05_read_single.sh                then type a b c d
#   ./book_05_read_single.sh <<< "a b c d"
#
# OUTPUT
#   Typed at the keyboard (the same screen as book_04):
#     Enter one or more values > a b c d
#     REPLY = 'a b c d'
#   Fed with the here string (no prompt, because the input is not a terminal):
#     REPLY = 'a b c d'
#
# TRY THIS
#   - Run book_04 and book_05 with the same here string, one after the other.
#     Which one shows its prompt, and why?
#   - In a copy, delete the space between > and the closing quote of the
#     prompt. Run it and type something: what does the screen look like?
#   - In a copy, add a variable name after the prompt: read -p "Name > " name,
#     and print $name. Where does the answer go now, and what is in REPLY?
#
# Below the line: the book's code, unchanged (TLCL is licensed CC BY-NC-ND 3.0;
# see LICENSE.md).
# ---------------------------------------------------------------------------

# read-single: read multiple values into default variable

read -p "Enter one or more values > "
echo "REPLY = '$REPLY'"
