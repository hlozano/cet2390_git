#!/bin/bash
# =============================================================================
# CET 2390 Operating Systems Laboratory: a textbook script, explained
# Script:   read-secret, from The Linux Command Line (TLCL 19.01), chapter 28,
#           "Options"
# Code:     William Shotts. Explanations: Prof. Hernan Lozano, CityTech (CUNY)
# =============================================================================
#
# WHAT IT DOES
#   Asks for a passphrase without showing what you type, and gives up if you
#   take longer than ten seconds. It then prints the passphrase, which a real
#   program would never do: it is here so you can see what read stored. Type
#   a made-up phrase, never a real password.
#
# HOW IT WORKS
#   1. `read -t 10 -sp "Enter secret passphrase > " secret_pass` uses three
#      options: -t 10 stops waiting after 10 seconds, -s (silent) hides the
#      typing, and -p prints the prompt. -sp is -s and -p written together,
#      as ls -la is -l and -a. -p must come last because the text right
#      after it is its prompt.
#   2. The read is the test of the if. Like every command, read returns an
#      exit status: 0 when a line arrived, non-zero when the time ran out or
#      the input ended. So the then part runs on success, the else part on
#      failure.
#   3. `echo -e "\nSecret passphrase = '$secret_pass'"`: -s hides even the
#      Enter you press, so the cursor is still on the prompt line. -e makes
#      echo turn \n into a new line, which moves the output down first.
#   4. The else part sends "Input timed out" to standard error and ends the
#      script with exit 1.
#
# NEW IN THIS SCRIPT
#   read -s       silent: what you type does not appear on the screen
#   read -t N     give up after N seconds; read then returns a non-zero status
#   -sp           two options in one: -s plus -p (the option that takes a
#                 value goes last)
#   if read ...   read used as the test of an if: success means a line arrived
#   echo -e       turn \n into a new line (and \t into a tab)
#
# RUN IT
#   chmod u+x book_06_read_secret.sh
#   ./book_06_read_secret.sh                 type open sesame, then Enter
#   ./book_06_read_secret.sh                 again, and wait 10 seconds
#   echo $?
#
# OUTPUT
#   Typed at the keyboard: nothing appears while you type open sesame, then
#     Enter secret passphrase >
#     Secret passphrase = 'open sesame'
#   Waiting ten seconds without typing:
#     Enter secret passphrase >
#     Input timed out
#   and echo $? prints 1. (read itself returned 142, its code for a timeout;
#   the script turns every failure into exit 1.)
#   Fed with ./book_06_read_secret.sh <<< "open sesame" there is no prompt
#   (the input is not a terminal), so the output is a blank line (from the
#   \n) and then Secret passphrase = 'open sesame'.
#
# TRY THIS
#   - Run it and press Ctrl-d (end of input) instead of typing. What does it
#     print? Is the message true? (read fails at end of input too, and the
#     script cannot tell that apart from a timeout.)
#   - In a copy, change -sp to -ps. Run it: bash reports
#     read: `Enter secret passphrase > ': not a valid identifier. Why?
#   - In a copy, remove the \n from the first echo. Where does the output
#     start now?
#
# Below the line: the book's code, unchanged (TLCL is licensed CC BY-NC-ND 3.0;
# see LICENSE.md).
# ---------------------------------------------------------------------------

# read-secret: input a secret passphrase

if read -t 10 -sp "Enter secret passphrase > " secret_pass; then
    echo -e "\nSecret passphrase = '$secret_pass'"
else
    echo -e "\nInput timed out" >&2
    exit 1
fi
