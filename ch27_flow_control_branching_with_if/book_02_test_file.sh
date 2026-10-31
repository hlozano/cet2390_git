#!/bin/bash
# =============================================================================
# CET 2390 Operating Systems Laboratory: a textbook script, explained
# Script:   test-file, from The Linux Command Line (TLCL 19.01), chapter 27,
#           "File Expressions"
# Code:     William Shotts. Explanations: Prof. Hernan Lozano, CityTech (CUNY)
# =============================================================================
#
# WHAT IT DOES
#   Asks a series of questions about one pathname, ~/.bashrc (your shell's
#   settings file): does it exist, is it a regular file or a directory, and
#   may you read it, write it and execute it? It prints one line for each
#   "yes", and ends with exit status 1 if the file does not exist.
#
# HOW IT WORKS
#   1. `FILE=~/.bashrc` stores the pathname. The ~ is not in quotes, so bash
#      expands it to your home folder: FILE holds /home/yourname/.bashrc.
#   2. `if [ -e "$FILE" ]; then` asks the first question: does it exist? All
#      the other tests are nested inside this if (written inside its then
#      part), so they run only for a file that exists.
#   3. Five small if statements follow, one question each: `-f` (a regular
#      file?), `-d` (a directory?), `-r` (may you read it?), `-w` (may you
#      write it?) and `-x` (may you execute it, or, for a directory, enter and
#      search it?). None has an else: when a test is false, nothing prints.
#   4. `"$FILE"` is in double quotes in every test. That is a defense: if FILE
#      were ever empty, an unquoted `[ -e $FILE ]` would shrink to `[ -e ]`,
#      which test reads as "is the text -e not empty?" and answers true.
#   5. The `else` belongs to the first if. When the file does not exist, the
#      script prints "... does not exist", and `exit 1` ends the script at once
#      with exit status 1, which tells whoever ran it that it failed.
#   6. `exit` on the last line, with no number, ends the script with the
#      status of the last command that ran (here 0). It is a formality: a
#      script that "runs off the end" does the same.
#
# NEW IN THIS SCRIPT
#   file expressions   tests about a file (each is false if it does not exist)
#     -e file            the file exists (any kind)
#     -f file            it is a regular file (not a directory or a device)
#     -d file            it is a directory
#     -r / -w / -x file  you may read / write / execute it (-x on a directory:
#                        you may enter and search it)
#   nested if          an if written inside another if's then or else lines
#   exit N             ends the script now, with exit status N
#   exit               ends the script with the status of the last command
#
# RUN IT
#   chmod u+x book_02_test_file.sh
#   ./book_02_test_file.sh
#   echo $?
#
# OUTPUT
#   /home/student/.bashrc is a regular file.
#   /home/student/.bashrc is readable.
#   /home/student/.bashrc is writable.
#   0
#   (Run by a user named student; you will see your own home folder.)
#
# TRY THIS
#   - Copy the script (cp book_02_test_file.sh try.sh). In the copy, change
#     FILE=~/.bashrc to FILE=/etc. Predict the lines it prints, then run
#     ./try.sh. Which two questions get no line, and why?
#   - Try FILE=/etc/shadow (the system's file of password hashes) and then
#     FILE=/nowhere. For each, predict the output and what echo $? shows.
#   - Try FILE="~/.bashrc" (with the quotes). Why does the script now say the
#     file does not exist? (Hint: does bash expand ~ inside quotes?)
#
# Below the line: the book's code, unchanged (TLCL is licensed CC BY-NC-ND 3.0;
# see LICENSE.md).
# ---------------------------------------------------------------------------

# test-file: Evaluate the status of a file

FILE=~/.bashrc

if [ -e "$FILE" ]; then
    if [ -f "$FILE" ]; then
        echo "$FILE is a regular file."
    fi
    if [ -d "$FILE" ]; then
        echo "$FILE is a directory."
    fi
    if [ -r "$FILE" ]; then
        echo "$FILE is readable."
    fi
    if [ -w "$FILE" ]; then
        echo "$FILE is writable."
    fi
    if [ -x "$FILE" ]; then
        echo "$FILE is executable/searchable."
    fi
else
    echo "$FILE does not exist"
    exit 1
fi

exit
