#!/bin/bash
# =============================================================================
# CET 2390 Operating Systems Laboratory: a textbook script, explained
# Script:   while-menu2, from The Linux Command Line (TLCL 19.01), chapter 29,
#           "Breaking Out of a Loop"
# Code:     William Shotts. Explanations: Prof. Hernan Lozano, CityTech (CUNY)
# =============================================================================
#
# WHAT IT DOES
#   The same menu as book_02_while_menu.sh, written as an endless loop that
#   you leave with break. Choices 1 to 3 end with continue, which starts the
#   next pass at once. What you see on the screen is the same as book_02.
#
# HOW IT WORKS
#   1. `while true; do` is an endless loop: true is a command that does
#      nothing and always succeeds (exit status 0), so the test never fails.
#      The loop can only end from inside, so some choice must reach break.
#   2. The menu (clear and the here document), the read and the check
#      `[[ "$REPLY" =~ ^[0-3]$ ]]` are the same as in book_02. As there, the
#      menu lines start with tabs, because <<- removes leading tabs only:
#      keep them as tabs if you retype it.
#   3. Choices 1, 2 and 3 each end with `continue`: skip the rest of this pass
#      and go straight back to the while line. Once choice 1 is handled there
#      is no reason to test for 2, 3 and 0, and continue skips those tests.
#   4. Choice 0 runs `break`: leave the loop at once and go on after done,
#      where "Program terminated." prints.
#   5. An invalid entry prints "Invalid entry.", pauses, and reaches done;
#      the next pass shows the menu again.
#   Changed from book_02: the quit test moved from the while line into the
#   body (if REPLY is 0, break), and each action ends with continue.
#
# NEW IN THIS SCRIPT
#   while true      an endless loop; true always succeeds
#   break           leave the loop now; go on after done
#   continue        skip the rest of this pass; go back to the test
#
# RUN IT
#   chmod u+x book_03_while_menu2.sh
#   ./book_03_while_menu2.sh               type 3, then 0
#   printf 'x\n3\n0\n' | ./book_03_while_menu2.sh
#   As with book_02, end fed answers with 0: when the fed input runs out,
#   every read fails, REPLY stays empty, and the loop never reaches break.
#
# OUTPUT
#   Typed at the keyboard, 3 and then 0 (the screen is cleared before each
#   menu; the size and user name are those of the machine used here):
#     Please Select:
#
#     1. Display System Information
#     2. Display Disk Space
#     3. Display Home Space Utilization
#     0. Quit
#
#     Enter selection [0-3] > 3
#     Home Space Utilization (student)
#     204K    /home/student
#   three seconds later the menu returns:
#     Please Select:
#     (the same four choices)
#     Enter selection [0-3] > 0
#     Program terminated.
#   Fed with printf (no prompts): the menu, Invalid entry. for the x, the
#   menu, the du lines, the menu, Program terminated.
#
# TRY THIS
#   - Find where this program ends. There is no test on the while line, so
#     which line is the only way out?
#   - In a copy, delete the continue after choice 1. Run it and choose 1.
#     Does anything change on the screen? (Not here: the later tests simply
#     fail. continue saves work; in other loops it changes what runs.)
#   - In a copy, delete the whole if block for choice 0. How can you leave
#     the program now?
#
# Below the line: the book's code, unchanged (TLCL is licensed CC BY-NC-ND 3.0;
# see LICENSE.md).
# ---------------------------------------------------------------------------

# while-menu2: a menu driven system information program

DELAY=3 # Number of seconds to display results

while true; do
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
        if [[ "$REPLY" == 1 ]]; then
            echo "Hostname: $HOSTNAME"
            uptime
            sleep "$DELAY"
            continue
        fi
        if [[ "$REPLY" == 2 ]]; then
            df -h
            sleep "$DELAY"
            continue
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
            continue
        fi
        if [[ "$REPLY" == 0 ]]; then
            break
        fi
    else
        echo "Invalid entry."
        sleep "$DELAY"
    fi
done
echo "Program terminated."
