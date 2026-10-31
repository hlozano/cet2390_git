#!/bin/bash
# =============================================================================
# CET 2390 Operating Systems Laboratory: a textbook script, explained
# Script:   test-integer2a, from The Linux Command Line (TLCL 19.01),
#           chapter 27, "(( )) - Designed for Integers"
# Code:     William Shotts. Explanations: Prof. Hernan Lozano, CityTech (CUNY)
# =============================================================================
#
# WHAT IT DOES
#   The same program as test-integer2 (book_06), with its three number tests
#   rewritten in (( )), bash's arithmetic test. The output is the same; the
#   tests read more like math class.
#
# HOW IT WORKS
#   1. The =~ check at the top is book_06's, unchanged.
#   2. `if ((INT == 0)); then` replaces `if [ "$INT" -eq 0 ]; then`. `(( ))`
#      works out the arithmetic inside it and succeeds (exit status 0) when
#      the result is not zero. A comparison such as INT == 0 gives 1 when it
#      is true and 0 when it is false, so the if behaves as you would expect.
#   3. Inside (( )) you write variable names without $ (INT, not $INT), and
#      you compare with the math signs == != < > <= >= instead of -eq, -ne,
#      -lt, -gt, -le and -ge.
#   4. `if ((INT < 0)); then` replaces the -lt test.
#   5. `if (( ((INT % 2)) == 0)); then` replaces `[ $((INT % 2)) -eq 0 ]`. The
#      inner parentheses only group INT % 2, as in algebra; the line could
#      also be written (( INT % 2 == 0 )).
#   6. (( )) is part of bash's own grammar, not a command like [, so the
#      spaces inside it are optional: ((INT<0)) works too.
#   What the pair shows: [ ] with -eq and (( )) with == ask the same questions
#   about whole numbers. (( )) is shorter and reads like arithmetic, but only
#   bash (and a few other modern shells) understands it.
#
# NEW IN THIS SCRIPT
#   (( expression ))   arithmetic test: status 0 (true) when the result is not
#                      zero, status 1 (false) when it is zero
#   == != < > <= >=    the comparison signs used inside (( ))
#
# RUN IT
#   chmod u+x book_07_test_integer2a.sh
#   ./book_07_test_integer2a.sh
#
# OUTPUT
#   INT is negative.
#   INT is odd.
#
# TRY THIS
#   - Copy the script (cp book_07_test_integer2a.sh try.sh). In the copy,
#     change INT=-5 to INT=0, then INT=10. Predict the output each time, then
#     run ./try.sh.
#   - At the prompt, type ((0)); echo $? and then ((1)); echo $? . Why does
#     the arithmetic result 0 give exit status 1?
#   - Try INT=08. It passes the =~ check; then bash prints "value too great
#     for base" three times and calls 8 odd. Inside (( )), a number that
#     starts with 0 is read in base 8 (octal), where 8 is not a digit, and each
#     failed test counts as false. For a value with no minus sign, writing
#     10#$INT instead of INT forces base 10 (10#-5 is an error, though).
#
# Below the line: the book's code, unchanged (TLCL is licensed CC BY-NC-ND 3.0;
# see LICENSE.md).
# ---------------------------------------------------------------------------

# test-integer2a: evaluate the value of an integer.

INT=-5

if [[ "$INT" =~ ^-?[0-9]+$ ]]; then
    if ((INT == 0)); then
        echo "INT is zero."
    else
        if ((INT < 0)); then
            echo "INT is negative."
        else
            echo "INT is positive."
        fi
        if (( ((INT % 2)) == 0)); then
            echo "INT is even."
        else
            echo "INT is odd."
        fi
    fi
else
    echo "INT is not an integer." >&2
    exit 1
fi
