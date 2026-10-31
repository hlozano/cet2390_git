#!/bin/bash
# =============================================================================
# CET 2390 Operating Systems Laboratory: a textbook script, explained
# Script:   the guarded distros loop (the book gives it no name), from The Linux
#           Command Line (TLCL 19.01), chapter 33, "for: Traditional Shell Form"
# Code:     William Shotts. Explanations: Prof. Hernan Lozano, CityTech (CUNY)
# =============================================================================
#
# WHAT IT DOES
#   Prints the name of every file in the current folder whose name matches
#   distros*.txt, and prints nothing at all when no file matches. The book
#   prints these five lines without a #!/bin/bash line; line 1 of this file
#   adds it so the file can run as a script.
#
# HOW IT WORKS
#   1. `for i in distros*.txt; do`: before the loop starts, the shell replaces
#      the wildcard pattern with the names of the matching files in the
#      current folder, in alphabetical order (the wildcards of chapter 4).
#      for then sets the variable i to each name in turn and runs the body,
#      the lines between do and done, once per name.
#   2. If no file matches, the shell leaves the pattern as it is, and for
#      receives one word: the text distros*.txt itself. Without a check, the
#      loop would print that pattern as if it were a file name.
#   3. `if [[ -e "$i" ]]; then`: -e (chapter 27) is true only when a file of
#      that name exists. The pattern itself is not a file, so it is skipped.
#   4. `echo "$i"` prints the name. The quotes keep a name that contains
#      spaces in one piece.
#   5. `done` ends the body: for goes back for the next name and stops after
#      the last one.
#   The book's distros files come from a later chapter of the book (chapter
#   20). Empty files with the same names are enough to try the loop.
#
# NEW IN THIS SCRIPT
#   for NAME in WORDS; do ... done   runs the body once per word; NAME holds
#                                    the current word (no $ on the for line)
#   distros*.txt   replaced by the matching file names before the loop runs,
#                  or left exactly as typed when nothing matches
#
# RUN IT
#   chmod u+x book_01_distros_guard.sh
#   ./book_01_distros_guard.sh
#   Then run it where matching files exist. These lines remember this folder,
#   make three empty files in a practice folder, run the script there, and
#   come back:
#   src="$PWD"
#   mkdir -p ~/playground && cd ~/playground
#   touch distros.txt distros-dates.txt distros-names.txt
#   "$src/book_01_distros_guard.sh"
#   cd "$src"
#
# OUTPUT
#   In this folder: nothing, because no file here matches distros*.txt.
#   In the practice folder:
#   distros-dates.txt
#   distros-names.txt
#   distros.txt
#
# TRY THIS
#   - In an empty folder (mkdir -p ~/playground/empty && cd ~/playground/empty),
#     type the loop without the guard: for i in distros*.txt; do echo "$i"; done
#     What prints, and why?
#   - Type the book's first loop at the prompt: for i in A B C D; do echo $i; done
#     Then type it again without the ; before do. Why does bash name done in
#     its error message? (Only a one-line loop fails at done. In a script with
#     the body on the lines below, bash names the body's first command.)
#   - In a copy, change distros*.txt to *.sh and run the copy in this folder.
#     Which names print?
#
# Below the line: the book's code, unchanged (TLCL is licensed CC BY-NC-ND 3.0;
# see LICENSE.md).
# ---------------------------------------------------------------------------
for i in distros*.txt; do
    if [[ -e "$i" ]]; then
        echo "$i"
    fi
done
