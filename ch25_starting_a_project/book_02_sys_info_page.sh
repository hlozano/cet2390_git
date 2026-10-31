#!/bin/bash
# =============================================================================
# CET 2390 Operating Systems Laboratory: a textbook script, explained
# Script:   sys_info_page (stage 2 of 7), from The Linux Command Line (TLCL 19.01),
#           chapter 25, "First Stage: Minimal Document", second listing
# Code:     William Shotts. Explanations: Prof. Hernan Lozano, CityTech (CUNY)
# =============================================================================
#
# WHAT IT DOES
#   Prints the same minimal web page as stage 1, but with one echo command instead
#   of eight.
#
# HOW IT WORKS
#   1. What changed from stage 1: the eight echo commands became one. The opening
#      double quote comes right after `echo` on the first line, before `<html>`,
#      and the closing double quote comes after `</html>` on the last line.
#   2. A quoted string may contain newlines. When bash meets the opening ", it
#      keeps reading, line after line, until it finds the closing ". Everything in
#      between, line breaks included, is one argument for echo, so one echo prints
#      the whole page.
#   3. Why it is better: adding a line to the page now means typing one line of
#      HTML inside the quotes, not a whole new echo command.
#   4. The only change in the output is the indentation, now 4 and 8 spaces.
#
# NEW IN THIS SCRIPT
#   "..." on many lines  a double-quoted string may run over several lines; bash
#                        reads on until it finds the closing quote
#   >                    PS2, the prompt bash shows at the command line while it
#                        waits for the rest of a command (here, the closing quote)
#
# RUN IT
#   chmod u+x book_02_sys_info_page.sh
#   ./book_02_sys_info_page.sh
#
# OUTPUT
#   <html>
#       <head>
#           <title>Page Title</title>
#       </head>
#       <body>
#           Page body.
#       </body>
#   </html>
#
# TRY THIS
#   - At the prompt, type echo "one and press Enter. Bash shows > and waits: type
#     two" and press Enter. What prints? (If you are ever stuck at the > prompt,
#     Ctrl-c gets you out.)
#   - In a copy, add the line <p>Made by me</p> after Page body., inside the
#     quotes. How many lines did you type to add one line to the page?
#   - In the copy, delete the closing " after </html> and run it. Bash answers
#     unexpected EOF while looking for matching `"': what was it looking for?
#
# Below the line: the book's code, unchanged (TLCL is licensed CC BY-NC-ND 3.0;
# see LICENSE.md).
# ---------------------------------------------------------------------------

# Program to output a system information page

echo "<html>
    <head>
        <title>Page Title</title>
    </head>
    <body>
        Page body.
    </body>
</html>"
