#!/bin/bash
# =============================================================================
# CET 2390 Operating Systems Laboratory: a textbook script, explained
# Script:   ftp_retrieve, second version, from The Linux Command Line (TLCL 19.01),
#           chapter 25, "Here Documents", third listing (the book gives this
#           script no file name)
# Code:     William Shotts. Explanations: Prof. Hernan Lozano, CityTech (CUNY)
# Layout:   the book prints the FTP_PATH line wrapped after "images/"; below the
#           line it is joined into one line, which holds two assignments.
# =============================================================================
#
# WHAT IT DOES
#   The same ftp script as book_08_ftp_retrieve.sh, with << changed to <<-, which
#   lets the here document be indented with TAB characters.
#
# HOW IT WORKS
#   1. What changed from book_08: `ftp -n << _EOF_` became `ftp -n <<- _EOF_`;
#      every line of the block, and the closing _EOF_, now starts with one TAB
#      character; and a blank line comes before `ls`.
#   2. With <<-, bash removes the leading tabs from each line of the block before
#      it feeds the text to ftp, and it accepts a closing _EOF_ with tabs in front
#      of it. So ftp receives the same six commands as in book_08, and the block
#      stands out in the script.
#   3. Only tabs are removed, never spaces. Many editors type spaces when you press
#      the Tab key. If the closing _EOF_ is indented with spaces, bash never finds
#      it: it warns that the here document ended at the end of the file and feeds
#      the rest of the script to the command. If a line of the block is indented
#      with spaces, the spaces reach the command.
#   4. The indents in this file are real tabs. cat -A shows each tab as ^I (and
#      the end of each line as $).
#   5. Everything else works as in book_08, with the same two problems: ftp is
#      often not installed, and the folder on the server is gone (the server
#      itself may be gone too). Read it for the <<- form.
#
# NEW IN THIS SCRIPT
#   command <<- token  a here document whose leading tabs are removed, so the
#                      block and its closing token may be indented with tabs
#   cat -A file        shows hidden characters: a tab as ^I, a line end as $
#
# RUN IT
#   Run a copy in a practice folder (a working ftp would save a file there):
#   mkdir -p ~/playground
#   cp book_09_ftp_retrieve.sh ~/playground/
#   cd ~/playground
#   chmod u+x book_09_ftp_retrieve.sh
#   ./book_09_ftp_retrieve.sh
#
# OUTPUT
#   Without ftp installed:
#   ./book_09_ftp_retrieve.sh: line 73: ftp: command not found
#   ls: cannot access 'debian-cd_info.tar.gz': No such file or directory
#   With ftp -n changed to cat in your copy, you see the same six lines as for
#   book_08, with no tabs in front of them, then the same ls message.
#
# TRY THIS
#   - Run cat -A book_09_ftp_retrieve.sh and look at the last lines. Which lines
#     start with ^I?
#   - In a copy with ftp -n changed to cat, replace the tab before the closing
#     _EOF_ with four spaces. Run it: what does the warning say, and which extra
#     lines does cat print?
#   - In the same copy, indent one line of the block with spaces instead of a
#     tab. Are the spaces printed?
#
# Below the line: the book's code, unchanged (TLCL is licensed CC BY-NC-ND 3.0;
# see LICENSE.md).
# ---------------------------------------------------------------------------

# Script to retrieve a file via FTP

FTP_SERVER=ftp.nl.debian.org
FTP_PATH=/debian/dists/stretch/main/installer-amd64/current/images/cdrom REMOTE_FILE=debian-cd_info.tar.gz

ftp -n <<- _EOF_
	open $FTP_SERVER
	user anonymous me@linuxbox
	cd $FTP_PATH
	hash
	get $REMOTE_FILE
	bye
	_EOF_

ls -l "$REMOTE_FILE"
