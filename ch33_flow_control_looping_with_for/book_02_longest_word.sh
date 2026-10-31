#!/bin/bash
# =============================================================================
# CET 2390 Operating Systems Laboratory: a textbook script, explained
# Script:   longest-word, from The Linux Command Line (TLCL 19.01), chapter 33,
#           "for: Traditional Shell Form"
# Code:     William Shotts. Explanations: Prof. Hernan Lozano, CityTech (CUNY)
# =============================================================================
#
# WHAT IT DOES
#   For each file you name after the script's name, finds the longest "word"
#   in the file and prints it with its length. A word here is anything
#   between spaces, tabs or line breaks.
#
# HOW IT WORKS
#   1. `while [[ -n "$1" ]]; do`: $1 is the first word typed after the
#      script's name. -n is true while it is not empty, so the loop runs once
#      for each file name you typed.
#   2. `if [[ -r "$1" ]]; then`: -r is true when the file exists and you may
#      read it. Any other name is skipped without a message.
#   3. `max_word=` and `max_len=0` reset the record for each file: no word
#      yet, length 0.
#   4. `for i in $(strings "$1"); do`: `strings` prints the readable text in a
#      file (it was made for program files; on a text file it prints the
#      lines). `$( )` is command substitution: bash runs the command and puts
#      its output in its place. The $( ) has no quotes on purpose: bash then
#      splits the output into words at every space, tab and line break, and
#      for gets one word per pass. With quotes, the whole file would be one
#      single word.
#   5. `len="$(echo -n "$i" | wc -c)"` measures the word: echo -n prints it
#      with no line break, and the pipe | hands that text to wc -c, which
#      counts its characters (the pipe and wc are chapter 6).
#   6. `if (( len > max_len )); then` keeps the word when it is longer than
#      the record so far (chapter 27's arithmetic test). The test is >, not
#      >=, so among words of equal length the first one wins.
#   7. After the inner loop, `echo "$1: '$max_word' ($max_len characters)"`
#      prints the file name and the winner.
#   8. `shift` throws $1 away and moves every remaining word down one place,
#      so the next file name becomes $1. When none is left, $1 is empty and
#      the while loop ends.
#   $1 and shift are positional parameters, chapter 32, which CET 2390 does
#   not teach: read them as explained above; you are not asked to write them.
#
# NEW IN THIS SCRIPT
#   $(command)        command substitution: replaced by the command's output
#   for i in $(...)   one pass per word of that output (unquoted on purpose)
#   strings FILE      prints the readable text in FILE (GNU binutils package)
#
# RUN IT
#   chmod u+x book_02_longest_word.sh
#   mkdir -p ~/playground
#   echo "The quick brown fox jumps over the lazy dog" > ~/playground/fox.txt
#   echo "one two three four five six seven" > ~/playground/count.txt
#   ./book_02_longest_word.sh ~/playground/fox.txt ~/playground/count.txt
#   The > after echo saves its line in a new file (redirection, chapter 6).
#
# OUTPUT
#   /home/student/playground/fox.txt: 'quick' (5 characters)
#   /home/student/playground/count.txt: 'three' (5 characters)
#   Your user name appears in place of student: bash replaces ~ with the path
#   of your home folder before the script starts. quick, brown and jumps all
#   have 5 letters; quick comes first, so it wins.
#
# TRY THIS
#   - Run it on its own file: ./book_02_longest_word.sh book_02_longest_word.sh
#     The winner is a line of 77 = signs from this header. Why does that count
#     as one word?
#   - Add a name that does not exist: ./book_02_longest_word.sh nosuch
#     ~/playground/fox.txt (all on one line). What happens to nosuch?
#   - In a copy, put double quotes around $(strings "$1") and run the copy on
#     fox.txt. What is the "longest word" now, and why?
#
# Below the line: the book's code, unchanged (TLCL is licensed CC BY-NC-ND 3.0;
# see LICENSE.md).
# ---------------------------------------------------------------------------

# longest-word: find longest string in a file

while [[ -n "$1" ]]; do
    if [[ -r "$1" ]]; then
        max_word=
        max_len=0
        for i in $(strings "$1"); do
            len="$(echo -n "$i" | wc -c)"
            if (( len > max_len )); then
                max_len="$len"
                max_word="$i"
            fi
        done
        echo "$1: '$max_word' ($max_len characters)"
    fi
    shift
done
