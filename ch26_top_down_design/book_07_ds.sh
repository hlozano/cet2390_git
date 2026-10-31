#!/bin/bash
# =============================================================================
# CET 2390 Operating Systems Laboratory: a textbook script, explained
# Script:   ds, from The Linux Command Line (TLCL 19.01), chapter 26,
#           "Shell Functions In Your .bashrc File"
# Code:     William Shotts. Explanations: Prof. Hernan Lozano, CityTech (CUNY)
# Added:    the book prints only the four lines of the function. The last two
#           lines below the line, a comment that starts "# added:" and the call
#           ds, are not from the book: they are there so that running this file
#           shows ds at work.
# =============================================================================
#
# WHAT IT DOES
#   Defines ds, a short personal command that prints a heading with the
#   computer's name and then the disk space report. The added last line calls it
#   once.
#
# HOW IT WORKS
#   1. `ds () {` ... `}` defines a function named ds in the simpler form. There is
#      no blank line after the rule line: the book's listing starts right there.
#   2. Its body has two commands: `echo "Disk Space Utilization For $HOSTNAME"`
#      prints a heading with the computer's name, and `df -h` prints the size,
#      used space and free space of each filesystem in readable sizes.
#   3. The book means this function for your ~/.bashrc file, which bash reads
#      every time a terminal opens (chapter 11). Put there, ds works as a command
#      in every new terminal.
#   4. Why a function and not an alias: an alias only replaces a word with other
#      text, and the book notes that aliases are limited in the commands and
#      shell features they support. A function can hold several commands and
#      anything a script can do.
#   5. The added `ds` at the end calls the function. Run as a script, ds exists
#      only while the script runs: when the script ends, your terminal does not
#      know ds. To keep it, add the four lines of the function (not the added
#      lines) to the end of ~/.bashrc and reload the file (see TRY THIS).
#
# NEW IN THIS SCRIPT
#   ~/.bashrc         the file bash reads when a terminal opens: a place for
#                     your own functions
#   source ~/.bashrc  reads the file again in the terminal you are using
#   type name         shows what a name is; for a function, its definition
#
# RUN IT
#   chmod u+x book_07_ds.sh
#   ./book_07_ds.sh
#
# OUTPUT
#   On our Ubuntu test computer, named linuxbox. The df lines depend on the computer;
#   ours printed 19 filesystems, shortened here (... marks the lines left out):
#   Disk Space Utilization For linuxbox
#   Filesystem      Size  Used Avail Use% Mounted on
#   ...
#   /dev/sdd       1007G  1.7G  954G   1% /
#   ...
#   tmpfs           3.2G   12K  3.2G   1% /run/user/1000
#
# TRY THIS
#   - After the script ends, type type ds at the prompt. Does your terminal know
#     ds? Why not?
#   - Type the function at the prompt on one line, then call it and look at it:
#     ds () { echo "Disk Space Utilization For $HOSTNAME"; df -h; }
#     ds
#     type ds
#   - Keep it: cp ~/.bashrc ~/.bashrc.bak (a backup), add the four lines of the
#     function to the end of ~/.bashrc with vi, then run source ~/.bashrc and ds.
#     Open a new terminal: is ds still there?
#
# Below the line: the book's code, unchanged (TLCL is licensed CC BY-NC-ND 3.0;
# see LICENSE.md).
# ---------------------------------------------------------------------------
ds () {
    echo "Disk Space Utilization For $HOSTNAME"
    df -h
}
# added: the book puts ds in ~/.bashrc; this call lets you see it run here
ds
