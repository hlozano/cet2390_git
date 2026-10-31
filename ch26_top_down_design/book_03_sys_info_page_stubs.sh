#!/bin/bash
# =============================================================================
# CET 2390 Operating Systems Laboratory: a textbook script, explained
# Script:   sys_info_page with stubs, from The Linux Command Line (TLCL 19.01),
#           chapter 26, "Shell Functions" (book name: sys_info_page)
# Code:     William Shotts. Explanations: Prof. Hernan Lozano, CityTech (CUNY)
# =============================================================================
#
# WHAT IT DOES
#   The three commands planned in book_01_sys_info_page.sh now exist, as shell
#   functions that do nothing but return. The script runs without errors again,
#   but the three new sections of the page are still empty.
#
# HOW IT WORKS
#   1. What changed from book_01: three function definitions, report_uptime,
#      report_disk_space and report_home_space, placed above the here document
#      that calls them. They use the simpler form, `name () {` ... `}`.
#   2. Each body is only `return`. A function must contain at least one command,
#      and return is enough. Functions like these, written now and filled in
#      later, are called stubs.
#   3. When cat's here document reaches `$(report_uptime)`, bash runs the
#      function. It prints nothing, so the command substitution puts nothing in
#      the page: the line keeps only its indent spaces.
#   4. The command not found errors are gone, because the three names are defined
#      before the here document uses them.
#   5. Also changed: the here document's indents are now 4 and 8 spaces, as the
#      book prints this listing.
#   6. The page cannot tell you whether the functions ran: an empty line looks the
#      same either way. book_05_sys_info_page_feedback.sh fixes that.
#
# NEW IN THIS SCRIPT
#   stub            a function that holds a place for code you will write later
#   name () { ... } the preferred way to define a function; the name follows the
#                   rules for variable names, and the parentheses stay empty
#
# RUN IT
#   chmod u+x book_03_sys_info_page_stubs.sh
#   ./book_03_sys_info_page_stubs.sh
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
#
#
#
#       </body>
#   </html>
#
# TRY THIS
#   - In a copy, misspell one definition (report_uptim () {). Run it. Which error
#     comes back, and why?
#   - Delete return from one stub, so its braces hold nothing. What does bash say?
#   - Add echo "uptime goes here" above return in report_uptime. Where does the
#     line appear in the page?
#
# Below the line: the book's code, unchanged (TLCL is licensed CC BY-NC-ND 3.0;
# see LICENSE.md).
# ---------------------------------------------------------------------------

# Program to output a system information page

TITLE="System Information Report For $HOSTNAME"
CURRENT_TIME="$(date +"%x %r %Z")"
TIMESTAMP="Generated $CURRENT_TIME, by $USER"

report_uptime () {
    return
}

report_disk_space () {
    return
}

report_home_space () {
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
