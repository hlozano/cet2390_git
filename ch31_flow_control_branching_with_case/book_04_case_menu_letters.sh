#!/bin/bash
# =============================================================================
# CET 2390 Operating Systems Laboratory: a textbook script, explained
# Script:   case-menu, the version with letters, from The Linux Command Line
#           (TLCL 19.01), chapter 31, "Patterns"
# Code:     William Shotts. Explanations: Prof. Hernan Lozano, CityTech (CUNY)
# =============================================================================
#
# WHAT IT DOES
#   The menu from book_02_case_menu.sh with letters instead of digits: A, B
#   and C for the three reports, Q to quit. A capital or a small letter gives
#   the same result.
#
# HOW IT WORKS
#   1. The menu and the prompt now show letters: "Enter selection [A, B, C or
#      Q] > ". The answer goes into REPLY, as before.
#   2. `q|Q)` holds two patterns joined by `|`. Read the bar as "or": the
#      answer q or the answer Q runs this branch. One bar, and no spaces are
#      needed around it.
#   3. `a|A)`, `b|B)` and `c|C)` work the same way for the three reports.
#   4. The first command of each branch sits on the same line as its pattern
#      (`q|Q) echo "Program terminated."`). That works exactly like starting
#      it on the next line, as case-menu did.
#   5. `*)` catches everything else: a digit, a whole word, or Enter alone.
#   Everything else is the same as book_02_case_menu.sh.
#
# NEW IN THIS SCRIPT
#   pat1|pat2)   several patterns share one branch; read | as "or".
#                (Not ||, which joins two commands: chapter 27.)
#
# RUN IT
#   chmod u+x book_04_case_menu_letters.sh
#   ./book_04_case_menu_letters.sh
#
# OUTPUT
#   After the menu (you typed Q; on a second run, z):
#
#   Enter selection [A, B, C or Q] > Q
#   Program terminated.
#
#   Enter selection [A, B, C or Q] > z
#   Invalid entry
#
# TRY THIS
#   - Answer quit. Why does it reach *)? Change q|Q) to q|Q|quit) in a copy
#     and try again.
#   - Write the first pattern as a set instead: [qQ]). Does the menu behave
#     the same? Could a set like that match the word yes? Why not?
#   - Answer a, then A. Is there any difference in what prints?
#
# Below the line: the book's code, unchanged (TLCL is licensed CC BY-NC-ND 3.0;
# see LICENSE.md).
# ---------------------------------------------------------------------------

# case-menu: a menu driven system information program

clear
echo "
Please Select:

A. Display System Information
B. Display Disk Space
C. Display Home Space Utilization
Q. Quit
"
read -p "Enter selection [A, B, C or Q] > "

case "$REPLY" in
    q|Q) echo "Program terminated."
        exit
        ;;
    a|A) echo "Hostname: $HOSTNAME"
        uptime
        ;;
    b|B) df -h
        ;;
    c|C) if [[ "$(id -u)" -eq 0 ]]; then
            echo "Home Space Utilization (All Users)"
            du -sh /home/*
        else
            echo "Home Space Utilization ($USER)"
            du -sh "$HOME"
        fi
        ;;
    *)  echo "Invalid entry" >&2
        exit 1
        ;;
esac
