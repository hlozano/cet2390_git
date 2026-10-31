#!/bin/bash
# =============================================================================
# CET 2390 Operating Systems Laboratory: a textbook script, explained
# Script:   while-read, from The Linux Command Line (TLCL 19.01), chapter 29,
#           "Reading Files with Loops"
# Code:     William Shotts. Explanations: Prof. Hernan Lozano, CityTech (CUNY)
# =============================================================================
#
# WHAT IT DOES
#   Reads the file distros.txt one line at a time and prints each line with
#   labels: the name of a Linux distribution, its version, and its release
#   date. It needs a file named distros.txt in the current folder: this
#   folder holds the book's data as book_distros.txt, and RUN IT shows how to
#   make the copy.
#
# HOW IT WORKS
#   1. `while read distro version release; do` uses read as the loop's test.
#      Each pass, read takes the next line of input and splits it at the tabs
#      (spaces and tabs both separate fields) into three variables: the name,
#      the version, and the release date.
#   2. `done < distros.txt`: the < after done is a redirection. It makes the
#      file the standard input of the whole loop, so every read inside it
#      takes the next line of that file instead of waiting for the keyboard.
#      The file is opened once, and read moves through it line by line.
#   3. The body prints the three fields. printf (chapter 21 of the book) is a
#      more precise echo: each %s in the first string is replaced by the next
#      argument, \t prints a tab and \n a new line. The \ at the end of a line
#      joins it to the next, so one long command fits on four lines.
#   4. After the last line, read finds nothing more (end of file) and returns
#      a non-zero status. while sees the failure and the loop ends.
#
# NEW IN THIS SCRIPT
#   while read a b c; do ... done < file   read a file one line per pass
#   < file after done   feed the whole loop from the file
#   printf "%s\t%s\n" x y   print x, a tab, y, a new line
#
# RUN IT
#   The script reads distros.txt from the folder you run it in. Work on
#   copies in a practice folder, so the chapter folder stays as it is:
#   mkdir -p ~/playground
#   cp book_distros.txt ~/playground/distros.txt
#   cp book_05_while_read.sh ~/playground/
#   cd ~/playground
#   ./book_05_while_read.sh
#
# OUTPUT
#   16 lines, one for each line of the file, in the order of the file. The
#   first four are below. The Released field shows the date from the release
#   date column of the file; here it is written as <date>. The terminal turns
#   each \t into spaces up to the next tab stop, so the columns line up:
#     Distro: SUSE    Version: 10.2   Released: <date>
#     Distro: Fedora  Version: 10     Released: <date>
#     Distro: SUSE    Version: 11.0   Released: <date>
#     Distro: Ubuntu  Version: 8.04   Released: <date>
#   Without distros.txt in the current folder, bash reports
#   "distros.txt: No such file or directory" and prints nothing else.
#
# TRY THIS
#   - In a copy, add count=0 before the loop, count=$((count + 1)) inside
#     it, and echo "$count lines" after done. What does it print?
#   - Run cat distros.txt and compare it with the output. Which line of the
#     file does read take on the first pass, and on the last?
#   - In a copy, change the read line to read distro rest and print $rest.
#     What lands in rest? (The last variable gets the rest of the line.)
#
# Below the line: the book's code, unchanged (TLCL is licensed CC BY-NC-ND 3.0;
# see LICENSE.md).
# ---------------------------------------------------------------------------

# while-read: read lines from a file

while read distro version release; do
    printf "Distro: %s\tVersion: %s\tReleased: %s\n" \
        "$distro" \
        "$version" \
        "$release"
done < distros.txt
