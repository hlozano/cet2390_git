#!/bin/bash
# =============================================================================
# CET 2390 Operating Systems Laboratory: a textbook script, explained
# Script:   ul-param, from The Linux Command Line (TLCL 19.01), chapter 34,
#           "Case Conversion"
# Code:     William Shotts. Explanations: Prof. Hernan Lozano, CityTech (CUNY)
# =============================================================================
#
# WHAT IT DOES
#   Prints the word you type after the script's name four ways: all
#   lowercase, first character lowercase, all uppercase, first character
#   uppercase. It uses parameter expansion instead of declare.
#
# HOW IT WORKS
#   1. `if [[ "$1" ]]; then`: $1 is the first word typed after the script's
#      name; the test is true when it is not empty.
#   2. `echo "${1,,}"`: two commas make every character lowercase.
#   3. `echo "${1,}"`: one comma makes only the first character lowercase.
#   4. `echo "${1^^}"`: two carets make every character uppercase.
#   5. `echo "${1^}"`: one caret makes only the first character uppercase.
#   The 1 inside the braces is the name of the parameter ($1); the same
#   expansions work on any variable: ${name^}, ${answer,,}.
#   What changed from ul-declare: no special variables are needed, and the
#   conversion happens at the moment the value is used, so the variable keeps
#   exactly what was typed.
#
# NEW IN THIS SCRIPT
#   ${name,,}  ${name,}    all lowercase / first character lowercase
#   ${name^^}  ${name^}    all uppercase / first character uppercase
#
# RUN IT
#   chmod u+x book_03_ul_param.sh
#   ./book_03_ul_param.sh aBc
#
# OUTPUT
#   abc
#   aBc
#   ABC
#   ABc
#   The second line looks unchanged because the first character, a, was
#   already lowercase.
#
# TRY THIS
#   - Run ./book_03_ul_param.sh "ana rivera". Does ${1^} capitalize each word
#     or only the first character of the whole value?
#   - At the prompt: answer="YeS"; [[ ${answer,,} == yes ]] && echo "accepted"
#     How many spellings of yes does that one test accept?
#   - Run it with Hello. Predict all four lines first.
#
# Below the line: the book's code, unchanged (TLCL is licensed CC BY-NC-ND 3.0;
# see LICENSE.md).
# ---------------------------------------------------------------------------

# ul-param: demonstrate case conversion via parameter expansion

if [[ "$1" ]]; then
        echo "${1,,}"
        echo "${1,}"
        echo "${1^^}"
        echo "${1^}"
fi
