#!/bin/bash
# =============================================================================
# CET 2390 Operating Systems Laboratory: a textbook script, explained
# Script:   read-multiple, from The Linux Command Line (TLCL 19.01), chapter 28,
#           "read - Read Values from Standard Input"
# Code:     William Shotts. Explanations: Prof. Hernan Lozano, CityTech (CUNY)
# =============================================================================
#
# WHAT IT DOES
#   Reads one line into five variables and prints each one between single
#   quotes, so you can see exactly which word landed in which variable,
#   including the variables that stayed empty.
#
# HOW IT WORKS
#   1. `echo -n "Enter one or more values > "` prints the question.
#   2. `read var1 var2 var3 var4 var5` reads one line and splits it into words
#      at spaces and tabs (extra spaces between words do not matter). The
#      first word goes into var1, the second into var2, and so on.
#   3. Fewer words than variables: the variables left over are set to empty.
#      More words than variables: the last variable, var5, gets everything
#      that is left of the line, spaces and all.
#   4. The five echo lines print each variable inside '...'. Inside double
#      quotes the single quotes are ordinary characters; they only show where
#      each value starts and ends. '' means empty.
#
# NEW IN THIS SCRIPT
#   read a b c    split the line into words: the first word into a, the
#                 second into b, and the rest of the line into c
#
# RUN IT
#   chmod u+x book_03_read_multiple.sh
#   ./book_03_read_multiple.sh                    then type a b c d e f g
#   ./book_03_read_multiple.sh <<< "a b c d e"    five words, one per variable
#   ./book_03_read_multiple.sh <<< "a"            one word
#
# OUTPUT
#   Typed at the keyboard, seven words (the line after > is what you typed):
#     Enter one or more values > a b c d e f g
#     var1 = 'a'
#     var2 = 'b'
#     var3 = 'c'
#     var4 = 'd'
#     var5 = 'e f g'
#   Fed with <<< "a" (the question prints, your typing does not, so the first
#   line of the answer joins the question):
#     Enter one or more values > var1 = 'a'
#     var2 = ''
#     var3 = ''
#     var4 = ''
#     var5 = ''
#   With "a b c d e" each variable gets one letter, var1 = 'a' to var5 = 'e'.
#
# TRY THIS
#   - Before you run it, write down what var5 will hold for "one two three
#     four five six". Then run it and check.
#   - Type "   a     b   " (many spaces). How many variables are filled, and
#     do the spaces show up anywhere?
#   - In a copy, change the read line to read first last and the echo lines
#     to match. Type a three-word name such as Mary Ann Lopez: where does Ann
#     go?
#
# Below the line: the book's code, unchanged (TLCL is licensed CC BY-NC-ND 3.0;
# see LICENSE.md).
# ---------------------------------------------------------------------------

# read-multiple: read multiple values from keyboard

echo -n "Enter one or more values > "
read var1 var2 var3 var4 var5

echo "var1 = '$var1'"
echo "var2 = '$var2'"
echo "var3 = '$var3'"
echo "var4 = '$var4'"
echo "var5 = '$var5'"
