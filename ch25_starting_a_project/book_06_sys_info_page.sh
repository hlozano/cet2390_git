#!/bin/bash
# =============================================================================
# CET 2390 Operating Systems Laboratory: a textbook script, explained
# Script:   sys_info_page (stage 6 of 7), from The Linux Command Line (TLCL 19.01),
#           chapter 25, "Assigning Values to Variables and Constants"
# Code:     William Shotts. Explanations: Prof. Hernan Lozano, CityTech (CUNY)
# =============================================================================
#
# WHAT IT DOES
#   The page now says when it was made and by whom: a new line shows the date,
#   the time, the time zone and the user name of whoever ran the script.
#
# HOW IT WORKS
#   1. What changed from stage 5: two new constants, CURRENT_TIME and TIMESTAMP,
#      and one new line in the page, `<p>$TIMESTAMP</p>`.
#   2. `CURRENT_TIME="$(date +"%x %r %Z")"` uses command substitution: bash runs
#      the command inside $( ) first and puts its output in that place. So
#      CURRENT_TIME holds whatever date printed.
#   3. `+"%x %r %Z"` tells date what to print: %x the date, %r the time with AM or
#      PM, %Z the time zone. The quotes inside $( ) start fresh, so they do not
#      close the double quotes around the whole value.
#   4. `TIMESTAMP="Generated $CURRENT_TIME, by $USER"` builds one value from
#      another constant and from $USER, your login name (set when you log in).
#   5. Order matters: each name is assigned on a line above the line that uses it.
#   6. `<p> ... </p>` is a paragraph in HTML.
#   7. date runs once, when the script starts, so every run shows a new time.
#
# NEW IN THIS SCRIPT
#   $(command)      command substitution: replaced by the command's output
#   date +FORMAT    prints the date and time in the format you give
#   $USER           the login name of the user who ran the script
#   <p> ... </p>    a paragraph in a web page
#
# RUN IT
#   chmod u+x book_06_sys_info_page.sh
#   ./book_06_sys_info_page.sh
#
# OUTPUT
#   On our test computer (name linuxbox, user student); your name, date and time differ:
#   <html>
#           <head>
#                   <title>System Information Report For linuxbox</title>
#           </head>
#           <body>
#                   <h1>System Information Report For linuxbox</h1>
#                   <p>Generated MM/DD/YY HH:MM:SS AM EDT, by student</p>
#           </body>
#   </html>
#   %x prints the date in the style of the computer's language setting (its
#   locale). Ours was set to C, which gives a two-digit year; a computer set to
#   US English (en_US) prints the year with four digits.
#
# TRY THIS
#   - Run the script twice, a few seconds apart. Which line of the page changes?
#   - At the prompt, run date +"%x %r %Z", then date +%Y and date +%H:%M. What does
#     each part of the format print?
#   - In a copy, misspell one use: <p>$TIMESTMP</p>. What prints, and why does
#     bash not complain?
#
# Below the line: the book's code, unchanged (TLCL is licensed CC BY-NC-ND 3.0;
# see LICENSE.md).
# ---------------------------------------------------------------------------

# Program to output a system information page

TITLE="System Information Report For $HOSTNAME"
CURRENT_TIME="$(date +"%x %r %Z")"
TIMESTAMP="Generated $CURRENT_TIME, by $USER"

echo "<html>
        <head>
                <title>$TITLE</title>
        </head>
        <body>
                <h1>$TITLE</h1>
                <p>$TIMESTAMP</p>
        </body>
</html>"
