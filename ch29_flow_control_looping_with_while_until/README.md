# Chapter 29: Flow Control: Looping with while / until

*The Linux Command Line* (TLCL), chapter 29. The book is free: https://linuxcommand.org/tlcl.php

## What you will learn

- A **loop** repeats a block of commands. `while` runs the block as long as its test command
  succeeds (exit status 0); `until` runs it as long as the test fails.
- A counting loop needs three parts: a **start** value, a **test**, and a **change**. Leave out
  the change and the loop never ends (Ctrl-c stops it).
- `break` leaves a loop at once; `continue` skips the rest of this pass and starts the next.
  `while true` is an endless loop that only `break` (or `exit`) can end.
- A menu inside a loop comes back after every choice, until the user picks Quit: the shape of
  every menu program.
- `while read ...; do ...; done < file` handles a file one line per pass. You can also pipe into
  a loop, but then it runs in a **subshell** and any variable it sets is lost when it ends.

## Files in this folder

| File | Book name | What it shows |
|---|---|---|
| `book_01_while_count.sh` | `while-count` | Count 1 to 5 with a `while` loop |
| `book_02_while_menu.sh` | `while-menu` | Chapter 28's menu inside a `while` loop: it repeats until you choose 0 |
| `book_03_while_menu2.sh` | `while-menu2` | The same menu as an endless loop, with `break` and `continue` |
| `book_04_until_count.sh` | `until-count` | Count 1 to 5 with `until`: the test turned around |
| `book_05_while_read.sh` | `while-read` | Read `distros.txt` one line per pass, fed by `done < distros.txt` |
| `book_06_while_read2.sh` | `while-read2` | The same loop fed by `sort` through a pipe |
| `book_distros.txt` | `distros.txt` | The book's data file: 16 lines, three fields separated by tabs (name, version, release date) |

## How to run

```bash
cd ch29_flow_control_looping_with_while_until
chmod u+x *.sh
./book_01_while_count.sh
```

If a script stops with `/bin/bash^M: bad interpreter`, the file has Windows line endings; this
fixes every script in the folder:

```bash
sed -i 's/\r$//' *.sh
```

A loop that never ends and a script waiting at a `read` look the same: nothing happens. Type an
answer; if nothing changes, press **Ctrl-c** to stop the script.

### Feeding answers to the menu scripts

`book_02` and `book_03` wait for your choices. You can also hand them a list of answers:

```bash
printf '9\n3\n0\n' | ./book_02_while_menu.sh
```

`printf` prints its text and turns each `\n` into a new line, so this is three answers: 9, 3
and 0, each followed by Enter. The pipe `|` (chapter 6) hands them to the script as its input.
The prompts do not appear, because `read -p` prints its prompt only when a person types at a
terminal. **Always end the list with 0**: when the fed answers run out, every `read` fails and
leaves `REPLY` empty, an empty answer is never 0, and the menu prints `Invalid entry.` forever
(Ctrl-c stops it).

### The distros.txt scripts

`book_05` and `book_06` read a file named exactly `distros.txt` in the folder you run them
from. The book made that file in chapter 20; here it is `book_distros.txt`. Work on copies in a
practice folder, so the chapter folder stays as it is:

```bash
mkdir -p ~/playground
cp book_distros.txt ~/playground/distros.txt
cp book_05_while_read.sh book_06_while_read2.sh ~/playground/
cd ~/playground
./book_05_while_read.sh
./book_06_while_read2.sh
```

`cd -` takes you back to the chapter folder afterwards.

## Walkthrough

### book_01_while_count.sh

The first loop.

```bash
#!/bin/bash

# while-count: display a series of numbers

count=1

while [[ "$count" -le 5 ]]; do
    echo "$count"
    count=$((count + 1))
done
echo "Finished."
```

| Line | What it does |
|---|---|
| `count=1` | The **start**: the counter begins at 1. |
| `while [[ "$count" -le 5 ]]; do` | The **test**, run before every pass (one run of the body). `while` looks only at the exit status, as `if` does: 0 runs the body again, anything else ends the loop. `-le` is "less than or equal to". |
| `echo "$count"` | The body, first line: print the number. |
| `count=$((count + 1))` | The **change**: work out `count + 1` and store it back in `count` (no `$` on the left of `=`). |
| `done` | The end of the body: back to the `while` line for the next test. |
| `echo "Finished."` | The first line after the loop, reached when the test fails. |

Pass by pass:

| Test | `count` | Result | The body prints | `count` becomes |
|---|---|---|---|---|
| 1st | 1 | `1 -le 5` succeeds | 1 | 2 |
| 2nd to 5th | 2 to 5 | succeeds | 2, 3, 4, 5 | 3 to 6 |
| 6th | 6 | `6 -le 5` fails | (loop ends) | |

```bash
$ ./book_01_while_count.sh
1
2
3
4
5
Finished.
```

`do` may also sit on a line of its own (then no `;` is needed before it). The test runs before
the first pass too, so a loop whose test fails at the start runs zero times.

Try this:

- In a copy (`cp book_01_while_count.sh mine.sh`), count to 10, then count by 2
  (`count=$((count + 2))`). Which line changes each time?
- Set `count=9` in the copy. What prints?
- Delete the change line in the copy and run it. It prints 1 forever: press Ctrl-c. Why does
  the test never fail?

### book_02_while_menu.sh

Chapter 28's menu program (`book_10_read_menu.sh` in `ch28_reading_keyboard_input`), now
inside a loop.

```bash
#!/bin/bash

# while-menu: a menu driven system information program

DELAY=3 # Number of seconds to display results

while [[ "$REPLY" != 0 ]]; do
    clear
    cat <<- _EOF_
		Please Select:

		1. Display System Information
		2. Display Disk Space
		3. Display Home Space Utilization
		0. Quit

	_EOF_
    read -p "Enter selection [0-3] > "

    if [[ "$REPLY" =~ ^[0-3]$ ]]; then
        if [[ $REPLY == 1 ]]; then
            echo "Hostname: $HOSTNAME"
            uptime
            sleep "$DELAY"
        fi
        if [[ "$REPLY" == 2 ]]; then
            df -h
            sleep "$DELAY"
        fi
        if [[ "$REPLY" == 3 ]]; then
            if [[ "$(id -u)" -eq 0 ]]; then
                echo "Home Space Utilization (All Users)"
                du -sh /home/*
            else
                echo "Home Space Utilization ($USER)"
                du -sh "$HOME"
            fi
            sleep "$DELAY"
        fi
    else
        echo "Invalid entry."
        sleep "$DELAY"
    fi
done
echo "Program terminated."
```

**The shape of a menu program.** Every menu program you will write follows this pattern:

| Part | In this script |
|---|---|
| **Repeat** until the user quits | `while [[ "$REPLY" != 0 ]]; do` ... `done` |
| **Show** the choices | `clear`, then the here document |
| **Read** one choice | `read -p "Enter selection [0-3] > "` |
| **Check** it | `[[ "$REPLY" =~ ^[0-3]$ ]]`, with `Invalid entry.` for anything else |
| **Act** on it | one `if` block per choice, each ending with a pause |
| **Quit** | 0 matches no block, and the `while` test ends the loop |

| Line | What it does |
|---|---|
| `DELAY=3 # Number of seconds ...` | The pause length, kept in one variable. The text after `#` is a comment. |
| `while [[ "$REPLY" != 0 ]]; do` | Repeat while the last answer is not 0. `REPLY` is empty when the script starts, and empty is not 0, so the first pass always runs. |
| `clear` | Wipe the window so each menu starts at the top. |
| `cat <<- _EOF_` ... `_EOF_` | A here document (chapter 25): the lines up to `_EOF_` become `cat`'s input. The `-` in `<<-` removes **tabs** at the start of each line, so the menu can be indented in the script and still print at the left edge. The indent in this file is made of tab characters; keep them as tabs if you retype it. |
| `read -p "Enter selection [0-3] > "` | The choice goes into `REPLY`. |
| `if [[ "$REPLY" =~ ^[0-3]$ ]]; then` | One digit from 0 to 3, nothing else. |
| `if [[ $REPLY == 1 ]]; then` ... `sleep "$DELAY"` | Choices 1, 2, 3: the same commands as chapter 28's menu (host name and `uptime`, `df -h`, `du -sh`), then a 3-second pause, so you can read the result before `clear` wipes it. |
| `echo "Invalid entry."` and `sleep "$DELAY"` | Anything else: a message, a pause, and the menu comes back. One wrong key no longer ends the program. |
| `done` | Back to the `while` test. After a 0 the test `0 != 0` fails and the loop ends. |
| `echo "Program terminated."` | The first line after the loop. |

What changed from chapter 28's `read-menu`: the `exit` lines are gone (the loop decides when to
stop), the `sleep` lines are new, the menu is a here document instead of an `echo`, and
`Invalid entry.` is no longer an error exit.

Typed at the keyboard: `9`, then `0`. The window is cleared before each menu, so you see one
menu at a time. The first screen:

```text
Please Select:

1. Display System Information
2. Display Disk Space
3. Display Home Space Utilization
0. Quit

Enter selection [0-3] > 9
Invalid entry.
```

Three seconds later the window clears and the menu returns:

```text
Please Select:

1. Display System Information
2. Display Disk Space
3. Display Home Space Utilization
0. Quit

Enter selection [0-3] > 0
Program terminated.
```

Fed with `printf '9\n3\n0\n' | ./book_02_while_menu.sh`, the same happens without prompts:
the menu, `Invalid entry.`, the menu, your home folder's size (on the machine used here
`Home Space Utilization (student)` and `204K    /home/student`), the menu, `Program terminated.`

Try this:

- Press Enter without typing. Why is an empty answer invalid, while the empty `REPLY` at the
  start lets the loop begin?
- In a copy, set `DELAY=0` and choose 2. Can you read the disk table before the menu returns?
- In a copy, replace the tabs in front of `_EOF_` with spaces and run it. Bash warns
  ``here-document at line ... delimited by end-of-file (wanted `_EOF_')`` and stops with
  `syntax error: unexpected end of file`. Why?

### book_03_while_menu2.sh

The same menu as an endless loop.

```bash
#!/bin/bash

# while-menu2: a menu driven system information program

DELAY=3 # Number of seconds to display results

while true; do
    clear
    cat <<- _EOF_
		Please Select:

		1. Display System Information
		2. Display Disk Space
		3. Display Home Space Utilization
		0. Quit

	_EOF_
    read -p "Enter selection [0-3] > "

    if [[ "$REPLY" =~ ^[0-3]$ ]]; then
        if [[ "$REPLY" == 1 ]]; then
            echo "Hostname: $HOSTNAME"
            uptime
            sleep "$DELAY"
            continue
        fi
        if [[ "$REPLY" == 2 ]]; then
            df -h
            sleep "$DELAY"
            continue
        fi
        if [[ "$REPLY" == 3 ]]; then
            if [[ "$(id -u)" -eq 0 ]]; then
                echo "Home Space Utilization (All Users)"
                du -sh /home/*
            else
                echo "Home Space Utilization ($USER)"
                du -sh "$HOME"
            fi
            sleep "$DELAY"
            continue
        fi
        if [[ "$REPLY" == 0 ]]; then
            break
        fi
    else
        echo "Invalid entry."
        sleep "$DELAY"
    fi
done
echo "Program terminated."
```

| Line | What it does |
|---|---|
| `while true; do` | An **endless loop**: `true` is a command that does nothing and always succeeds, so the test never fails. The loop can only end from inside. |
| `clear`, the here document, `read -p`, `=~ ^[0-3]$` | Show, read and check: the same as `book_02` (and the same tabs in the here document). |
| `continue` (after choices 1, 2 and 3) | Skip the rest of this pass and go straight back to the `while` line. Once a choice is handled there is no reason to test the others. |
| `if [[ "$REPLY" == 0 ]]; then break; fi` | `break` leaves the loop at once; the script goes on after `done`. This is the only way out. |
| `echo "Invalid entry."` | Bad input: a message, a pause, and the next pass shows the menu again. |
| `echo "Program terminated."` | Runs after `break`. |

`break` and `continue` work in every `while` and `until` loop (and in the `for` loops of
chapter 33). Both act on the loop they sit in. `while :` means the same as `while true`: `:`
is another command that always succeeds.

Compared with `book_02`, the quit test moved from the `while` line into the body. What you see
on the screen is the same. Typed: `3`, then `0` (size and user name from the machine used
here):

```text
Please Select:

1. Display System Information
2. Display Disk Space
3. Display Home Space Utilization
0. Quit

Enter selection [0-3] > 3
Home Space Utilization (student)
204K    /home/student
```

Three seconds later the menu returns; type `0` and the script prints `Program terminated.`
Fed answers work as for `book_02`: `printf 'x\n3\n0\n' | ./book_03_while_menu2.sh`.

Try this:

- Find the line where this program ends. There is no test on the `while` line, so which line
  is the only way out?
- In a copy, delete the `if` block for choice 0. How can you leave the program now?
- In a copy, delete the `continue` after choice 1 and choose 1. Does the screen change? (No:
  the later tests just fail. Here `continue` only saves work.)

### book_04_until_count.sh

`book_01` written with `until`.

```bash
#!/bin/bash

# until-count: display a series of numbers

count=1

until [[ "$count" -gt 5 ]]; do
    echo "$count"
    count=$((count + 1))
done
echo "Finished."
```

| Line | What it does |
|---|---|
| `count=1` | The start, as before. |
| `until [[ "$count" -gt 5 ]]; do` | `until` runs the body as long as the test **fails**, and stops when it succeeds. So the test is turned around: `-le 5` ("still 5 or less") became `-gt 5` ("greater than 5": time to stop). |
| `echo "$count"` and `count=$((count + 1))` | The same body: print, then add 1. |
| `done`, `echo "Finished."` | Back to the test; at 6 the test `6 -gt 5` succeeds, the loop ends, and `Finished.` prints. |

```bash
$ ./book_04_until_count.sh
1
2
3
4
5
Finished.
```

| | `while` | `until` |
|---|---|---|
| Runs the body when the test | succeeds (status 0) | fails (status not 0) |
| Stops when the test | fails | succeeds |
| Read it as | "as long as ..." | "up to the moment that ..." |

Any `while` loop can be written as an `until` loop by turning the test around. The book's
advice: choose the one whose test reads most clearly. You will write `while` far more often.

Try this:

- In a copy, change `until` to `while` and leave the test alone. Why does only `Finished.`
  print?
- Change `-gt 5` to `-eq 5`. How many numbers print now, and why?

### book_05_while_read.sh

A file, one line per pass. It needs `distros.txt` (see "The distros.txt scripts" above).

```bash
#!/bin/bash

# while-read: read lines from a file

while read distro version release; do
    printf "Distro: %s\tVersion: %s\tReleased: %s\n" \
        "$distro" \
        "$version" \
        "$release"
done < distros.txt
```

| Line | What it does |
|---|---|
| `while read distro version release; do` | `read` is the loop's test. Each pass it takes the next line and splits it at the tabs into three variables (chapter 28: spaces and tabs both separate fields). It returns 0 while there is a line to read. |
| `printf "Distro: %s\tVersion: %s\tReleased: %s\n" \` | `printf` (chapter 21 of the book) prints the first string with each `%s` replaced by the next argument; `\t` is a tab and `\n` a new line. The `\` at the end of the line joins it to the next, so one command fits on four lines. |
| `"$distro"`, `"$version"`, `"$release"` | The three values for the three `%s`. |
| `done < distros.txt` | A **redirection**: `<` makes the file the standard input of the whole loop, so every `read` inside it takes the next line of the file instead of waiting for the keyboard. The file is opened once. |

At the end of the file there is nothing left to read: `read` returns a non-zero status, and
that ends the `while`.

The output has 16 lines, one for each line of the file, in the file's order. The first four
are below. The `Released:` field shows the date from the release date column of the file; it
is written here as `<date>`. The terminal turns each tab into spaces up to the next tab stop,
so the columns line up:

```text
Distro: SUSE    Version: 10.2   Released: <date>
Distro: Fedora  Version: 10     Released: <date>
Distro: SUSE    Version: 11.0   Released: <date>
Distro: Ubuntu  Version: 8.04   Released: <date>
```

Run without `distros.txt` in the current folder, it prints only
`./book_05_while_read.sh: line 77: distros.txt: No such file or directory`.

Try this:

- Run `cat distros.txt` and compare it with the output. Which line does `read` take on the
  first pass, and on the last?
- In a copy, change the `read` line to `read distro rest` and print `$rest`. What lands in
  `rest`? (The last variable gets the rest of the line.)

### book_06_while_read2.sh

The same loop, fed through a pipe. It needs `distros.txt` too.

```bash
#!/bin/bash

# while-read2: read lines from a file

sort -k 1,1 -k 2n distros.txt | while read distro version release; do

    printf "Distro: %s\tVersion: %s\tReleased: %s\n" \
        "$distro" \
        "$version" \
        "$release"
done
```

| Line | What it does |
|---|---|
| `sort -k 1,1 -k 2n distros.txt` | Sorts the lines: by field 1 only (`-k 1,1`, the name), then lines with the same name by field 2 as a number (`-k 2n`, the version), so Fedora 9 comes before Fedora 10. Sorted as text, `10` would come first. |
| `\| while read distro version release; do` | The pipe sends `sort`'s output into the loop, so each `read` takes the next sorted line. That is why there is no `< distros.txt` after `done`. |
| `printf ...` | The same as in `book_05`. |
| `done` | The end of the loop. |

The output: the same 16 lines, sorted. The six Fedora lines (versions 5 to 10), then SUSE
(10.1 to 11.0), then Ubuntu (6.06 to 8.10). The first seven, with the release date column
again written as `<date>`:

```text
Distro: Fedora  Version: 5      Released: <date>
Distro: Fedora  Version: 6      Released: <date>
Distro: Fedora  Version: 7      Released: <date>
Distro: Fedora  Version: 8      Released: <date>
Distro: Fedora  Version: 9      Released: <date>
Distro: Fedora  Version: 10     Released: <date>
Distro: SUSE    Version: 10.1   Released: <date>
```

**The catch: a piped loop runs in a subshell.** Bash runs every part of a pipeline in a
subshell, a copy of the shell with a copy of its variables. Here the whole loop is in that
copy, so any variable the loop sets disappears when the loop ends. This script sets nothing it
needs afterwards, so it works. A counter does not survive; try both forms at the prompt, in
`~/playground` where `distros.txt` is:

```bash
$ count=0
$ while read line; do count=$((count + 1)); done < distros.txt
$ echo "$count"
16
$ count=0
$ sort distros.txt | while read line; do count=$((count + 1)); done
$ echo "$count"
0
```

With `done < distros.txt` there is no pipe and no copy, so the loop changes the shell's own
`count`. With the pipe, the copy counted to 16 and was thrown away. It is the same rule that
stops you from piping into `read` (chapter 28). When a loop must set a variable you use later,
feed it with `done < file`.

Without `distros.txt`, this script prints
`sort: cannot read: distros.txt: No such file or directory` and still ends with status 0: a
pipeline's status is that of its last part, the loop, which simply found no lines.

Try this:

- In a copy, remove `-k 2n`. Where does Fedora 10 go now, and why?
- Change the sort to `sort -k 2n distros.txt` (version only). Which distributions end up next
  to each other?

## Common mistakes

| You type | What bash says | Fix |
|---|---|---|
| A loop with no change line | Nothing: the same line prints forever | Ctrl-c, then add the change, such as `count=$((count + 1))` |
| `$count=$((count + 1))` | `1=2: command not found` (and the loop never ends) | No `$` on the left of `=`: `count=$((count + 1))` |
| `while [[ "$count" -le 5 ]]` with no `; do` | ``syntax error near unexpected token `done'`` | `while [[ "$count" -le 5 ]]; do` |
| A `while` with no `done` | `syntax error: unexpected end of file` | Close every loop with `done` |
| `_EOF_` indented with spaces under `<<-` | ``warning: here-document at line ... delimited by end-of-file (wanted `_EOF_')``, then `syntax error: unexpected end of file` | Indent the here document with tabs: `<<-` removes leading tabs only |
| `break` outside a loop | ``break: only meaningful in a `for', `while', or `until' loop`` | Use `break` only inside a loop; `exit` ends the whole script |
| Fed menu answers without a final 0 | `Invalid entry.` forever | Ctrl-c; end the answers with 0 |
| `./book_05_while_read.sh` with no `distros.txt` | `distros.txt: No such file or directory` | Copy `book_distros.txt` to `distros.txt` in the folder you run it from |
| `while read line < distros.txt; do` | Nothing: it reads the first line forever | The file reopens every pass; put the redirection after `done` |
| A counter set in a piped loop | It is 0 after `done` | The pipe ran the loop in a subshell; feed it with `done < file` |
| `continue` before the change line | Nothing: the count sticks and the loop never ends | Put the change line first in the body |
| `/bin/bash^M: bad interpreter` | The file has Windows line endings | `sed -i 's/\r$//' *.sh` |

## Check yourself

1. What is the difference between `while` and `until`?
   <details><summary>Answer</summary><code>while</code> runs the body as long as its test
   succeeds (exit status 0); <code>until</code> runs it as long as the test fails. Turning the
   test around turns one into the other.</details>
2. In `book_01_while_count.sh`, what is `count` when the loop ends, and why does `Finished.`
   print only once?
   <details><summary>Answer</summary><code>count</code> is 6: the test <code>6 -le 5</code>
   fails. <code>echo "Finished."</code> is after <code>done</code>, outside the loop, so it runs
   once, after the last pass.</details>
3. In `book_02_while_menu.sh`, why does the menu appear at all on the first pass, when nothing
   has been typed yet?
   <details><summary>Answer</summary><code>REPLY</code> is empty when the script starts, and an
   empty string is not 0, so <code>[[ "$REPLY" != 0 ]]</code> succeeds and the first pass
   runs.</details>
4. What do `break` and `continue` do?
   <details><summary>Answer</summary><code>break</code> leaves the loop at once, and the script
   goes on after <code>done</code>. <code>continue</code> skips the rest of this pass and goes
   back to the test for the next one.</details>
5. A loop counts lines with `count=$((count + 1))`. Fed by `done < distros.txt` it ends with
   16; fed by `sort distros.txt |` it ends with 0. Why?
   <details><summary>Answer</summary>A pipe runs the loop in a subshell, a copy of the shell.
   The copy counts to 16 and is thrown away when the loop ends, so the original
   <code>count</code> is still 0. With the redirection there is no copy.</details>
