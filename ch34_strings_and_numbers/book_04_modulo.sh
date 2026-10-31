#!/bin/bash
# =============================================================================
# CET 2390 Operating Systems Laboratory: a textbook script, explained
# Script:   modulo, from The Linux Command Line (TLCL 19.01), chapter 34,
#           "Simple Arithmetic"
# Code:     William Shotts. Explanations: Prof. Hernan Lozano, CityTech (CUNY)
# =============================================================================
#
# WHAT IT DOES
#   Prints the numbers from 0 to 20 on one line and puts angle brackets around
#   every multiple of 5. The remainder operator % finds the multiples.
#
# HOW IT WORKS
#   1. `for ((i = 0; i <= 20; i = i + 1)); do` is chapter 33's C language
#      form of for: i goes from 0 up to and including 20 (<= means "less than
#      or equal to").
#   2. `remainder=$((i % 5))`: $(( )) is arithmetic expansion, replaced by the
#      result of the math inside. % (modulo) gives the remainder of a
#      division: 7 % 5 is 2, 10 % 5 is 0. The remainder is 0 exactly when i
#      is a multiple of 5.
#   3. `if (( remainder == 0 )); then`: == compares (chapter 27's (( )) test).
#   4. `printf "<%d> " "$i"`: printf prints its first argument, the format,
#      and puts the next argument where %d is, as a whole number. Unlike echo,
#      printf adds no line break unless you write \n, so the numbers stay on
#      one line. (printf is chapter 21.)
#   5. `else printf "%d " "$i"` prints the other numbers with no brackets.
#   6. After the loop, `printf "\n"` ends the line.
#   Bash arithmetic uses whole numbers only, so a division throws away the
#   fraction: $(( 5 / 2 )) is 2, and $(( 5 % 2 )) is the 1 left over.
#
# NEW IN THIS SCRIPT
#   $(( expression ))   replaced by the result of the arithmetic
#   %                   modulo: the remainder of a division
#   printf "%d " "$i"   prints $i as a whole number, with no line break
#
# RUN IT
#   chmod u+x book_04_modulo.sh
#   ./book_04_modulo.sh
#
# OUTPUT
#   <0> 1 2 3 4 <5> 6 7 8 9 <10> 11 12 13 14 <15> 16 17 18 19 <20>
#
# TRY THIS
#   - Change % 5 to % 3. Which numbers get brackets now?
#   - Delete the last line, printf "\n", in a copy and run it. Where does the
#     prompt appear, and why?
#   - At the prompt, predict, then run: echo $(( 17 / 5 )) $(( 17 % 5 ))
#
# Below the line: the book's code, unchanged (TLCL is licensed CC BY-NC-ND 3.0;
# see LICENSE.md).
# ---------------------------------------------------------------------------

# modulo: demonstrate the modulo operator

for ((i = 0; i <= 20; i = i + 1)); do
    remainder=$((i % 5))
    if (( remainder == 0 )); then
        printf "<%d> " "$i"
    else
        printf "%d " "$i"
    fi
done
printf "\n"
