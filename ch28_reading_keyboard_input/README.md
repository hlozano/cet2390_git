# Chapter 28: Reading Keyboard Input

*The Linux Command Line* (TLCL), chapter 28. The book is free: https://linuxcommand.org/tlcl.php

## What you will learn

- `read` makes a script **interactive**: it stops, waits for one line of **standard input**
  (what you type, up to the Enter key) and stores it in the variables you name. With no
  variable named, the whole line goes into the shell variable `REPLY`.
- With several variables, `read` splits the line into words: too few words leave the extra
  variables empty, too many all land in the last variable.
- Options shape the question: `-p` prompts on the same line, `-s` hides the typing, `-t` gives
  up after a number of seconds, `-e -i` offers a default answer.
- `IFS` decides where one field ends and the next begins. `IFS=":" read ...` splits at colons
  for that one command, and a **here string** (`<<<`) hands `read` a line of text. You
  **cannot pipe** into `read`.
- A person can type anything, so a script **validates** every answer before using it: empty
  first, then its shape, then its range.
- A **menu program** shows the choices, reads one, checks it, and acts on it.

## Files in this folder

| File | Book name | What it shows |
|---|---|---|
| `book_01_test_integer2.sh` | `test-integer2` | Chapter 27's integer test, with the value written into the script: the problem `read` solves |
| `book_02_read_integer.sh` | `read-integer` | An `echo -n` prompt, `read int`, then the integer tests |
| `book_03_read_multiple.sh` | `read-multiple` | One line into five variables |
| `book_04_read_single.sh` | `read-single` (first version) | `read` with no variable: the line goes into `REPLY` |
| `book_05_read_single.sh` | `read-single` (second version) | `read -p`: the prompt moves into the `read` command |
| `book_06_read_secret.sh` | `read-secret` | `-s` hides the typing, `-t 10` sets a time limit, `read` as the test of an `if` |
| `book_07_read_default.sh` | `read-default` | `-e -i`: a default answer you accept with Enter |
| `book_08_read_ifs.sh` | `read-ifs` | `IFS=":"` and a here string split a line of `/etc/passwd` |
| `book_09_read_validate.sh` | `read-validate` | Checking input: empty, several words, filename, file exists, floating point, integer |
| `book_10_read_menu.sh` | `read-menu` | A menu program: show, read, check, act |

## How to run

```bash
cd ch28_reading_keyboard_input
chmod u+x *.sh
./book_02_read_integer.sh
```

Every script except `book_01` stops at a `read` and waits for you: type an answer and press
Enter. A script that seems frozen is waiting for input. Ctrl-c stops a script at any time.

If a script stops with `/bin/bash^M: bad interpreter`, the file has Windows line endings; this
fixes every script in the folder:

```bash
sed -i 's/\r$//' *.sh
```

### Feeding the answer instead of typing it

This guide often hands a script its answer in the command itself, so you can repeat a run
exactly:

```bash
./book_02_read_integer.sh <<< 5
printf 'a b c\n' | ./book_05_read_single.sh
```

- `<<<` is a **here string**: the text after it, followed by an Enter, becomes the script's
  input, as if you had typed it.
- `printf` prints its text and turns each `\n` into a new line, one per answer. The pipe `|`
  (chapter 6) hands that output to the script as its input.

Two things look different from a typed run:

1. What you type is not on the screen, because you did not type it. With an `echo -n` prompt,
   the script's first line of output joins the prompt line.
2. A prompt made with `read -p` does not appear at all: `read -p` prints its prompt only when
   the input comes from a terminal (a person at the keyboard).

```bash
$ ./book_02_read_integer.sh <<< 5
Please enter an integer -> 5 is positive.
5 is odd.
$ ./book_05_read_single.sh <<< "a b c"
REPLY = 'a b c'
```

Each walkthrough below shows the typed run as you see it on the screen, then a fed run where
it helps.

## Walkthrough

### book_01_test_integer2.sh

The chapter opens with a script from chapter 27, to show what is missing.

```bash
#!/bin/bash

# test-integer2: evaluate the value of an integer.

INT=-5

if [[ "$INT" =~ ^-?[0-9]+$ ]]; then
    if [ "$INT" -eq 0 ]; then
        echo "INT is zero."
    else
        if [ "$INT" -lt 0 ]; then
            echo "INT is negative."
        else
            echo "INT is positive."
        fi
        if [ $((INT % 2)) -eq 0 ]; then
            echo "INT is even."
        else
            echo "INT is odd."
        fi
    fi
else
    echo "INT is not an integer." >&2
    exit 1
fi
```

| Line | What it does |
|---|---|
| `INT=-5` | Stores the value to test. To test another number you must edit this line: the problem this chapter solves. |
| `if [[ "$INT" =~ ^-?[0-9]+$ ]]; then` | Checks the shape first. `=~` compares the text with a regular expression: `^` start, `-?` an optional minus, `[0-9]+` one or more digits, `$` end. |
| `if [ "$INT" -eq 0 ]; then` | Equal to zero? Safe now, because only integers get here. |
| `if [ "$INT" -lt 0 ]; then` ... `else` | Less than zero: negative; otherwise positive. |
| `if [ $((INT % 2)) -eq 0 ]; then` | `%` gives the remainder after dividing by 2: 0 means even. |
| `echo "INT is not an integer." >&2` | `>&2` sends the message to standard error, the channel for error messages. |
| `exit 1` | Ends the script with status 1: something went wrong. |

```bash
$ ./book_01_test_integer2.sh
INT is negative.
INT is odd.
```

Try this:

- Copy it (`cp book_01_test_integer2.sh mine.sh`), set `INT=0`, then `INT=8`, and run the copy
  each time. Why does 0 print only one line?
- Set `INT=five` in the copy and run it, then `echo $?`. What does status 1 tell you?

### book_02_read_integer.sh

The same tests, but the number comes from the keyboard.

```bash
#!/bin/bash

# read-integer: evaluate the value of an integer.

echo -n "Please enter an integer -> "
read int

if [[ "$int" =~ ^-?[0-9]+$ ]]; then
    if [ "$int" -eq 0 ]; then
        echo "$int is zero."
    else
        if [ "$int" -lt 0 ]; then
            echo "$int is negative."
        else
            echo "$int is positive."
        fi
        if [ $((int % 2)) -eq 0 ]; then
            echo "$int is even."
        else
            echo "$int is odd."
        fi
    fi
else
    echo "Input value is not an integer." >&2
    exit 1
fi
```

| Line | What it does |
|---|---|
| `echo -n "Please enter an integer -> "` | Prints the question. `-n` leaves out the newline, so the cursor waits on the same line. |
| `read int` | Waits for one line of input and stores it in the variable `int`. No `$`: `read` fills the variable. |
| `if [[ "$int" =~ ^-?[0-9]+$ ]]; then` | The shape check, now essential: a person can type anything. |
| the rest | The code of `book_01`, with `INT` changed to `$int` and the number printed in each message. |

`read` is a **builtin**: a command built into bash itself, so `help read` (not `man read`)
describes it.

Typed at the keyboard (you type `5` and press Enter):

```bash
$ ./book_02_read_integer.sh
Please enter an integer -> 5
5 is positive.
5 is odd.
```

Other answers: `-8` prints `-8 is negative.` and `-8 is even.`; `0` prints `0 is zero.`; and
`five`, `4.5` or a bare Enter print `Input value is not an integer.` with exit status 1.

Try this:

- Type `    7` (spaces first). The spaces are gone: `read` drops spaces at the start and end of
  the line when it fills a named variable.
- Type `-0`. Is it zero? Why? (`-eq` compares numbers, not text.)
- Type `08`. It prints `08 is positive.`, then stops with
  `value too great for base (error token is "08")`. Inside `$(( ))`, a number that starts with
  0 is read in base 8 (octal), where 8 is not a digit. The regular expression cannot see that.

### book_03_read_multiple.sh

One `read`, five variables.

```bash
#!/bin/bash

# read-multiple: read multiple values from keyboard

echo -n "Enter one or more values > "
read var1 var2 var3 var4 var5

echo "var1 = '$var1'"
echo "var2 = '$var2'"
echo "var3 = '$var3'"
echo "var4 = '$var4'"
echo "var5 = '$var5'"
```

| Line | What it does |
|---|---|
| `echo -n "Enter one or more values > "` | Prints the question. |
| `read var1 var2 var3 var4 var5` | Splits the line into words at spaces and tabs and hands them out in order: first word to `var1`, second to `var2`, and so on. |
| `echo "var1 = '$var1'"` (five lines) | Prints each variable between single quotes, so you see exactly where it starts and ends; `''` means empty. |

The two rules: **too few words**, and the leftover variables are set to empty; **too many**,
and the last variable gets everything left over, spaces and all. Three typed runs:

```bash
$ ./book_03_read_multiple.sh
Enter one or more values > a b c d e
var1 = 'a'
var2 = 'b'
var3 = 'c'
var4 = 'd'
var5 = 'e'
$ ./book_03_read_multiple.sh
Enter one or more values > a
var1 = 'a'
var2 = ''
var3 = ''
var4 = ''
var5 = ''
$ ./book_03_read_multiple.sh
Enter one or more values > a b c d e f g
var1 = 'a'
var2 = 'b'
var3 = 'c'
var4 = 'd'
var5 = 'e f g'
```

Try this:

- Before you run it, write down what `var5` will hold for `one two three four five six`.
- Type `   a     b   ` with many spaces. How many variables are filled? Do the spaces show?
- In a copy, read into just `first last` and type `Mary Ann Lopez`. Where does `Ann` go?

### book_04_read_single.sh

`read` with no variable name.

```bash
#!/bin/bash

# read-single: read multiple values into default variable

echo -n "Enter one or more values > "
read

echo "REPLY = '$REPLY'"
```

| Line | What it does |
|---|---|
| `echo -n "Enter one or more values > "` | Prints the question. |
| `read` | No variable named: the whole line goes into the shell variable `REPLY`, unsplit, even the spaces at its start and end. |
| `echo "REPLY = '$REPLY'"` | Prints it between single quotes. |

```bash
$ ./book_04_read_single.sh
Enter one or more values > a b c d
REPLY = 'a b c d'
$ ./book_04_read_single.sh <<< "   spaced   out   "
Enter one or more values > REPLY = '   spaced   out   '
```

`REPLY` is handy for a quick answer that you check once and act on, such as a menu choice.
It is one variable, reused: the next bare `read` overwrites it. An answer you need later
belongs in a variable with a name that says what it holds.

Try this:

- In a copy, change `read` to `read line` and print `$line`. Feed it `"   spaced   out   "`.
  Which spaces are gone?
- In a copy, put a second `read` under the first and type two different lines. Which one is
  in `REPLY` at the end?

### book_05_read_single.sh

The same program with `read -p`. The book keeps the name `read-single`.

```bash
#!/bin/bash

# read-single: read multiple values into default variable

read -p "Enter one or more values > "
echo "REPLY = '$REPLY'"
```

| Line | What it does |
|---|---|
| `read -p "Enter one or more values > "` | Prints the prompt and waits, in one command: it replaces `echo -n` plus `read`. This is the form to use. |
| `echo "REPLY = '$REPLY'"` | Prints the answer, which went into `REPLY` as before. |

Typed, the screen is the same as `book_04`. Fed, the prompt is gone, because `read -p` prints
its prompt only for a terminal (and on standard error, not standard output):

```bash
$ ./book_05_read_single.sh
Enter one or more values > a b c d
REPLY = 'a b c d'
$ ./book_05_read_single.sh <<< "a b c d"
REPLY = 'a b c d'
```

Try this:

- Feed `book_04` and `book_05` the same here string. Which one shows its prompt, and why?
- In a copy, delete the space before the closing quote of the prompt and type an answer.
  What does the screen look like? (End every prompt with a space.)

### book_06_read_secret.sh

A hidden answer with a time limit. Type a made-up phrase, never a real password: the script
prints what you typed so you can see what `read` stored.

```bash
#!/bin/bash

# read-secret: input a secret passphrase

if read -t 10 -sp "Enter secret passphrase > " secret_pass; then
    echo -e "\nSecret passphrase = '$secret_pass'"
else
    echo -e "\nInput timed out" >&2
    exit 1
fi
```

| Line | What it does |
|---|---|
| `if read -t 10 -sp "..." secret_pass; then` | `-t 10`: give up after 10 seconds. `-s`: silent, the typing does not show. `-p`: the prompt. `-sp` is `-s` and `-p` together; `-p` comes last because the text after it is its prompt. The `read` is the test of the `if`: status 0 when a line arrived, non-zero when the time ran out or the input ended. |
| `echo -e "\nSecret passphrase = '$secret_pass'"` | `-s` hid even your Enter, so the cursor is still on the prompt line. `-e` turns `\n` into a new line, which moves the output down first. |
| `echo -e "\nInput timed out" >&2` | The failure message, on standard error. |
| `exit 1` | Ends with status 1. |

Typed at the keyboard (`open sesame` does not appear while you type it):

```bash
$ ./book_06_read_secret.sh
Enter secret passphrase >
Secret passphrase = 'open sesame'
```

Wait ten seconds without typing:

```bash
$ ./book_06_read_secret.sh
Enter secret passphrase >
Input timed out
$ echo $?
1
```

`read` itself returns 142 on a timeout (any status above 128 means the time ran out); the
script turns every failure into exit 1. Pressing Ctrl-d (end of input) at the prompt also makes
`read` fail, so the script prints `Input timed out` although no time ran out: the script cannot
tell the two apart.

Try this:

- In a copy, change `-sp` to `-ps`. Bash reports
  ``read: `Enter secret passphrase > ': not a valid identifier``, and the script then says
  `Input timed out`. Why? (Now `s` is the prompt, and the prompt text is taken as a variable
  name.)
- In a copy, remove the `\n` from the first `echo`. Where does the output start?

### book_07_read_default.sh

An answer already filled in.

```bash
#!/bin/bash

# read-default: supply a default value if user presses Enter key.

read -e -p "What is your user name? " -i $USER
echo "You answered: '$REPLY'"
```

| Line | What it does |
|---|---|
| `read -e -p "What is your user name? " -i $USER` | `-i` puts the value of `USER` (your login name) on the input line, ready to accept with Enter or to edit. `-i` works only with `-e`, which turns on Readline: the same line editing you have at the prompt (arrow keys, Backspace, Ctrl-a). No variable is named, so the answer goes into `REPLY`. |
| `echo "You answered: '$REPLY'"` | Prints the answer. |

Press Enter without typing (the machine used here has the user `student`; you see your own
name, the one `whoami` prints):

```bash
$ ./book_07_read_default.sh
What is your user name? student
You answered: 'student'
```

Two things a current system adds to the book's description:

- The default appears only when a person types at a terminal. Fed input is taken as it is:
  `./book_07_read_default.sh <<< ""` prints `You answered: ''`.
- The book writes `$USER` without quotes. If `USER` is empty or unset, `-i` has nothing after
  it. Git Bash on Windows does not set `USER`, and there the script prints:

```text
./book_07_read_default.sh: line 65: read: -i: option requires an argument
read: usage: read [-ers] [-a array] [-d delim] [-i text] [-n nchars] [-N nchars] [-p prompt] [-t timeout] [-u fd] [name ...]
You answered: ''
```

  In your own scripts, quote it: `-i "$USER"`. (Line 65 is the `read` line in this study copy,
  below the explanation block.)

Try this:

- Press Backspace three times, type another name, press Enter. What lands in `REPLY`?
- In a copy, remove `-e`. Does the default still appear?

### book_08_read_ifs.sh

Split one line of `/etc/passwd` into fields. Run it on Linux: Git Bash on Windows has no
`/etc/passwd`.

```bash
#!/bin/bash

# read-ifs: read fields from a file

FILE=/etc/passwd

read -p "Enter a username > " user_name

file_info="$(grep "^$user_name:" $FILE)"

if [ -n "$file_info" ]; then
    IFS=":" read user pw uid gid name home shell <<< "$file_info"
    echo "User =      '$user'"
    echo "UID =       '$uid'"
    echo "GID =       '$gid'"
    echo "Full Name = '$name'"
    echo "Home Dir. = '$home'"
    echo "Shell =     '$shell'"
else
    echo "No such user '$user_name'" >&2
    exit 1
fi
```

`/etc/passwd` lists the accounts on the system, one per line, seven fields separated by colons:
name, password, user ID (UID), group ID (GID), full name, home folder, shell. Look at one line:

```bash
$ grep "^root:" /etc/passwd
root:x:0:0:root:/root:/bin/bash
```

| Line | What it does |
|---|---|
| `FILE=/etc/passwd` | The file to search. Every user may read it; the script changes nothing. |
| `read -p "Enter a username > " user_name` | Asks for a name. |
| `file_info="$(grep "^$user_name:" $FILE)"` | `$( )` (command substitution) stores grep's output in `file_info`. `^name:` means the name at the start of the line followed by a colon, so `ann` cannot match `anna`. |
| `if [ -n "$file_info" ]; then` | `-n`: true when the string is not empty, that is, grep found the line. |
| `IFS=":" read user pw uid gid name home shell <<< "$file_info"` | Splits the line at the colons into seven variables. See "IFS and here strings" below. |
| `echo "User =      '$user'"` (six lines) | Print six fields. `pw` is never printed: on current systems it is only an `x`, because the password hashes live in `/etc/shadow`, which only root can read. |
| `echo "No such user '$user_name'" >&2` and `exit 1` | No line found: an error message and status 1. |

**IFS and here strings.** The line `IFS=":" read ... <<< "$file_info"` has three parts:

- `IFS`, the **Internal Field Separator**, is the variable that tells `read` where one field
  ends and the next begins. Its normal value is a space, a tab and a newline, which is why
  `book_03` split at spaces.
- An assignment written **in front of a command** changes the variable for that one command
  only. After this line, `IFS` is back to normal. (The book shows the long way too: save `IFS`
  in another variable, set it, run `read`, put the old value back.)
- `<<<` is a **here string**: the text after it becomes the command's standard input. It is a
  one-line cousin of the here document (`<< _EOF_`, chapter 25).

Typed at the keyboard:

```bash
$ ./book_08_read_ifs.sh
Enter a username > root
User =      'root'
UID =       '0'
GID =       '0'
Full Name = 'root'
Home Dir. = '/root'
Shell =     '/bin/bash'
$ ./book_08_read_ifs.sh <<< nosuchuser
No such user 'nosuchuser'
```

For your own account (`./book_08_read_ifs.sh <<< "$USER"`) the UID is usually `1000` and the
home folder `/home/` plus your name. The full name may be empty, or end in commas
(`Student,,,`): the commas separate extra items, such as a room or phone number, left empty.

Try this:

- Type `Root` with a capital R. Why is there no such user?
- At the prompt, run `IFS=":" read a b rest <<< "a:b:c:d"` and then `echo "$rest"`. Why does
  `rest` hold `c:d`, colon included?
- Why does the book use a here string and not `echo "$file_info" | IFS=":" read ...`? Read
  "You cannot pipe into read" below.

### book_09_read_validate.sh

One item, checked several ways.

```bash
#!/bin/bash

# read-validate: validate input

invalid_input () {
    echo "Invalid input '$REPLY'" >&2
    exit 1
}

read -p "Enter a single item > "

# input is empty (invalid)
[[ -z "$REPLY" ]] && invalid_input

# input is multiple items (invalid)
(( "$(echo "$REPLY" | wc -w)" > 1 )) && invalid_input

# is input a valid filename?
if [[ "$REPLY" =~ ^[-[:alnum:]\._]+$ ]]; then
    echo "'$REPLY' is a valid filename."
    if [[ -e "$REPLY" ]]; then
        echo "And file '$REPLY' exists."
    else
        echo "However, file '$REPLY' does not exist."
    fi

    # is input a floating point number?
    if [[ "$REPLY" =~ ^-?[[:digit:]]*\.[[:digit:]]+$ ]]; then
        echo "'$REPLY' is a floating point number."
    else
        echo "'$REPLY' is not a floating point number."
    fi

    # is input an integer?
    if [[ "$REPLY" =~ ^-?[[:digit:]]+$ ]]; then
        echo "'$REPLY' is an integer."
    else
        echo "'$REPLY' is not an integer."
    fi
else
    echo "The string '$REPLY' is not a valid filename."
fi
```

| Line | What it does |
|---|---|
| `invalid_input () { ... }` | A shell function (chapter 26): prints the bad answer on standard error and ends the script with status 1. One function gives every check the same message and status. |
| `read -p "Enter a single item > "` | The answer goes into `REPLY`. |
| `[[ -z "$REPLY" ]] && invalid_input` | `-z`: true for an empty string. `&&` runs the command on its right only when the one on its left succeeded. A check like this at the top, which stops the script on bad input, is a **guard clause**. |
| `(( "$(echo "$REPLY" \| wc -w)" > 1 )) && invalid_input` | `wc -w` counts the words; `(( ... > 1 ))` is an arithmetic test, true for two words or more. |
| `if [[ "$REPLY" =~ ^[-[:alnum:]\._]+$ ]]; then` | A valid filename: one or more characters, each a hyphen, a letter or digit (`[:alnum:]`), a dot or an underscore. Inside `[ ]` a dot is already an ordinary dot, so the backslash before it is not needed. |
| `if [[ -e "$REPLY" ]]; then` | `-e`: true when a file or folder with that name exists in the current folder. The script only tests. |
| `^-?[[:digit:]]*\.[[:digit:]]+$` | A floating point number: optional minus, any number of digits (even none), a real dot (`\.`; a bare `.` would mean any character), then at least one digit. |
| `^-?[[:digit:]]+$` | An integer, as in `book_02`. |
| `echo "The string '$REPLY' is not a valid filename."` | Any other character (a slash, a `*`, a comma). This is ordinary output, with exit status 0. |

The order of the checks is the rule for every script that reads input: **empty first, then
the shape** (a regular expression), **then the range or meaning** (here: does the file exist).

Typed at the keyboard:

```bash
$ ./book_09_read_validate.sh
Enter a single item > 3.14
'3.14' is a valid filename.
However, file '3.14' does not exist.
'3.14' is a floating point number.
'3.14' is not an integer.
```

Fed answers (no prompt, because the input is not a terminal):

| You feed | It prints |
|---|---|
| `<<< ""` | `Invalid input ''` (status 1) |
| `<<< "two words"` | `Invalid input 'two words'` (status 1) |
| `<<< -7` | a valid filename, does not exist, not a floating point number, an integer |
| `<<< .5` | a valid filename, does not exist, a floating point number, not an integer |
| `<<< book_09_read_validate.sh` | a valid filename, `And file 'book_09_read_validate.sh' exists.`, not a floating point number, not an integer |
| `<<< a/b` | `The string 'a/b' is not a valid filename.` (status 0) |

Try this:

- The script can print nine different messages. Find an answer for each.
- Type three spaces and press Enter. Neither guard clause stops it: a bare `read` keeps the
  spaces, so `REPLY` is not empty, and `wc -w` counts zero words. Which check catches it?
- `5.` (dot last) is not a floating point number by this pattern. Which part of the pattern
  decides that?

### book_10_read_menu.sh

The first menu program.

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

**The shape of a menu program.** Every menu program has the same parts, and this script has
them in order:

1. **Show** the choices: `clear` wipes the window, and one `echo` prints the whole menu (the
   quoted text runs over several lines, and `echo` prints its line breaks as they are).
2. **Read** one choice: `read -p "Enter selection [0-3] > "` stores it in `REPLY`.
3. **Check** it: `[[ "$REPLY" =~ ^[0-3]$ ]]` accepts exactly one character, a digit from 0 to
   3. Anything else goes to the `else` at the bottom.
4. **Act** on it: one `if` per choice.
5. **Repeat** until the user picks Quit. This script does not have that part yet: every choice
   ends with `exit`. Chapter 29 puts the menu in a loop.

| Line | What it does |
|---|---|
| `clear` | Wipes the terminal window so the menu starts at the top. |
| `echo "` ... `"` | Prints the menu, blank lines included. |
| `read -p "Enter selection [0-3] > "` | The choice goes into `REPLY`. |
| `if [[ "$REPLY" =~ ^[0-3]$ ]]; then` | One digit from 0 to 3, nothing before or after it. `12`, `9`, a word or a bare Enter fail. |
| `if [[ "$REPLY" == 0 ]]; then` ... `exit` | Quit: prints `Program terminated.` and ends. `exit` with no number keeps the status of the last command. |
| `echo "Hostname: $HOSTNAME"`, `uptime` | Choice 1: `HOSTNAME` is a variable bash sets to the computer's name; `uptime` shows how long the system has been running. |
| `df -h` | Choice 2: free space on each file system, `-h` for sizes in K, M and G. |
| `if [[ "$(id -u)" -eq 0 ]]; then` | Choice 3: `id -u` prints your user ID; 0 is root, who may measure every folder in `/home` with `du -sh /home/*`. |
| `du -sh "$HOME"` | Anyone else: the total size (`-s`) of your own home folder, in K, M or G (`-h`). |
| `echo "Invalid entry." >&2` and `exit 1` | Any other answer: an error message and status 1. |

The book itself notes that many `exit` lines make a program harder to follow; the loop in
chapter 29 removes them.

Typed at the keyboard, choice 3 (the window is cleared first; the size and user name are those
of the machine used here):

```text

Please Select:

1. Display System Information
2. Display Disk Space
3. Display Home Space Utilization
0. Quit

Enter selection [0-3] > 3
Home Space Utilization (student)
88K     /home/student
```

Choice 2 prints the `df` table, which starts with
`Filesystem      Size  Used Avail Use% Mounted on`; choice 0 prints `Program terminated.`.
Fed an invalid choice:

```bash
$ ./book_10_read_menu.sh <<< 9

Please Select:

1. Display System Information
2. Display Disk Space
3. Display Home Space Utilization
0. Quit

Invalid entry.
$ echo $?
1
```

Try this:

- Type `12`. Why is it invalid when 1 and 2 are both choices?
- Choose 2. Does the menu come back? What would you need so that it does? (Chapter 29,
  `book_02_while_menu.sh` in `ch29_flow_control_looping_with_while_until`.)

## The options of read

The book's Table 28-1, with the ones you will use most at the top. `help read` lists them all.

| Option | What it does | Used in |
|---|---|---|
| `-p "prompt"` | Print a prompt, then wait on the same line (only when input comes from a terminal) | `book_05` to `book_10` |
| `-s` | Silent: what you type does not show | `book_06` |
| `-t seconds` | Give up after that many seconds; `read` then returns a status above 128 | `book_06` |
| `-e` | Use Readline: edit the answer with the arrow keys | `book_07` |
| `-i "text"` | Start with `text` as the answer (needs `-e`; terminal only) | `book_07` |
| `-n num` | Stop after `num` characters, without waiting for Enter | |
| `-r` | Raw: keep backslashes as they are | |
| `-d char` | Stop at `char` instead of at the end of the line | |
| `-a name` | Put the words into an array (chapter 35) | |
| `-u fd` | Read from file descriptor `fd` instead of standard input | |

Options can be stacked, as with `ls -la`: `-sp` is `-s` plus `-p`. The option that takes a
value goes last, right before its value.

None of the book's scripts use `-r`, but it is a good habit. Without it, `read` treats a
backslash as an escape and removes it:

```bash
$ read x <<< 'C:\Users\ann'; echo "x = '$x'"
x = 'C:Usersann'
$ read -r x <<< 'C:\Users\ann'; echo "x = '$x'"
x = 'C:\Users\ann'
```

`-n 1` waits for a single key, handy for a yes or no. It does not print a new line for you,
so add `echo` after it:

```bash
read -n 1 -p "Continue? [y/n] " answer; echo
echo "You pressed: $answer"
```

## You cannot pipe into read

This looks right and does nothing:

```bash
$ echo "foo" | read
$ echo "REPLY = '$REPLY'"
REPLY = ''
```

There is no error, and no value. Bash runs each part of a pipeline in a **subshell**: a copy
of the shell with a copy of its variables. `read` does put `foo` in `REPLY`, but in the copy,
and the copy is thrown away as soon as the pipeline ends. A copy can never change the
variables of the shell that started it.

Feed `read` without a pipe and there is no copy, so the variable survives:

```bash
$ read <<< "foo"
$ echo "REPLY = '$REPLY'"
REPLY = 'foo'
```

That is why `book_08` uses a here string. Piping into a **script**
(`printf 'a b c\n' | ./book_05_read_single.sh`) is fine: the whole script runs on the right of
the pipe, and it uses its variables before it ends. The problem is only a `read` whose
variables you want to use after the pipeline is over.

## Common mistakes

| You type | What bash says | Fix |
|---|---|---|
| A script that waits forever | Nothing: it is waiting at a `read` | Type an answer and press Enter; Ctrl-c stops the script |
| `read $name` | Nothing, but the answer goes into `REPLY` (or a strange variable), not `name` | No `$` when `read` fills a variable: `read name` |
| `read -p "Name?" name` | The screen shows `Name?Ann` | End the prompt with a space: `"Name? "` |
| `read -ps "PIN: " pin` | ``read: `PIN: ': not a valid identifier`` | The option that takes a value goes last: `read -sp "PIN: " pin` |
| `[ "$int" -lt 0 ]` with `five` | `[: five: integer expression expected` | Check the shape first: `[[ "$int" =~ ^-?[0-9]+$ ]]` |
| `08` typed into `book_02` | `08: value too great for base (error token is "08")` | `$(( ))` reads a leading 0 as base 8. In your own scripts, refuse leading zeros in the shape check: `^-?(0\|[1-9][0-9]*)$` |
| `echo "foo" \| read` | Nothing; `REPLY` stays empty | Use a here string: `read <<< "foo"` |
| `read -e -p "User? " -i $USER` when `USER` is empty | `read: -i: option requires an argument` | Quote it: `-i "$USER"` |
| `book_08` run in Git Bash on Windows | `grep: /etc/passwd: No such file or directory`, then `No such user` | Run it on Linux |
| A prompt that does not appear | Nothing: the input was fed, not typed | Normal for `read -p`; type the answer to see the prompt |
| `/bin/bash^M: bad interpreter` | The file has Windows line endings | `sed -i 's/\r$//' *.sh` |

## Check yourself

1. You run `read a b` and type `one two three`. What is in `a` and in `b`?
   <details><summary>Answer</summary><code>a</code> is <code>one</code> and <code>b</code> is
   <code>two three</code>: the last variable gets everything left over.</details>
2. A script runs `read` with no variable name. Where is the answer, and what happens to it at
   the next bare `read`?
   <details><summary>Answer</summary>In the shell variable <code>REPLY</code>. The next bare
   <code>read</code> overwrites it, so keep an answer you need later in a named variable.</details>
3. Why does `./book_05_read_single.sh <<< hi` print no prompt?
   <details><summary>Answer</summary><code>read -p</code> prints its prompt only when the input
   comes from a terminal. Here the input is a here string, so there is no prompt.</details>
4. What does `IFS=":" read a b c <<< "x:y:z"` do, and what is `IFS` afterwards?
   <details><summary>Answer</summary>It splits the text at the colons: <code>a</code> is
   <code>x</code>, <code>b</code> is <code>y</code>, <code>c</code> is <code>z</code>. The
   assignment in front of <code>read</code> lasts for that command only, so <code>IFS</code>
   is back to space, tab and newline.</details>
5. `echo "hi" | read x` runs without an error, yet `x` is empty afterwards. Why?
   <details><summary>Answer</summary>The pipe runs <code>read</code> in a subshell, a copy of
   the shell. The copy sets <code>x</code> and is then thrown away, and the original shell's
   <code>x</code> never changed. Use <code>read x &lt;&lt;&lt; "hi"</code> instead.</details>
