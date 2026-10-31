#!/bin/bash
# =============================================================================
# CET 2390 Operating Systems Laboratory: a textbook script, explained
# Script:   sys_info_page (stage 5 of 7), from The Linux Command Line (TLCL 19.01),
#           chapter 25, "Variables and Constants", second listing
# Code:     William Shotts. Explanations: Prof. Hernan Lozano, CityTech (CUNY)
# =============================================================================
#
# WHAT IT DOES
#   The title becomes a constant named TITLE, and it now ends with the network
#   name of the computer the script runs on.
#
# HOW IT WORKS
#   1. What changed from stage 4: the name title became TITLE (in the assignment
#      and in both uses), and its value gained the words For $HOSTNAME.
#   2. A constant is a variable whose value the script never changes. Bash treats
#      both the same way; the habit is UPPERCASE names for constants and lowercase
#      names for variables, so a reader can tell them apart.
#   3. HOSTNAME is a variable bash sets by itself when it starts: the computer's
#      network name. Inside the double quotes of the assignment, $HOSTNAME is
#      expanded, so TITLE holds System Information Report For, then the name.
#      A value may contain other expansions, like this variable.
#   4. To make bash enforce a constant, declare it read-only:
#      declare -r TITLE="Page Title" (readonly TITLE="Page Title" does the same).
#      Any later assignment to TITLE then fails with TITLE: readonly variable.
#      The book notes that this is rarely used.
#
# NEW IN THIS SCRIPT
#   constant         a variable that never changes; named in UPPERCASE by habit
#   $HOSTNAME        the computer's network name, set by bash
#   declare -r NAME  makes NAME read-only (a true constant)
#
# RUN IT
#   chmod u+x book_05_sys_info_page.sh
#   ./book_05_sys_info_page.sh
#
# OUTPUT
#   On our test computer, named linuxbox (yours shows its own name):
#   <html>
#           <head>
#                   <title>System Information Report For linuxbox</title>
#           </head>
#           <body>
#                   <h1>System Information Report For linuxbox</h1>
#           </body>
#   </html>
#
# TRY THIS
#   - Run echo $HOSTNAME at the prompt. Is it the name in your page?
#   - At the prompt, type declare -r PI=3.1415 and then PI=3. What does bash say?
#     (Use PI, not TITLE: a read-only name stays locked until you close the
#     terminal.)
#   - In a copy, replace $HOSTNAME with $USER. Whose name appears now?
#
# Below the line: the book's code, unchanged (TLCL is licensed CC BY-NC-ND 3.0;
# see LICENSE.md).
# ---------------------------------------------------------------------------

# Program to output a system information page

TITLE="System Information Report For $HOSTNAME"

echo "<html>
        <head>
                <title>$TITLE</title>
        </head>
        <body>
                <h1>$TITLE</h1>
        </body>
</html>"
