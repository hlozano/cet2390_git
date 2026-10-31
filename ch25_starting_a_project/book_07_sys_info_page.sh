#!/bin/bash
# =============================================================================
# CET 2390 Operating Systems Laboratory: a textbook script, explained
# Script:   sys_info_page (stage 7 of 7), from The Linux Command Line (TLCL 19.01),
#           chapter 25, "Here Documents", first listing
# Code:     William Shotts. Explanations: Prof. Hernan Lozano, CityTech (CUNY)
# =============================================================================
#
# WHAT IT DOES
#   Prints the same page as stage 6, now with cat and a here document instead of
#   echo. This is the last stage in chapter 25; chapter 26 starts from it.
#
# HOW IT WORKS
#   1. What changed from stage 6: `echo "` before <html> and the closing `"` after
#      </html> are gone. In their place, `cat << _EOF_` comes before the page and
#      a line holding only `_EOF_` comes after it.
#   2. `cat << _EOF_` starts a here document: bash takes every line after it, up
#      to the line that holds only _EOF_, and feeds that text to cat as its
#      standard input, as if you had typed it at the keyboard. cat prints what it
#      reads, so the page appears on the screen.
#   3. Variables and $( ) inside the block are still expanded, so $TITLE and
#      $TIMESTAMP are filled in exactly as they were with echo.
#   4. _EOF_ (End Of File) is the token that marks the end. Any word works if both
#      ends match. The closing token must be alone on its line, at the left edge,
#      with nothing after it, not even a space.
#   5. The advantage over echo: inside a here document, single and double quotes
#      are ordinary characters, so the page may contain them freely. Only $ and \
#      keep a special meaning (\$ prints a plain $).
#   6. The page itself is identical to stage 6.
#
# NEW IN THIS SCRIPT
#   command << token   a here document: the lines up to token become the
#                      command's standard input
#   _EOF_              the usual token; the closing one stands alone on its line
#   standard input     where a command reads its input; normally the keyboard
#
# RUN IT
#   chmod u+x book_07_sys_info_page.sh
#   ./book_07_sys_info_page.sh
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
#
# TRY THIS
#   - In a copy, add the line <p>She said "it works"</p> inside the block. Are the
#     quotes printed? What would the same line have done inside stage 6's echo?
#   - Put one space after the closing _EOF_ and run it. Read the warning: which
#     extra line did cat print at the end?
#   - Change both _EOF_ tokens to END. Does the script still work?
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
        </body>
</html>
_EOF_
