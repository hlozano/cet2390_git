#!/bin/bash
# =============================================================================
# CET 2390 Operating Systems Laboratory: a textbook script, explained
# Script:   longest-word3, from The Linux Command Line (TLCL 19.01), chapter 34,
#           "String Operations"
# Code:     William Shotts. Explanations: Prof. Hernan Lozano, CityTech (CUNY)
# =============================================================================
#
# WHAT IT DOES
#   Finds the longest word in each file you name, like chapter 33's
#   longest-word2, but measures each word with the parameter expansion ${#j}
#   instead of running echo and wc. Same answers, much faster.
#
# HOW IT WORKS
#   1. `for i; do` walks the words typed after the script's name (one file
#      name per pass), as in longest-word2.
#   2. `[[ -r "$i" ]]` skips a file you cannot read; `max_word=` and
#      `max_len=0` reset the record for each file.
#   3. `for j in $(strings $i); do`: strings prints the readable text in the
#      file, and the unquoted $( ) splits it into words, one per pass. Note
#      that this listing writes $i without quotes, where longest-word2 had
#      "$i": a file name with a space in it is split in two (see TRY THIS).
#   4. `len="${#j}"` is what changed. ${#j} is the number of characters in
#      j's value, counted by bash itself. longest-word2 used
#      $(echo -n "$j" | wc -c), which starts a new shell and two programs for
#      every single word.
#   5. `(( len > max_len ))` keeps the longest word, and the echo after the
#      inner loop prints it, as before.
#   The book timed both versions on a list of the programs in /usr/bin: 3.618
#   seconds became 0.060. On a test machine with 905 names, it was 1.49
#   seconds against 0.013.
#
# NEW IN THIS SCRIPT
#   ${#name}   the length of name's value, in characters
#
# RUN IT
#   chmod u+x book_01_longest_word3.sh
#   mkdir -p ~/playground
#   echo "The quick brown fox jumps over the lazy dog" > ~/playground/fox.txt
#   echo "one two three four five six seven" > ~/playground/count.txt
#   ./book_01_longest_word3.sh ~/playground/fox.txt ~/playground/count.txt
#   The > after echo saves its line in a new file (redirection, chapter 6).
#
# OUTPUT
#   /home/student/playground/fox.txt: 'quick' (5 characters)
#   /home/student/playground/count.txt: 'three' (5 characters)
#   Your user name appears in place of student (~ is your home folder).
#
# TRY THIS
#   - At the prompt: word="Linux"; echo ${#word}. Then try a value with
#     spaces: title="CET 2390"; echo ${#title}. Do spaces count?
#   - Make a file whose name has a space:
#     echo "hello there" > ~/playground/"my notes.txt"
#     ./book_01_longest_word3.sh ~/playground/"my notes.txt"
#     strings complains about two files, my and notes.txt. Which unquoted
#     variable splits the name?
#   - Time both versions on a long file (the README shows how). Which is
#     faster, and by how much?
#
# Below the line: the book's code, unchanged (TLCL is licensed CC BY-NC-ND 3.0;
# see LICENSE.md).
# ---------------------------------------------------------------------------

# longest-word3: find longest string in a file

for i; do
    if [[ -r "$i" ]]; then
        max_word=
        max_len=0
        for j in $(strings $i); do
            len="${#j}"
            if (( len > max_len )); then
                max_len="$len"
                max_word="$j"
            fi
        done
        echo "$i: '$max_word' ($max_len characters)"
    fi
done
