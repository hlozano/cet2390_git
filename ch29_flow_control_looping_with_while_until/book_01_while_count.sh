#!/bin/bash
# =============================================================================
# CET 2390 Operating Systems Laboratory: a textbook script, explained
# Script:   while-count, from The Linux Command Line (TLCL 19.01), chapter 29,
#           "while"
# Code:     William Shotts. Explanations: Prof. Hernan Lozano, CityTech (CUNY)
# =============================================================================
#
# WHAT IT DOES
#   Prints the numbers 1 to 5, one per line, then "Finished." It is the
#   smallest useful loop: a block of commands that runs again and again
#   until a test says stop.
#
# HOW IT WORKS
#   1. `count=1` sets the start value of the counter.
#   2. `while [[ "$count" -le 5 ]]; do` runs the test before every pass (one
#      run of the loop's body). while looks only at the test's exit status,
#      the way if does: 0 (success) runs the body once more; anything else
#      ends the loop. -le means "less than or equal to".
#   3. The body, the lines between do and done, prints the number and then
#      adds 1: `count=$((count + 1))` works out count + 1 with $(( )) and
#      stores the result back in count (no $ on the left of =).
#   4. `done` marks the end of the body and sends bash back to the while
#      line for the next test.
#   5. After the fifth pass count is 6, the test 6 -le 5 fails, the body is
#      skipped, and bash goes on to the first line after done:
#      echo "Finished."
#   Every counting loop needs these three parts: a start (count=1), a test
#   (-le 5) and a change (count + 1). Leave out the change and the test never
#   fails, so the loop never ends.
#
# NEW IN THIS SCRIPT
#   while test; do ... done   repeat the commands between do and done for
#                             as long as the test succeeds (exit status 0)
#   loop, pass                a loop repeats a block; one run of it is a pass
#   start, test, change       the three parts of every counting loop
#
# RUN IT
#   chmod u+x book_01_while_count.sh
#   ./book_01_while_count.sh
#
# OUTPUT
#   1
#   2
#   3
#   4
#   5
#   Finished.
#
# TRY THIS
#   - In a copy (cp book_01_while_count.sh mine.sh), make it count to 10,
#     then count by 2. Which line changes each time?
#   - Set count=9 in your copy. What prints? (The test runs before the first
#     pass, so a loop can run zero times.)
#   - Delete the count=$((count + 1)) line in your copy and run it. Stop the
#     endless stream of 1s with Ctrl-c. Why does it never stop on its own?
#
# Below the line: the book's code, unchanged (TLCL is licensed CC BY-NC-ND 3.0;
# see LICENSE.md).
# ---------------------------------------------------------------------------

# while-count: display a series of numbers

count=1

while [[ "$count" -le 5 ]]; do
    echo "$count"
    count=$((count + 1))
done
echo "Finished."
