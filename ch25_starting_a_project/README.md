# Chapter 25: Starting a Project

*The Linux Command Line* (TLCL), chapter 25. The book is free: https://linuxcommand.org/tlcl.php

## What you will learn

- Programs are built **in stages**: get something small running, add one feature, run it
  again. The chapter's project, `sys_info_page`, starts as a fixed web page and grows into a
  report with the computer's name, the time and the user. Chapters 26 and 27 keep building it.
- A **variable** is a name that holds a value: `name=value` stores it (no spaces around the
  `=`), and `$name` puts the value back wherever you write it.
- A **constant** is a variable whose value never changes; by habit its name is in UPPERCASE.
  `declare -r` makes bash enforce it.
- **Command substitution**, `$(command)`, runs a command and puts its output in place, so a
  script can store the date or the computer's name in a variable.
- A **here document**, `cat << _EOF_` ... `_EOF_`, prints a whole block of text with the
  variables filled in. It can feed any command that reads input, and `<<-` lets you indent the
  block with tabs.

## Files in this folder

| File | Book name | What it shows |
|---|---|---|
| `book_01_sys_info_page.sh` | `sys_info_page`, stage 1 | One `echo` per line of a minimal web page |
| `book_02_sys_info_page.sh` | `sys_info_page`, stage 2 | One `echo` with a quoted string over many lines |
| `book_03_sys_info_page.sh` | `sys_info_page`, stage 3 | A real title and heading, typed twice |
| `book_04_sys_info_page.sh` | `sys_info_page`, stage 4 | The title stored once, in the variable `title` |
| `book_05_sys_info_page.sh` | `sys_info_page`, stage 5 | The constant `TITLE`, with `$HOSTNAME` in it |
| `book_06_sys_info_page.sh` | `sys_info_page`, stage 6 | A timestamp from `$(date ...)` and `$USER` |
| `book_07_sys_info_page.sh` | `sys_info_page`, stage 7 | `cat` with a here document instead of `echo` |
| `book_08_ftp_retrieve.sh` | (no name; "Script to retrieve a file via FTP") | A here document that types commands into `ftp` |
| `book_09_ftp_retrieve.sh` | (no name) | The same with `<<-` and tab-indented lines |

## How to run

```bash
cd ch25_starting_a_project
chmod u+x *.sh
./book_01_sys_info_page.sh
```

The `sys_info_page` stages print a web page (HTML) on the screen. To see it as a web page,
save the output in a file with `>` (redirection: it sends a command's output into a file
instead of to the screen; chapter 6 covers it fully) and open the file in a browser. The
file goes in a practice folder, `~/playground`, so nothing lands among the scripts:

```bash
mkdir -p ~/playground
./book_07_sys_info_page.sh > ~/playground/sys_info_page.html
firefox ~/playground/sys_info_page.html
```

If Firefox was not open already, the terminal waits until you close it; then your prompt comes
back. If `firefox` is not found, open the file from the file manager instead. (The book saves its script as
`~/bin/sys_info_page` and runs it by name; chapter 24 explains how.)

If a script stops with `/bin/bash^M: bad interpreter`, the file has Windows line endings;
this fixes every script in the folder:

```bash
sed -i 's/\r$//' *.sh
```

The outputs below come from our Ubuntu test computer, whose network name is `linuxbox` and whose
user is `student`. Your computer's name, your user name, the date and the time will differ.

## Walkthrough

The book builds one program, `sys_info_page`, in seven stages. Each stage is its own file, so
you can run two stages one after the other and see what a single change does.

| Stage | What changed from the previous stage | Does the page change? |
|---|---|---|
| 1 | (first stage) eight `echo` commands, one per line of a minimal page | A page with no data yet |
| 2 | The eight `echo` commands become one `echo` with a quoted string over many lines | No (only the indents) |
| 3 | A real `<title>` and an `<h1>` heading; "System Information Report" is typed twice | Yes: title and heading |
| 4 | The repeated words go in a variable, `title`, used twice as `$title` | No |
| 5 | The variable becomes the constant `TITLE` and ends with `$HOSTNAME` | Yes: the computer's name |
| 6 | `CURRENT_TIME` holds `$(date ...)`, `TIMESTAMP` adds `$USER`, a `<p>` line prints it | Yes: the time and the user |
| 7 | `echo "..."` is replaced by `cat << _EOF_` ... `_EOF_`, a here document | No |

The two `ftp` scripts at the end use a here document with a different command.

### book_01_sys_info_page.sh

Stage 1: a shebang, a comment and eight `echo` commands, one for each line of a minimal web
page. There is no system information yet; the first stage only has to run.

```bash
#!/bin/bash

# Program to output a system information page

echo "<html>"
echo "  <head>"
echo "       <title>Page Title</title>"
echo "  </head>"
echo "  <body>"
echo "       Page body."
echo "  </body>"
echo "</html>"
```

| Line | What it does |
|---|---|
| `#!/bin/bash` | The shebang: Linux runs this file with bash. |
| `# Program to output a system information page` | A comment saying what the program is for. Bash skips it. |
| `echo "<html>"` | Prints `<html>`, the HTML tag that opens a web page. A tag is a word in angle brackets. |
| `echo "  <head>"` | Opens the head, the part of the page that describes it. The spaces inside the quotes are printed too; they only indent the HTML for people. |
| `echo "       <title>Page Title</title>"` | The page title, which the browser shows on its tab. `</title>`, with a slash, closes `<title>`. |
| `echo "  </head>"` | Closes the head. |
| `echo "  <body>"` | Opens the body, the part shown in the browser window. |
| `echo "       Page body."` | The only content of the page. |
| `echo "  </body>"` | Closes the body. |
| `echo "</html>"` | Closes the page. |

Run it:

```bash
$ ./book_01_sys_info_page.sh
<html>
  <head>
       <title>Page Title</title>
  </head>
  <body>
       Page body.
  </body>
</html>
```

Saved to a file and opened in a browser, the tab says Page Title and the window says Page
body. The browser ignores the indents.

Try this:

- Copy the script (`cp book_01_sys_info_page.sh mine.sh`), change `Page body.` to a sentence
  about yourself, run the copy with `> ~/playground/sys_info_page.html` and reload the page.
- Count the `echo` commands. A 40-line page would need 40 of them. Stage 2 shows a shorter way.

### book_02_sys_info_page.sh

Stage 2: the same page from a single `echo`. What changed from stage 1: eight commands became
one, and the indents inside the string are now 4 and 8 spaces.

```bash
#!/bin/bash

# Program to output a system information page

echo "<html>
    <head>
        <title>Page Title</title>
    </head>
    <body>
        Page body.
    </body>
</html>"
```

| Line | What it does |
|---|---|
| `echo "<html>` | Starts one `echo` command. The double quote opens a string that does not close on this line. |
| `    <head>` to `    </body>` | Still inside the quotes: bash keeps reading until it finds the closing quote, so each of these lines, with its spaces and its line break, becomes part of the same string. |
| `</html>"` | The closing quote ends the string, and the end of this line ends the `echo` command. `echo` receives the whole page as one argument and prints it. |

Run it:

```bash
$ ./book_02_sys_info_page.sh
<html>
    <head>
        <title>Page Title</title>
    </head>
    <body>
        Page body.
    </body>
</html>
```

The same works at the prompt. Type `echo "one` and press Enter: bash shows `>` and waits.
That `>` is `PS2`, the prompt bash shows while a command is unfinished (here, a quote is
still open). Type `two"` and press Enter:

```bash
$ echo "one
> two"
one
two
```

If you are ever stuck at the `>` prompt, Ctrl-c gets you out.

Try this:

- In a copy, add `<p>Made by me</p>` on a new line after `Page body.`, inside the quotes. One
  new line in the script gives one new line in the page.
- Delete the closing `"` after `</html>` and run it. Bash answers
  ``unexpected EOF while looking for matching `"'``: it reached the end of the file still
  looking for the closing quote.

### book_03_sys_info_page.sh

Stage 3, "Adding a Little Data". What changed from stage 2: `Page Title` became
`System Information Report`, the body holds an `<h1>` heading with the same words instead of
`Page body.`, and the indents are 8 and 16 spaces.

```bash
#!/bin/bash

# Program to output a system information page

echo "<html>
        <head>
                <title>System Information Report</title>
        </head>
        <body>
                <h1>System Information Report</h1>
        </body>
</html>"
```

| Line | What it does |
|---|---|
| `echo "<html>` | Starts the one `echo` and its quoted string, as in stage 2. |
| `<title>System Information Report</title>` | A real page title for the browser tab. |
| `<h1>System Information Report</h1>` | A top-level heading (`<h1>`), shown in large bold letters in the window. |
| `</html>"` | Ends the string and the command. |

Run it:

```bash
$ ./book_03_sys_info_page.sh
<html>
        <head>
                <title>System Information Report</title>
        </head>
        <body>
                <h1>System Information Report</h1>
        </body>
</html>
```

The words "System Information Report" are now typed twice. In a long script, changing the
title would mean finding every copy, and a missed copy makes the page disagree with itself.
Stage 4 fixes that.

Try this:

- In a copy, change the words in the `<title>` line only. Open the saved page in the browser:
  the tab and the heading now disagree.
- Add `<h2>Uptime</h2>` under the `<h1>` line. `<h2>` is a smaller heading; chapter 26 uses
  it for each section of the report.

### book_04_sys_info_page.sh

Stage 4: the title is stored once, in a variable named `title`, and used twice. What changed
from stage 3: a new line before the `echo`, and the two copies of the words became `$title`.
The page is the same.

```bash
#!/bin/bash

# Program to output a system information page

title="System Information Report"

echo "<html>
        <head>
                <title>$title</title>
        </head>
        <body>
                <h1>$title</h1>
        </body>
</html>"
```

| Line | What it does |
|---|---|
| `title="System Information Report"` | An assignment: creates a variable named `title` and stores the text in it. No space on either side of `=`; the quotes are needed because the value has spaces. |
| `<title>$title</title>` | Inside the double-quoted string, bash replaces `$title` with its value before `echo` runs (parameter expansion). |
| `<h1>$title</h1>` | The same value, used a second time. |

Run it:

```bash
$ ./book_04_sys_info_page.sh
<html>
        <head>
                <title>System Information Report</title>
        </head>
        <body>
                <h1>System Information Report</h1>
        </body>
</html>
```

Changing the title now means editing one line. Bash has no declaration step: a variable
exists from the moment you assign it. The rules for a name: letters, digits and underscores
only, a letter or an underscore first, no spaces or punctuation.

Try this:

- Put spaces around the `=`: `title = "System Information Report"`. Bash answers
  `title: command not found`: with the spaces, `title` is the first word of a command, so bash
  looks for a program by that name.
- Misspell one use: `<h1>$titel</h1>`. The heading prints empty and nothing complains: a name
  that was never assigned expands to nothing.

### book_05_sys_info_page.sh

Stage 5: the variable becomes a constant. What changed from stage 4: `title` became `TITLE`,
and its value ends with `$HOSTNAME`.

```bash
#!/bin/bash

# Program to output a system information page

TITLE="System Information Report For $HOSTNAME"

echo "<html>
        <head>
                <title>$TITLE</title>
        </head>
        <body>
                <h1>$TITLE</h1>
        </body>
</html>"
```

| Line | What it does |
|---|---|
| `TITLE="System Information Report For $HOSTNAME"` | Stores the title. `HOSTNAME` is a variable bash sets by itself to the computer's network name; it is expanded inside the quotes, so the value ends with that name. The UPPERCASE name tells the reader this value never changes. |
| `<title>$TITLE</title>` and `<h1>$TITLE</h1>` | Both uses now say `$TITLE`. |

Run it:

```bash
$ ./book_05_sys_info_page.sh
<html>
        <head>
                <title>System Information Report For linuxbox</title>
        </head>
        <body>
                <h1>System Information Report For linuxbox</h1>
        </body>
</html>
```

A **constant** is a variable whose value does not change while the script runs. Bash treats
variables and constants the same; UPPERCASE for constants and lowercase for variables is a
habit that helps the reader. To make bash enforce a constant, declare it read-only. The
book's example is `declare -r TITLE="Page Title"`; `readonly` does the same. Try it with
another name, because a read-only name stays locked until you close the terminal:

```bash
$ declare -r PI=3.1415
$ echo "$PI"
3.1415
$ PI=3
bash: PI: readonly variable
```

Try this:

- Run `echo $HOSTNAME` at the prompt. It is the name in your page.
- In a copy, replace `$HOSTNAME` with `$USER`. Whose name appears now?

### book_06_sys_info_page.sh

Stage 6: the page says when it was made and by whom. What changed from stage 5: two new
constants, `CURRENT_TIME` and `TIMESTAMP`, and a new line in the page.

```bash
#!/bin/bash

# Program to output a system information page

TITLE="System Information Report For $HOSTNAME"
CURRENT_TIME="$(date +"%x %r %Z")"
TIMESTAMP="Generated $CURRENT_TIME, by $USER"

echo "<html>
        <head>
                <title>$TITLE</title>
        </head>
        <body>
                <h1>$TITLE</h1>
                <p>$TIMESTAMP</p>
        </body>
</html>"
```

| Line | What it does |
|---|---|
| `TITLE="System Information Report For $HOSTNAME"` | Unchanged from stage 5. |
| `CURRENT_TIME="$(date +"%x %r %Z")"` | Command substitution: bash runs `date` first and stores what it prints. `%x` is the date, `%r` the time with AM or PM, `%Z` the time zone. The quotes inside `$( )` start fresh, so they do not close the outer quotes. |
| `TIMESTAMP="Generated $CURRENT_TIME, by $USER"` | Builds one value from another constant and `$USER`, the login name of whoever runs the script. It comes after `CURRENT_TIME`, because a name must be set above the line that uses it. |
| `<p>$TIMESTAMP</p>` | A paragraph (`<p>`) in the page holding the timestamp. |

Run it:

```bash
$ ./book_06_sys_info_page.sh
<html>
        <head>
                <title>System Information Report For linuxbox</title>
        </head>
        <body>
                <h1>System Information Report For linuxbox</h1>
                <p>Generated MM/DD/YY HH:MM:SS AM EDT, by student</p>
        </body>
</html>
```

`%x` prints the date in the style of the computer's language setting (its locale). Our test
computer is set to `C`, which gives a two-digit year; a computer set to US English (`en_US`)
prints a four-digit year. `date` runs once, when the script starts, so every run shows a new
time. This is the first stage worth opening in the browser: it reads like a real report.

Try this:

- Run the script twice, a few seconds apart. Only the "Generated" line changes.
- At the prompt, try `date +"%x %r %Z"`, `date +%Y` and `date +%H:%M`. Each `%` letter is one
  piece of the date or time.

### book_07_sys_info_page.sh

Stage 7, the last stage in this chapter: a here document replaces `echo`. What changed from
stage 6: `echo "` and the closing `"` are gone; `cat << _EOF_` comes before the page, and a
line holding only `_EOF_` comes after it. The page is identical.

```bash
#!/bin/bash

# Program to output a system information page

TITLE="System Information Report For $HOSTNAME"
CURRENT_TIME="$(date +"%x %r %Z")"
TIMESTAMP="Generated $CURRENT_TIME, by $USER"

cat << _EOF_
<html>
        <head>
                <title>$TITLE</title>
        </head>
        <body>
                <h1>$TITLE</h1>
                <p>$TIMESTAMP</p>
        </body>
</html>
_EOF_
```

| Line | What it does |
|---|---|
| The three assignments | Unchanged from stage 6. |
| `cat << _EOF_` | Starts a here document: bash takes every line after this one, up to the line holding only `_EOF_`, and feeds that text to `cat` as its standard input, as if you typed it at the keyboard. `cat` prints what it reads. |
| `<html>` to `</html>` | The text of the page. `$TITLE` and `$TIMESTAMP` are still expanded, exactly as inside `echo "..."`. |
| `_EOF_` | The closing token. It must be alone on its line, at the left edge, with nothing after it, not even a space. |

Run it:

```bash
$ ./book_07_sys_info_page.sh
<html>
        <head>
                <title>System Information Report For linuxbox</title>
        </head>
        <body>
                <h1>System Information Report For linuxbox</h1>
                <p>Generated MM/DD/YY HH:MM:SS AM EDT, by student</p>
        </body>
</html>
```

`_EOF_` (End Of File) is only a habit; any word works if both ends match. The advantage over
`echo`: inside a here document, single and double quotes are ordinary characters, so the page
may contain them freely. `$` still expands, and a backslash in front of it stops that. Try it
at the prompt (bash shows `>` until the closing token):

```bash
$ foo="some text"
$ cat << _EOF_
> $foo
> "$foo"
> '$foo'
> \$foo
> _EOF_
some text
"some text"
'some text'
$foo
```

Try this:

- In a copy, add `<p>She said "it works"</p>` inside the block. The quotes print. Inside
  stage 6's `echo "..."`, the first of them would have ended the string.
- Put one space after the closing `_EOF_` and run it. Bash warns
  ``here-document at line M delimited by end-of-file (wanted `_EOF_')`` (M is the line of
  `cat << _EOF_`), and `cat` prints the line `_EOF_ ` as part of the page.

### book_08_ftp_retrieve.sh

A here document can feed any command that reads standard input. The book uses one to type six
commands into `ftp`, a program that copies files from a server over the network, as if you
typed them at its prompt. The book gives the script no file name. It prints the `FTP_PATH`
line wrapped after `images/`; in this file it is one line that holds two assignments.

```bash
#!/bin/bash

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
```

| Line | What it does |
|---|---|
| `FTP_SERVER=ftp.nl.debian.org` | The server's name. No quotes needed: the value has no spaces. |
| `FTP_PATH=... REMOTE_FILE=...` | Two assignments on one line, separated by a space: the folder on the server and the file to fetch. Bash allows several assignments on one line. |
| `ftp -n << _EOF_` | Runs `ftp` and feeds it the block as standard input. `-n` stops `ftp` from asking for a user name when it connects; the block logs in by itself. |
| `open $FTP_SERVER` | Connect to the server. Bash has already replaced `$FTP_SERVER` with the name, so `ftp` reads `open ftp.nl.debian.org`. |
| `user anonymous me@linuxbox` | Log in as `anonymous`, the public user of an FTP server. By tradition the password is an e-mail address; the book uses a made-up one. |
| `cd $FTP_PATH` | Move to the folder on the server. |
| `hash` | Print a `#` for each block received, as a progress bar. |
| `get $REMOTE_FILE` | Download the file into the current folder. |
| `bye` | Close the connection and end `ftp`. |
| `_EOF_` | Ends the here document. |
| `ls -l "$REMOTE_FILE"` | Runs after `ftp` has ended: lists the downloaded file to prove it arrived. |

**It will most likely fail, and that is fine.** The `ftp` program is often not installed (it
was not on our Ubuntu test computer). The server may be gone, too: Debian has closed most of
its public FTP service. When we tested, `ftp.nl.debian.org` still answered and accepted the
anonymous login, but the folder is gone: `stretch`, the Debian release named in `FTP_PATH`, is
old and was removed from the server, so it answers the `cd` with `550 Failed to change
directory` and the `get` fails. What matters is how the script feeds commands to `ftp`.

Run a copy in the practice folder, since a working `ftp` saves the file in the current folder:

```bash
$ mkdir -p ~/playground
$ cp book_08_ftp_retrieve.sh ~/playground/
$ cd ~/playground
$ ./book_08_ftp_retrieve.sh
./book_08_ftp_retrieve.sh: line 91: ftp: command not found
ls: cannot access 'debian-cd_info.tar.gz': No such file or directory
```

To see exactly what the here document would type into `ftp`, open your copy in vi (chapter
12), change `ftp -n` to `cat`, and run it again:

```bash
$ ./book_08_ftp_retrieve.sh
open ftp.nl.debian.org
user anonymous me@linuxbox
cd /debian/dists/stretch/main/installer-amd64/current/images/cdrom
hash
get debian-cd_info.tar.gz
bye
ls: cannot access 'debian-cd_info.tar.gz': No such file or directory
```

Try this:

- In the `cat` copy, put a backslash before `$FTP_SERVER` (`\$FTP_SERVER`). The `open` line
  now prints `$FTP_SERVER` itself.
- Feed a here document to `sort`, which prints lines in alphabetical order:

```bash
$ sort << _EOF_
> pear
> apple
> fig
> _EOF_
apple
fig
pear
```

### book_09_ftp_retrieve.sh

The same script with `<<-` instead of `<<`. What changed from `book_08`: `<<` became `<<-`,
every line of the block and the closing `_EOF_` start with one TAB character, and a blank line
comes before `ls`. The `FTP_PATH` line is joined as in `book_08`.

```bash
#!/bin/bash

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
```

| Line | What it does |
|---|---|
| The two assignment lines | Unchanged from `book_08`. |
| `ftp -n <<- _EOF_` | The dash tells bash to remove leading tab characters from every line of the block before `ftp` reads it. |
| The six indented commands | Each starts with a tab, which bash removes, so `ftp` reads the same six commands as in `book_08`. |
| `_EOF_` (after a tab) | With `<<-`, the closing token may have tabs in front of it. |
| `ls -l "$REMOTE_FILE"` | As in `book_08`. |

Only tabs are removed, never spaces. Many editors type spaces when you press the Tab key; then
the closing `_EOF_` is never found, bash warns that the here document ended at the end of the
file, and the rest of the script is fed to the command as text. `cat -A` shows the difference:
it prints each tab as `^I` and the end of each line as `$`.

```bash
$ ./book_09_ftp_retrieve.sh
./book_09_ftp_retrieve.sh: line 73: ftp: command not found
ls: cannot access 'debian-cd_info.tar.gz': No such file or directory
```

With `ftp -n` changed to `cat` in a copy, it prints the same six lines as `book_08`, with no
tabs in front of them. The same two problems apply: `ftp` may not be installed, and the server
or its folder may be gone.

Try this:

- Run `cat -A book_09_ftp_retrieve.sh` and look at the last lines. Which start with `^I`?
- In the `cat` copy, replace the tab before the closing `_EOF_` with four spaces and run it.
  Bash warns ``here-document at line M delimited by end-of-file (wanted `_EOF_')``, and `cat`
  prints `    _EOF_`, a blank line and the `ls` line as text: the `ls` command never runs.

## More from the chapter: variables at the prompt

The book tries these at the prompt. Run the ones that create files in `~/playground`.

**A misspelled name expands to nothing.** There is no error:

```bash
$ foo="yes"
$ echo $foo
yes
$ echo $fool

$
```

The book says bash quietly created an empty variable named `fool`. Strictly, bash creates
nothing (`declare -p fool` answers `fool: not found`): a name that was never assigned expands to
an empty string. Either way, an empty expansion can break a command that needs arguments.
Here `$fool` is a typo for `$foo1`, so `cp` receives one file name instead of two:

```bash
$ foo=foo.txt
$ foo1=foo1.txt
$ cp $foo $fool
cp: missing destination file operand after 'foo.txt'
Try 'cp --help' for more information.
```

The book prints the message with a backquote (`` `foo.txt' ``); current versions of `cp` use
straight quotes.

**What a value can be.** Anything that expands to text:

```bash
$ a=z                    # the text z
$ b="a string"           # spaces need quotes
$ c="a string and $b"    # another variable expanded into the value
$ e=$((5 * 7))           # arithmetic: the text 35
$ f="\t\ta string\n"     # backslash sequences
$ echo "$c"
a string and a string
$ echo "$e"
35
$ echo "$f"
\t\ta string\n
```

The book also shows `d="$(ls -l foo.txt)"`, the output of a command (empty, with a complaint
from `ls`, if there is no `foo.txt` in the folder). Note the last line: bash does not turn `\t`
and `\n` into a tab and a new line inside double quotes. `f` holds the backslashes themselves,
and plain `echo` prints them as they are; `echo -e "$f"` would turn them into tabs and line
breaks. Several assignments may share a line:

```bash
$ a=5 b="a string"
$ echo "$a and $b"
5 and a string
```

**Braces mark where a name ends.** The book tries to rename `myfile` to `myfile1`:

```bash
$ cd ~/playground
$ filename="myfile"
$ touch "$filename"
$ mv "$filename" "$filename1"
mv: cannot move 'myfile' to '': No such file or directory
$ mv "$filename" "${filename}1"
$ ls myfile*
myfile1
```

Bash reads `$filename1` as a variable named `filename1`, which is empty. The braces in
`${filename}1` say where the name ends. The book prints the error as `missing destination file
operand`, which is what `mv` says when the empty variable has no quotes around it; with quotes,
`mv` receives an empty name. The newest versions of `mv` word it as
`mv: cannot overwrite directory '' with non-directory 'myfile'`. Put double quotes around
every variable and command substitution, as the book advises: a value with spaces then stays
one argument.

## Common mistakes

In the messages, `N` and `M` stand for line numbers in your script.

| You type | What bash says | Fix |
|---|---|---|
| `title = "System Information Report"` | `./mine.sh: line N: title: command not found` | No spaces around `=`: `title="System Information Report"` |
| `TITLE= "System Information Report For $HOSTNAME"` | `./mine.sh: line N: System Information Report For linuxbox: command not found` (with your computer's name) | Remove the space after `=` |
| `<h1>$titel</h1>` (a typo) | Nothing: the heading is empty | Check the spelling against the assignment |
| `echo '<html> ... $title ... </html>'` (single quotes) | Prints `$title` itself, not its value | Double quotes: single quotes expand nothing |
| `echo "<html>` with no closing `"` | ``./mine.sh: line N: unexpected EOF while looking for matching `"'`` | Close the quote after `</html>` |
| `_EOF_ ` (a space after the closing token) | ``./mine.sh: line N: warning: here-document at line M delimited by end-of-file (wanted `_EOF_')`` | `_EOF_` alone at the start of its line, nothing after it |
| `PI=3` after `declare -r PI=3.1415` | `bash: PI: readonly variable` | Use another name, or open a new terminal |
| `mv "$filename" "$filename1"` | `mv: cannot move 'myfile' to '': No such file or directory` | Braces: `"${filename}1"` |
| `./book_08_ftp_retrieve.sh` | `./book_08_ftp_retrieve.sh: line 91: ftp: command not found` | Nothing to fix: change `ftp -n` to `cat` in a copy to see what `ftp` would read |
| A file saved on Windows | `/bin/bash^M: bad interpreter: No such file or directory` | `sed -i 's/\r$//' mine.sh` |

## Check yourself

1. Stage 4 prints exactly the same page as stage 3. Why is it better?
   <details><summary>Answer</summary>The title is written once, in the variable
   <code>title</code>, and used twice as <code>$title</code>. Changing it means editing one line,
   and the two copies on the page can never disagree.</details>
2. You type `TITLE = "Report"` in a script. What does bash do, and why?
   <details><summary>Answer</summary>It reports <code>TITLE: command not found</code>. With spaces
   around the <code>=</code>, the line is not an assignment: <code>TITLE</code> is the first word of
   a command, so bash looks for a program named <code>TITLE</code>.</details>
3. What is the difference between `NOW=date` and `NOW="$(date)"`?
   <details><summary>Answer</summary><code>NOW=date</code> stores the four letters d, a, t, e.
   <code>NOW="$(date)"</code> runs the <code>date</code> command and stores what it prints
   (command substitution).</details>
4. In a here document, which characters keep a special meaning, and which lose it?
   <details><summary>Answer</summary>Single and double quotes become ordinary characters.
   <code>$</code> still expands variables and <code>$( )</code>, and a backslash before it
   (<code>\$</code>) stops the expansion.</details>
5. In `book_09_ftp_retrieve.sh`, why must the indents be tabs and not spaces?
   <details><summary>Answer</summary><code>&lt;&lt;-</code> removes leading tabs only. With spaces,
   the closing <code>_EOF_</code> is not alone at the start of its line, so bash never finds it
   and feeds the rest of the script to the command.</details>
