# Chapter 24: Writing Your First Script

*The Linux Command Line* (TLCL), chapter 24. The book is free: https://linuxcommand.org/tlcl.php

## What you will learn

- A **shell script** is a plain text file of commands. Bash reads the file and runs the
  commands one after another, as if you typed them at the prompt.
- Three steps make any script run: **write** it in an editor, make it **executable** with
  `chmod`, and **run** it from a place the shell can find (or put `./` in front of its name).
- Line 1, `#!/bin/bash`, is the **shebang**: it tells Linux which program reads the file.
  Every other line that starts with `#` is a **comment**, which bash skips.
- Bash looks for commands only in the folders listed in the `PATH` variable. Putting your
  scripts in `~/bin` lets you run them by name from anywhere.
- Scripts are read by people too: long option names and one command split over several lines
  make a script easier to read and fix.

## Files in this folder

| File | Book name | What it shows |
|---|---|---|
| `book_01_hello_world.sh` | `hello_world` | The book's first script: the shebang, a comment and one `echo` |

## How to run

```bash
cd ch24_writing_your_first_script
chmod u+x *.sh
./book_01_hello_world.sh
```

`chmod u+x` gives you, the owner of the file (`u`), permission to execute it (`x`). You do it
once per file. `./` means "the program is in this folder". If a script stops with
`/bin/bash^M: bad interpreter`, the file has Windows line endings; this fixes it:

```bash
sed -i 's/\r$//' *.sh
```

## Walkthrough

### book_01_hello_world.sh

The book's code (open the file to see it with the full explanation at the top):

```bash
#!/bin/bash

# This is our first script.

echo 'Hello World!'
```

| Line | What it does |
|---|---|
| `#!/bin/bash` | The shebang. When you run the file, Linux reads this line to find the program that should read the rest: bash. It must be line 1, starting with `#!`. |
| (blank) | Ignored. Blank lines only make a script easier to read. |
| `# This is our first script.` | A comment. Bash skips any line that starts with `#`. |
| `echo 'Hello World!'` | An ordinary command: it prints its argument. The single quotes keep `!` from being treated as a special character. |

Run it:

```bash
$ ./book_01_hello_world.sh
Hello World!
```

Try this:

- Run it without `./`: `book_01_hello_world.sh`. Bash says `command not found`, because the
  current folder is not in `PATH`. Look at `echo $PATH` to see where bash searches.
- Copy it (`cp book_01_hello_world.sh mine.sh`), add a line `echo "I am $USER"`, and run the
  copy. Then add `pwd` and `ls`: a script can run any command you already know.

## Running a script by name: ~/bin and PATH

The book's next examples are typed at the prompt. `PATH` is a list of folders separated by
colons; bash looks through them, in order, for every command you type:

```bash
echo $PATH
```

On Linux Mint, `~/.profile` adds `/home/yourname/bin` to the list when you log in, but only if
that folder exists at that moment. Make the folder, copy the script into it, then reread
`~/.profile` (or log out and back in) and run the script by name from anywhere:

```bash
mkdir ~/bin
cp book_01_hello_world.sh ~/bin/hello_world
source ~/.profile
hello_world
```

| Folder | What goes there |
|---|---|
| `~/bin` | Your own scripts, for your account only |
| `/usr/local/bin` | Scripts for every user of the machine (needs administrator rights) |
| `/usr/bin` | Programs installed by the system; do not put your files here |

## Writing scripts people can read

Long option names explain themselves, and a backslash (`\`) at the very end of a line joins it
to the next line, so one long command can be split for reading:

```bash
ls -ad /etc/b*          # short options: fast to type at the prompt
ls --all --directory /etc/b*    # long options: easier to read in a script
```

```bash
ls -l \
   --human-readable \
   /etc/hostname
```

Nothing may follow the backslash, not even a space; otherwise the next line runs as a separate
command.

## Common mistakes

| You type | What bash says | Fix |
|---|---|---|
| `./book_01_hello_world.sh` before `chmod` | `bash: ./book_01_hello_world.sh: Permission denied` | `chmod u+x book_01_hello_world.sh` |
| `book_01_hello_world.sh` (no `./`) | `bash: book_01_hello_world.sh: command not found` | `./book_01_hello_world.sh`, or move it into `~/bin` |
| `#!/bin/bsh` (typo in line 1) | `bash: ./myscript.sh: /bin/bsh: bad interpreter: No such file or directory` | Line 1 must be exactly `#!/bin/bash` |
| A file saved on Windows | `/bin/bash^M: bad interpreter: No such file or directory` | `sed -i 's/\r$//' myscript.sh` |
| A space after a line-ending `\` | The next line runs as its own command | Delete everything after the `\` |

## Check yourself

1. What does the shebang line do, and why must it be line 1?
   <details><summary>Answer</summary>It tells Linux which program reads the rest of the file
   (here bash). Linux only looks at the first two characters of the file for <code>#!</code>, so the
   line must come first.</details>
2. You wrote `myscript.sh` and typed `myscript.sh` at the prompt. Bash says `command not found`.
   Give two ways to run it.
   <details><summary>Answer</summary>Run it with its path, <code>./myscript.sh</code>, or move it into a
   folder listed in <code>PATH</code>, such as <code>~/bin</code>, and run it by name.</details>
3. What does `chmod u+x myscript.sh` change?
   <details><summary>Answer</summary>It adds execute permission (<code>x</code>) for the file's owner
   (<code>u</code>), so the owner can run the file as a program.</details>
4. Bash skips two kinds of line in a script. Which ones?
   <details><summary>Answer</summary>Comments (lines that start with <code>#</code>) and blank lines.
   The shebang starts with <code>#</code> too: bash skips it, but Linux reads it first.</details>
