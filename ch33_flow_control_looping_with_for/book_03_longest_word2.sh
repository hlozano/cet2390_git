#!/bin/bash
# =============================================================================
# CET 2390 Operating Systems Laboratory: a textbook script, explained
# Script:   longest-word2, from The Linux Command Line (TLCL 19.01), chapter 33,
#           "for: Traditional Shell Form"
# Code:     William Shotts. Explanations: Prof. Hernan Lozano, CityTech (CUNY)
# =============================================================================
#
# WHAT IT DOES
#   The same job as book_02_longest_word.sh: the longest word in each file you
#   name. The outer while loop is replaced by a shorter for loop.
#
# HOW IT WORKS
#   What changed from longest-word:
#   1. `for i; do` replaces `while [[ -n "$1" ]]; do`. A for with no "in
#      words" part walks the words typed after the script's name, one per
#      pass, so i holds each file name in turn.
#   2. Every "$1" became "$i", and `shift` is gone: for moves on to the next
#      name by itself.
#   3. The inner loop's variable is now j (`for j in $(strings "$i")`),
#      because i belongs to the outer loop.
#   What stayed the same: `[[ -r "$i" ]]` skips files you cannot read,
#   strings and the unquoted $( ) make the word list, `echo -n "$j" | wc -c`
#   measures each word, and `(( len > max_len ))` keeps the longest.
#
# NEW IN THIS SCRIPT
#   for i; do ... done   for with no list: one pass per word typed after the
#                        script's name (a chapter 32 form; read only)
#
# RUN IT
#   chmod u+x book_03_longest_word2.sh
#   ./book_03_longest_word2.sh ~/playground/fox.txt ~/playground/count.txt
#   (The two files are made in the RUN IT section of book_02_longest_word.sh.)
#
# OUTPUT
#   /home/student/playground/fox.txt: 'quick' (5 characters)
#   /home/student/playground/count.txt: 'three' (5 characters)
#   The same as longest-word, with your user name in place of student.
#
# TRY THIS
#   - Run it with no file names. What prints, and why?
#   - In a copy, rename the inner variable back to i (in `for j in`, and the
#     three $j after it). Run the copy on the same two files. The file names
#     in the output turn into dog and seven: why?
#   - Which version is easier to read, the while with shift or for i? Why?
#
# Below the line: the book's code, unchanged (TLCL is licensed CC BY-NC-ND 3.0;
# see LICENSE.md).
# ---------------------------------------------------------------------------

# longest-word2: find longest string in a file

for i; do
    if [[ -r "$i" ]]; then
        max_word=
        max_len=0
        for j in $(strings "$i"); do
            len="$(echo -n "$j" | wc -c)"
            if (( len > max_len )); then
                max_len="$len"
                max_word="$j"
            fi
        done
        echo "$i: '$max_word' ($max_len characters)"
    fi
done
