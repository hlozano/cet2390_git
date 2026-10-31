#!/bin/bash
# =============================================================================
# CET 2390 Operating Systems Laboratory: a textbook script, explained
# Script:   ftp_retrieve, from The Linux Command Line (TLCL 19.01), chapter 25,
#           "Here Documents", second listing. The book gives this script no file
#           name; its comment calls it a "Script to retrieve a file via FTP".
# Code:     William Shotts. Explanations: Prof. Hernan Lozano, CityTech (CUNY)
# Layout:   the book prints the FTP_PATH line wrapped after "images/"; below the
#           line it is joined into one line, which holds two assignments.
# =============================================================================
#
# WHAT IT DOES
#   Shows that a here document can feed any command that reads standard input.
#   Here it types six commands into ftp, a program that copies files from a
#   server over the network, to download one file from a Debian Linux server.
#   Read it for the here document: it will most likely not download anything
#   (see step 7).
#
# HOW IT WORKS
#   1. `FTP_SERVER=ftp.nl.debian.org` stores the server's name. No quotes are
#      needed, because the value has no spaces.
#   2. The next line holds two assignments separated by a space: FTP_PATH (the
#      folder on the server, ending in .../images/cdrom) and REMOTE_FILE (the
#      file to fetch). Bash allows several assignments on one line.
#   3. `ftp -n << _EOF_` runs ftp and feeds it the block as standard input. ftp
#      reads its commands from standard input, so the six lines act as if you
#      typed them at ftp's own prompt. The -n option stops ftp from asking for a
#      user name when it connects; the block logs in by itself.
#   4. Bash expands the variables before ftp sees the text, so ftp receives the
#      real server name, folder and file name.
#   5. The six ftp commands: open connects to the server; user logs in as the
#      public user anonymous (by tradition the password is an e-mail address,
#      and the book uses a made-up one); cd moves to the folder on the server;
#      hash prints a # for each block received, as a progress bar; get downloads
#      the file into the current folder; bye closes the connection and ends ftp.
#   6. After the closing _EOF_, ftp has ended, and `ls -l "$REMOTE_FILE"` lists
#      the downloaded file to prove it arrived.
#   7. Why it will most likely fail: the ftp program is often not installed (it
#      was not on our Ubuntu test computer, see OUTPUT), and the server may be
#      gone. Debian has closed most of its public FTP service. When we tested,
#      ftp.nl.debian.org still answered, but the folder is gone: stretch, the
#      Debian release named in FTP_PATH, is old and was removed from the server,
#      so it answers the cd with 550 Failed to change directory and the get
#      fails. What matters here is how the script feeds commands to ftp.
#
# NEW IN THIS SCRIPT
#   a=1 b=2          two assignments on one line
#   ftp -n           the FTP client, without automatic login
#   command << token any command that reads standard input can take a here
#                    document, not only cat
#
# RUN IT
#   Run a copy in a practice folder (a working ftp would save a file there):
#   mkdir -p ~/playground
#   cp book_08_ftp_retrieve.sh ~/playground/
#   cd ~/playground
#   chmod u+x book_08_ftp_retrieve.sh
#   ./book_08_ftp_retrieve.sh
#
# OUTPUT
#   Without ftp installed:
#   ./book_08_ftp_retrieve.sh: line 91: ftp: command not found
#   ls: cannot access 'debian-cd_info.tar.gz': No such file or directory
#   With ftp -n changed to cat in your copy, you see the six lines ftp would read:
#   open ftp.nl.debian.org
#   user anonymous me@linuxbox
#   cd /debian/dists/stretch/main/installer-amd64/current/images/cdrom
#   hash
#   get debian-cd_info.tar.gz
#   bye
#   ls: cannot access 'debian-cd_info.tar.gz': No such file or directory
#
# TRY THIS
#   - In your copy, change ftp -n to cat (with vi, chapter 12) and run it. Which
#     words did bash fill in?
#   - In the cat copy, put a backslash before $FTP_SERVER (\$FTP_SERVER). What
#     prints on the open line now?
#   - Feed a here document to sort, which prints lines in alphabetical order:
#     type sort << _EOF_ at the prompt, then pear, apple, fig, each on its own
#     line, then _EOF_. What prints?
#
# Below the line: the book's code, unchanged (TLCL is licensed CC BY-NC-ND 3.0;
# see LICENSE.md).
# ---------------------------------------------------------------------------

# Script to retrieve a file via FTP

FTP_SERVER=ftp.nl.debian.org
FTP_PATH=/debian/dists/stretch/main/installer-amd64/current/images/cdrom REMOTE_FILE=debian-cd_info.tar.gz

ftp -n << _EOF_
open $FTP_SERVER
user anonymous me@linuxbox
cd $FTP_PATH
hash
get $REMOTE_FILE
bye
_EOF_
ls -l "$REMOTE_FILE"
