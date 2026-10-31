# Chapter 31: Flow Control: Branching with case

*The Linux Command Line* (TLCL), chapter 31. The book is free: https://linuxcommand.org/tlcl.php

## What you will learn

- `case` compares **one value** with a list of **patterns**, from the top down, and runs the
  commands of the **first** pattern that matches; then it is done. It replaces a chain of `if`
  commands that test the same variable again and again, which is why menus are written with it.
- The shape: `case word in`, then one branch per answer (`pattern)` commands `;;`), then
  `esac` (case spelled backwards, the way `fi` closes `if`).
- Patterns are **wildcards**, the same ones you typed after `ls` in chapter 4 (`*`, `?`,
  `[ABC]`, `[[:digit:]]`). They are not regular expressions.
- `q|Q)` lets several patterns share one branch. `*)` matches anything, so it goes last and
  catches every answer you did not plan for.
- Ending a branch with `;;&` instead of `;;` (bash 4.0 and later) tells `case` to keep testing
  the patterns below, so one value can match several branches.

## Files in this folder

| File | Book name | What it shows |
|---|---|---|
| `book_01_read_menu.sh` | `read-menu` (from chapter 28) | The menu written with a chain of `if` commands: the "before" picture |
| `book_02_case_menu.sh` | `case-menu` | The same menu rewritten with `case` |
| `book_03_patterns_at_work.sh` | (no name) | Five kinds of pattern tested on one word you type |
| `book_04_case_menu_letters.sh` | `case-menu`, letter version | The menu with letters; `q\|Q)` accepts both cases |
| `book_05_case4_1.sh` | `case4-1` | Names the class of one character; stops at the first match |
| `book_06_case4_2.sh` | `case4-2` | The same with `;;&`: every class the character belongs to |

## How to run

```bash
cd ch31_flow_control_branching_with_case
chmod u+x *.sh
./book_02_case_menu.sh
```

`chmod u+x` gives you, the owner of the files (`u`), permission to execute them (`x`); `./`
means "the program is in this folder". Every script here reads one answer from the keyboard,
acts on it, and ends; to try another answer, run it again. The three menus clear the screen
first (`clear`).

You can also hand a script its answer through a pipe instead of typing it, which is quicker
when you want to try several answers in a row. The pipe `|` sends the output of the command on
its left into the command on its right (chapter 6). When the answer comes through a pipe,
`read` does not show its prompt:

```bash
echo B7 | ./book_03_patterns_at_work.sh
```

```
is A, B, or C followed by a digit.
```

If a script stops with `/bin/bash^M: bad interpreter`, the file has Windows line endings; this
fixes every script in the folder:

```bash
sed -i 's/\r$//' *.sh
```

## Walkthrough

### book_01_read_menu.sh

The chapter opens by reprinting `read-menu`, the menu from chapter 28, to show the problem
`case` solves: one variable, several possible values, and a different action for each.

```bash
#!/bin/bash

# read-menu: a menu driven system information program

clear
echo "
Please Select:

1. Display System Information
2. Display Disk Space
3. Display Home Space Utilization
0. Quit
"
read -p "Enter selection [0-3] > "

if [[ "$REPLY" =~ ^[0-3]$ ]]; then
    if [[ "$REPLY" == 0 ]]; then
        echo "Program terminated."
        exit
    fi
    if [[ "$REPLY" == 1 ]]; then
        echo "Hostname: $HOSTNAME"
        uptime
        exit
    fi
    if [[ "$REPLY" == 2 ]]; then
        df -h
        exit
    fi
    if [[ "$REPLY" == 3 ]]; then
        if [[ "$(id -u)" -eq 0 ]]; then
            echo "Home Space Utilization (All Users)"
            du -sh /home/*
        else
            echo "Home Space Utilization ($USER)"
            du -sh "$HOME"
        fi
        exit
    fi
else
    echo "Invalid entry." >&2
    exit 1
fi
```

| Line | What it does |
|---|---|
| `clear` | Empties the terminal window, so the menu starts at the top. |
| `echo "` ... `"` | One `echo` prints the whole menu. The quoted text runs over several lines, blank lines included, and `echo` prints it as typed. |
| `read -p "Enter selection [0-3] > "` | Prints the prompt and waits for you to type a line and press Enter. No variable name follows `read`, so the answer goes into `REPLY` (chapter 28). |
| `if [[ "$REPLY" =~ ^[0-3]$ ]]; then` | A regular expression test (chapter 27): `^` is the start, `[0-3]` one character from 0 to 3, `$` the end. Only a single digit from 0 to 3 passes; anything else goes to the `else` at the bottom. |
| `if [[ "$REPLY" == 0 ]]; then` ... `fi` | Answer 0: prints `Program terminated.` and `exit` ends the script. |
| `if [[ "$REPLY" == 1 ]]; then` ... `fi` | Answer 1: `$HOSTNAME` holds the computer's name; `uptime` shows how long the computer has been running. Then `exit`. |
| `if [[ "$REPLY" == 2 ]]; then` ... `fi` | Answer 2: `df -h` lists each disk with its size and free space in "human readable" units (16G). |
| `if [[ "$REPLY" == 3 ]]; then` ... `fi` | Answer 3: `id -u` prints your user ID number; 0 means the superuser, root, who gets `du -sh /home/*` (every home folder). Everyone else gets `du -sh "$HOME"`, the size of their own. |
| `else` / `echo "Invalid entry." >&2` / `exit 1` | Any other answer. `>&2` sends the message to standard error, the channel for error messages (chapter 6), and `exit 1` ends the script with exit status 1, "failure". |

Count the tests on `REPLY`: five. A fifth menu item would mean editing the regular expression
and adding a sixth `if` block. Run it and answer 9 (the screen clears first, and the menu
begins with a blank line):

```
Please Select:

1. Display System Information
2. Display Disk Space
3. Display Home Space Utilization
0. Quit

Enter selection [0-3] > 9
Invalid entry.
```

Try this:

- Answer `12`. Is that a single digit from 0 to 3? Predict the message first.
- Answer `9`, then type `echo $?` at the prompt. Which line set the 1 you see?

### book_02_case_menu.sh

The same program written with `case`. Open it next to `book_01_read_menu.sh` and compare.

```bash
#!/bin/bash

# case-menu: a menu driven system information program

clear
echo "
Please Select:

1. Display System Information
2. Display Disk Space
3. Display Home Space Utilization
0. Quit
"
read -p "Enter selection [0-3] > "

case "$REPLY" in
    0)  echo "Program terminated."
        exit
        ;;
    1)  echo "Hostname: $HOSTNAME"
        uptime
        ;;
    2)  df -h
        ;;
    3)  if [[ "$(id -u)" -eq 0 ]]; then
            echo "Home Space Utilization (All Users)"
            du -sh /home/*
        else
            echo "Home Space Utilization ($USER)"
            du -sh "$HOME"
        fi
        ;;
    *)  echo "Invalid entry" >&2
        exit 1
        ;;
esac
```

| Line | What it does |
|---|---|
| `clear`, `echo`, `read -p` | Unchanged from `read-menu`: the answer is in `REPLY`. |
| `case "$REPLY" in` | Names the value to test, once; `in` ends the line. `case` compares it with the patterns below, top to bottom. |
| `0)  echo "Program terminated."` / `exit` / `;;` | `0)` is a pattern: it matches the answer 0. `exit` ends the script; `;;` ends the branch. |
| `1)  echo "Hostname: $HOSTNAME"` / `uptime` / `;;` | Answer 1. No `exit` needed: after `;;` the `case` is finished and bash goes on after `esac`, where nothing is left, so the script ends. |
| `2)  df -h` / `;;` | Answer 2. |
| `3)  if [[ "$(id -u)" -eq 0 ]]; then` ... `fi` / `;;` | Answer 3. A branch can hold any commands, here the superuser test from `read-menu`. |
| `*)  echo "Invalid entry" >&2` / `exit 1` / `;;` | `*` matches anything, so every other answer lands here: 9, x, 12, Enter alone. This one branch replaces both the regular expression and the `else` of `read-menu`. It must be the last branch. |
| `esac` | Closes the `case` command. |

Run it twice, answering `0` and then `x`, and check the exit status after the second run:

```
Enter selection [0-3] > 0
Program terminated.
```

```
Enter selection [0-3] > x
Invalid entry
$ echo $?
1
```

Answer `3` and you see the size of your own home folder. On a test machine whose user is
`student`, it printed:

```
Home Space Utilization (student)
88K	/home/student
```

Try this:

- Add a choice `4. Display the Date` that runs `date`. Besides the new branch, which two lines
  must change? Why must the new branch go above `*)`?
- In a copy, delete the three lines of the `*)` branch and answer `9`. Nothing prints, and
  `echo $?` says 0: a `case` where no pattern matches is not an error. Nothing tells the person
  the answer was wrong.

### book_03_patterns_at_work.sh

One `case`, five kinds of pattern (the book's Table 31-1 at work). The book gives this script
no name.

```bash
#!/bin/bash

read -p "enter word > "

case "$REPLY" in
    [[:alpha:]])  echo "is a single alphabetic character." ;;
    [ABC][0-9])   echo "is A, B, or C followed by a digit." ;;
    ???)          echo "is three characters long." ;;
    *.txt)        echo "is a word ending in '.txt'" ;;
    *)            echo "is something else." ;;
esac
```

| Line | What it does |
|---|---|
| `read -p "enter word > "` | Stores the line you type in `REPLY`. |
| `[[:alpha:]])` | Exactly one alphabetic character (one letter). The outer brackets mean "one character from this set"; `[:alpha:]` inside is the name of the set. Both pairs are needed. |
| `[ABC][0-9])` | Exactly two characters: a capital A, B or C, then one digit. `[ABC]` lists the allowed characters; `[0-9]` is a range. |
| `???)` | Any three characters: each `?` stands for exactly one character of any kind. |
| `*.txt)` | Any word ending in `.txt`: `*` stands for any text, even none. |
| `*)` | Everything else, including an empty answer (Enter alone). |

Each branch fits on one line: the pattern, one command, `;;`. Five runs:

```
enter word > k
is a single alphabetic character.
enter word > B7
is A, B, or C followed by a digit.
enter word > abc
is three characters long.
enter word > notes.txt
is a word ending in '.txt'
enter word > hello
is something else.
```

`[[:alpha:]]` and `[ABC]` each match exactly one character. That is why `abc` does not fit
`[[:alpha:]]`, and why `b7` (small b) does not fit `[ABC][0-9]` and prints
`is something else.` `REPLY` keeps every character you type, spaces too: `a b` is three
characters, so it prints `is three characters long.`

Try this:

- Answer `A1`, `a1` and `x.txt`. Predict each line before you press Enter.
- In a copy, move the `*)` line to the top of the `case` and answer `k`. Why does every word
  now print `is something else.`?
- In a copy, change `[ABC]` to `[A-Z]` and answer `b7`. In bash 5 the range `[A-Z]` holds only
  the 26 capital letters, so `b7` still prints `is something else.` (see "Two claims you may
  read elsewhere" below).

### book_04_case_menu_letters.sh

`case-menu` again, now with letters for the choices.

```bash
#!/bin/bash

# case-menu: a menu driven system information program

clear
echo "
Please Select:

A. Display System Information
B. Display Disk Space
C. Display Home Space Utilization
Q. Quit
"
read -p "Enter selection [A, B, C or Q] > "

case "$REPLY" in
    q|Q) echo "Program terminated."
        exit
        ;;
    a|A) echo "Hostname: $HOSTNAME"
        uptime
        ;;
    b|B) df -h
        ;;
    c|C) if [[ "$(id -u)" -eq 0 ]]; then
            echo "Home Space Utilization (All Users)"
            du -sh /home/*
        else
            echo "Home Space Utilization ($USER)"
            du -sh "$HOME"
        fi
        ;;
    *)  echo "Invalid entry" >&2
        exit 1
        ;;
esac
```

| Line | What it does |
|---|---|
| `echo "` ... `"` and `read -p` | The menu and the prompt now show letters. |
| `q\|Q) echo "Program terminated."` | Two patterns joined by `\|`. Read the bar as "or": the answer q or the answer Q runs this branch. One bar, no spaces needed. The first command sits on the pattern's line, which works exactly like putting it on the next line. |
| `a\|A)`, `b\|B)`, `c\|C)` | The same idea for the three reports. |
| `*)` | Everything else: a digit, a whole word, Enter alone. |

The rest is the same as `book_02_case_menu.sh`. Two runs:

```
Enter selection [A, B, C or Q] > Q
Program terminated.
```

```
Enter selection [A, B, C or Q] > z
Invalid entry
```

Try this:

- Answer `quit`. Why does it reach `*)`? Change `q|Q)` to `q|Q|quit)` in a copy and try again.
- Write the first pattern as a set: `[qQ])`. The menu behaves the same. Could a set match the
  word `yes`? (A set matches one character; `yes|YES)` or `[yY][eE][sS])` would.)

### book_05_case4_1.sh

Tests one character against eight POSIX character classes.

```bash
#!/bin/bash

# case4-1: test a character

read -n 1 -p "Type a character > "
echo
case "$REPLY" in
    [[:upper:]])    echo "'$REPLY' is upper case." ;;
    [[:lower:]])    echo "'$REPLY' is lower case." ;;
    [[:alpha:]])    echo "'$REPLY' is alphabetic." ;;
    [[:digit:]])    echo "'$REPLY' is a digit." ;;
    [[:graph:]])    echo "'$REPLY' is a visible character." ;;
    [[:punct:]])    echo "'$REPLY' is a punctuation symbol." ;;
    [[:space:]])    echo "'$REPLY' is a whitespace character." ;;
    [[:xdigit:]])   echo "'$REPLY' is a hexadecimal digit." ;;
esac
```

| Line | What it does |
|---|---|
| `read -n 1 -p "Type a character > "` | `-n 1` makes `read` return after one character: you do not press Enter. The character goes into `REPLY`. |
| `echo` | Prints an empty line, so the answer starts on a new line (you never pressed Enter). |
| `[[:upper:]]` / `[[:lower:]]` / `[[:alpha:]]` | A capital letter / a small letter / any letter. |
| `[[:digit:]]` | A digit, 0 to 9. |
| `[[:graph:]]` | Any visible character (a space or a tab is not visible). |
| `[[:punct:]]` | A punctuation mark: `!`, `,`, `.`, `?` and so on. |
| `[[:space:]]` | Whitespace: a space or a tab. |
| `[[:xdigit:]]` | A hexadecimal (base 16) digit: 0 to 9, a to f, A to F. |
| `;;` at the end of every line | `case` stops at the first class that matches. |

In `echo "'$REPLY' is upper case."` the single quotes sit inside double quotes, so they print as
plain characters around the key you pressed.

```
Type a character > a
'a' is lower case.
```

The letter a is also alphabetic, visible and a hexadecimal digit, but only the first match is
reported. In fact three branches never run for a key on a US keyboard: every letter is caught
by `[[:upper:]]` or `[[:lower:]]` before `[[:alpha:]]`, every punctuation mark by `[[:graph:]]`
before `[[:punct:]]`, and every hexadecimal digit before `[[:xdigit:]]`. Pressing `!` prints
`'!' is a visible character.`, never "punctuation symbol".

Try this:

- Press `7`, then the space bar (one run each). Predict both lines.
- Press Enter instead of a character. Nothing prints: Enter ends `read`, so `REPLY` is empty,
  and no branch matches an empty value. Which pattern would you add to catch it?

### book_06_case4_2.sh

`case4-1` with every `;;` changed to `;;&`.

```bash
#!/bin/bash

# case4-2: test a character

read -n 1 -p "Type a character > "
echo
case "$REPLY" in
    [[:upper:]])    echo "'$REPLY' is upper case." ;;&
    [[:lower:]])    echo "'$REPLY' is lower case." ;;&
    [[:alpha:]])    echo "'$REPLY' is alphabetic." ;;&
    [[:digit:]])    echo "'$REPLY' is a digit." ;;&
    [[:graph:]])    echo "'$REPLY' is a visible character." ;;&
    [[:punct:]])    echo "'$REPLY' is a punctuation symbol." ;;&
    [[:space:]])    echo "'$REPLY' is a whitespace character." ;;&
    [[:xdigit:]])   echo "'$REPLY' is a hexadecimal digit." ;;&
esac
```

| Line | What it does |
|---|---|
| `read -n 1 ...` / `echo` | Same as `case4-1`. |
| The eight patterns | Same patterns, same order. |
| `;;&` at the end of every line | "Run this branch, then keep testing the patterns below it." Every class the character belongs to gets a line. After the last pattern, `case` ends. |

```
Type a character > a
'a' is lower case.
'a' is alphabetic.
'a' is a visible character.
'a' is a hexadecimal digit.
```

Pressing `7` prints three lines (a digit, visible, hexadecimal), `!` prints two (visible,
punctuation), and a space prints one (whitespace). `;;&` arrived in bash 4.0; Linux Mint and
Ubuntu ship bash 5 (`bash --version` shows yours). Use `;;` in a menu, where one answer means one
action, and `;;&` only when a value can belong to several categories.

Try this:

- Press `f`, then `g`. Why does `f` give four lines and `g` only three?
- In a copy, change only the `[[:alpha:]]` line back to `;;` and press `a`. Which lines still
  print, and why do the ones below it stop?

## case at the prompt

`case` works at the prompt too, written on one line, which is the fastest way to test a
pattern. This loop (chapter 33 explains `for`) feeds three words to one `case`:

```bash
for w in ab b zz; do case $w in a*) echo "$w: starts with a" ;; *b) echo "$w: ends with b" ;; *) echo "$w: neither" ;; esac; done
```

```
ab: starts with a
b: ends with b
zz: neither
```

`ab` fits both `a*)` and `*b)`, but only the first runs: there is no "fall through" to the next
branch, so `case` needs no `break` (unlike `switch` in C or Java, if you know it).

## Two claims you may read elsewhere

- **"An unquoted `case $REPLY in` is a syntax error when the answer is empty or has a space."**
  It is not. Bash never splits the word after `case` into pieces, so an empty answer is compared
  as an empty value and `two words` as one value. Tested in bash 5.2:

  ```bash
  REPLY=""; case $REPLY in "") echo "empty answer" ;; *) echo "something else" ;; esac
  REPLY="two words"; case $REPLY in "two words") echo "matched two words" ;; esac
  ```

  ```
  empty answer
  matched two words
  ```

  The book writes `case "$REPLY" in`, and you should too: the habit protects you where quotes do
  matter, in `[ ]` tests and in commands such as `ls "$f"`.
- **"`[A-Z]` may match small letters, depending on your locale."** That was true of older bash.
  Since bash 5.0 the option `globasciiranges` is on by default, so in a `case` pattern `[A-Z]`
  matches only the 26 capital letters. The named classes (`[[:upper:]]`) still mean the same
  thing in every tool, so they stay the safer habit.

## Common mistakes

| You type | What bash says | Fix |
|---|---|---|
| `1) date` with no `;;`, then `2) df -h ;;` on the next line | ``line 3: syntax error near unexpected token `)'`` | Add `;;` at the end of the branch **above** the line bash names: a missing `;;` is noticed only when the next pattern appears |
| A `case` with no `esac` | `syntax error: unexpected end of file` | Close every `case` with `esac` |
| `y\|\|Y)` (two bars) | ``syntax error near unexpected token `\|\|'`` | One bar: `y\|Y)`. `\|\|` is the "or" between two commands |
| `1 echo one ;;` (no `)`) | ``syntax error near unexpected token `echo'`` | Every pattern ends in `)`: `1) echo one ;;` |
| A menu with no `*)`, answered with 9 | Nothing at all, and the exit status is 0 | Add `*) echo "Invalid entry" >&2 ;;` as the last branch |
| `*)` as the first branch | No message: every answer runs `*)` and the branches below never run | Put specific patterns first and `*)` last |
| `^[0-3]$)` or `[0-9]+)` | No message: the pattern never matches `2` or `42` | Patterns are wildcards: `[0-3])`, `[0-9][0-9])`; a regular expression belongs in `[[ $x =~ ... ]]` |
| `case $REPLY in` (no quotes) | No message: it works the same | Not an error; quote it anyway, as a habit |
| A file saved on Windows | `/bin/bash^M: bad interpreter: No such file or directory` | `sed -i 's/\r$//' myscript.sh` |

## Check yourself

1. What does `;;` do at the end of a branch, and how is `;;&` different?
   <details><summary>Answer</summary><code>;;</code> ends the branch and the whole <code>case</code>:
   bash jumps to <code>esac</code>. <code>;;&amp;</code> ends the branch but keeps testing the
   patterns below it, so more branches can run (bash 4.0 and later).</details>
2. In `book_03_patterns_at_work.sh`, why does the answer `abc` not print
   `is a single alphabetic character.`?
   <details><summary>Answer</summary><code>[[:alpha:]]</code> matches exactly one character, and
   <code>abc</code> has three. It fits <code>???)</code> instead.</details>
3. A menu's `case` has no `*)` branch, and someone types 9. What happens, and what is the exit
   status?
   <details><summary>Answer</summary>Nothing prints: no pattern matches, so no branch runs. A
   <code>case</code> with no match is not an error, so the exit status is 0. Nothing tells the
   person the answer was wrong; that is why every menu ends with <code>*)</code>.</details>
4. A `case` has the branches `a*)` and then `*b)`. Which one runs for the word `ab`?
   <details><summary>Answer</summary>Only <code>a*)</code>. Both patterns match, but
   <code>case</code> runs the first match from the top and then jumps to
   <code>esac</code>.</details>
5. Is `case $REPLY in`, without quotes, a syntax error when the person presses Enter alone?
   <details><summary>Answer</summary>No. Bash never splits the word after <code>case</code>, so
   an empty answer is compared as an empty value and reaches <code>*)</code> (or a
   <code>"")</code> pattern). Quoting it is still a good habit.</details>
