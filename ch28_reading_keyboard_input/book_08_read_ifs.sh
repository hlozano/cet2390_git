#!/bin/bash
# =============================================================================
# CET 2390 Operating Systems Laboratory: a textbook script, explained
# Script:   read-ifs, from The Linux Command Line (TLCL 19.01), chapter 28,
#           "IFS"
# Code:     William Shotts. Explanations: Prof. Hernan Lozano, CityTech (CUNY)
# =============================================================================
#
# WHAT IT DOES
#   Asks for a user name, finds that user's line in /etc/passwd, splits the
#   line at its colons, and prints the fields one per line. It only reads
#   /etc/passwd (every user may read it); it changes nothing.
#
# HOW IT WORKS
#   1. `FILE=/etc/passwd` names the file that lists the accounts on a Linux
#      system, one line per account, seven fields separated by colons:
#        name:password:UID:GID:full name:home folder:shell
#      for example root:x:0:0:root:/root:/bin/bash
#   2. `read -p "Enter a username > " user_name` asks for a name.
#   3. `file_info="$(grep "^$user_name:" $FILE)"` runs grep and stores what
#      it prints in file_info ($( ) is command substitution: the output of
#      the command takes its place). The pattern ^name: means "the name at
#      the start of the line, then a colon", so ann matches only ann's line,
#      never anna's.
#   4. `[ -n "$file_info" ]` is true when grep found a line (-n: not empty).
#   5. `IFS=":" read user pw uid gid name home shell <<< "$file_info"` is the
#      heart of the script. It has three parts:
#      - IFS (Internal Field Separator) is the variable that tells read where
#        one field ends and the next begins. Normally it holds a space, a tab
#        and a newline. Written in front of a command, IFS=":" changes it to
#        a colon for that one command only; afterwards IFS is back to normal.
#      - read hands the seven fields to the seven variables, in order.
#      - <<< "$file_info" is a here string: it feeds the text in file_info to
#        read's standard input, as if it had been typed.
#   6. The echo lines print six of the fields. pw is read but never printed:
#      on current systems that field holds only an x, because the real
#      password hashes are kept in /etc/shadow, which only root can read.
#   7. No matching line: "No such user ..." on standard error, and exit 1.
#   Why not echo "$file_info" | IFS=":" read ...? A pipe runs read in a copy
#   of the shell (a subshell), and the copy's variables vanish when it ends.
#   The here string keeps read in the script's own shell. The chapter README
#   shows this under "You cannot pipe into read".
#
# NEW IN THIS SCRIPT
#   IFS             Internal Field Separator: the characters read splits on
#                   (default: space, tab, newline)
#   VAR=value cmd   an assignment in front of a command lasts for that
#                   command only
#   <<< "$var"      a here string: the text of var becomes the command's input
#   /etc/passwd     the list of accounts, seven colon-separated fields a line
#
# RUN IT
#   chmod u+x book_08_read_ifs.sh
#   ./book_08_read_ifs.sh                  then type root
#   ./book_08_read_ifs.sh <<< "$USER"      your own account
#   ./book_08_read_ifs.sh <<< nosuchuser
#   Run it on Linux. Git Bash on Windows has no /etc/passwd, so there grep
#   reports "No such file or directory" and every name is "No such user".
#
# OUTPUT
#   Typed at the keyboard, root:
#     Enter a username > root
#     User =      'root'
#     UID =       '0'
#     GID =       '0'
#     Full Name = 'root'
#     Home Dir. = '/root'
#     Shell =     '/bin/bash'
#   Fed <<< nosuchuser (no prompt, because the input is not a terminal):
#     No such user 'nosuchuser'
#   and the exit status is 1. For your own account the UID is usually 1000
#   and the home folder is /home/ followed by your name. The full name may be
#   empty, or followed by commas (Student,,,): the commas separate extra
#   items such as a room or phone number, left empty.
#
# TRY THIS
#   - Type Root with a capital R. Why is there no such user? (grep and user
#     names are case-sensitive.)
#   - Run grep "^root:" /etc/passwd yourself and count the colons. Which
#     variable gets each field?
#   - At the prompt, run IFS=":" read a b rest <<< "a:b:c:d" and then
#     echo "$rest". Why does rest hold c:d, colon included?
#
# Below the line: the book's code, unchanged (TLCL is licensed CC BY-NC-ND 3.0;
# see LICENSE.md).
# ---------------------------------------------------------------------------

# read-ifs: read fields from a file

FILE=/etc/passwd

read -p "Enter a username > " user_name

file_info="$(grep "^$user_name:" $FILE)"

if [ -n "$file_info" ]; then
    IFS=":" read user pw uid gid name home shell <<< "$file_info"
    echo "User =      '$user'"
    echo "UID =       '$uid'"
    echo "GID =       '$gid'"
    echo "Full Name = '$name'"
    echo "Home Dir. = '$home'"
    echo "Shell =     '$shell'"
else
    echo "No such user '$user_name'" >&2
    exit 1
fi
