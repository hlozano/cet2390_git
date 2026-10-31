#!/bin/bash
# =============================================================================
# CET 2390 Operating Systems Laboratory: a textbook script, explained
# Script:   sys_info_page (chapter 26, first listing), from The Linux Command Line
#           (TLCL 19.01), chapter 26, "Shell Functions"
# Code:     William Shotts. Explanations: Prof. Hernan Lozano, CityTech (CUNY)
# =============================================================================
#
# WHAT IT DOES
#   The report from the end of chapter 25, with three new lines in the page that
#   plan three new sections: system uptime, disk space and home space. The
#   commands they call do not exist yet, so running it prints three
#   "command not found" errors, on purpose.
#
# HOW IT WORKS
#   1. Top-down design: write the job as a few big steps, then break each step
#      that is still vague into smaller ones. The book lists the steps this script
#      already does (open the page, set the title, ..., print the timestamp,
#      close the body, close the page) and plans three more after the timestamp.
#   2. The three constants and the here document are stage 7 of chapter 25,
#      unchanged (`cat << _EOF_` prints every line up to `_EOF_`).
#   3. What changed: three lines inside the here document, after
#      `<p>$TIMESTAMP</p>`: `$(report_uptime)`, `$(report_disk_space)` and
#      `$(report_home_space)`. Each is a command substitution: bash runs the
#      command named inside $( ) and puts its output in the page at that spot.
#   4. No commands with those names exist yet. For each one bash prints
#      report_uptime: command not found (and so on) on the screen, and puts
#      nothing in the page: three lines that hold only their indent spaces.
#   5. The errors are expected: they list exactly what is left to write. The
#      book's plan is to write the three commands inside the script, as shell
#      functions (book_03_sys_info_page_stubs.sh).
#   6. All three messages name the line of `cat << _EOF_`, where the here
#      document starts, not the lines inside it.
#
# NEW IN THIS SCRIPT
#   top-down design   plan a job as big steps, then refine each step until it is
#                     a command you know how to write
#   $(name)           a planned step, written before the command exists
#
# RUN IT
#   chmod u+x book_01_sys_info_page.sh
#   ./book_01_sys_info_page.sh
#
# OUTPUT
#   On our test computer (name linuxbox, user student); your name, date and time differ.
#   The three errors come first, then the page:
#   ./book_01_sys_info_page.sh: line 81: report_uptime: command not found
#   ./book_01_sys_info_page.sh: line 81: report_disk_space: command not found
#   ./book_01_sys_info_page.sh: line 81: report_home_space: command not found
#   <html>
#           <head>
#                   <title>System Information Report For linuxbox</title>
#           </head>
#           <body>
#                   <h1>System Information Report For linuxbox</h1>
#                   <p>Generated MM/DD/YY HH:MM:SS AM EDT, by student</p>
#
#
#
#           </body>
#   </html>
#
# TRY THIS
#   - Save the page: ./book_01_sys_info_page.sh > ~/playground/page.html (make the
#     folder first with mkdir -p ~/playground). Do the three errors go into the
#     file or onto the screen?
#   - At the prompt, type uptime, then report_uptime. Which one is a real command?
#   - Write the steps of a job you know (making a sandwich) as five plain lines,
#     then break one step into smaller steps. When would you stop?
#
# Below the line: the book's code, unchanged (TLCL is licensed CC BY-NC-ND 3.0;
# see LICENSE.md).
# ---------------------------------------------------------------------------

# Program to output a system information page

TITLE="System Information Report For $HOSTNAME"
CURRENT_TIME="$(date +"%x %r %Z")"
TIMESTAMP="Generated $CURRENT_TIME, by $USER"

cat << _EOF_
<html>
        <head>
                <title>$TITLE</title>
        </head>
        <body>
                <h1>$TITLE</h1>
                <p>$TIMESTAMP</p>
                $(report_uptime)
                $(report_disk_space)
                $(report_home_space)
        </body>
</html>
_EOF_
