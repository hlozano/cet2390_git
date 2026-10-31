#!/bin/bash
# =============================================================================
# CET 2390 Operating Systems Laboratory: a textbook script, explained
# Script:   sys_info_page, from The Linux Command Line (TLCL 19.01),
#           chapter 27, "Summing Up"
# Code:     William Shotts. Explanations: Prof. Hernan Lozano, CityTech (CUNY)
# =============================================================================
#
# WHAT IT DOES
#   The report program from chapters 25 and 26, at its chapter 27 stage: it
#   writes a web page (HTML) about the computer, with the uptime, the disk
#   space and the space used by home folders. New here: the home folder part
#   adapts to who runs it. The superuser (root) gets every home folder; any
#   other user gets only their own.
#
# HOW IT WORKS
#   1. TITLE, CURRENT_TIME and TIMESTAMP are set as in chapter 25.
#   2. report_uptime and report_disk_space are chapter 26's functions,
#      unchanged: each prints an <h2> heading and one command's output inside
#      <pre> tags, with a here document (cat <<- _EOF_ ... _EOF_).
#   3. What changed from chapter 26 (book_06_sys_info_page_filled.sh in
#      ../ch26_top_down_design): report_home_space now starts with
#      `if [[ "$(id -u)" -eq 0 ]]; then`. `id -u` prints your numeric user
#      ID, and $( ) puts that number into the test. The superuser's ID is
#      always 0; every other user has a number greater than 0 (the first
#      account made on Linux Mint or Ubuntu is usually 1000).
#   4. ID 0: the heading says "(All Users)" and `du -sh /home/*` prints the
#      total size of every folder in /home. Only the superuser may read
#      everyone's folders.
#   5. Any other ID: the heading names $USER, and `du -sh $HOME` totals only
#      your own home folder, which you can always read. In chapter 26 a normal
#      user on a shared computer got "Permission denied" for the other users'
#      folders; now that cannot happen.
#   6. The main here document at the bottom calls the three functions with
#      $(report_uptime) and the others, and cat prints the finished page.
#   7. This file is assembled: the finished chapter 26 script with
#      report_home_space replaced by this chapter's version (the book prints
#      only the new function). The here document lines inside the functions
#      start with tab characters, because <<- strips leading tabs, not spaces.
#
# NEW IN THIS SCRIPT
#   id -u    prints your numeric user ID: 0 for the superuser
#   $USER    your user name; $HOME is your home folder
#
# RUN IT
#   chmod u+x book_12_sys_info_page.sh
#   ./book_12_sys_info_page.sh
#
# OUTPUT (shortened; ... marks lines left out)
#   <html>
#       <head>
#           <title>System Information Report For linuxbox</title>
#       </head>
#       <body>
#           <h1>System Information Report For linuxbox</h1>
#           <p>Generated MM/DD/YY HH:MM:SS AM EDT, by student</p>
#           <h2>System Uptime</h2>
#   <pre> HH:MM:SS up 3 min,  1 user,  load average: 0.09, 0.06, 0.02</pre>
#           <h2>Disk Space Utilization</h2>
#   <pre>Filesystem      Size  Used Avail Use% Mounted on
#   /dev/sdd       1007G  1.7G  954G   1% /
#   ...</pre>
#           <h2>Home Space Utilization (student)</h2>
#   <pre>204K    /home/student</pre>
#       </body>
#   </html>
#   (Run on a computer named linuxbox by a user named student, user ID 1000.
#   MM/DD/YY HH:MM:SS stands for the date and time of the run; df prints one
#   line for each mounted file system. Your names and numbers will differ.)
#
# TRY THIS
#   - Type id -u and id -un at the prompt. Which branch will the script take
#     for you? Run it and find the "Home Space Utilization" heading.
#   - Read the then part: what heading would the superuser see, and which
#     folders would du measure? (Reading the code is enough; no sudo needed.)
#   - Save the page and open it in a web browser:
#         mkdir -p ~/playground
#         ./book_12_sys_info_page.sh > ~/playground/sys_info_page.html
#         firefox ~/playground/sys_info_page.html
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
    if [[ "$(id -u)" -eq 0 ]]; then
        cat <<- _EOF_
			<h2>Home Space Utilization (All Users)</h2>
			<pre>$(du -sh /home/*)</pre>
			_EOF_
    else
        cat <<- _EOF_
			<h2>Home Space Utilization ($USER)</h2>
			<pre>$(du -sh $HOME)</pre>
			_EOF_
    fi
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
