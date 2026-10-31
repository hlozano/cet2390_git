#!/bin/bash
# =============================================================================
# CET 2390 Operating Systems Laboratory: a textbook script, explained
# Script:   read-menu, from The Linux Command Line (TLCL 19.01), chapter 31,
#           "case" (the book first shows it in chapter 28, "Menus")
# Code:     William Shotts. Explanations: Prof. Hernan Lozano, CityTech (CUNY)
# =============================================================================
#
# WHAT IT DOES
#   Shows a menu with four choices, reads your answer and runs the matching
#   command: system information, disk space, the size of your home folder, or
#   quit. Chapter 31 reprints this chapter 28 program as the "before" picture:
#   it tests one variable with a chain of if commands. The next script,
#   book_02_case_menu.sh, does the same job with case.
#
# HOW IT WORKS
#   1. `clear` empties the terminal window, so the menu starts at the top.
#   2. One `echo` prints the whole menu. The text inside the double quotes
#      runs over several lines, and echo prints every line break as typed,
#      blank lines included.
#   3. `read -p "Enter selection [0-3] > "` prints the prompt and waits for you
#      to type a line and press Enter. No variable name follows read, so your
#      answer is stored in the variable REPLY (chapter 28).
#   4. `[[ "$REPLY" =~ ^[0-3]$ ]]` checks the answer with a regular expression
#      (chapter 27): ^ is the start, [0-3] is one character from 0 to 3, $ is
#      the end. Only a single digit from 0 to 3 passes; anything else jumps to
#      the `else` at the bottom.
#   5. Four more if commands test the same variable again, one per choice:
#      `[[ "$REPLY" == 0 ]]`, then 1, 2 and 3. Each block ends with `exit`, so
#      once one choice has run, the script stops.
#        0  prints "Program terminated."
#        1  `echo "Hostname: $HOSTNAME"` prints the computer's name (bash keeps
#           it in the variable HOSTNAME); `uptime` shows how long the computer
#           has been running.
#        2  `df -h` lists each disk with its size and free space; -h means
#           "human readable" sizes such as 16G.
#        3  `[[ "$(id -u)" -eq 0 ]]` asks whether you are the superuser: id -u
#           prints your user ID number, and root's is 0. Root gets
#           `du -sh /home/*`, the size of every home folder; everyone else
#           gets `du -sh "$HOME"`, the size of their own.
#   6. The `else` branch prints "Invalid entry." with `>&2`, which sends the
#      message to standard error, the channel meant for error messages
#      (chapter 6), and `exit 1` ends the script with exit status 1: failure.
#   Count the tests on REPLY: five. A fifth menu item would mean editing the
#   regular expression and writing one more if block. That repetition is the
#   problem case solves.
#
# NEW IN THIS SCRIPT
#   Nothing new: every piece comes from chapters 27 and 28. Read it so you can
#   compare it, line by line, with book_02_case_menu.sh.
#
# RUN IT
#   chmod u+x book_01_read_menu.sh
#   ./book_01_read_menu.sh
#   It ends after one choice; run it again to try another answer.
#
# OUTPUT
#   You typed 9 and pressed Enter. The screen clears first, and the menu
#   begins with one blank line (the quoted text starts with a line break):
#
#   Please Select:
#
#   1. Display System Information
#   2. Display Disk Space
#   3. Display Home Space Utilization
#   0. Quit
#
#   Enter selection [0-3] > 9
#   Invalid entry.
#
#   Answering 0 instead prints "Program terminated."
#
# TRY THIS
#   - Answer 12. Is that a single digit from 0 to 3? Predict the message.
#   - Answer 9, then type echo $? at the prompt. Which exit status does the
#     else branch leave, and which line sets it?
#   - Answer 4. Which of the five tests on REPLY rejects it?
#
# Below the line: the book's code, unchanged (TLCL is licensed CC BY-NC-ND 3.0;
# see LICENSE.md).
# ---------------------------------------------------------------------------

# read-menu: a menu driven system information program

clear
echo "
Please Select:

1. Display System Information
2. Display Disk Space
3. Display Home Space Utilization
0. Quit
"
read -p "Enter selection [0-3] > "

if [[ "$REPLY" =~ ^[0-3]$ ]]; then
    if [[ "$REPLY" == 0 ]]; then
        echo "Program terminated."
        exit
    fi
    if [[ "$REPLY" == 1 ]]; then
        echo "Hostname: $HOSTNAME"
        uptime
        exit
    fi
    if [[ "$REPLY" == 2 ]]; then
        df -h
        exit
    fi
    if [[ "$REPLY" == 3 ]]; then
        if [[ "$(id -u)" -eq 0 ]]; then
            echo "Home Space Utilization (All Users)"
            du -sh /home/*
        else
            echo "Home Space Utilization ($USER)"
            du -sh "$HOME"
        fi
        exit
    fi
else
    echo "Invalid entry." >&2
    exit 1
fi
