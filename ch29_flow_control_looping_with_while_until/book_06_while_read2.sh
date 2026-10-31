#!/bin/bash
# =============================================================================
# CET 2390 Operating Systems Laboratory: a textbook script, explained
# Script:   while-read2, from The Linux Command Line (TLCL 19.01), chapter 29,
#           "Reading Files with Loops"
# Code:     William Shotts. Explanations: Prof. Hernan Lozano, CityTech (CUNY)
# =============================================================================
#
# WHAT IT DOES
#   The same loop as book_05_while_read.sh, fed by a pipe instead of a
#   redirection: sort puts the lines of distros.txt in order, by name and
#   then by version number, and the loop prints them. Like book_05, it needs
#   a file named distros.txt in the current folder (see RUN IT).
#
# HOW IT WORKS
#   1. `sort -k 1,1 -k 2n distros.txt` sorts the file's lines. -k 1,1 sorts by
#      field 1 only (the name). -k 2n then sorts lines with the same name by
#      field 2 (the version) as a number, so Fedora 9 comes before Fedora 10
#      (sorted as text, "10" would come first, because 1 comes before 9).
#   2. `| while read distro version release; do` is a pipe (chapter 6): it
#      sends sort's output into the loop, so each read takes the next sorted
#      line. That is why there is no < distros.txt after done.
#   3. The body is the same printf as in book_05.
#   4. The catch: bash runs every part of a pipeline in a subshell, a copy of
#      the shell. Here the whole loop runs in that copy, so any variable the
#      loop sets is lost when the loop ends. This script sets nothing it
#      needs afterwards, so it works; a counter would not survive (TRY THIS).
#      The same rule is why you cannot pipe into read (chapter 28).
#
# NEW IN THIS SCRIPT
#   cmd | while read ...; do ... done   feed a loop from a pipe
#   sort -k 1,1 -k 2n                   sort by field 1, then field 2 as a
#                                       number
#   subshell                            a copy of the shell; its variables
#                                       vanish when it ends
#
# RUN IT
#   As for book_05, in a practice folder with a copy named distros.txt:
#   mkdir -p ~/playground
#   cp book_distros.txt ~/playground/distros.txt
#   cp book_06_while_read2.sh ~/playground/
#   cd ~/playground
#   ./book_06_while_read2.sh
#
# OUTPUT
#   The same 16 lines as book_05, now sorted: the six Fedora lines (versions
#   5 to 10), then SUSE (10.1, 10.2, 10.3, 11.0), then Ubuntu (6.06 to 8.10).
#   The first lines, with the release date column written as <date>:
#     Distro: Fedora  Version: 5      Released: <date>
#     Distro: Fedora  Version: 6      Released: <date>
#     Distro: Fedora  Version: 7      Released: <date>
#     Distro: Fedora  Version: 8      Released: <date>
#     Distro: Fedora  Version: 9      Released: <date>
#     Distro: Fedora  Version: 10     Released: <date>
#     Distro: SUSE    Version: 10.1   Released: <date>
#   Without distros.txt in the current folder, sort reports
#   "sort: cannot read: distros.txt: No such file or directory". The script
#   still ends with status 0: a pipeline's status is that of its last part,
#   the loop, and the loop simply found no lines.
#
# TRY THIS
#   - In a copy, add count=0 before the pipeline, count=$((count + 1)) in the
#     loop, and echo "$count lines" after done. It prints 0 lines. Do the same
#     in book_05 (16 lines) and explain the difference.
#   - Remove -k 2n from your copy. Where does Fedora 10 go now, and why?
#   - Change the sort to sort -k 2n distros.txt (version only). Which lines
#     end up next to each other?
#
# Below the line: the book's code, unchanged (TLCL is licensed CC BY-NC-ND 3.0;
# see LICENSE.md).
# ---------------------------------------------------------------------------

# while-read2: read lines from a file

sort -k 1,1 -k 2n distros.txt | while read distro version release; do

    printf "Distro: %s\tVersion: %s\tReleased: %s\n" \
        "$distro" \
        "$version" \
        "$release"
done
