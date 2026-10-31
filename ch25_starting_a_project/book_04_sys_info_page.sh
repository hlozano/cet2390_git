#!/bin/bash
# =============================================================================
# CET 2390 Operating Systems Laboratory: a textbook script, explained
# Script:   sys_info_page (stage 4 of 7), from The Linux Command Line (TLCL 19.01),
#           chapter 25, "Variables and Constants", first listing
# Code:     William Shotts. Explanations: Prof. Hernan Lozano, CityTech (CUNY)
# =============================================================================
#
# WHAT IT DOES
#   Prints the same page as stage 3, but the title is now stored once, in a
#   variable named title, and used twice.
#
# HOW IT WORKS
#   1. What changed from stage 3: a new line before the echo,
#      `title="System Information Report"`, and the two copies of the words in
#      the page became `$title`.
#   2. `title="System Information Report"` is an assignment. It creates a variable
#      (a name that holds a value) called title and stores the text in it. There
#      is no space on either side of the =. The double quotes are needed because
#      the value contains spaces.
#   3. Inside the double-quoted string, bash replaces `$title` with the value
#      before echo runs. This is parameter expansion: echo never sees $title, only
#      the words System Information Report.
#   4. The page is the same as in stage 3, but changing the title now means
#      editing one line.
#   5. Bash has no declaration step: a variable exists from the moment you assign
#      it. A name that was never assigned expands to nothing, with no warning, so
#      spelling matters: a typo like $titel prints an empty heading.
#
# NEW IN THIS SCRIPT
#   variable      a name that holds a value; for bash every value is text
#   name=value    an assignment: no spaces around the =, quotes around spaces
#   $name         parameter expansion: bash puts the value in its place
#
# RUN IT
#   chmod u+x book_04_sys_info_page.sh
#   ./book_04_sys_info_page.sh
#
# OUTPUT
#   <html>
#           <head>
#                   <title>System Information Report</title>
#           </head>
#           <body>
#                   <h1>System Information Report</h1>
#           </body>
#   </html>
#
# TRY THIS
#   - In a copy, change the words in the title= line. How many lines of the script
#     did you edit, and how many lines of the page changed?
#   - Put spaces around the =: title = "System Information Report". Bash answers
#     title: command not found. Why does it think title is a command?
#   - Misspell one use: <h1>$titel</h1>. What prints in that line, and why is
#     there no error message?
#
# Below the line: the book's code, unchanged (TLCL is licensed CC BY-NC-ND 3.0;
# see LICENSE.md).
# ---------------------------------------------------------------------------

# Program to output a system information page

title="System Information Report"

echo "<html>
        <head>
                <title>$title</title>
        </head>
        <body>
                <h1>$title</h1>
        </body>
</html>"
