#!/bin/bash
# =============================================================================
# CET 2390 Operating Systems Laboratory: a textbook script, explained
# Script:   case-menu, from The Linux Command Line (TLCL 19.01), chapter 31,
#           "case"
# Code:     William Shotts. Explanations: Prof. Hernan Lozano, CityTech (CUNY)
# =============================================================================
#
# WHAT IT DOES
#   The menu from book_01_read_menu.sh, rewritten with case. It looks the same
#   and does the same work, but the program is shorter and easier to extend.
#
# HOW IT WORKS
#   1. `clear`, the `echo` that prints the menu, and `read -p` are the same as
#      in read-menu: your answer is stored in REPLY.
#   2. `case "$REPLY" in` names the value to test, once. Each line below it
#      that starts with a pattern and a `)` begins a branch. case compares
#      REPLY with the patterns from the top down.
#   3. `0)` matches the answer 0: it prints "Program terminated." and `exit`
#      ends the script. `;;` marks the end of the branch.
#   4. `1)`, `2)` and `3)` run the same commands as before. They need no
#      `exit`: when a branch reaches `;;`, case is finished and bash goes on
#      after `esac`. Nothing follows `esac`, so the script ends anyway.
#   5. Branch `3)` still holds the if from read-menu that checks for the
#      superuser (user ID 0). A branch can hold any commands, even an if.
#   6. `*)` matches anything at all, so it catches every answer the patterns
#      above did not: 9, x, 12, or Enter alone. It prints "Invalid entry" to
#      standard error (`>&2`) and ends with exit status 1. This one branch
#      replaces both the regular expression and the else of read-menu.
#   7. `esac` (case spelled backwards) closes the command, the way fi closes if.
#   Only the first branch whose pattern matches runs; then case jumps to esac.
#
# NEW IN THIS SCRIPT
#   case WORD in   compares WORD with the patterns below it, top to bottom
#   pattern)       starts a branch; the ) ends the pattern
#   ;;             ends a branch: case is done, bash jumps to esac
#   *)             matches anything: the default branch, always the last one
#   esac           closes the case command
#   About the quotes: the book writes case "$REPLY" in. Some guides warn that
#   case $REPLY in, without quotes, is a syntax error when the answer is empty
#   or holds a space. It is not: bash never splits the word after case into
#   pieces, so both forms behave the same. Quote it anyway. The habit protects
#   you in [ ] tests and in commands such as ls "$f", where quotes do matter.
#
# RUN IT
#   chmod u+x book_02_case_menu.sh
#   ./book_02_case_menu.sh
#
# OUTPUT
#   The same menu as read-menu, then (you typed 0; on a second run, x):
#
#   Enter selection [0-3] > 0
#   Program terminated.
#
#   Enter selection [0-3] > x
#   Invalid entry
#
#   After the x, echo $? prints 1. Answer 3 and you see the size of your own
#   home folder; on a test machine whose user is student:
#   Home Space Utilization (student)
#   88K     /home/student
#
# TRY THIS
#   - Add a choice "4. Display the Date" that runs date. Besides the new
#     branch, which two lines must change? Why must the branch go above *)?
#   - In a copy, delete the three lines of the *) branch and answer 9. What
#     prints, and what does echo $? say now?
#   - Remove the quotes (case $REPLY in), run it and press Enter alone. Is
#     there a syntax error, or does *) answer?
#
# Below the line: the book's code, unchanged (TLCL is licensed CC BY-NC-ND 3.0;
# see LICENSE.md).
# ---------------------------------------------------------------------------

# case-menu: a menu driven system information program

clear
echo "
Please Select:

1. Display System Information
2. Display Disk Space
3. Display Home Space Utilization
0. Quit
"
read -p "Enter selection [0-3] > "

case "$REPLY" in
    0)  echo "Program terminated."
        exit
        ;;
    1)  echo "Hostname: $HOSTNAME"
        uptime
        ;;
    2)  df -h
        ;;
    3)  if [[ "$(id -u)" -eq 0 ]]; then
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
