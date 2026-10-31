# Chapter 33: Flow Control: Looping with for

*The Linux Command Line* (TLCL), chapter 33. The book is free: https://linuxcommand.org/tlcl.php

## What you will learn

- `for` runs its body once for **each word in a list**, so the length of the list decides the
  number of passes. `while` and `until` (chapter 29) ask a question before every pass; `for`
  asks nothing.
- The shell builds the list **before** the loop starts: from words you type (`A B C D`), from a
  brace range (`{A..D}`), from file names (`distros*.txt`), or from a command's output
  (`$(strings file)`). `for` never learns where its words came from.
- A wildcard that matches no file comes back as itself (`distros*.txt`), so a loop over file
  names tests `[[ -e "$i" ]]` before it uses the name.
- `for (( i=0; i<5; i=i+1 ))` is the C language form: the loop for counting.
- The chapter ends by giving the `sys_info_page` project a `for` loop in `report_home_space`.

## Files in this folder

| File | Book name | What it shows |
|---|---|---|
| `book_01_distros_guard.sh` | (no name) | A loop over `distros*.txt` that skips the pattern when no file matches |
| `book_02_longest_word.sh` | `longest-word` | The longest word in each file you name: `for` over the output of `strings` |
| `book_03_longest_word2.sh` | `longest-word2` | The same with `for i; do`, which walks the words typed after the script's name |
| `book_04_simple_counter.sh` | `simple_counter` | Counts from 0 to 4 with `for (( ))` |
| `book_05_sys_info_page.sh` | `sys_info_page` (assembled) | The project script with the new `for`-loop `report_home_space` |

## How to run

```bash
cd ch33_flow_control_looping_with_for
chmod u+x *.sh
./book_04_simple_counter.sh
```

`chmod u+x` gives you, the owner of the files (`u`), permission to execute them (`x`); `./`
means "the program is in this folder". The two `longest_word` scripts take one or more file
names after the script's name (examples below). They use `strings`, from the GNU binutils
package; if bash says `strings: command not found`, that package is missing from your machine:
install it with your system's package manager (chapter 14) or ask your instructor.

The examples below that create files work in a practice folder, `~/playground`, so your own
files are never touched. If a script stops with `/bin/bash^M: bad interpreter`, the file has
Windows line endings; this fixes every script in the folder:

```bash
sed -i 's/\r$//' *.sh
```

## Walkthrough

### for at the prompt

The chapter first shows `for` as a one-line command. Type these two lines; both print `A`, `B`,
`C` and `D`, one per line:

```bash
for i in A B C D; do echo $i; done
for i in {A..D}; do echo $i; done
```

```
A
B
C
D
```

| Part | What it does |
|---|---|
| `for i in A B C D` | `i` is the loop variable (no `$` here). It takes each of the four words in turn. |
| `; do` | Ends the list and starts the body. On one line, the `;` before `do` is required. |
| `echo $i` | The body: it runs once per word, with `$i` holding the current word. |
| `; done` | Ends the body; the loop goes back for the next word, and stops after the last one. |
| `{A..D}` | Brace expansion: the shell turns `{A..D}` into `A B C D` before `for` runs. `{1..5}` gives `1 2 3 4 5`, and `{1..10..2}` gives `1 3 5 7 9`. |

Look at a list before a loop uses it: `echo {1..5}` prints the words the loop would receive.

### book_01_distros_guard.sh

Next the book builds the list from file names with a wildcard. If no file matches, the loop
receives the pattern itself, so the book adds a guard. It prints these lines without a
`#!/bin/bash` line; line 1 of the file adds it.

```bash
for i in distros*.txt; do
    if [[ -e "$i" ]]; then
        echo "$i"
    fi
done
```

| Line | What it does |
|---|---|
| `for i in distros*.txt; do` | Before the loop starts, the shell replaces the pattern with the matching file names in the current folder, in alphabetical order (the wildcards of chapter 4). If nothing matches, the pattern stays exactly as typed. |
| `if [[ -e "$i" ]]; then` | `-e` (chapter 27) is true only when a file with that name exists, so an unmatched pattern is skipped. |
| `echo "$i"` | Prints the name. The quotes keep a name with spaces in one piece. |
| `fi` / `done` | End the `if`, then end the loop body. |

The book's `distros` files come from a later chapter (chapter 20); empty files with the same
names are enough. In this folder the script prints nothing. Make three files in the practice
folder and run it there:

```bash
src="$PWD"
mkdir -p ~/playground && cd ~/playground
touch distros.txt distros-dates.txt distros-names.txt
"$src/book_01_distros_guard.sh"
cd "$src"
```

```
distros-dates.txt
distros-names.txt
distros.txt
```

Try this:

- In an empty folder, type the loop without the guard:

  ```bash
  mkdir -p ~/playground/empty && cd ~/playground/empty
  for i in distros*.txt; do echo "$i"; done
  ```

  It prints `distros*.txt`: the pattern matched nothing, so it came back as itself.
- In a copy, change `distros*.txt` to `*.sh` and run the copy in this folder. Which names print?

### book_02_longest_word.sh

Another common source of words is a command's output.

```bash
#!/bin/bash

# longest-word: find longest string in a file

while [[ -n "$1" ]]; do
    if [[ -r "$1" ]]; then
        max_word=
        max_len=0
        for i in $(strings "$1"); do
            len="$(echo -n "$i" | wc -c)"
            if (( len > max_len )); then
                max_len="$len"
                max_word="$i"
            fi
        done
        echo "$1: '$max_word' ($max_len characters)"
    fi
    shift
done
```

| Line | What it does |
|---|---|
| `while [[ -n "$1" ]]; do` | `$1` is the first word typed after the script's name; `-n` is true while it is not empty, so the loop runs once per file name you typed. |
| `if [[ -r "$1" ]]; then` | `-r` is true when the file exists and you may read it. Any other name is skipped without a message. |
| `max_word=` / `max_len=0` | Resets the record for each file: no word yet, length 0. |
| `for i in $(strings "$1"); do` | `strings` prints the readable text in a file (it was made for program files; on a text file it prints the lines). `$( )` is **command substitution**: bash runs the command and puts its output in its place. Unquoted on purpose: bash splits that output into words at every space, tab and line break, and `for` gets one word per pass. |
| `len="$(echo -n "$i" \| wc -c)"` | Measures the word: `echo -n` prints it with no line break, and the pipe `\|` hands it to `wc -c`, which counts its characters (both chapter 6). |
| `if (( len > max_len )); then` ... `fi` | Keeps the word when it beats the record. With `>`, not `>=`, the first of several equally long words wins. |
| `echo "$1: '$max_word' ($max_len characters)"` | Prints the file name and the winner. |
| `shift` | Throws `$1` away and moves every remaining word down one place, so the next file name becomes `$1`. |

`$1` and `shift` are positional parameters, chapter 32, which CET 2390 does not teach: read
them as explained in the table; you are not asked to write them. Make two small text files and
run the script on both (`>` saves `echo`'s line in a new file: redirection, chapter 6):

```bash
mkdir -p ~/playground
echo "The quick brown fox jumps over the lazy dog" > ~/playground/fox.txt
echo "one two three four five six seven" > ~/playground/count.txt
./book_02_longest_word.sh ~/playground/fox.txt ~/playground/count.txt
```

```
/home/student/playground/fox.txt: 'quick' (5 characters)
/home/student/playground/count.txt: 'three' (5 characters)
```

Your user name appears in place of `student`: bash replaces `~` with the path of your home
folder before the script starts. `quick`, `brown` and `jumps` all have five letters; `quick`
comes first, so it wins. Run it on one of the scripts in this folder:

```bash
./book_02_longest_word.sh book_04_simple_counter.sh
```

```
book_04_simple_counter.sh: '=============================================================================' (77 characters)
```

The winner is the line of 77 `=` signs at the top of the study header. To the loop, a word is
anything between spaces, and 77 `=` in a row is one word.

Try this:

- Add a name that does not exist: `./book_02_longest_word.sh nosuch ~/playground/fox.txt`. Only
  `fox.txt` is reported: `[[ -r "$1" ]]` is false for `nosuch`, and `shift` moves on.
- In a copy, put double quotes around `$(strings "$1")` and run the copy on `fox.txt`. It reports
  the whole line, 43 characters, as one "word": quoted, the output is not split.

### book_03_longest_word2.sh

The same program with the outer `while` replaced by `for`.

```bash
#!/bin/bash

# longest-word2: find longest string in a file

for i; do
    if [[ -r "$i" ]]; then
        max_word=
        max_len=0
        for j in $(strings "$i"); do
            len="$(echo -n "$j" | wc -c)"
            if (( len > max_len )); then
                max_len="$len"
                max_word="$j"
            fi
        done
        echo "$i: '$max_word' ($max_len characters)"
    fi
done
```

| Line | What it does |
|---|---|
| `for i; do` | A `for` with no `in words` part walks the words typed after the script's name, one per pass, so `i` holds each file name in turn. It replaces the `while`, and `shift` is no longer needed. |
| `if [[ -r "$i" ]]; then` | Every `"$1"` of `longest-word` became `"$i"`. |
| `for j in $(strings "$i"); do` | The inner loop's variable is now `j`, because `i` belongs to the outer loop. |
| The rest | The same as `longest-word`. |

The output is the same:

```bash
./book_03_longest_word2.sh ~/playground/fox.txt ~/playground/count.txt
```

```
/home/student/playground/fox.txt: 'quick' (5 characters)
/home/student/playground/count.txt: 'three' (5 characters)
```

Try this:

- Run it with no file names. Nothing prints: the list is empty, so the loop makes no passes.
- In a copy, rename the inner variable back to `i` (in `for j in` and the three `$j` after it)
  and run the copy on the same two files. The output starts with `dog:` and `seven:`, the last
  word of each file. Why? (The outer `for` still finds the next file name, but the inner loop
  has overwritten `i` by the time `echo` runs.)

### book_04_simple_counter.sh

The C language form of `for`.

```bash
#!/bin/bash

# simple_counter: demo of C style for command

for (( i=0; i<5; i=i+1 )); do
    echo $i
done
```

| Line | What it does |
|---|---|
| `for (( i=0; i<5; i=i+1 )); do` | Three arithmetic expressions: `i=0` runs once, before the first pass; `i<5` is tested before every pass and ends the loop the moment it is false; `i=i+1` runs at the end of every pass. |
| `echo $i` | Prints the current value. |
| `done` | Ends the body. |

Inside `(( ))` a name is read as a variable, so you write `i`, not `$i`, as in the `(( ))` test
of chapter 27. Many scripts write `i++` for `i=i+1`; inside `(( ))` both mean "add 1 to i".

```
0
1
2
3
4
```

After the fifth pass `i` becomes 5, `i<5` is false, and the loop ends (an `echo "$i"` after
`done` prints 5). The book points out that this does the same work as a `while` loop:

```bash
(( i=0 ))
while (( i<5 )); do
    echo $i
    (( i=i+1 ))
done
```

Try this:

- Make it print 1 to 5. Which of the three expressions must change?
- Make it print 0, 2, 4, 6 and 8. Change only the step.

### book_05_sys_info_page.sh (assembled)

The project script that grew through chapters 25 to 27 gets its last improvement here. The
book shows only the new `report_home_space` function, so this file is **assembled**: the full
listing of chapter 26 ("Shell Functions"), `report_uptime` and `report_disk_space` from
chapter 26 ("Keep Scripts Running"), and chapter 33's new `report_home_space`; nothing else
changed. The book's own copy at this point also has the command-line options from chapter 32,
which CET 2390 does not teach, so they are not included.

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

    local format="%8s%10s%10s\n"
    local i dir_list total_files total_dirs total_size user_name

    if [[ "$(id -u)" -eq 0 ]]; then
        dir_list=/home/*
        user_name="All Users"
    else
        dir_list="$HOME"
        user_name="$USER"
    fi

    echo "<h2>Home Space Utilization ($user_name)</h2>"

    for i in $dir_list; do

        total_files="$(find "$i" -type f | wc -l)"
        total_dirs="$(find "$i" -type d | wc -l)"
        total_size="$(du -sh "$i" | cut -f 1)"

        echo "<H3>$i</H3>"
        echo "<pre>"
        printf "$format" "Dirs" "Files" "Size"
        printf "$format" "----" "-----" "----"
        printf "$format" "$total_dirs" "$total_files" "$total_size"
        echo "</pre>"
    done
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
| `TITLE=...`, `CURRENT_TIME=...`, `TIMESTAMP=...` | The page's title and its "Generated" line. `date +"%x %r %Z"` prints the date, the time and the time zone. |
| `report_uptime` / `report_disk_space` | From chapter 26: each prints a heading and a command's output with a here document. `<<-` removes leading **tabs**, so those lines are indented with tabs, not spaces. |
| `local format="%8s%10s%10s\n"` | A layout for `printf` (chapter 21): three strings, 8, 10 and 10 characters wide, pushed to the right, then a line break. `local` keeps the variables inside the function (chapter 26). |
| `if [[ "$(id -u)" -eq 0 ]]; then` ... `fi` | The `if` now only chooses the list: `/home/*` and "All Users" for the superuser (user ID 0), `$HOME` and `$USER` for everyone else. In the chapter 27 version, the `if` did all the reporting itself. |
| `dir_list=/home/*` | No expansion happens in an assignment: `dir_list` holds the text `/home/*`. |
| `for i in $dir_list; do` | Unquoted, so here the wildcard expands: one pass per home folder (one pass for a regular user). |
| `find "$i" -type f \| wc -l` | `find` (chapter 17) lists every file under the folder; `wc -l` counts the lines. `-type d` counts folders, the folder itself included. |
| `du -sh "$i" \| cut -f 1` | The folder's size; `cut -f 1` keeps the first column and drops the folder name. |
| `echo "<H3>$i</H3>"` ... `echo "</pre>"` | A heading, then three rows lined up by `$format`. The book writes `<H3>` in capitals; HTML does not mind. |
| `cat << _EOF_` ... `_EOF_` | Prints the page; each `$(report_...)` runs a function and puts its output into the page. |

Save the page in the practice folder and open it in the web browser:

```bash
mkdir -p ~/playground
./book_05_sys_info_page.sh > ~/playground/sys_info_page.html
firefox ~/playground/sys_info_page.html
```

`find` walks every file in your home folder, so a large home folder takes a few seconds. The
end of the page, on a test machine whose user is `student` (your name and numbers will differ):

```
        <h2>Home Space Utilization (student)</h2>
<H3>/home/student</H3>
<pre>
    Dirs     Files      Size
    ----     -----      ----
      14        25      204K
</pre>
    </body>
</html>
```

Try this:

- Type `echo /home/*` at the prompt: that is the list the superuser's loop would walk.
- In a copy, change the format to `"%-8s%-10s%-10s\n"`. What does the `-` do to the columns?

## Common mistakes

| You type | What bash says | Fix |
|---|---|---|
| `for i in 1 2 3 do echo "$i"; done` (one line) | ``syntax error near unexpected token `done'`` | `for i in 1 2 3; do`. Without the `;`, `do` became one more word of the list, so bash finds `done` with no `do` |
| `for i in 1 2 3 do` in a script, with the body on the lines below | ``line 2: syntax error near unexpected token `echo'`` | The same fix. Here bash names the first command of the body, not `done`: "reported at done" is true only for a one-line loop |
| A `for` with no `done` | `syntax error: unexpected end of file` | Close every loop with `done` |
| `for $f in *.txt; do` | ``line 1: `$f': not a valid identifier`` | No `$` on the loop variable: `for f in *.txt` |
| The loop prints `distros*.txt` | No message: no file matched, so the pattern itself was the list | Test `[[ -e "$i" ]]` before using the name |
| `cat $f` when a file is named `my notes.txt` | `cat: my: No such file or directory` and `cat: notes.txt: No such file or directory` | Quote it: `cat "$f"` |
| `n=5; for i in {1..$n}` | No message: one pass, with `i` set to the text `{1..5}` | Brace expansion happens before `$n` is replaced; count with `for (( i=1; i<=n; i=i+1 ))` |
| `./book_02_longest_word.sh` on a machine without binutils | `strings: command not found` (after the script's name and a line number) | Install the binutils package |
| Tabs before `_EOF_` in `book_05` turned into spaces | `report_disk_space: command not found`, or `syntax error: unexpected end of file` | `<<-` strips tabs only: indent those lines with tabs again |
| A file saved on Windows | `/bin/bash^M: bad interpreter: No such file or directory` | `sed -i 's/\r$//' myscript.sh` |

## Check yourself

1. In `for i in distros*.txt`, who builds the list of words, and what does the loop receive
   when no file matches?
   <details><summary>Answer</summary>The shell builds it before the loop starts, by replacing
   the wildcard with the matching file names. When nothing matches, the loop receives one word:
   the pattern <code>distros*.txt</code> itself. That is why the book tests
   <code>[[ -e "$i" ]]</code>.</details>
2. Why does `longest-word` leave `$(strings "$1")` without double quotes?
   <details><summary>Answer</summary>Unquoted, the output is split into words, so
   <code>for</code> makes one pass per word. Quoted, the whole output would be one single word
   and the loop would make one pass.</details>
3. What list does `for i; do` walk?
   <details><summary>Answer</summary>The words typed after the script's name, one per pass
   (the positional parameters of chapter 32).</details>
4. In `for (( i=0; i<5; i=i+1 ))`, when does each of the three parts run, and what is `i` after
   the loop?
   <details><summary>Answer</summary><code>i=0</code> runs once before the first pass,
   <code>i&lt;5</code> is tested before every pass, and <code>i=i+1</code> runs at the end of
   every pass. After the loop <code>i</code> is 5, the first value that made the test
   false.</details>
5. You type `for i in 1 2 3 do echo $i; done` at the prompt. Why does the error name `done`?
   <details><summary>Answer</summary>Without a <code>;</code> before it, <code>do</code> is read
   as one more word of the list, so the loop still has no <code>do</code> when bash reaches
   <code>done</code>. Write <code>for i in 1 2 3; do</code>.</details>
