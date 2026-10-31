#!/bin/bash
# =============================================================================
# CET 2390 Operating Systems Laboratory: a textbook script, explained
# Script:   sys_info_page (stage 3 of 7), from The Linux Command Line (TLCL 19.01),
#           chapter 25, "Second Stage: Adding a Little Data"
# Code:     William Shotts. Explanations: Prof. Hernan Lozano, CityTech (CUNY)
# =============================================================================
#
# WHAT IT DOES
#   The page gets its first real content: a title and a heading that both say
#   System Information Report.
#
# HOW IT WORKS
#   1. What changed from stage 2: `<title>Page Title</title>` became
#      `<title>System Information Report</title>`.
#   2. In the body, the words Page body. were replaced by
#      `<h1>System Information Report</h1>`. The tag <h1> marks a top-level
#      heading: the browser shows it in large bold letters.
#   3. It is still one echo with one double-quoted string; the indents are now 8
#      and 16 spaces, as the book prints them.
#   4. The problem this stage creates: the words System Information Report are
#      typed twice. In a long script, changing the title would mean finding every
#      copy, and a missed copy makes the page disagree with itself. Stage 4 fixes
#      this with a variable.
#
# NEW IN THIS SCRIPT
#   <h1> ... </h1>   a top-level heading in a web page
#
# RUN IT
#   chmod u+x book_03_sys_info_page.sh
#   ./book_03_sys_info_page.sh
#
# OUTPUT
#   <html>
#           <head>
#                   <title>System Information Report</title>
#           </head>
#           <body>
#                   <h1>System Information Report</h1>
#           </body>
#   </html>
#
# TRY THIS
#   - In a copy, change the words in the <title> line only. Save the output in
#     ~/playground and open it in the browser: what do the tab and the heading say?
#   - Add <h2>Uptime</h2> on a new line under the <h1> line. How does an <h2>
#     heading look next to the <h1>? (Chapter 26 uses <h2> for its sections.)
#
# Below the line: the book's code, unchanged (TLCL is licensed CC BY-NC-ND 3.0;
# see LICENSE.md).
# ---------------------------------------------------------------------------

# Program to output a system information page

echo "<html>
        <head>
                <title>System Information Report</title>
        </head>
        <body>
                <h1>System Information Report</h1>
        </body>
</html>"
