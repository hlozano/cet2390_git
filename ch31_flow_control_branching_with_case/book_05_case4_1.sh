#!/bin/bash
# =============================================================================
# CET 2390 Operating Systems Laboratory: a textbook script, explained
# Script:   case4-1, from The Linux Command Line (TLCL 19.01), chapter 31,
#           "Performing Multiple Actions"
# Code:     William Shotts. Explanations: Prof. Hernan Lozano, CityTech (CUNY)
# =============================================================================
#
# WHAT IT DOES
#   Reads one keypress and names the kind of character it is: upper case,
#   lower case, a digit, punctuation, and so on. It reports only the first
#   kind that matches, even when the character belongs to several.
#
# HOW IT WORKS
#   1. `read -n 1 -p "Type a character > "`: -n 1 makes read return after one
#      character, so you do not press Enter. The character goes into REPLY.
#   2. `echo` with nothing after it prints an empty line. Without it, the
#      answer would start on the same line as the prompt, because you never
#      pressed Enter.
#   3. case tests REPLY against eight POSIX character classes, in this order:
#        [[:upper:]]    a capital letter
#        [[:lower:]]    a small letter
#        [[:alpha:]]    any letter
#        [[:digit:]]    a digit, 0 to 9
#        [[:graph:]]    any visible character (a space or a tab is not)
#        [[:punct:]]    a punctuation mark: ! , . ? and so on
#        [[:space:]]    whitespace: a space or a tab
#        [[:xdigit:]]   a hexadecimal digit: 0-9, a-f, A-F
#   4. Every branch ends in `;;`, so case stops at the first class that
#      matches. The letter a is lower case, alphabetic, visible and a
#      hexadecimal digit, but you only hear "lower case".
#   5. In `echo "'$REPLY' is lower case."` the single quotes sit inside double
#      quotes, so they print as plain characters around the key you typed.
#   Because the first match wins, three branches never run for a key on a US
#   keyboard: every letter is caught by upper or lower before alpha, every
#   punctuation mark by graph before punct, and every hexadecimal digit by
#   upper, lower or digit before xdigit. book_06_case4_2.sh fixes that.
#
# NEW IN THIS SCRIPT
#   read -n 1     return after one character, no Enter needed
#   [[:graph:]]   any visible character; also [[:punct:]], [[:space:]],
#                 [[:xdigit:]] (hexadecimal: base 16, digits 0-9 and a-f)
#
# RUN IT
#   chmod u+x book_05_case4_1.sh
#   ./book_05_case4_1.sh
#
# OUTPUT
#   You pressed the a key:
#   Type a character > a
#   'a' is lower case.
#
# TRY THIS
#   - Press 7, then !, then the space bar (one run each). Predict every line.
#   - Press Enter instead of a character. Why does nothing print? (What is in
#     REPLY, and which branch would catch it?)
#   - In a copy, move the [[:punct:]] line above [[:graph:]] and press ! again.
#
# Below the line: the book's code, unchanged (TLCL is licensed CC BY-NC-ND 3.0;
# see LICENSE.md).
# ---------------------------------------------------------------------------

# case4-1: test a character

read -n 1 -p "Type a character > "
echo
case "$REPLY" in
    [[:upper:]])    echo "'$REPLY' is upper case." ;;
    [[:lower:]])    echo "'$REPLY' is lower case." ;;
    [[:alpha:]])    echo "'$REPLY' is alphabetic." ;;
    [[:digit:]])    echo "'$REPLY' is a digit." ;;
    [[:graph:]])    echo "'$REPLY' is a visible character." ;;
    [[:punct:]])    echo "'$REPLY' is a punctuation symbol." ;;
    [[:space:]])    echo "'$REPLY' is a whitespace character." ;;
    [[:xdigit:]])   echo "'$REPLY' is a hexadecimal digit." ;;
esac
