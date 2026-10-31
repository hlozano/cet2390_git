#!/bin/bash
# =============================================================================
# CET 2390 Operating Systems Laboratory: a textbook script, explained
# Script:   sys_info_page with the stubs filled in, from The Linux Command Line
#           (TLCL 19.01), chapter 26, "Keep Scripts Running" (book name:
#           sys_info_page)
# Code:     William Shotts. Explanations: Prof. Hernan Lozano, CityTech (CUNY)
# Assembled: the book prints the three finished functions one at a time. Below the
#           line they replace the three empty functions of the stub listing from
#           "Shell Functions" (book_03_sys_info_page_stubs.sh); nothing else
#           changed. The here document lines inside the functions start with
#           tabs, because <<- removes tabs only.
# =============================================================================
#
# WHAT IT DOES
#   The report as chapter 26 leaves it: each function now writes a section
#   heading and the output of one command, uptime, df -h or du -sh /home/*.
#
# HOW IT WORKS
#   1. What changed from book_05: each stub's echo is replaced by a small here
#      document, `cat <<- _EOF_` ... `_EOF_`, that prints two lines of HTML.
#   2. report_uptime prints `<h2>System Uptime</h2>` and `<pre>$(uptime)</pre>`.
#      uptime prints the time, how long the computer has been running, how many
#      users are logged in, and the load average: how busy the processor was over
#      the last 1, 5 and 15 minutes.
#   3. `<h2>` is a second-level heading. `<pre>` ... `</pre>` tells the browser to
#      show the text exactly as printed, spaces and line breaks included, so the
#      columns of the command's output stay lined up.
#   4. report_disk_space has the same shape with `df -h`: the size, used space and
#      free space of each disk area (filesystem); -h prints sizes as K, M or G.
#   5. report_home_space uses `du -sh /home/*`: the space used by each folder in
#      /home (-s one total per folder, -h readable sizes). /home/* expands to
#      every home folder.
#   6. Inside each function, `<<-` removes the leading tabs, so the block can be
#      indented in the script and still print at the left edge. The closing _EOF_
#      is indented with tabs too. Spaces would not work.
#   7. Command substitution inside command substitution: the main here document
#      runs `$(report_uptime)`; the function runs its own cat, whose block runs
#      `$(uptime)`. Each output flows back up into the page.
#   8. In the output, only the first line of each section has the 8-space indent
#      of the `$(...)` line in the main here document; the lines after it start
#      at the left edge, because that indent is written once in the page.
#   9. du -sh /home/* works on a computer where you are the only user. On a shared
#      computer other home folders are private, so du prints Permission denied
#      for them; the book says the function would then need superuser privileges.
#      Chapter 27 changes report_home_space with if to handle that.
#
# NEW IN THIS SCRIPT
#   uptime          how long the computer has been on, and its load average
#   df -h           disk space used and free, in readable sizes
#   du -sh folder   total space used by a folder
#   <h2>, <pre>     a section heading; text shown exactly as printed
#
# RUN IT
#   chmod u+x book_06_sys_info_page_filled.sh
#   ./book_06_sys_info_page_filled.sh
#   To view it as a web page:
#   mkdir -p ~/playground
#   ./book_06_sys_info_page_filled.sh > ~/playground/sys_info_page.html
#   firefox ~/playground/sys_info_page.html
#
# OUTPUT
#   On our Ubuntu test computer (name linuxbox, user student). The df lines depend on
#   the computer; ours printed 19 filesystems, shortened here (... marks the lines
#   left out). The line for / is the main disk:
#   <html>
#       <head>
#           <title>System Information Report For linuxbox</title>
#       </head>
#       <body>
#           <h1>System Information Report For linuxbox</h1>
#           <p>Generated MM/DD/YY HH:MM:SS AM EDT, by student</p>
#           <h2>System Uptime</h2>
#   <pre> HH:MM:SS up 2 min,  1 user,  load average: 0.07, 0.06, 0.02</pre>
#           <h2>Disk Space Utilization</h2>
#   <pre>Filesystem      Size  Used Avail Use% Mounted on
#   ...
#   /dev/sdd       1007G  1.7G  954G   1% /
#   ...
#   tmpfs           3.2G   12K  3.2G   1% /run/user/1000</pre>
#           <h2>Home Space Utilization</h2>
#   <pre>128K	/home/student</pre>
#       </body>
#   </html>
#
# TRY THIS
#   - Save the page in ~/playground and open it in a browser. Do the <pre>
#     sections keep their columns?
#   - Run uptime, df -h and du -sh ~ at the prompt and compare them with the page.
#   - In a copy, add a fourth function, report_date, that prints <h2>Date</h2> and
#     <pre>$(date)</pre> the same way, and add $(report_date) to the page.
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
    cat <<- _EOF_
		<h2>Home Space Utilization</h2>
		<pre>$(du -sh /home/*)</pre>
		_EOF_
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
