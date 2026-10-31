#!/bin/bash
# =============================================================================
# CET 2390 Operating Systems Laboratory: a textbook script, explained
# Script:   read-menu, from The Linux Command Line (TLCL 19.01), chapter 28,
#           "Menus"
# Code:     William Shotts. Explanations: Prof. Hernan Lozano, CityTech (CUNY)
# =============================================================================
#
# WHAT IT DOES
#   A menu-driven program: it clears the screen, shows four numbered choices,
#   reads one, and carries it out (system information, disk space, or the
#   space used by home folders). Each choice ends the program, so it does one
#   thing per run. Nothing it runs changes the system; it only reports.
#
# HOW IT WORKS
#   Every menu program has the same shape, and this one shows it in order:
#   show the choices, read one, check it, act on it. (Chapter 29 adds the
#   last part: repeat until the user picks Quit.)
#   1. Show: `clear` wipes the terminal window, then one echo prints the
#      whole menu. The text in double quotes runs over several lines, and
#      echo prints its line breaks as they are, blank lines included.
#   2. Read: `read -p "Enter selection [0-3] > "` stores the choice in REPLY.
#   3. Check: `[[ "$REPLY" =~ ^[0-3]$ ]]` accepts exactly one character, a
#      digit from 0 to 3. Anything else (9, 12, a word, a bare Enter) goes to
#      the else at the bottom: "Invalid entry." on standard error and exit 1.
#   4. Act: one if per choice, each comparing REPLY with ==.
#      0 prints "Program terminated.".
#      1 prints "Hostname:" and $HOSTNAME (a variable bash sets to the name
#        of the computer), then runs uptime (how long the system has been up).
#      2 runs df -h: free space on each file system (-h: sizes in K, M, G).
#      3 runs du -sh: the total size of a folder (-s: one total, -h: K, M, G).
#        `[[ "$(id -u)" -eq 0 ]]` asks whether you are root (user ID 0): root
#        may measure every folder in /home; anyone else measures only their
#        own home folder, "$HOME".
#   5. Each block ends with exit, so after one action the program stops. The
#      book itself says that many exits make a program harder to follow;
#      chapter 29 puts this menu in a loop and removes them.
#
# NEW IN THIS SCRIPT
#   menu-driven     the program shows choices and the user picks one
#   clear           wipe the terminal window
#   ^[0-3]$         exactly one character, a digit from 0 to 3
#   exit            end the script now (exit with no number keeps the status
#                   of the last command, here 0)
#   $HOSTNAME       the computer's name;  id -u: your user ID (root is 0)
#   uptime, df -h, du -sh   time since start-up, disk space, folder size
#
# RUN IT
#   chmod u+x book_10_read_menu.sh
#   ./book_10_read_menu.sh                 then type 3
#   ./book_10_read_menu.sh <<< 9           an invalid choice
#   echo $?
#
# OUTPUT
#   Typed at the keyboard, 3 (the screen is cleared first; the size and the
#   name are those of the machine used here):
#
#     Please Select:
#
#     1. Display System Information
#     2. Display Disk Space
#     3. Display Home Space Utilization
#     0. Quit
#
#     Enter selection [0-3] > 3
#     Home Space Utilization (student)
#     88K     /home/student
#   Choice 2 prints the df table, which starts with the heading
#     Filesystem      Size  Used Avail Use% Mounted on
#   and choice 0 prints Program terminated.
#   Fed <<< 9: the menu prints, then Invalid entry. (no prompt, because the
#   input is not a terminal), and echo $? prints 1.
#
# TRY THIS
#   - Run it and type 12. Why is 12 invalid when 1 and 2 are both on the
#     menu? Which part of ^[0-3]$ rejects it?
#   - Run it with choice 1, then type echo $?. Run it with 9 and do the
#     same. Where does each status come from, when the exit in choice 1 has
#     no number?
#   - Run it and type 2 again: does the menu come back? What would you need
#     to make it come back? (Chapter 29, book_02_while_menu.sh.)
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
