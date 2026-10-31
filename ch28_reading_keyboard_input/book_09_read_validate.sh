#!/bin/bash
# =============================================================================
# CET 2390 Operating Systems Laboratory: a textbook script, explained
# Script:   read-validate, from The Linux Command Line (TLCL 19.01),
#           chapter 28, "Validating Input"
# Code:     William Shotts. Explanations: Prof. Hernan Lozano, CityTech (CUNY)
# =============================================================================
#
# WHAT IT DOES
#   Reads one item and checks it several ways. An empty answer or more than
#   one word stops the script with an error. Anything else is reported on:
#   is it a valid filename, does that file exist here, is it a floating point
#   number, is it an integer. It only tests whether a file exists; it creates
#   nothing.
#
# HOW IT WORKS
#   1. `invalid_input () { ... }` defines a shell function (chapter 26): a
#      named group of commands. Calling invalid_input prints the bad answer
#      on standard error and ends the script with exit 1. Writing it once
#      gives every check the same message and the same exit status.
#   2. `read -p "Enter a single item > "` stores the answer in REPLY.
#   3. `[[ -z "$REPLY" ]] && invalid_input`: -z is true for an empty string,
#      and && runs the command after it only when the command before it
#      succeeded. So an empty answer calls the function, and anything else
#      goes on. A check at the top that stops the script early on bad input
#      is called a guard clause.
#   4. `(( "$(echo "$REPLY" | wc -w)" > 1 )) && invalid_input`: wc -w counts
#      the words that echo hands it, $( ) puts the count into the line, and
#      (( ... > 1 )) is an arithmetic test, true for two words or more.
#   5. `[[ "$REPLY" =~ ^[-[:alnum:]\._]+$ ]]` checks for a valid filename:
#      one or more characters, each one a hyphen, a letter or digit
#      ([:alnum:]), a dot or an underscore. Inside [ ] a dot is already an
#      ordinary dot, so the backslash in front of it is not needed. All the
#      other checks sit inside this if.
#   6. `[[ -e "$REPLY" ]]` is true when a file or folder with that name exists
#      in the current folder.
#   7. `^-?[[:digit:]]*\.[[:digit:]]+$` is a floating point number: an
#      optional minus, any number of digits (even none), a real dot (outside
#      brackets a plain . means "any character", so \. is needed here), then
#      at least one digit. So 3.14 and .5 pass; 5. does not.
#   8. `^-?[[:digit:]]+$` is an integer, as in book_02_read_integer.sh.
#   9. An answer with any other character (a slash, a *, a comma) gets "The
#      string ... is not a valid filename." This message goes to standard
#      output, and the exit status is 0: only the guard clauses report an
#      error.
#   The order is the rule for every script that reads input: empty first,
#   then the shape (a regular expression), then the range or meaning.
#
# NEW IN THIS SCRIPT
#   guard clause       a check at the top that rejects bad input and stops
#   test && command    run command only when test succeeds
#   wc -w              count words
#   [:alnum:] [:digit:]  letters and digits; digits only (inside [ ])
#   [[ -e name ]]      true when a file or folder called name exists
#
# RUN IT
#   chmod u+x book_09_read_validate.sh
#   ./book_09_read_validate.sh                   then type 3.14
#   ./book_09_read_validate.sh <<< ""            an empty answer
#   ./book_09_read_validate.sh <<< "two words"
#   ./book_09_read_validate.sh <<< -7
#   ./book_09_read_validate.sh <<< book_09_read_validate.sh
#   ./book_09_read_validate.sh <<< a/b
#
# OUTPUT
#   Typed at the keyboard, 3.14:
#     Enter a single item > 3.14
#     '3.14' is a valid filename.
#     However, file '3.14' does not exist.
#     '3.14' is a floating point number.
#     '3.14' is not an integer.
#   Fed answers (no prompt, because the input is not a terminal):
#     ""                  Invalid input ''                       (status 1)
#     "two words"         Invalid input 'two words'              (status 1)
#     -7                  '-7' is a valid filename.
#                         However, file '-7' does not exist.
#                         '-7' is not a floating point number.
#                         '-7' is an integer.
#     book_09_read_validate.sh
#                         'book_09_read_validate.sh' is a valid filename.
#                         And file 'book_09_read_validate.sh' exists.
#                         'book_09_read_validate.sh' is not a floating point number.
#                         'book_09_read_validate.sh' is not an integer.
#     a/b                 The string 'a/b' is not a valid filename.
#
# TRY THIS
#   - The script can print nine different messages. Find an answer that
#     produces each one.
#   - Type three spaces and press Enter. The guard clauses let it through.
#     Why? (A bare read keeps the spaces in REPLY, so it is not empty, and
#     wc -w counts zero words.) Which check catches it?
#   - Try .5 and 5. (with the dot last). Which one is a floating point
#     number by this pattern, and which part of the pattern decides it?
#
# Below the line: the book's code, unchanged (TLCL is licensed CC BY-NC-ND 3.0;
# see LICENSE.md).
# ---------------------------------------------------------------------------

# read-validate: validate input

invalid_input () {
    echo "Invalid input '$REPLY'" >&2
    exit 1
}

read -p "Enter a single item > "

# input is empty (invalid)
[[ -z "$REPLY" ]] && invalid_input

# input is multiple items (invalid)
(( "$(echo "$REPLY" | wc -w)" > 1 )) && invalid_input

# is input a valid filename?
if [[ "$REPLY" =~ ^[-[:alnum:]\._]+$ ]]; then
    echo "'$REPLY' is a valid filename."
    if [[ -e "$REPLY" ]]; then
        echo "And file '$REPLY' exists."
    else
        echo "However, file '$REPLY' does not exist."
    fi

    # is input a floating point number?
    if [[ "$REPLY" =~ ^-?[[:digit:]]*\.[[:digit:]]+$ ]]; then
        echo "'$REPLY' is a floating point number."
    else
        echo "'$REPLY' is not a floating point number."
    fi

    # is input an integer?
    if [[ "$REPLY" =~ ^-?[[:digit:]]+$ ]]; then
        echo "'$REPLY' is an integer."
    else
        echo "'$REPLY' is not an integer."
    fi
else
    echo "The string '$REPLY' is not a valid filename."
fi
