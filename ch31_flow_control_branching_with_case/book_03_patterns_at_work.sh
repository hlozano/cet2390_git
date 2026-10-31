#!/bin/bash
# =============================================================================
# CET 2390 Operating Systems Laboratory: a textbook script, explained
# Script:   an example with no name ("Here is an example of patterns at work"),
#           from The Linux Command Line (TLCL 19.01), chapter 31, "Patterns"
# Code:     William Shotts. Explanations: Prof. Hernan Lozano, CityTech (CUNY)
# =============================================================================
#
# WHAT IT DOES
#   Reads one word and tells you which of five patterns it fits first: a
#   single letter, A, B or C followed by a digit, any three characters, a word
#   ending in .txt, or something else.
#
# HOW IT WORKS
#   1. `read -p "enter word > "` stores the line you type in REPLY.
#   2. `case "$REPLY" in` compares REPLY with five patterns, top down, and the
#      first one that matches wins. The patterns are the wildcards you used
#      with ls in chapter 4 (ls *.txt), applied here to a word instead of to
#      file names. They are not regular expressions.
#   3. `[[:alpha:]])` matches exactly one alphabetic character (one letter).
#      The outer brackets mean "one character from this set"; the inner
#      [:alpha:] is the name of the set. Both pairs are needed.
#   4. `[ABC][0-9])` matches exactly two characters: a capital A, B or C, then
#      one digit. [ABC] lists the allowed characters; [0-9] is a range.
#   5. `???)` matches any three characters: each ? stands for exactly one
#      character of any kind, so abc, txt, 7-A and even "a b" fit.
#   6. `*.txt)` matches any word that ends in .txt: * stands for any text,
#      even none, so .txt alone fits too.
#   7. `*)` matches everything else, including an empty answer (Enter alone).
#   Each branch fits on one line: the pattern, one echo, and `;;`.
#
# NEW IN THIS SCRIPT
#   [[:alpha:]]   one letter (also [[:digit:]], [[:upper:]], [[:lower:]] ...)
#   [ABC]         one character from the list A, B, C
#   [0-9]         one character from the range 0 to 9
#   ?             exactly one character of any kind
#   *             any text, including none
#   About ranges: in bash 5 (Linux Mint and Ubuntu), [A-Z] in a case pattern
#   matches only the 26 capital letters. Older guides warn that it may also
#   match small letters, depending on the language settings (the locale);
#   bash 5 turned that behavior off by default. The named classes, such as
#   [[:upper:]], mean the same thing in every tool, so they stay the safer
#   habit.
#
# RUN IT
#   chmod u+x book_03_patterns_at_work.sh
#   ./book_03_patterns_at_work.sh
#   It reads one word and ends; run it once for each word you want to test.
#
# OUTPUT
#   Five runs; each time you typed the word shown after the prompt:
#   enter word > k
#   is a single alphabetic character.
#   enter word > B7
#   is A, B, or C followed by a digit.
#   enter word > abc
#   is three characters long.
#   enter word > notes.txt
#   is a word ending in '.txt'
#   enter word > hello
#   is something else.
#
# TRY THIS
#   - Answer b7 (small b). Which pattern fails, and why does *) answer?
#   - Answer a b (a, a space, b). Is it three characters? Predict, then run.
#   - In a copy, move the *) line to the top of the case and answer k. Why
#     does every word now get "is something else."?
#   - In a copy, change [ABC] to [A-Z]. Answer b7, then Z9. Does the range
#     include small letters in bash 5?
#
# Below the line: the book's code, unchanged (TLCL is licensed CC BY-NC-ND 3.0;
# see LICENSE.md).
# ---------------------------------------------------------------------------

read -p "enter word > "

case "$REPLY" in
    [[:alpha:]])  echo "is a single alphabetic character." ;;
    [ABC][0-9])   echo "is A, B, or C followed by a digit." ;;
    ???)          echo "is three characters long." ;;
    *.txt)        echo "is a word ending in '.txt'" ;;
    *)            echo "is something else." ;;
esac
