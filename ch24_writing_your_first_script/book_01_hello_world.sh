#!/bin/bash
# =============================================================================
# CET 2390 Operating Systems Laboratory: a textbook script, explained
# Script:   hello_world, from The Linux Command Line (TLCL 19.01), chapter 24,
#           "Script File Format"
# Code:     William Shotts. Explanations: Prof. Hernan Lozano, CityTech (CUNY)
# =============================================================================
#
# WHAT IT DOES
#   The book's first script: it prints Hello World! and stops. It is tiny on
#   purpose, so all your attention goes to the three kinds of line every
#   script has.
#
# HOW IT WORKS
#   1. `#!/bin/bash` (line 1) is the shebang. When you run the file, Linux reads
#      this line to learn which program should read the rest of the file: here,
#      bash. It must be the very first line, with nothing before the #!.
#   2. `# This is our first script.` is a comment. Bash skips every line that
#      starts with #, so comments are notes for the people who read the script.
#      (This whole block you are reading is comments too.)
#   3. Blank lines are skipped as well; they only make the script easier to read.
#   4. `echo 'Hello World!'` is an ordinary command, exactly what you would type
#      at the prompt. The single quotes keep the ! from being treated as a
#      special character, so it prints as an exclamation mark.
#
# NEW IN THIS SCRIPT
#   #!/bin/bash   the shebang: names the program that runs the script
#   # text        a comment: bash ignores it
#   chmod u+x     gives you, the file's owner (u), permission to execute (x) it
#   ./name        runs a program in the current folder (. means "this folder")
#
# RUN IT
#   chmod u+x book_01_hello_world.sh
#   ./book_01_hello_world.sh
#
# OUTPUT
#   Hello World!
#
# TRY THIS
#   - Run it as book_01_hello_world.sh (no ./). Why does bash answer
#     "command not found"? (Hint: echo $PATH lists where bash looks.)
#   - Make a copy, add a second line: echo "I am $USER". Run the copy.
#   - In the copy, add the commands pwd and ls on new lines at the end. A script
#     can run any command you already know: what does the copy print now?
#
# Below the line: the book's code, unchanged (TLCL is licensed CC BY-NC-ND 3.0;
# see LICENSE.md).
# ---------------------------------------------------------------------------

# This is our first script.

echo 'Hello World!'
