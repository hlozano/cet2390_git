#!/bin/bash
# =============================================================================
# CET 2390 Operating Systems Laboratory: a textbook script, explained
# Script:   sys_info_page (stage 1 of 7), from The Linux Command Line (TLCL 19.01),
#           chapter 25, "First Stage: Minimal Document", first listing
# Code:     William Shotts. Explanations: Prof. Hernan Lozano, CityTech (CUNY)
# =============================================================================
#
# WHAT IT DOES
#   Prints a minimal web page (an HTML document) on the screen. This is stage 1 of
#   sys_info_page, the report program the book builds in chapters 25 to 27. It
#   holds no system information yet: the first stage only has to run.
#
# HOW IT WORKS
#   1. `#!/bin/bash` and `# Program to output a system information page` are the
#      shebang and a comment, as in chapter 24.
#   2. Eight `echo` commands follow, one for each line of the page. Each one prints
#      the text between its double quotes, spaces included, and ends the line.
#   3. The text is HTML, the language of web pages. A word in angle brackets is a
#      tag: `<html>` opens the page and `</html>` (with a slash) closes it. The
#      `<head>` part holds the `<title>`, which the browser shows on its tab; the
#      `<body>` part holds what appears in the window, here the words Page body.
#   4. The spaces inside the quotes only indent the HTML, so a person can see which
#      tag sits inside which. A browser ignores them.
#   5. The page goes to standard output, the screen. To see it as a web page, save
#      it in a file with > and open the file in a browser (see RUN IT).
#
# NEW IN THIS SCRIPT
#   HTML          the text format of web pages: <tag> ... </tag> around content
#   <title>       the page title, shown on the browser tab
#   <body>        the part of the page shown in the browser window
#   > file        sends a command's output into a file instead of to the screen
#                 (redirection; chapter 6 covers it fully)
#
# RUN IT
#   chmod u+x book_01_sys_info_page.sh
#   ./book_01_sys_info_page.sh
#   To view the page in a browser (> creates a file, so use a practice folder):
#   mkdir -p ~/playground
#   ./book_01_sys_info_page.sh > ~/playground/sys_info_page.html
#   firefox ~/playground/sys_info_page.html
#
# OUTPUT
#   <html>
#     <head>
#          <title>Page Title</title>
#     </head>
#     <body>
#          Page body.
#     </body>
#   </html>
#   In the browser, the tab says Page Title and the window says Page body.
#
# TRY THIS
#   - Copy the script (cp book_01_sys_info_page.sh mine.sh), change Page body. to
#     a sentence about yourself, run the copy and save its output. What does the
#     browser show when you reload the page?
#   - In the copy, change Page Title to your name. Where does it appear in the
#     browser: in the window or on the tab?
#   - Count the echo commands. How many would a 40-line page need? Stage 2 shows
#     a shorter way.
#
# Below the line: the book's code, unchanged (TLCL is licensed CC BY-NC-ND 3.0;
# see LICENSE.md).
# ---------------------------------------------------------------------------

# Program to output a system information page

echo "<html>"
echo "  <head>"
echo "       <title>Page Title</title>"
echo "  </head>"
echo "  <body>"
echo "       Page body."
echo "  </body>"
echo "</html>"
