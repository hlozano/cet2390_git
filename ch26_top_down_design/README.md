# Chapter 26: Top-Down Design

*The Linux Command Line* (TLCL), chapter 26. The book is free: https://linuxcommand.org/tlcl.php

## What you will learn

- **Top-down design**: write a big job as a few steps in plain words, then break every step
  that is still vague into smaller steps, until each one is a command you know how to write.
- A **shell function** is a small script inside your script, with a name. You define it once,
  `name () { commands }`, and run it by typing its name, like any command. In this course the
  parentheses stay empty: a function takes nothing in and works with the script's own
  variables.
- A function must be **defined above the line that calls it**. Otherwise bash looks for a
  program by that name and says `command not found`.
- **Local variables**: `local name` inside a function makes a variable that only that function
  sees, so the function cannot change a variable the rest of the script depends on.
- **Stubs**: empty functions that print their own name. They keep a half-built script
  running, so you can test after every small change.
- The book grows its `sys_info_page` report from chapter 25 with three functions: system
  uptime, disk space and home space.

## Files in this folder

| File | Book name | What it shows |
|---|---|---|
| `book_01_sys_info_page.sh` | `sys_info_page` | The plan: three `$( )` calls to commands that do not exist yet |
| `book_02_function_demo.sh` | (no name; "Shell function demo") | The path bash takes through a function call: Step 1, 2, 3 |
| `book_03_sys_info_page_stubs.sh` | `sys_info_page` | Three empty functions (stubs) that make the report run again |
| `book_04_local_vars.sh` | `local-vars` | `local` gives each function its own `foo`; the global `foo` stays 0 |
| `book_05_sys_info_page_feedback.sh` | `sys_info_page` | Stubs that print their names, so you can see each one run |
| `book_06_sys_info_page_filled.sh` | `sys_info_page` | The functions doing real work with `uptime`, `df -h` and `du -sh` |
| `book_07_ds.sh` | `ds` | A function worth keeping in your `~/.bashrc` file |

## How to run

```bash
cd ch26_top_down_design
chmod u+x *.sh
./book_02_function_demo.sh
```

The `sys_info_page` files print a web page (HTML). To see it in a browser, save the output in
a file with `>` (redirection: the output goes into the file instead of to the screen; chapter
6 covers it fully) in a practice folder, and open the file:

```bash
mkdir -p ~/playground
./book_06_sys_info_page_filled.sh > ~/playground/sys_info_page.html
firefox ~/playground/sys_info_page.html
```

If Firefox was not open already, the terminal waits until you close it. If `firefox` is not
found, open the file from the file manager.

If a script stops with `/bin/bash^M: bad interpreter`, the file has Windows line endings;
this fixes every script in the folder:

```bash
sed -i 's/\r$//' *.sh
```

The outputs below come from our Ubuntu test computer, whose network name is `linuxbox` and whose
user is `student`. Your computer's name, your user name, the date, the time and the disk lines
will differ.

## Walkthrough

**Top-down design.** The book explains a trip to the market to a visitor from Mars: get in
the car, drive to the market, park the car, enter the market, buy food, and so on back home.
"Park car" is still too vague for the visitor, so it is broken down again: find a space, drive
into it, turn off the motor, set the brake, exit the car, lock it. You stop refining when every
step is one action you know how to do. In a script, each named step becomes a function, and a
short main program at the bottom calls them in order.

The chapter does exactly that to `sys_info_page`. Chapter 25 left it doing nine steps (open
the page, open the head, set the title, close the head, open the body, print the heading,
print the timestamp, close the body, close the page). This chapter adds three steps after the
timestamp, as functions: system uptime, disk space and home space. The book shows the script
in stages; where it prints only the functions that change, the file here is **assembled**: the
earlier listing with those functions put in place, so every file runs on its own. The
`sys_info_page` that chapter 25 finished is in `../ch25_starting_a_project/`.

### book_01_sys_info_page.sh

The plan, written as code: chapter 25's last stage with three new lines in the page. They call
commands that do not exist yet.

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
                $(report_uptime)
                $(report_disk_space)
                $(report_home_space)
        </body>
</html>
_EOF_
```

| Line | What it does |
|---|---|
| The three assignments | The constants from chapter 25: the title with `$HOSTNAME`, the time from `date`, and the timestamp with `$USER`. |
| `cat << _EOF_` to `<p>$TIMESTAMP</p>` | Chapter 25's here document: `cat` prints every line up to `_EOF_`, with the variables filled in. |
| `$(report_uptime)` | New: a command substitution. Bash runs a command named `report_uptime` and puts its output here. No such command exists yet, so bash prints an error and puts nothing here. |
| `$(report_disk_space)` and `$(report_home_space)` | The same for the other two planned sections. |
| `</body>` to `_EOF_` | The end of the page and of the here document. |

Run it:

```bash
$ ./book_01_sys_info_page.sh
./book_01_sys_info_page.sh: line 81: report_uptime: command not found
./book_01_sys_info_page.sh: line 81: report_disk_space: command not found
./book_01_sys_info_page.sh: line 81: report_home_space: command not found
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

The three errors are expected: they list exactly what is left to write. All three name line
81, the line of `cat << _EOF_`, where the here document starts. The three lines after the
timestamp hold only their indent spaces. The book could write the three commands as separate
scripts in a folder on the `PATH`; it chooses to write them inside this script, as shell
functions.

Try this:

- Save the page with `> ~/playground/page.html`. The three errors still appear on the screen,
  not in the file: error messages go to the screen even when the output goes to a file.
- At the prompt, type `uptime`, then `report_uptime`. Only the first is a real command.

### book_02_function_demo.sh

The book's demo of how bash runs a function. It uses the formal form, `function step2 {`. The
book prints line numbers 1 to 14 beside the code; they are not part of the script.

```bash
#!/bin/bash

# Shell function demo

function step2 {
    echo "Step 2"
    return
}

# Main program starts here

echo "Step 1"
step2
echo "Step 3"
```

| Line | What it does |
|---|---|
| `function step2 {` | Starts a function definition named `step2`. Bash remembers the commands between the braces under that name, but runs nothing yet. |
| `    echo "Step 2"` | The first command of the function. |
| `    return` | Ends the function: bash goes back to the line after the call. |
| `}` | Ends the definition. |
| `# Main program starts here` | A comment marking where execution really begins. |
| `echo "Step 1"` | The first command bash runs. |
| `step2` | A call: bash runs the function's commands, so `Step 2` prints, then comes back here. |
| `echo "Step 3"` | Runs after the function returns. |

Run it:

```bash
$ ./book_02_function_demo.sh
Step 1
Step 2
Step 3
```

The book traces the script by its line numbers: lines 1 to 11 are comments and the definition,
so nothing runs; execution begins at line 12 (`echo "Step 1"`); line 13 calls `step2`, so
control moves to lines 6 and 7; `return` sends it back to line 14. In this file the study
header comes first, so add 63 to a book line number: book line 12 is line 75 here. `cat -n
book_02_function_demo.sh` shows the file with its line numbers.

There are two ways to write a function, and they do the same thing:

| Form | First line | Where you see it |
|---|---|---|
| Formal | `function step2 {` | This demo |
| Simpler | `step2 () {` | Every other script in this chapter; the book prefers it |

Either way, the parentheses stay empty. A function's name follows the same rules as a
variable's name, and its body must hold at least one command. `return` is optional (the
closing brace ends the function too), but it makes the end easy to see.

Try this:

- In a copy, call `step2` twice in a row. `Step 2` prints twice: define once, call as often as
  you like.
- Move the `step2` call up, right after `# Shell function demo`, above the definition. Bash
  prints `./mine.sh: line N: step2: command not found`, then `Step 1` and `Step 3`: bash met the
  name before the definition, looked for a program called `step2`, and found none.
- Rewrite the first line of the definition as `step2 () {`. Nothing changes.

### book_03_sys_info_page_stubs.sh

The three commands planned in `book_01` now exist, as functions that only `return`. What
changed from `book_01`: three function definitions above the here document, and the here
document's indents are now 4 and 8 spaces.

```bash
#!/bin/bash

# Program to output a system information page

TITLE="System Information Report For $HOSTNAME"
CURRENT_TIME="$(date +"%x %r %Z")"
TIMESTAMP="Generated $CURRENT_TIME, by $USER"

report_uptime () {
    return
}

report_disk_space () {
    return
}

report_home_space () {
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
| The three assignments | Unchanged. |
| `report_uptime () {` | Defines a function named `report_uptime`, in the simpler form. |
| `    return` | The whole body. A function needs at least one command; `return` is enough. A function like this, holding a place for code you will write later, is a **stub**. |
| `}` | Ends the definition. The other two functions are built the same way. |
| `cat << _EOF_` | The here document, as before. The functions are defined above it, so they exist when it runs. |
| `$(report_uptime)` and the other two | Each runs its function. A stub prints nothing, so nothing goes into the page. |

Run it:

```bash
$ ./book_03_sys_info_page_stubs.sh
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

The errors are gone, but the page cannot tell you whether the functions ran: an empty line
looks the same either way. `book_05` fixes that.

Try this:

- In a copy, misspell one definition (`report_uptim () {`). The `command not found` error for
  `report_uptime` comes back, because that name is no longer defined.
- Delete `return` from one stub, so its braces hold nothing. Bash answers
  ``syntax error near unexpected token `}'``: a function body cannot be empty.

### book_04_local_vars.sh

A short demo of global and local variables.

```bash
#!/bin/bash

# local-vars: script to demonstrate local variables

foo=0   # global variable foo

funct_1 () {

    local foo # variable foo local to funct_1

    foo=1
    echo "funct_1: foo = $foo"
}

funct_2 () {

    local foo # variable foo local to funct_2

    foo=2
    echo "funct_2: foo = $foo"
}

echo "global:  foo = $foo"
funct_1
echo "global:  foo = $foo"
funct_2
echo "global:  foo = $foo"
```

| Line | What it does |
|---|---|
| `foo=0   # global variable foo` | A global variable: it exists for the whole script, inside functions too. Every variable you have written so far was global. |
| `funct_1 () {` | Defines the first function. |
| `    local foo # variable foo local to funct_1` | Makes a new `foo` that belongs to `funct_1` alone. While the function runs, `foo` means this local one; the global `foo` is hidden, not changed. The space before `#` matters: a comment starts only where `#` begins a word. |
| `    foo=1` | Sets the local `foo`. |
| `    echo "funct_1: foo = $foo"` | Prints the local value, 1. When the function ends, its local `foo` disappears. |
| `funct_2 () {` to `}` | The same with its own local `foo`, set to 2. |
| The five lines at the bottom | The main program: it prints the global `foo` before and after each call. |

Run it:

```bash
$ ./book_04_local_vars.sh
global:  foo = 0
funct_1: foo = 1
global:  foo = 0
funct_2: foo = 2
global:  foo = 0
```

The global `foo` is 0 every time: neither function touched it. That independence lets you copy
a function into another script without it changing that script's variables.

Try this:

- In a copy, delete `local foo` from `funct_1` only. Predict the five lines, then run it. The
  output becomes 0, 1, 1, 2, 1: without `local`, `funct_1` changes the global `foo` to 1,
  while `funct_2`, which still has its `local`, leaves it alone.
- Type `local foo=5` at the prompt, outside any function. Bash answers
  `bash: local: can only be used in a function`.

### book_05_sys_info_page_feedback.sh

Assembled: the book prints only the three new stubs; here they replace the empty functions of
`book_03`, and nothing else changed. What changed from `book_03`: each stub prints its own name
before it returns.

```bash
#!/bin/bash

# Program to output a system information page

TITLE="System Information Report For $HOSTNAME"
CURRENT_TIME="$(date +"%x %r %Z")"
TIMESTAMP="Generated $CURRENT_TIME, by $USER"

report_uptime () {
        echo "Function report_uptime executed."
        return
}

report_disk_space () {
        echo "Function report_disk_space executed."
        return
}

report_home_space () {
        echo "Function report_home_space executed."
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
| `        echo "Function report_uptime executed."` | New in each stub: the function prints a message with its own name. |
| `        return` | Ends the function, as before. |
| `cat << _EOF_` | The here document, unchanged (the book's listing has no blank line before it). |
| `$(report_uptime)` and the other two | The command substitution captures each message and puts it in the page, where the `$( )` was written. |

Run it:

```bash
$ ./book_05_sys_info_page_feedback.sh
<html>
    <head>
        <title>System Information Report For linuxbox</title>
    </head>
    <body>
        <h1>System Information Report For linuxbox</h1>
        <p>Generated MM/DD/YY HH:MM:SS AM EDT, by student</p>
        Function report_uptime executed.
        Function report_disk_space executed.
        Function report_home_space executed.
    </body>
</html>
```

The empty lines of `book_03` became proof that the script reaches all three functions, in
order. This is the habit the book recommends: keep the program in a state that runs, test
after every small change (then the last change is the only suspect), and give every stub
something to say.

Try this:

- In a copy, add a fourth stub, `report_users`, that prints `Function report_users executed.`,
  and add `$(report_users)` to the page. Run it: does your line appear where you expected?
- Swap the `$(report_uptime)` and `$(report_home_space)` lines in the page. The messages follow
  the order of the calls, not the order of the definitions.

### book_06_sys_info_page_filled.sh

Assembled: the book prints the three finished functions one at a time; here they replace the
empty functions of `book_03`, and nothing else changed. What changed from `book_05`: each
function now prints a section heading and the output of one command. The lines inside each
function's here document start with tabs, because `<<-` removes tabs only.

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
    cat <<- _EOF_
		<h2>Home Space Utilization</h2>
		<pre>$(du -sh /home/*)</pre>
		_EOF_
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
| `    cat <<- _EOF_` | Each function prints its section with its own here document. The `-` removes the leading tabs from every line of the block, so it can be indented in the script and still print at the left edge. |
| `<h2>System Uptime</h2>` | A second-level heading (`<h2>`) for the section. |
| `<pre>$(uptime)</pre>` | Runs `uptime` (the time, how long the computer has been running, the users logged in, and the load average: how busy the processor was over the last 1, 5 and 15 minutes). `<pre>` tells the browser to show the text exactly as printed, so the columns stay lined up. |
| `_EOF_` (after two tabs) | Ends the function's here document. With `<<-` it may be indented, but only with tabs. |
| `    return` | Ends the function. |
| `<pre>$(df -h)</pre>` | In `report_disk_space`: the size, used and free space of each disk area (filesystem); `-h` prints sizes as K, M or G. |
| `<pre>$(du -sh /home/*)</pre>` | In `report_home_space`: the space used by each folder in `/home`; `-s` gives one total per folder, `-h` readable sizes. |
| `cat << _EOF_` to `_EOF_` | The page, unchanged. Each `$( )` now receives a whole section from its function. |

Run it (the `df` lines are shortened here; `...` marks lines left out, and ours printed 19
filesystems):

```bash
$ ./book_06_sys_info_page_filled.sh
<html>
    <head>
        <title>System Information Report For linuxbox</title>
    </head>
    <body>
        <h1>System Information Report For linuxbox</h1>
        <p>Generated MM/DD/YY HH:MM:SS AM EDT, by student</p>
        <h2>System Uptime</h2>
<pre> HH:MM:SS up 2 min,  1 user,  load average: 0.07, 0.06, 0.02</pre>
        <h2>Disk Space Utilization</h2>
<pre>Filesystem      Size  Used Avail Use% Mounted on
...
/dev/sdd       1007G  1.7G  954G   1% /
...
tmpfs           3.2G   12K  3.2G   1% /run/user/1000</pre>
        <h2>Home Space Utilization</h2>
<pre>128K	/home/student</pre>
    </body>
</html>
```

Two things to notice. Only the first line of each section has the 8-space indent: that indent
is written once in the page, before `$(report_uptime)`, and the function's other lines start
at the left edge because `<<-` removed their tabs. And the work is nested: the page's here
document runs `$(report_uptime)`, whose own here document runs `$(uptime)`; each output flows
back up into the page.

`du -sh /home/*` works on a computer where you are the only user. On a shared computer other
home folders are private, and `du` prints `Permission denied` for each of them; the book says
the function would then need superuser privileges. Chapter 27 changes `report_home_space` with
`if` to handle that.

Try this:

- Save the page in `~/playground` and open it in a browser. The `<pre>` sections keep their
  columns; the rest of the text flows like a normal web page.
- Run `uptime`, `df -h` and `du -sh ~` at the prompt and compare them with the page.
- In a copy, add a fourth function, `report_date`, that prints `<h2>Date</h2>` and
  `<pre>$(date)</pre>` the same way, and add `$(report_date)` to the page.

### book_07_ds.sh

The book's example of a function to keep in your `~/.bashrc` file, the file bash reads when
a terminal opens (chapter 11). The book prints only the four lines of the function. The last
two lines of this file, a comment that starts `# added:` and the call `ds`, are not from the
book: they are there so that running the file shows `ds` at work.

```bash
#!/bin/bash
ds () {
    echo "Disk Space Utilization For $HOSTNAME"
    df -h
}
# added: the book puts ds in ~/.bashrc; this call lets you see it run here
ds
```

| Line | What it does |
|---|---|
| `ds () {` | Defines a function named `ds` (for "disk space"). |
| `    echo "Disk Space Utilization For $HOSTNAME"` | Prints a heading with the computer's name. |
| `    df -h` | Prints the disk space report. |
| `}` | Ends the definition. A function may hold several commands, which an alias cannot do well: that is why the book prefers functions for personal shortcuts. |
| `# added: ...` | Not from the book: a comment explaining the next line. |
| `ds` | Not from the book: calls the function once. |

Run it (the `df` lines are shortened; `...` marks lines left out):

```bash
$ ./book_07_ds.sh
Disk Space Utilization For linuxbox
Filesystem      Size  Used Avail Use% Mounted on
...
/dev/sdd       1007G  1.7G  954G   1% /
...
tmpfs           3.2G   12K  3.2G   1% /run/user/1000
```

When the script ends, `ds` is gone: a function defined in a script lives only while that
script runs. To keep `ds` in every terminal, make a backup of `~/.bashrc`, add the four lines
of the function (not the two added lines) to the end of the file with vi (chapter 12), and
reload the file in the current terminal with `source`. `type` then shows the definition:

```bash
cp ~/.bashrc ~/.bashrc.bak
vi ~/.bashrc
source ~/.bashrc
ds
type ds
```

Try this:

- After running the script, type `ds` at the prompt (before you edit `~/.bashrc`). Bash says
  `ds: command not found`: the function lived only inside the script.
- After adding `ds` to `~/.bashrc`, open a new terminal and run `ds`. It is there without
  `source`, because every new terminal reads `~/.bashrc`.

## More from the chapter: functions at the prompt

A function works at the prompt too, which is a quick way to try an idea. On one line, put a
space after `{` and a semicolon after each command, including the last one before `}`:

```bash
$ say_hi () { echo "Hi, $USER"; }
$ say_hi
Hi, student
$ type say_hi
say_hi is a function
say_hi () 
{ 
    echo "Hi, $USER"
}
```

A function typed at the prompt lasts until you close that terminal.

## Common mistakes

In the messages, `N` stands for a line number in your script.

| You type | What bash says | Fix |
|---|---|---|
| A call such as `step2` above the function's definition | `./mine.sh: line N: step2: command not found` | Define every function above the main program |
| `report_uptime () { }` (nothing inside) | ``./mine.sh: line N: syntax error near unexpected token `}'`` | Put at least one command inside: `return` |
| `step2 ()` as the call | ``./mine.sh: line N: syntax error near unexpected token `echo'`` (the first word of the next line) | Call a function by its name only: `step2` |
| `hi () {echo hi; }` (no space after `{`) | ``./mine.sh: line N: syntax error near unexpected token `{echo'`` | A space after `{` |
| `hi () { echo hi }` (no `;` before `}`) | `./mine.sh: line N: syntax error: unexpected end of file` | On one line, end the last command with `;` before `}` |
| `local foo=5` outside a function | `./mine.sh: line N: local: can only be used in a function` | Use `local` only inside a function |
| `local foo# comment` (no space before `#`) | ``./mine.sh: line N: local: `foo#': not a valid identifier`` | A space before the `#` |
| A function sets a variable without `local` | Nothing: the main program's variable changes | `local name` inside the function |
| In `book_06`, the first function's closing `_EOF_` indented with spaces | The page shows lines of your own script, and `./mine.sh: line N: report_disk_space: command not found` | Indent `<<-` blocks with tabs only |
| `book_06` on a computer shared with other users | `du: cannot read directory '/home/...': Permission denied` | Expected; chapter 27 reports only your own home folder |
| `ds` after editing `~/.bashrc` | `ds: command not found` | `source ~/.bashrc`, or open a new terminal |

## Check yourself

1. What is top-down design, and when do you stop breaking a step down?
   <details><summary>Answer</summary>Writing a job as a few big steps, then breaking each step
   that is still vague into smaller steps. You stop when every step is one command (or a few)
   you know how to write.</details>
2. A script calls `greet` on line 2 and defines `greet () { ... }` on line 5. What happens, and
   why?
   <details><summary>Answer</summary>Bash prints <code>line 2: greet: command not found</code>.
   It reads the script from top to bottom, so on line 2 it has not met the definition yet and
   looks for a program named <code>greet</code>. Definitions must come above the calls.</details>
3. In `book_04_local_vars.sh`, why does the global `foo` stay 0?
   <details><summary>Answer</summary>Each function declares <code>local foo</code>, which makes a
   separate variable that exists only while that function runs. Setting it to 1 or 2 never
   touches the global <code>foo</code>.</details>
4. What is a stub, and why should it print something?
   <details><summary>Answer</summary>A function that holds a place for code you will write
   later, such as <code>report_uptime () { return; }</code>. If it prints its own name, the
   output proves that the script reached it, so you can test the flow of the program before
   the real code exists.</details>
5. Why does `report_uptime` in `book_06` use `<<-` with tabs, and what goes wrong with spaces?
   <details><summary>Answer</summary><code>&lt;&lt;-</code> removes leading tabs, so the block can
   be indented inside the function and still print at the left edge. It never removes spaces:
   a closing <code>_EOF_</code> indented with spaces is not recognized, so the here document
   swallows the lines after it.</details>
