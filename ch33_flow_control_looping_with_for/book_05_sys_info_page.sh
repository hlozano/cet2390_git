#!/bin/bash
# =============================================================================
# CET 2390 Operating Systems Laboratory: a textbook script, explained
# Script:   sys_info_page, final stage, from The Linux Command Line
#           (TLCL 19.01), assembled from chapters 26 and 33
# Code:     William Shotts. Explanations: Prof. Hernan Lozano, CityTech (CUNY)
# =============================================================================
#
# WHAT IT DOES
#   Prints a system information report as a web page (HTML): a title, the
#   time it was made, the uptime, the disk space, and the space used in the
#   home folders. This last section now uses a for loop to report the number
#   of folders and files and the size of each home folder.
#   This file is assembled. In chapter 33, "Summing Up", the book shows only
#   the new report_home_space function, so this file joins: the full listing
#   of chapter 26, "Shell Functions"; report_uptime and report_disk_space from
#   chapter 26, "Keep Scripts Running"; and chapter 33's new report_home_space.
#   Below the line is the book's code assembled from those listings; nothing
#   else changed. The book's own copy at this point also has the command-line
#   options added in chapter 32, which CET 2390 does not teach, so they are
#   not included.
#
# HOW IT WORKS
#   1. TITLE, CURRENT_TIME and TIMESTAMP are set first. `date +"%x %r %Z"`
#      prints the date, the time and the time zone.
#   2. `report_uptime` and `report_disk_space` (chapter 26) each print a
#      heading and a command's output with a here document. `<<-` removes the
#      tabs at the start of each line, so those lines are indented with tabs,
#      not spaces.
#   3. `report_home_space` is what changed. The chapter 27 version did all its
#      reporting inside an if, with one here document for the superuser and
#      another for everyone else. Now the if only chooses what to report:
#        root (id -u prints 0):  dir_list=/home/*   user_name="All Users"
#        anyone else:            dir_list="$HOME"   user_name="$USER"
#      The * in /home/* is not expanded in the assignment: dir_list holds the
#      text /home/*. It is expanded on the for line, where $dir_list has no
#      quotes, so one loop serves both cases.
#   4. `local format="%8s%10s%10s\n"` and `local i dir_list ...` keep these
#      variables inside the function (chapter 26). format describes three
#      columns for printf: 8, 10 and 10 characters wide, text pushed to the
#      right, then a line break.
#   5. `for i in $dir_list; do` makes one pass per home folder: one pass for
#      a regular user, one per folder in /home for root.
#   6. `find "$i" -type f | wc -l` lists every file under the folder (find is
#      chapter 17) and wc -l counts the lines: the number of files.
#      `-type d` counts the folders the same way, the folder itself included.
#   7. `du -sh "$i" | cut -f 1` gives the folder's size; cut -f 1 keeps the
#      first column (the size) and drops the folder name.
#   8. echo prints an <H3> heading and <pre>; the three printf lines print the
#      column names, the dashes and the numbers, lined up by format.
#   9. The last `cat << _EOF_` prints the page. $(report_uptime),
#      $(report_disk_space) and $(report_home_space) run each function and put
#      its output into the page.
#
# NEW IN THIS SCRIPT
#   for i in $dir_list   a for loop over the words stored in a variable
#   printf FORMAT ARGS   prints ARGS in the layout FORMAT describes; %8s is
#                        "a string, 8 characters wide" (printf is chapter 21)
#
# RUN IT
#   chmod u+x book_05_sys_info_page.sh
#   ./book_05_sys_info_page.sh            (the page scrolls past on screen)
#   mkdir -p ~/playground
#   ./book_05_sys_info_page.sh > ~/playground/sys_info_page.html
#   firefox ~/playground/sys_info_page.html
#   The > saves the page in a file (chapter 6); firefox shows it as a web
#   page. find walks every file in your home folder, so a large home folder
#   takes a few seconds.
#
# OUTPUT
#   The end of the page, for a regular user (here the user was student; your
#   name and numbers will differ):
#           <h2>Home Space Utilization (student)</h2>
#   <H3>/home/student</H3>
#   <pre>
#       Dirs     Files      Size
#       ----     -----      ----
#         14        25      204K
#   </pre>
#       </body>
#   </html>
#   Above it come the title, a "Generated" line with the date, the time and
#   your user name, the uptime line and the df -h table.
#
# TRY THIS
#   - Type echo /home/* at the prompt. That is the list root's loop would walk.
#   - In a copy, change the format to "%-8s%-10s%-10s\n". What does the - do to
#     the three columns?
#   - Run find ~ -type d | wc -l at the prompt. Is it the same as Dirs?
#
# Below the line: the book's code, unchanged (TLCL is licensed CC BY-NC-ND 3.0;
# see LICENSE.md).
# ---------------------------------------------------------------------------
# Program to output a system information page

TITLE="System Information Report For $HOSTNAME"
CURRENT_TIME="$(date +"%x %r %Z")"
TIMESTAMP="Generated $CURRENT_TIME, by $USER"

report_uptime () {
    cat <<- _EOF_
		<h2>System Uptime</h2>
		<pre>$(uptime)</pre>
		_EOF_
    return
}

report_disk_space () {
    cat <<- _EOF_
		<h2>Disk Space Utilization</h2>
		<pre>$(df -h)</pre>
		_EOF_
    return
}

report_home_space () {

    local format="%8s%10s%10s\n"
    local i dir_list total_files total_dirs total_size user_name

    if [[ "$(id -u)" -eq 0 ]]; then
        dir_list=/home/*
        user_name="All Users"
    else
        dir_list="$HOME"
        user_name="$USER"
    fi

    echo "<h2>Home Space Utilization ($user_name)</h2>"

    for i in $dir_list; do

        total_files="$(find "$i" -type f | wc -l)"
        total_dirs="$(find "$i" -type d | wc -l)"
        total_size="$(du -sh "$i" | cut -f 1)"

        echo "<H3>$i</H3>"
        echo "<pre>"
        printf "$format" "Dirs" "Files" "Size"
        printf "$format" "----" "-----" "----"
        printf "$format" "$total_dirs" "$total_files" "$total_size"
        echo "</pre>"
    done
    return
}

cat << _EOF_
<html>
    <head>
        <title>$TITLE</title>
    </head>
    <body>
        <h1>$TITLE</h1>
        <p>$TIMESTAMP</p>
        $(report_uptime)
        $(report_disk_space)
        $(report_home_space)
    </body>
</html>
_EOF_
