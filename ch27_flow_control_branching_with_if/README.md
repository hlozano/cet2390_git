# Chapter 27: Flow Control: Branching with if

*The Linux Command Line* (TLCL), chapter 27. The book is free: https://linuxcommand.org/tlcl.php

## What you will learn

- Every command ends with an **exit status**, a number from 0 to 255: 0 means success and any
  other number means failure. `$?` shows the last one; `exit N` sets it for a script and
  `return N` for a function.
- `if` runs a command and chooses what to do next by that command's exit status. `elif` adds
  more tests, `else` catches whatever is left, and `fi` closes the block.
- `test`, usually written `[ ]`, is the command `if` runs most often. It has **file**
  expressions (`-e -f -d -r -w -x`), **string** expressions (`-z -n = !=`) and **integer**
  expressions (`-eq -ne -lt -le -gt -ge`). Quote every variable inside it.
- Bash has two tests of its own: `[[ ]]` adds `=~` (match a regular expression) and `==`
  (match a wildcard pattern), and `(( ))` tests whole numbers with the signs from math class.
- Tests combine with AND, OR and NOT (`&&` `||` `!` inside `[[ ]]`, `-a` `-o` `!` inside
  `[ ]`), and `&&` and `||` between two commands make a one-line branch.
- The report program `sys_info_page` uses `if` to adapt to the person who runs it.

## Files in this folder

| File | Book name | What it shows |
|---|---|---|
| `book_01_if_x_equals_5.sh` | (no name; the chapter's first example) | The first `if` / `else`: does x equal 5? |
| `book_02_test_file.sh` | `test-file` | File expressions on `~/.bashrc`; `exit 1` when the file does not exist |
| `book_03_test_file_function.sh` | `test_file` | The same checks as a function that ends with `return 1` |
| `book_04_test_string.sh` | `test-string` | String expressions, an `elif` chain, an error message sent to standard error |
| `book_05_test_integer.sh` | `test-integer` | Integer expressions: zero, negative or positive; even or odd |
| `book_06_test_integer2.sh` | `test-integer2` | `[[ ]]` and `=~` reject anything that is not a whole number |
| `book_07_test_integer2a.sh` | `test-integer2a` | The same tests written with `(( ))` |
| `book_08_test_integer3.sh` | `test-integer3` | A range check: AND with `&&` inside `[[ ]]` |
| `book_09_test_integer3_with_test.sh` | `test-integer3`, coded with `test` | The same range check: AND with `-a` inside `[ ]` |
| `book_10_test_integer4.sh` | `test-integer4` | Outside the range: NOT with `!` and parentheses inside `[[ ]]` |
| `book_11_test_integer4_with_test.sh` | `test-integer4`, coded with `test` | The same with `[ ]`: `!` and escaped parentheses `\( \)` |
| `book_12_sys_info_page.sh` | `sys_info_page` | The report checks `id -u`: every home folder for the superuser, your own for anyone else |

Where the book prints only a replacement for part of an earlier listing ("We could have also
coded this using test"), the file is **assembled**: the earlier listing with the new part put in
place, so it runs on its own. The comment block at the top of each file says so.

## How to run

```bash
cd ch27_flow_control_branching_with_if
chmod u+x *.sh
./book_01_if_x_equals_5.sh
echo $?
```

`echo $?` right after a script shows the exit status it ended with. Most of these scripts test
a value written near the top (`x=5`, `FILE=~/.bashrc`, `ANSWER=maybe`, `INT=-5`, `INT=50`). To
see the other branches, copy the script (`cp book_05_test_integer.sh try.sh`), change the value
in the copy with vi, **predict** what it will print, and then run `./try.sh`. If a script stops
with `/bin/bash^M: bad interpreter`, the file has Windows line endings; this fixes it:

```bash
sed -i 's/\r$//' *.sh
```

## Walkthrough

### book_01_if_x_equals_5.sh

The book starts with pseudocode, a plan written for people: "X = 5. If X = 5, say 'X equals
5.' Otherwise, say 'X is not equal to 5.'" Here it is in bash. (Open the file to see the code
with the full explanation at the top.)

```bash
#!/bin/bash
x=5

if [ "$x" -eq 5 ]; then
    echo "x equals 5."
else
    echo "x does not equal 5."
fi
```

| Line | What it does |
|---|---|
| `#!/bin/bash` | The shebang: run this file with bash. The book prints this example without it; it was added so the file runs as a script. |
| `x=5` | Stores 5 in the variable `x`. No spaces around `=`. |
| `if [ "$x" -eq 5 ]; then` | Runs the command `[ "$x" -eq 5 ]` and looks at its exit status. Status 0 (true): bash runs the lines after `then`. The `;` is needed because `then` shares the line with the test. |
| `echo "x equals 5."` | Runs only when the test succeeded. |
| `else` | Starts the lines that run when the test failed. |
| `echo "x does not equal 5."` | Skipped this time. |
| `fi` | Ends the `if` statement ("if" spelled backwards). |

**What `if` really checks: the exit status.** Every command ends with a number from 0 to 255,
its exit status. 0 means success; any other number means failure. The special parameter `$?`
holds the status of the last command:

```bash
$ ls -d /usr/bin
/usr/bin
$ echo $?
0
$ ls -d /bin/usr
ls: cannot access '/bin/usr': No such file or directory
$ echo $?
2
$ echo $?
0
```

The last `echo $?` prints 0 because it reports on the `echo` just before it: `$?` changes after
every command, so save it right away (`status=$?`) if you need it later. (The book prints the
`ls` message without the quotes around `'/bin/usr'`; current versions of `ls` add them.)

| Status | Meaning |
|---|---|
| 0 | Success. In a test: true |
| 1 | The most common failure. In a test: false |
| 2 | `test` uses it for an error (it could not compare); `ls` uses it for serious trouble, such as a missing file. `man ls` lists the codes under "Exit status" |
| 127 | Command not found |

**What `[` is.** `[` is a command, another name for the command `test`. It checks the
expression between the brackets, prints nothing, and ends with status 0 if the expression is
true or 1 if it is false. Because it is a command, it needs a space after it, and the closing
`]` (its last argument) needs a space before it. `test -d /etc` and `[ -d /etc ]` are the same
command. `-eq` means "is equal to" for whole numbers (integers).

Run it:

```bash
$ ./book_01_if_x_equals_5.sh
x equals 5.
```

Try this (in a copy: `cp book_01_if_x_equals_5.sh try.sh`):

- Change `x=5` to `x=0`. Predict the line, then run `./try.sh`.
- Change it to `x=05`. `-eq` compares numbers, so 05 and 5 are equal: it prints
  `x equals 5.`
- Change it to `x=five`. Bash prints `./try.sh: line 63: [: five: integer expression expected`
  and then `x does not equal 5.` The test could not compare, so it ended with status 2, and
  `if` treats every status except 0 as failure.

### book_02_test_file.sh

`test-file` asks a series of questions about one pathname, `~/.bashrc`, your shell's settings
file.

```bash
#!/bin/bash

# test-file: Evaluate the status of a file

FILE=~/.bashrc

if [ -e "$FILE" ]; then
    if [ -f "$FILE" ]; then
        echo "$FILE is a regular file."
    fi
    if [ -d "$FILE" ]; then
        echo "$FILE is a directory."
    fi
    if [ -r "$FILE" ]; then
        echo "$FILE is readable."
    fi
    if [ -w "$FILE" ]; then
        echo "$FILE is writable."
    fi
    if [ -x "$FILE" ]; then
        echo "$FILE is executable/searchable."
    fi
else
    echo "$FILE does not exist"
    exit 1
fi

exit
```

| Line | What it does |
|---|---|
| `# test-file: ...` | A comment with the book's name for the script. |
| `FILE=~/.bashrc` | Stores the pathname. The `~` is not in quotes, so bash expands it to your home folder: `/home/yourname/.bashrc`. |
| `if [ -e "$FILE" ]; then` | The first question: does the file exist (`-e`)? Every other test is **nested** inside this `if`, so it runs only for a file that exists. |
| `if [ -f "$FILE" ]; then` ... `fi` | Is it a regular file (`-f`), not a directory or a device? If so, say so. No `else`: when the test is false, nothing prints. |
| `if [ -d "$FILE" ]; then` ... `fi` | Is it a directory (`-d`)? |
| `if [ -r "$FILE" ]; then` ... `fi` | May you read it (`-r`)? |
| `if [ -w "$FILE" ]; then` ... `fi` | May you write (change) it (`-w`)? |
| `if [ -x "$FILE" ]; then` ... `fi` | May you execute it (`-x`)? For a directory, `-x` means you may enter and search it. |
| `else` | Belongs to the first `if`: the file does not exist. |
| `echo "$FILE does not exist"` | The message. (It goes to standard output; `book_04` shows the better habit of sending error messages to standard error with `>&2`.) |
| `exit 1` | Ends the script at once with exit status 1, so whoever ran it knows it failed. |
| `exit` | With no number, ends the script with the status of the last command that ran. A formality: a script that "runs off the end" does the same. |

**Why every `$FILE` is in double quotes.** If `FILE` were empty, an unquoted `[ -e $FILE ]`
would shrink to `[ -e ]`. A test with one word only asks "is this text not empty?", and `-e`
is not empty, so the test says **true** for a file that does not exist. With quotes, test
receives an empty string and answers honestly:

```bash
$ F=
$ [ -e $F ]; echo $?
0
$ [ -e "$F" ]; echo $?
1
```

The book's Table 27-1 lists 21 file expressions. The six in this script are the ones you will
use most; three more worth knowing are `-s file` (exists and is not empty), `-L file` (is a
symbolic link) and `file1 -nt file2` (file1 is newer than file2).

Run it (the output below came from a user named `student`; you will see your own home folder):

```bash
$ ./book_02_test_file.sh
/home/student/.bashrc is a regular file.
/home/student/.bashrc is readable.
/home/student/.bashrc is writable.
$ echo $?
0
```

Try this (in a copy: `cp book_02_test_file.sh try.sh`); predict first, then run:

- `FILE=/etc`. A directory you may read and search, but not write: three lines, and no
  "regular file" or "writable" line.
- `FILE=/etc/shadow` (the system's password hashes). It exists and is a regular file, but you
  may not read or write it: one line only.
- `FILE=/nowhere`. One line, `/nowhere does not exist`, and `echo $?` shows 1.
- `FILE="~/.bashrc"`, with the quotes. Bash does not expand `~` inside quotes, so the script
  looks for a folder literally named `~` and says `~/.bashrc does not exist`.

### book_03_test_file_function.sh

The book's next step: the same checks inside a **function** (chapter 26) named `test_file`, the
way you would put them into a larger program.

```bash
#!/bin/bash
test_file () {

    # test-file: Evaluate the status of a file

    FILE=~/.bashrc

    if [ -e "$FILE" ]; then
        if [ -f "$FILE" ]; then
            echo "$FILE is a regular file."
        fi
        if [ -d "$FILE" ]; then
            echo "$FILE is a directory."
        fi
        if [ -r "$FILE" ]; then
            echo "$FILE is readable."
        fi
        if [ -w "$FILE" ]; then
            echo "$FILE is writable."
        fi
        if [ -x "$FILE" ]; then
            echo "$FILE is executable/searchable."
        fi
    else
        echo "$FILE does not exist"
        return 1
    fi

}
# added: call the function; the script then ends with the function's exit status
test_file
```

| Line | What it does |
|---|---|
| `test_file () {` | Starts the function definition. Defining a function runs nothing; bash only stores the lines under the name `test_file`. |
| `FILE=~/.bashrc` ... the five `if` blocks | The same as `book_02`, line for line. |
| `return 1` | Replaces `book_02`'s `exit 1`. It ends **only the function** and hands exit status 1 back to the line that called it. |
| `}` | Ends the function. When the file exists, the function gets here without a `return` and returns the status of the last command it ran: 0. `book_02`'s final `exit` is gone, because a function must not end the script. |
| `# added: ...` | Not in the book. The book prints only the function; this comment and the next line were added so the file does something when you run it. |
| `test_file` | Calls the function. It is the script's last command, so the script ends with the function's exit status. |

**What the pair shows.** `book_02` and `book_03` print the same lines. The difference is what
stops: `exit` ends the whole script, wherever it is; `return` ends only the function, and the
script carries on with the next line after the call.

Run it:

```bash
$ ./book_03_test_file_function.sh
/home/student/.bashrc is a regular file.
/home/student/.bashrc is readable.
/home/student/.bashrc is writable.
$ echo $?
0
```

Try this (in a copy: `cp book_03_test_file_function.sh try.sh`):

- Change `FILE=~/.bashrc` to `FILE=/nowhere` and add `echo "back from test_file, status $?"`
  as the last line. It prints `/nowhere does not exist` and then
  `back from test_file, status 1`: the script went on after the function returned.
- Now change `return 1` to `exit 1`. Only `/nowhere does not exist` prints, because `exit`
  ended the whole script inside the function. `echo $?` still shows 1.

### book_04_test_string.sh

`test-string` decides what the text in `ANSWER` says.

```bash
#!/bin/bash

# test-string: evaluate the value of a string

ANSWER=maybe

if [ -z "$ANSWER" ]; then
    echo "There is no answer." >&2
    exit 1
fi

if [ "$ANSWER" = "yes" ]; then
    echo "The answer is YES."
elif [ "$ANSWER" = "no" ]; then
    echo "The answer is NO."
elif [ "$ANSWER" = "maybe" ]; then
    echo "The answer is MAYBE."
else
    echo "The answer is UNKNOWN."
fi
```

| Line | What it does |
|---|---|
| `ANSWER=maybe` | The text to check. (Chapter 28's `read` lets a script ask the user; here the value is fixed.) |
| `if [ -z "$ANSWER" ]; then` | `-z`: is the string empty (zero length)? |
| `echo "There is no answer." >&2` | `>&2` sends the message to **standard error**, the output channel meant for error messages (redirection is chapter 6). |
| `exit 1` | Stops the script with status 1. |
| `fi` | Ends the first `if`. It has no `else`: a non-empty answer just goes on. |
| `if [ "$ANSWER" = "yes" ]; then` | `=` is true when the two strings are exactly the same, letter for letter. |
| `elif [ "$ANSWER" = "no" ]; then` | `elif` means "else if": tried only because the test above failed. |
| `elif [ "$ANSWER" = "maybe" ]; then` | Tried only if "yes" and "no" both failed. True here, so its `echo` runs and the rest of the chain is skipped. |
| `else` | Any other value: `The answer is UNKNOWN.` |
| `fi` | One `fi` closes the whole chain. |

The four string expressions: `-z string` (empty), `-n string` (not empty), `s1 = s2` (the same
text; bash also accepts `==`) and `s1 != s2` (different text).

Run it:

```bash
$ ./book_04_test_string.sh
The answer is MAYBE.
```

Try this (in a copy: `cp book_04_test_string.sh try.sh`):

- `ANSWER=yes`, then `ANSWER=YES`. The first prints `The answer is YES.`; the second prints
  `The answer is UNKNOWN.`, because `=` compares letter for letter and `Y` is not `y`.
- `ANSWER=` (empty). It prints `There is no answer.` and `echo $?` shows 1.

### book_05_test_integer.sh

`test-integer` uses the integer expressions.

```bash
#!/bin/bash

# test-integer: evaluate the value of an integer.

INT=-5

if [ -z "$INT" ]; then
    echo "INT is empty." >&2
    exit 1
fi

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
```

| Line | What it does |
|---|---|
| `INT=-5` | The number to check. |
| `if [ -z "$INT" ]; then` ... `fi` | The empty-value guard from `book_04`: message on standard error, `exit 1`. |
| `if [ "$INT" -eq 0 ]; then` | `-eq` compares two whole numbers. Zero: print `INT is zero.` and skip the `else` part. |
| `else` | Not zero. Two separate `if` statements follow, and both run. |
| `if [ "$INT" -lt 0 ]; then` ... `fi` | `-lt`, "less than": negative or positive. |
| `if [ $((INT % 2)) -eq 0 ]; then` | `$((INT % 2))` is **arithmetic expansion**: bash replaces it with the remainder of INT divided by 2. Even numbers leave 0; odd numbers leave 1 (or -1 when negative). |
| `echo "INT is odd."` | For -5 the remainder is -1, so this line runs. |
| `fi` | Ends the outer `if`. |

The six integer expressions: `-eq` (equal), `-ne` (not equal), `-lt` (less than), `-le` (less
than or equal), `-gt` (greater than), `-ge` (greater than or equal). They compare **numbers**,
while `=` compares **text**: `[ 05 -eq 5 ]` is true, `[ 05 = 5 ]` is false. Arithmetic is
covered fully in chapter 34.

Run it:

```bash
$ ./book_05_test_integer.sh
INT is negative.
INT is odd.
```

Try this (in a copy: `cp book_05_test_integer.sh try.sh`):

- `INT=0`, `INT=12`, `INT=-4`. Predict the lines before each run.
- `INT=abc`. Predict, then run. The script is fooled:

  ```bash
  $ ./try.sh
  ./try.sh: line 70: [: abc: integer expression expected
  ./try.sh: line 73: [: abc: integer expression expected
  INT is positive.
  INT is even.
  ```

  Each failed test ends with status 2, so its `else` runs; and inside `$(( ))` bash reads
  `abc` as the name of a variable, which is unset and counts as 0. The next script fixes this.

### book_06_test_integer2.sh

`test-integer2` checks that `INT` really is a whole number before it compares anything.

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
| `if [[ "$INT" =~ ^-?[0-9]+$ ]]; then` | `[[ ]]` is bash's newer test: it understands every expression `[ ]` does, plus `=~`, true when the text on the left matches the **regular expression** (a pattern that describes text) on the right. |
| `^-?[0-9]+$` | Read it piece by piece: `^` the start; `-?` an optional minus sign (`?` = zero or one); `[0-9]+` one or more digits (`+` = one or more); `$` the end. So `-5`, `0` and `42` match; `abc`, `3.5`, `+7` and an empty value do not. Leave it **unquoted**: in quotes it becomes plain text. |
| the inner `if` blocks | `book_05`'s number tests, unchanged. They run only for a real whole number. |
| `else` | The value is not a whole number. |
| `echo "INT is not an integer." >&2` | The error message, on standard error. |
| `exit 1` | Stops with status 1. |

**What changed from `book_05`.** The `-z` check is gone, because the pattern already rejects an
empty value, and every number test moved inside the new `if`. For `INT=-5` the output is the
same. For `INT=abc`, `book_05` gave a wrong answer; `book_06` refuses the value.

Run it:

```bash
$ ./book_06_test_integer2.sh
INT is negative.
INT is odd.
```

Try this (in a copy: `cp book_06_test_integer2.sh try.sh`):

- `INT=abc`. Now it prints `INT is not an integer.` and `echo $?` shows 1.
- `INT=3.5` and `INT=+7`. Neither matches the pattern (a dot is not a digit, and the pattern
  allows only a minus sign in front).
- Put double quotes around the pattern, `"^-?[0-9]+$"`, and run it with `INT=-5`. It now says
  `INT is not an integer.`: in quotes, `=~` looks for those exact characters.

### book_07_test_integer2a.sh

`test-integer2a`: the same program, with its number tests written in `(( ))`, bash's
arithmetic test.

```bash
#!/bin/bash

# test-integer2a: evaluate the value of an integer.

INT=-5

if [[ "$INT" =~ ^-?[0-9]+$ ]]; then
    if ((INT == 0)); then
        echo "INT is zero."
    else
        if ((INT < 0)); then
            echo "INT is negative."
        else
            echo "INT is positive."
        fi
        if (( ((INT % 2)) == 0)); then
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
| `if [[ "$INT" =~ ^-?[0-9]+$ ]]; then` | The integer check from `book_06`, unchanged. |
| `if ((INT == 0)); then` | Replaces `[ "$INT" -eq 0 ]`. `(( ))` works out the arithmetic inside it and succeeds (status 0) when the result is **not zero**. A comparison gives 1 when true and 0 when false, so the `if` works as you expect. |
| `if ((INT < 0)); then` | Replaces `-lt`. Inside `(( ))` you use `==`, `!=`, `<`, `>`, `<=`, `>=`, and you write `INT`, not `$INT`. |
| `if (( ((INT % 2)) == 0)); then` | Replaces `[ $((INT % 2)) -eq 0 ]`. The inner parentheses only group `INT % 2`, as in algebra; `(( INT % 2 == 0 ))` means the same. |
| the rest | The same as `book_06`. |

`(( ))` is part of bash's own grammar, not a command like `[`, so the spaces inside it are
optional: `((INT<0))` works too.

**What the pair shows.** `book_06` and `book_07` ask the same questions and print the same
answers. `[ "$INT" -eq 0 ]` is the traditional spelling that every shell understands;
`((INT == 0))` is shorter and reads like arithmetic, but only bash (and a few other modern
shells) understands it.

Run it:

```bash
$ ./book_07_test_integer2a.sh
INT is negative.
INT is odd.
```

Try this (in a copy: `cp book_07_test_integer2a.sh try.sh`):

- `INT=0`, then `INT=10`. Predict the output each time.
- At the prompt: `((0)); echo $?` prints 1 and `((1)); echo $?` prints 0. Arithmetic "zero"
  means false, and false is exit status 1.
- `INT=08`. It passes the `=~` check, and then:

  ```bash
  $ ./try.sh
  ./try.sh: line 67: ((: 08: value too great for base (error token is "08")
  ./try.sh: line 70: ((: 08: value too great for base (error token is "08")
  INT is positive.
  ./try.sh: line 75: ((: 08: value too great for base (error token is "08")
  INT is odd.
  ```

  Inside `(( ))` and `$(( ))`, a number that starts with 0 is read in base 8 (octal), where 8
  is not a digit. Each failed test counts as false, so 8 is called odd. The book does not
  mention this. For a value with no minus sign, writing `10#$INT` instead of `INT` forces base
  10: `((10#$INT % 2 == 0))` is true for 08. It does not accept a sign after the `#`, though:
  with `INT=-5`, bash 5.2 stops with `10#: invalid integer constant`.

### book_08_test_integer3.sh

`test-integer3` asks whether `INT` lies between `MIN_VAL` and `MAX_VAL`.

```bash
#!/bin/bash

# test-integer3: determine if an integer is within a
# specified range of values.

MIN_VAL=1
MAX_VAL=100

INT=50

if [[ "$INT" =~ ^-?[0-9]+$ ]]; then
    if [[ "$INT" -ge "$MIN_VAL" && "$INT" -le "$MAX_VAL" ]]; then
        echo "$INT is within $MIN_VAL to $MAX_VAL."
    else
        echo "$INT is out of range."
    fi
else
        echo "INT is not an integer." >&2
        exit 1
fi
```

| Line | What it does |
|---|---|
| `MIN_VAL=1`, `MAX_VAL=100` | The two ends of the range. |
| `INT=50` | The value to check. |
| `if [[ "$INT" =~ ^-?[0-9]+$ ]]; then` | The integer check from `book_06`. |
| `if [[ "$INT" -ge "$MIN_VAL" && "$INT" -le "$MAX_VAL" ]]; then` | Two expressions joined by `&&` (AND) in one `[[ ]]`: true only when both are true. INT is at least 1 **and** at most 100. |
| `echo "$INT is within $MIN_VAL to $MAX_VAL."` | Both were true. |
| `echo "$INT is out of range."` | At least one was false. |
| `else` / `echo ... >&2` / `exit 1` | Not a whole number. These lines are indented 8 spaces in the book; bash ignores indentation, which is there only for people. |

Inside `[[ ]]`, `A && B` is true when both are true, `A || B` when at least one is true, and
`! A` when A is false. The same `&&` and `||` also go **between two commands**, with a related
meaning: see "Control operators" below.

Run it:

```bash
$ ./book_08_test_integer3.sh
50 is within 1 to 100.
```

Try this (in a copy: `cp book_08_test_integer3.sh try.sh`):

- `INT=100`, `INT=101`, `INT=0`. Predict first. 100 is within the range (`-le` includes
  equal); 101 and 0 are out of range.
- `INT=fifty`. The outer `else` runs: `INT is not an integer.`, and `echo $?` shows 1.
- Rewrite the range test as `(( INT >= MIN_VAL && INT <= MAX_VAL ))`. The answers do not
  change.

### book_09_test_integer3_with_test.sh

Assembled: `test-integer3` with its range test rewritten for `test` (`[ ]`), as the book shows
next.

```bash
#!/bin/bash

# test-integer3: determine if an integer is within a
# specified range of values.

MIN_VAL=1
MAX_VAL=100

INT=50

if [[ "$INT" =~ ^-?[0-9]+$ ]]; then
    if [ "$INT" -ge "$MIN_VAL" -a "$INT" -le "$MAX_VAL" ]; then
        echo "$INT is within $MIN_VAL to $MAX_VAL."
    else
        echo "$INT is out of range."
    fi
else
        echo "INT is not an integer." >&2
        exit 1
fi
```

| Line | What it does |
|---|---|
| every line but one | The same as `book_08`. |
| `if [ "$INT" -ge "$MIN_VAL" -a "$INT" -le "$MAX_VAL" ]; then` | Inside `[ ]`, AND is spelled `-a` (and OR is `-o`). `&&` cannot go inside `[ ]`: bash reads `&&` itself and cuts the test in two. |

**What the pair shows.** `[[ A && B ]]` and `[ A -a B ]` give the same answers. `[ ]` is the
standard (POSIX) form that every shell understands; `[[ ]]` belongs to bash, is easier to write
and harder to break, and the book prefers it for new scripts. The first test still needs
`[[ ]]`, because `[ ]` has no `=~`. On a current system, `man test` warns that `-a` and `-o`
are "inherently ambiguous" and suggests two tests joined by `&&` instead:
`[ "$INT" -ge "$MIN_VAL" ] && [ "$INT" -le "$MAX_VAL" ]`. They still work in bash.

Run it:

```bash
$ ./book_09_test_integer3_with_test.sh
50 is within 1 to 100.
```

Try this (in a copy: `cp book_09_test_integer3_with_test.sh try.sh`):

- `INT=1`, then `INT=101`: the same answers as `book_08`.
- Replace `-a` with `&&` inside the `[ ]` and run it with `INT=50`. Bash prints
  ``./try.sh: line 66: [: missing `]'`` and then `50 is out of range.`, a wrong answer: the
  first `[` never got its `]`, failed with status 2, and `&&` skipped the rest.
- Write the test as two commands, `if [ "$INT" -ge "$MIN_VAL" ] && [ "$INT" -le "$MAX_VAL" ]; then`.
  It works: here `&&` joins two whole commands.

### book_10_test_integer4.sh

`test-integer4` turns the question around: is `INT` **outside** the range?

```bash
#!/bin/bash

# test-integer4: determine if an integer is outside a
# specified range of values.

MIN_VAL=1
MAX_VAL=100

INT=50

if [[ "$INT" =~ ^-?[0-9]+$ ]]; then
    if [[ ! ("$INT" -ge "$MIN_VAL" && "$INT" -le "$MAX_VAL") ]]; then
        echo "$INT is outside $MIN_VAL to $MAX_VAL."
    else
        echo "$INT is in range."
    fi
else
        echo "INT is not an integer." >&2
        exit 1
fi
```

| Line | What it does |
|---|---|
| the limits, `INT=50`, the `=~` check | The same as `book_08`. |
| `if [[ ! ("$INT" -ge "$MIN_VAL" && "$INT" -le "$MAX_VAL") ]]; then` | `book_08`'s range test in parentheses, with `!` (NOT) in front. `!` reverses a test, so this is true exactly when INT is **not** in the range. The parentheses make `!` apply to the whole AND; without them it would reverse only the first expression. |
| `echo "$INT is outside $MIN_VAL to $MAX_VAL."` | The reversed test was true. |
| `echo "$INT is in range."` | The reversed test was false: 50 is in the range. |

Run it:

```bash
$ ./book_10_test_integer4.sh
50 is in range.
```

Try this (in a copy: `cp book_10_test_integer4.sh try.sh`):

- `INT=101`, `INT=0`, `INT=1`. Predict first: outside, outside, in range.
- Remove the parentheses, `[[ ! "$INT" -ge "$MIN_VAL" && "$INT" -le "$MAX_VAL" ]]`, and run it
  with `INT=101`. It says `101 is in range.`, which is wrong: `!` now reverses only
  `"$INT" -ge "$MIN_VAL"` (true for 101, so false), and false AND anything is false.
- Ask the same question without `!`: `[[ "$INT" -lt "$MIN_VAL" || "$INT" -gt "$MAX_VAL" ]]`
  (below the bottom **or** above the top). 0 and 101 are outside; 50 is in range.

### book_11_test_integer4_with_test.sh

Assembled: `test-integer4` with its test rewritten for `test` (`[ ]`), as the book shows next.

```bash
#!/bin/bash

# test-integer4: determine if an integer is outside a
# specified range of values.

MIN_VAL=1
MAX_VAL=100

INT=50

if [[ "$INT" =~ ^-?[0-9]+$ ]]; then
    if [ ! \( "$INT" -ge "$MIN_VAL" -a "$INT" -le "$MAX_VAL" \) ]; then
        echo "$INT is outside $MIN_VAL to $MAX_VAL."
    else
        echo "$INT is in range."
    fi
else
        echo "INT is not an integer." >&2
        exit 1
fi
```

| Line | What it does |
|---|---|
| every line but one | The same as `book_10`. |
| `if [ ! \( "$INT" -ge "$MIN_VAL" -a "$INT" -le "$MAX_VAL" \) ]; then` | NOT is `!` in both forms, and AND becomes `-a`. The parentheses are written `\(` and `\)`: `[` is an ordinary command, so bash reads the line first, and to bash a bare `(` means something else (here, a syntax error). The backslash makes it a plain character that `[` receives as an argument. Each one needs spaces around it. |

The book breaks this `if` line before `then` to fit its page; here it is one line, and it runs
the same.

**What the pair shows.** `[[ ! ( A && B ) ]]` and `[ ! \( A -a B \) ]` give the same answers.
Inside `[[ ]]` bash reads the test itself, so the parentheses need no backslashes, which is one
more reason the book prefers `[[ ]]` for new scripts.

Run it:

```bash
$ ./book_11_test_integer4_with_test.sh
50 is in range.
```

Try this (in a copy: `cp book_11_test_integer4_with_test.sh try.sh`):

- `INT=100`, then `INT=101`. 100 is in range; 101 is outside.
- Delete the two backslashes and run it. Nothing in the `if` statement runs; bash stops with a
  syntax error and status 2:

  ```bash
  $ ./try.sh
  ./try.sh: line 63: syntax error near unexpected token `('
  ./try.sh: line 63: `    if [ ! ( "$INT" -ge "$MIN_VAL" -a "$INT" -le "$MAX_VAL" ) ]; then'
  ```

### book_12_sys_info_page.sh

Assembled: the finished chapter 26 report (`book_06_sys_info_page_filled.sh` in
`../ch26_top_down_design/`) with this chapter's new `report_home_space`. It answers the question
the chapter opens with: how can the report adapt to the privileges of the person running it?

```bash
#!/bin/bash

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
```

| Line | What it does |
|---|---|
| `TITLE=...`, `CURRENT_TIME=...`, `TIMESTAMP=...` | The page title, the date and time, and who made the page, as in chapter 25. |
| `report_uptime () {` ... `}` | Chapter 26's function, unchanged: an `<h2>` heading and the output of `uptime` inside `<pre>` tags, printed by `cat` from a here document. |
| `report_disk_space () {` ... `}` | The same, for `df -h` (disk space). Unchanged. |
| `if [[ "$(id -u)" -eq 0 ]]; then` | **New.** `id -u` prints your numeric user ID, and `$( )` puts it into the test. The superuser (root) is always 0; everyone else is greater than 0 (the first account on Linux Mint or Ubuntu is usually 1000). |
| `<h2>Home Space Utilization (All Users)</h2>` and `du -sh /home/*` | The superuser's branch: the size of every folder in `/home`. Only the superuser may read everyone's folders. |
| `else` ... `<h2>Home Space Utilization ($USER)</h2>` and `du -sh $HOME` | Anyone else: only your own home folder, which you can always read. In chapter 26 a normal user on a shared computer got `Permission denied` for the other users' folders. |
| `fi` / `return` | Ends the `if`, then the function. |
| `cat << _EOF_` ... `_EOF_` | The page itself; `$(report_uptime)` and the others run the functions and put their output in place. |

The here document lines inside the functions start with **tab** characters, because `<<-`
strips leading tabs, not spaces.

Run it (shortened: `...` marks lines left out). This run was on a computer named `linuxbox` by
a user named `student`, user ID 1000; `MM/DD/YY HH:MM:SS` stands for the date and time of the
run, and `df` prints one line for each mounted file system. Your names and numbers will differ.

```bash
$ ./book_12_sys_info_page.sh
<html>
    <head>
        <title>System Information Report For linuxbox</title>
    </head>
    <body>
        <h1>System Information Report For linuxbox</h1>
        <p>Generated MM/DD/YY HH:MM:SS AM EDT, by student</p>
        <h2>System Uptime</h2>
<pre> HH:MM:SS up 3 min,  1 user,  load average: 0.09, 0.06, 0.02</pre>
        <h2>Disk Space Utilization</h2>
<pre>Filesystem      Size  Used Avail Use% Mounted on
/dev/sdd       1007G  1.7G  954G   1% /
...</pre>
        <h2>Home Space Utilization (student)</h2>
<pre>204K	/home/student</pre>
    </body>
</html>
```

Run by the superuser, the same script prints the heading `Home Space Utilization (All Users)`
and one line per folder in `/home`. You do not need `sudo` to see that: reading the `then`
part is enough.

Try this:

- Type `id -u` and `id -un` at the prompt. Which branch will the script take for you?
- Save the page in a practice folder and open it in a web browser (close the browser to get
  your prompt back):

  ```bash
  mkdir -p ~/playground
  ./book_12_sys_info_page.sh > ~/playground/sys_info_page.html
  firefox ~/playground/sys_info_page.html
  ```

## More from the chapter: tests at the prompt

The book types these at the prompt. `if` works there too, all on one line, so you can try an
idea before you put it in a script.

**`if` judges the last command of a list.** `true` and `false` are commands that do nothing
but end with status 0 and 1. When several commands follow `if`, only the last one counts:

```bash
$ if true; then echo "It's true."; fi
It's true.
$ if false; then echo "It's true."; fi
$ if false; true; then echo "It's true."; fi
It's true.
$ if true; false; then echo "It's true."; fi
```

**Wildcard patterns with `==` inside `[[ ]]`.** Inside `[[ ]]`, `==` matches the text on its
left against a pattern with the same wildcards as pathname expansion (`*`, `?`, `[ ]`). Leave
the pattern unquoted; in quotes, `*` is just a star:

```bash
$ FILE=foo.bar
$ if [[ $FILE == foo.* ]]; then echo "$FILE matches pattern 'foo.*'"; fi
foo.bar matches pattern 'foo.*'
$ if [[ $FILE == "foo.*" ]]; then echo "quoted matches"; else echo "quoted does not match"; fi
quoted does not match
```

**Arithmetic truth with `(( ))`.** A result that is not zero is true; zero is false. The exit
status runs the other way, so `((0))` ends with status 1:

```bash
$ if ((1)); then echo "It is true."; fi
It is true.
$ if ((0)); then echo "It is true."; fi
$ ((0)); echo $?
1
```

## Control operators: && and || between commands

Between two commands, `&&` and `||` are **control operators**, another way to branch.
`command1 && command2` runs command2 only if command1 succeeded; `command1 || command2` runs
command2 only if command1 failed. Try them in a practice folder:

```bash
$ mkdir -p ~/playground
$ cd ~/playground
$ mkdir temp && cd temp
$ pwd
/home/student/playground/temp
$ cd ..
$ mkdir temp && cd temp
mkdir: cannot create directory 'temp': File exists
$ pwd
/home/student/playground
$ [[ -d temp ]] || mkdir temp
$ rmdir temp
$ [[ -d temp ]] || mkdir temp
$ ls
temp
$ rmdir temp
```

The second `mkdir temp` failed (the folder was already there), so `cd temp` never ran. The
first `[[ -d temp ]] || mkdir temp` did nothing, because the test succeeded; after `rmdir` the
test failed, so `mkdir` ran. `[ -d temp ] || mkdir temp` makes the same decision as
`if [ ! -d temp ]; then mkdir temp; fi`, on one short line. In a script, `[ -d temp ] || exit 1`
stops the script with status 1 when a folder it needs is missing.

Inside `[[ ]]` the same two symbols join expressions (`book_08`); between commands they join
whole commands.

## Which test to use

| Form | Best for | Example | Remember |
|---|---|---|---|
| `[ ]` (`test`) | Files and simple checks; works in every shell | `[ -f "$f" ]`, `[ "$a" = yes ]` | Quote every variable. AND/OR are `-a`/`-o`; escape `\(` `\)` and `\<` `\>` |
| `[[ ]]` | Text, wildcard patterns, regular expressions | `[[ $f == *.txt ]]`, `[[ $n =~ ^[0-9]+$ ]]` | Bash only. Never quote the pattern after `==` or `=~` |
| `(( ))` | Whole-number comparisons and arithmetic | `(( n > 5 ))`, `(( n % 2 == 0 ))` | Bash only. No `$` needed; a leading 0 means base 8 |

`[[ ]]` and `(( ))` belong to bash. On Linux Mint and Ubuntu, `sh` is a smaller shell named
dash, which has neither. Running a script with `sh` instead of `./` shows the difference:

```bash
$ sh book_06_test_integer2.sh
book_06_test_integer2.sh: 68: [[: not found
INT is not an integer.
```

That is why these scripts start with `#!/bin/bash` and run with `./`.

## Common mistakes

| You type | What bash says | Fix |
|---|---|---|
| `[$x -eq 5]` | `bash: [5: command not found` | `[` is a command: put a space after `[` and before `]` |
| `[ "$x" -eq 5]` | ``bash: [: missing `]'`` | A space before the closing `]` |
| `[ $answer = yes ]` with `answer` empty | `bash: [: =: unary operator expected` | Quote it: `[ "$answer" = yes ]` |
| `[ -e $FILE ]` with `FILE="my notes.txt"` | `bash: [: my: binary operator expected` | Quote it: `[ -e "$FILE" ]` |
| `[ -e $F ]` with `F` empty | Nothing; status 0, as if the file existed | Quote it: `[ -e "$F" ]` gives 1 |
| `[ abc -eq 5 ]` | `bash: [: abc: integer expression expected` | `-eq` is for numbers; use `=` for text, or check the value first with `=~` (`book_06`) |
| `[[ 10 > 9 ]]` | Nothing; status 1 (false): `>` compares as text, and "1" sorts before "9" | Numbers: `[ 10 -gt 9 ]` or `(( 10 > 9 ))` |
| `[ "$n" > 5 ]` | Nothing, but a file named `5` appears: inside `[ ]`, `>` is redirection | `[ "$n" -gt 5 ]` or `(( n > 5 ))` |
| `if [ -f /etc/passwd ] then echo yes; fi` | ``bash: syntax error near unexpected token `fi'`` | A `;` (or a new line) before `then` |
| An `if` with no `fi` | `./try.sh: line 5: syntax error: unexpected end of file` | Close every `if` with `fi` |
| `[[ $INT =~ "^-?[0-9]+$" ]]` | Nothing; never true | Leave the pattern after `=~` unquoted |
| `INT=08` and `(( INT == 0 ))` | `bash: ((: 08: value too great for base (error token is "08")` | A leading 0 means base 8. For a value with no minus sign, `(( 10#$INT == 0 ))` forces base 10 |
| `[ ! ( ... -a ... ) ]` | ``bash: syntax error near unexpected token `('`` | Escape them: `[ ! \( ... -a ... \) ]`, or use `[[ ]]` |
| `FILE="~/.bashrc"` | The script says `~/.bashrc does not exist` | `~` expands only unquoted: `FILE=~/.bashrc` or `FILE="$HOME/.bashrc"` |
| `sh book_06_test_integer2.sh` | `book_06_test_integer2.sh: 68: [[: not found` | Run it with `./`, so `#!/bin/bash` picks bash |
| A file saved on Windows | `/bin/bash^M: bad interpreter: No such file or directory` | `sed -i 's/\r$//' file.sh` |

## Check yourself

1. You run `ls /nowhere`, then `echo $?` twice. What do the two `echo` commands print, and why?
   <details><summary>Answer</summary>The first prints 2, the status of the failed
   <code>ls</code>. The second prints 0: <code>$?</code> holds the status of the most recent
   command, and that was the first <code>echo</code>, which succeeded.</details>
2. `if` does not compare anything by itself. What does it actually check?
   <details><summary>Answer</summary>It runs the command (or the list of commands) after
   <code>if</code> and checks the exit status of the last one: 0 runs the
   <code>then</code> part, anything else runs <code>elif</code> or <code>else</code>.
   <code>[ ]</code>, <code>[[ ]]</code> and <code>(( ))</code> are just commands that end with
   0 for true and 1 for false.</details>
3. `FILE` is empty. Why does `[ -e $FILE ]` say true, and how do you fix it?
   <details><summary>Answer</summary>Without quotes the empty variable disappears and test
   sees only <code>[ -e ]</code>, a one-word test that asks whether the text
   <code>-e</code> is not empty, which is true. With quotes, <code>[ -e "$FILE" ]</code>, test
   receives an empty file name and answers false (status 1).</details>
4. In `book_03_test_file_function.sh`, why does the function use `return 1` where
   `book_02_test_file.sh` uses `exit 1`?
   <details><summary>Answer</summary><code>exit</code> ends the whole script, even from inside
   a function. <code>return</code> ends only the function and hands its status to the caller,
   so the rest of a larger program can decide what to do next.</details>
5. Write one `[[ ]]` test that is true when `INT` is a whole number, and one `(( ))` test that
   is true when `INT` is between 1 and 10.
   <details><summary>Answer</summary><code>[[ "$INT" =~ ^-?[0-9]+$ ]]</code> (the pattern
   unquoted) and <code>(( INT &gt;= 1 &amp;&amp; INT &lt;= 10 ))</code>.</details>
