#!/bin/bash
# =============================================================================
# CET 2390 Operating Systems Laboratory: a textbook script, explained
# Script:   modulo2, from The Linux Command Line (TLCL 19.01), chapter 34,
#           "Assignment"
# Code:     William Shotts. Explanations: Prof. Hernan Lozano, CityTech (CUNY)
# =============================================================================
#
# WHAT IT DOES
#   The same output as book_04_modulo.sh, from a shorter program: the
#   numbers 0 to 20 with brackets around every multiple of 5.
#
# HOW IT WORKS
#   What changed from modulo:
#   1. `for ((i = 0; i <= 20; ++i ))`: the step `i = i + 1` became `++i`, the
#      increment operator: add 1 to i.
#   2. The remainder variable is gone. `if (((i % 5) == 0 )); then` computes
#      the remainder and tests it in one step: the outer (( )) is the test,
#      and the inner ( ) groups i % 5 so it is read first.
#   3. The two printf lines and the final printf "\n" are unchanged.
#   ++i and i++ both add 1 to i; they differ only in the value they hand
#   back. ++i adds first and gives the new value; i++ gives the old value,
#   then adds. As the step of a for loop, where nobody uses that value, both
#   work the same. The book prefers ++i.
#
# NEW IN THIS SCRIPT
#   ++i  i++   add 1 to i (--i and i-- subtract 1)
#   +=  -=     add to / subtract from a variable: (( total += 5 ))
#
# RUN IT
#   chmod u+x book_05_modulo2.sh
#   ./book_05_modulo2.sh
#
# OUTPUT
#   <0> 1 2 3 4 <5> 6 7 8 9 <10> 11 12 13 14 <15> 16 17 18 19 <20>
#
# TRY THIS
#   - In a copy, change ++i to i++. Does the output change? Why not?
#   - At the prompt: i=1; echo $(( i++ )); echo $i. Then i=1; echo $(( ++i ))
#     Explain each number you see.
#   - In a copy, make the step i += 5. Which numbers print now?
#
# Below the line: the book's code, unchanged (TLCL is licensed CC BY-NC-ND 3.0;
# see LICENSE.md).
# ---------------------------------------------------------------------------

# modulo2: demonstrate the modulo operator

for ((i = 0; i <= 20; ++i )); do
    if (((i % 5) == 0 )); then
        printf "<%d> " "$i"
    else
        printf "%d " "$i"
    fi
done
printf "\n"
