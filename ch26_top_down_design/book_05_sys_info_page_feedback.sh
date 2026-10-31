#!/bin/bash
# =============================================================================
# CET 2390 Operating Systems Laboratory: a textbook script, explained
# Script:   sys_info_page with feedback stubs, from The Linux Command Line
#           (TLCL 19.01), chapter 26, "Keep Scripts Running" (book name:
#           sys_info_page)
# Code:     William Shotts. Explanations: Prof. Hernan Lozano, CityTech (CUNY)
# Assembled: the book prints only the three new functions. Below the line they
#           replace the three empty functions of the stub listing from "Shell
#           Functions" (book_03_sys_info_page_stubs.sh); nothing else changed.
# =============================================================================
#
# WHAT IT DOES
#   The stubs now print their own names, so the page proves that each of the
#   three functions runs.
#
# HOW IT WORKS
#   1. What changed from book_03: each stub gets one line above its return, for
#      example `echo "Function report_uptime executed."`.
#   2. When the here document reaches `$(report_uptime)`, bash runs the function.
#      Its echo prints into the command substitution, so the message lands in
#      the page exactly where `$(report_uptime)` was written.
#   3. The three empty lines of book_03 become three messages: proof that the
#      script reaches all three functions, in the order the page calls them.
#   4. This is the habit the book recommends: keep the program in a state that
#      runs, test after every small change (then the last change is the only
#      suspect), and give each stub something to say, so the output shows how far
#      the script got.
#
# NEW IN THIS SCRIPT
#   feedback stub   a stub that prints its own name, so you can see it run
#
# RUN IT
#   chmod u+x book_05_sys_info_page_feedback.sh
#   ./book_05_sys_info_page_feedback.sh
#
# OUTPUT
#   On our test computer (name linuxbox, user student); your name, date and time differ:
#   <html>
#       <head>
#           <title>System Information Report For linuxbox</title>
#       </head>
#       <body>
#           <h1>System Information Report For linuxbox</h1>
#           <p>Generated MM/DD/YY HH:MM:SS AM EDT, by student</p>
#           Function report_uptime executed.
#           Function report_disk_space executed.
#           Function report_home_space executed.
#       </body>
#   </html>
#
# TRY THIS
#   - In a copy, add a fourth stub, report_users, that prints its own name the
#     same way, and add $(report_users) to the page. Does your message appear
#     where you expected?
#   - Swap the $(report_uptime) and $(report_home_space) lines in the page. Do the
#     messages follow the order of the definitions or the order of the calls?
#   - Save the page in ~/playground and open it in a browser. Why do the three
#     messages appear on one line there? (A browser joins lines of text.)
#
# Below the line: the book's code, unchanged (TLCL is licensed CC BY-NC-ND 3.0;
# see LICENSE.md).
# ---------------------------------------------------------------------------

# Program to output a system information page

TITLE="System Information Report For $HOSTNAME"
CURRENT_TIME="$(date +"%x %r %Z")"
TIMESTAMP="Generated $CURRENT_TIME, by $USER"

report_uptime () {
        echo "Function report_uptime executed."
        return
}

report_disk_space () {
        echo "Function report_disk_space executed."
        return
}

report_home_space () {
        echo "Function report_home_space executed."
        return
}
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
