#!/bin/bash
# =============================================================================
# CET 2390 Operating Systems Laboratory: a textbook script, explained
# Script:   loan-calc, from The Linux Command Line (TLCL 19.01), chapter 34,
#           "An Example Script"
# Code:     William Shotts. Explanations: Prof. Hernan Lozano, CityTech (CUNY)
# =============================================================================
#
# WHAT IT DOES
#   Calculates the monthly payment on a loan from three numbers typed after
#   the script's name: the amount, the yearly interest rate as a decimal, and
#   the number of months. The shell has no decimals, so the math is handed to
#   bc, a calculator program.
#
# HOW IT WORKS
#   1. `PROGNAME="${0##*/}"`: $0 holds the name the script was run with, such
#      as ./book_07_loan_calc.sh. ##*/ removes the longest match of */ from
#      the front, everything up to the last /, which leaves the bare name.
#   2. `usage ()` is a function that prints the help text with a here document
#      (chapter 25). `<<-` removes the tabs at the start of each line, so the
#      text can be indented in the script and still print at the left edge.
#      Those lines are indented with tabs; keep them as tabs when you edit.
#   3. `if (($# != 3)); then`: $# is how many words were typed after the
#      script's name. Anything but three prints the usage and `exit 1` stops
#      the script with status 1, before any math.
#   4. `principal=$1`, `interest=$2`, `months=$3`: $1, $2 and $3 are the
#      first, second and third words typed after the script's name.
#   5. `bc <<- EOF` ... `EOF` hands a small program to bc through a here
#      document. Bash first replaces $interest, $principal and $months with
#      the numbers, then bc runs the lines:
#        scale = 10      keep 10 digits after the decimal point
#        i = $interest / 12   the monthly rate: the yearly rate over 12
#        p, n            the amount and the number of months
#        a = p * ((i * ((1 + i) ^ n)) / (((1 + i) ^ n) - 1))
#                        the standard loan-payment formula; in bc, ^ is the
#                        power operator (bash writes **)
#        print a, "\n"   prints the payment and a line break
#   The closing EOF of this here document starts at the left edge, with no
#   tab; with <<- a tab before it would work too.
#
# NEW IN THIS SCRIPT
#   bc               a calculator with its own small language; it can do
#                    decimals, which bash arithmetic cannot
#   scale = N        bc keeps N digits after the decimal point
#   $#  $0           how many words follow the script's name / the name used
#                    to run it (chapter 32 ideas, explained above)
#
# RUN IT
#   chmod u+x book_07_loan_calc.sh
#   ./book_07_loan_calc.sh 135000 0.0775 180
#   ($135,000 at 7.75% a year for 180 months, the book's example.)
#
# OUTPUT
#   1270.7222490000
#   With no numbers (./book_07_loan_calc.sh), the usage text, and echo $?
#   then prints 1:
#   Usage: book_07_loan_calc.sh PRINCIPAL INTEREST MONTHS
#
#   Where:
#
#   PRINCIPAL is the amount of the loan.
#   INTEREST is the APR as a number (7% = 0.07).
#   MONTHS is the length of the loan's term.
#
# TRY THIS
#   - Run it with only two numbers. Which line stops it, and what does
#     echo $? print?
#   - Type the rate as 7.75 instead of 0.0775. The script prints
#     87187.4999955000 without complaint: why can it not tell?
#   - In a copy, change scale = 10 to scale = 20, then to scale = 4. bc cuts
#     every result along the way to scale digits, so the answers differ
#     (1270.72226660429165940000 and 1255.5000). With scale = 2 it fails:
#     0.0775 / 12 becomes 0.00, and bc reports a divide by zero.
#
# Below the line: the book's code, unchanged (TLCL is licensed CC BY-NC-ND 3.0;
# see LICENSE.md).
# ---------------------------------------------------------------------------

# loan-calc: script to calculate monthly loan payments

PROGNAME="${0##*/}" # Use parameter expansion to get basename

usage () {
    cat <<- EOF
	Usage: $PROGNAME PRINCIPAL INTEREST MONTHS

	Where:

	PRINCIPAL is the amount of the loan.
	INTEREST is the APR as a number (7% = 0.07).
	MONTHS is the length of the loan's term.

	EOF
}

if (($# != 3)); then
    usage
    exit 1
fi

principal=$1
interest=$2
months=$3

bc <<- EOF
	scale = 10
	i = $interest / 12
	p = $principal
	n = $months
	a = p * ((i * ((1 + i) ^ n)) / (((1 + i) ^ n) - 1))
	print a, "\n"
EOF
