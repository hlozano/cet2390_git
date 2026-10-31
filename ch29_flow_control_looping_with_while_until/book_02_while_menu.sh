#!/bin/bash
# =============================================================================
# CET 2390 Operating Systems Laboratory: a textbook script, explained
# Script:   while-menu, from The Linux Command Line (TLCL 19.01), chapter 29,
#           "while"
# Code:     William Shotts. Explanations: Prof. Hernan Lozano, CityTech (CUNY)
# =============================================================================
#
# WHAT IT DOES
#   Chapter 28's menu program (read-menu) inside a while loop. The menu comes
#   back after every choice, a wrong entry gets another try instead of ending
#   the program, and the program ends only when you choose 0. It only reports
#   on the system; it changes nothing.
#
# HOW IT WORKS
#   This is the full shape every menu program follows: repeat { show the
#   choices, read one, check it, act on it } until the user picks Quit.
#   1. `DELAY=3` keeps the pause length in one variable for every sleep. The
#      text after # on that line is a comment.
#   2. Repeat: `while [[ "$REPLY" != 0 ]]; do` runs the loop as long as the
#      last answer is not 0. REPLY is empty when the script starts, and empty
#      is not 0, so the first pass always runs and the menu appears.
#   3. Show: `clear`, then `cat <<- _EOF_` prints the menu. That is a here
#      document (chapter 25): the lines up to the end marker _EOF_ become
#      cat's input. The - in <<- removes tab characters at the start of each
#      line, so the menu can be indented in the script and still print at the
#      left edge. It removes tabs only, not spaces: the menu lines in this
#      file start with tabs, so keep them as tabs if you retype it. Indent
#      the _EOF_ line with spaces and bash never finds the end marker: it
#      warns "here-document ... delimited by end-of-file" and stops with
#      "syntax error: unexpected end of file".
#   4. Read: `read -p "Enter selection [0-3] > "` stores the choice in REPLY.
#   5. Check: `[[ "$REPLY" =~ ^[0-3]$ ]]` accepts one digit from 0 to 3.
#      Anything else prints "Invalid entry.", pauses, and reaches done, so the
#      menu comes back: one wrong key no longer ends the program.
#   6. Act: choices 1, 2 and 3 run the same commands as in read-menu (host
#      name and uptime, df -h, du -sh), each followed by `sleep "$DELAY"`:
#      a 3-second pause so you can read the result before clear wipes it.
#   7. Quit: 0 passes the check but matches none of the 1, 2, 3 blocks, so
#      nothing runs. At done the test 0 != 0 fails, the loop ends, and the
#      line after done prints "Program terminated."
#   Changed from read-menu (chapter 28): the exit lines are gone, the sleep
#   lines are new, the menu is a here document instead of an echo, and
#   "Invalid entry." now goes to standard output and is not an error exit.
#
# NEW IN THIS SCRIPT
#   while [[ "$REPLY" != 0 ]]   loop until the answer is 0
#   sleep N                     pause for N seconds
#   cat <<- _EOF_               a here document; <<- strips leading tabs
#
# RUN IT
#   chmod u+x book_02_while_menu.sh
#   ./book_02_while_menu.sh                type 9, then 0
#   printf '9\n3\n0\n' | ./book_02_while_menu.sh
#   The second line feeds three answers without typing: printf prints each
#   one followed by \n (a new line, like pressing Enter), and the pipe |
#   hands that text to the script as its input. Always end fed answers with
#   0: once the fed input runs out, every read fails and leaves REPLY empty,
#   empty is never 0, and the menu repeats "Invalid entry." until Ctrl-c.
#
# OUTPUT
#   Typed at the keyboard, 9 and then 0. The screen is cleared before each
#   menu, so you see one menu at a time. First:
#     Please Select:
#
#     1. Display System Information
#     2. Display Disk Space
#     3. Display Home Space Utilization
#     0. Quit
#
#     Enter selection [0-3] > 9
#     Invalid entry.
#   three seconds later the screen clears and the menu returns:
#     Please Select:
#     (the same four choices)
#     Enter selection [0-3] > 0
#     Program terminated.
#   Fed with printf, there are no prompts (read -p prints its prompt only
#   for a terminal): the menu, Invalid entry., the menu again, the du line
#   for your home folder (Home Space Utilization (student) and its size on the
#   machine used here), the menu a third time, Program terminated.
#
# TRY THIS
#   - Run it and press Enter without typing. Why is an empty answer invalid,
#     but the empty REPLY at the start lets the loop run?
#   - In a copy, change DELAY=3 to DELAY=0 and choose 2. Can you read the
#     disk table before the menu comes back?
#   - Compare it with ../ch28_reading_keyboard_input/book_10_read_menu.sh.
#     List every line that changed.
#
# Below the line: the book's code, unchanged (TLCL is licensed CC BY-NC-ND 3.0;
# see LICENSE.md).
# ---------------------------------------------------------------------------

# while-menu: a menu driven system information program

DELAY=3 # Number of seconds to display results

while [[ "$REPLY" != 0 ]]; do
    clear
    cat <<- _EOF_
		Please Select:

		1. Display System Information
		2. Display Disk Space
		3. Display Home Space Utilization
		0. Quit

	_EOF_
    read -p "Enter selection [0-3] > "

    if [[ "$REPLY" =~ ^[0-3]$ ]]; then
        if [[ $REPLY == 1 ]]; then
            echo "Hostname: $HOSTNAME"
            uptime
            sleep "$DELAY"
        fi
        if [[ "$REPLY" == 2 ]]; then
            df -h
            sleep "$DELAY"
        fi
        if [[ "$REPLY" == 3 ]]; then
            if [[ "$(id -u)" -eq 0 ]]; then
                echo "Home Space Utilization (All Users)"
                du -sh /home/*
            else
                echo "Home Space Utilization ($USER)"
                du -sh "$HOME"
            fi
            sleep "$DELAY"
        fi
    else
        echo "Invalid entry."
        sleep "$DELAY"
    fi
done
echo "Program terminated."
