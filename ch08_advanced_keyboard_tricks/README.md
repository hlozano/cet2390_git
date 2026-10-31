# Chapter 8: Advanced Keyboard Tricks

*The Linux Command Line* (TLCL), chapter 8. The book is free: https://linuxcommand.org/tlcl.php

## What you will learn

- Bash reads the line you type through a library called **Readline**, which turns the
  command line into a small editor: a few control keys move the cursor, fix typos, and cut
  and paste text without the arrow keys or the mouse.
- **Tab completion**: press Tab and bash finishes a file name, folder, command, variable or
  user name for you; press Tab twice to see every possible match.
- Bash keeps a **history** of the commands you type. `history` lists it, and `Ctrl-r`
  searches it as you type.
- **History expansion** (`!!`, `!88`, `!string`) reruns old commands, and `script` records a
  whole terminal session in a file.
- None of this is required. The book calls these tricks "optional and potentially helpful":
  pick the few that fit your hands.

## Files in this folder

This chapter has no scripts and no data files. Its examples are keys you press and commands
you type at the prompt, all explained below. Keep a terminal open and try each key as you
read.

## The book's examples

**How to read the key names.** `Ctrl-a` means: hold the Ctrl key and press a. `Alt-f` means:
hold the Alt key and press f. Letters are written in lowercase and you never need Shift. None
of these keys needs Enter; they act on the line as you type it.

**A safe line to practice on.** Type a line that starts with `echo` and press the keys
before you press Enter: if you make a mess, Enter only prints some words. To throw a line
away without running it, press `Ctrl-u` (it clears everything before the cursor) or
`Ctrl-c`.

### Command Line Editing

Readline is a library (a shared collection of routines that different programs can use).
Because many programs use it, the same keys also work at other prompts, such as the
`python3` prompt.

Some `Alt` keys may be taken by the terminal window for its own menus: in some terminals
`Alt-f` opens the File menu instead of moving the cursor. All of them work in a virtual
console (a full-screen text login with no desktop), and in a window there is a way around
it, explained in "The Meta Key" below.

### Cursor Movement

| Key | Action (the book's Table 8-1) |
|---|---|
| `Ctrl-a` | Move the cursor to the beginning of the line |
| `Ctrl-e` | Move the cursor to the end of the line |
| `Ctrl-f` | Move forward one character (same as the Right arrow) |
| `Ctrl-b` | Move backward one character (same as the Left arrow) |
| `Alt-f` | Move forward one word |
| `Alt-b` | Move backward one word |
| `Ctrl-l` | Clear the screen and move the cursor to the top-left corner; the line you are typing stays |

`clear` is the command that does what `Ctrl-l` does:

```bash
clear
```

Try this: type `sl -l /usr/bin` (with the typo at the front) but do not press Enter. Instead
of holding Backspace, press `Ctrl-a` to jump to the start and fix it. Enter runs the whole
line, wherever the cursor is.

### Modifying Text

| Key | Action (the book's Table 8-2) |
|---|---|
| `Ctrl-d` | Delete the character at the cursor |
| `Ctrl-t` | Transpose (swap) the character at the cursor with the one before it |
| `Alt-t` | Transpose the word at the cursor with the one before it |
| `Alt-l` | Lowercase from the cursor to the end of the word |
| `Alt-u` | Uppercase from the cursor to the end of the word |

`Alt-l` and `Alt-L` (with Shift) do the same thing: by default Readline treats Alt with a
capital letter as the lowercase key, so the letters are written in lowercase.

Two things to try:

- Type `echo raedme.txt`, put the cursor on the `e` of `raedme` (Ctrl-a, then `Ctrl-f` six
  times), and press `Ctrl-t`. The line becomes `echo readme.txt`: the `a` and the `e` traded
  places.
- Type `echo one two` and press `Alt-t` at the end of the line: it becomes `echo two one`.

**Careful with Ctrl-d on an empty line.** There it means "end of input" (the same signal that
ended `cat` in chapter 6), so the shell exits and the terminal window closes.

### Cutting and Pasting (Killing and Yanking) Text

The Readline documentation says **kill** for cut and **yank** for paste. Killed text goes into
a buffer (a temporary storage area in memory) called the **kill-ring**.

| Key | Action (the book's Table 8-3) |
|---|---|
| `Ctrl-k` | Kill from the cursor to the end of the line |
| `Ctrl-u` | Kill from the cursor back to the beginning of the line |
| `Alt-d` | Kill from the cursor to the end of the current word |
| `Alt-Backspace` | Kill from the cursor back to the beginning of the current word; if the cursor is at the start of a word, kill the previous word |
| `Ctrl-y` | Yank (paste) the text from the kill-ring at the cursor |

Try it: type `echo one two three` but do not press Enter. Press `Ctrl-a` (start of the line),
`Alt-f` (the cursor moves past `echo`), `Alt-d` (` one` is cut), `Ctrl-e` (end of the line)
and `Ctrl-y` (the cut text is pasted). Now press Enter:

```text
$ echo two three one
two three one
```

A handy use: you are halfway through a long command and realize you need to run something
else first. Press `Ctrl-u` to kill the line (it is saved, not lost), run the other command,
then press `Ctrl-y` to get the long command back.

The kill-ring is not the desktop clipboard. In a terminal window, copy and paste with the
mouse use `Ctrl-Shift-c` and `Ctrl-Shift-v`; plain `Ctrl-c` stops the running command.

### The Meta Key

The Readline documentation (the READLINE section of `man bash`) talks about a **meta** key.
Readline is older than the PC: it was written for terminals, keyboard-and-screen devices
wired to a shared computer, and since not every terminal had an extra modifier key, Readline
invented one and called it meta. On a modern keyboard, meta is `Alt`.

Readline also accepts a second way to type it: **press and release Esc, then press the
letter**. So `Esc` then `f` does the same as `Alt-f`. That is the way around a terminal
window that takes the Alt key for its menus.

### Completion

Completion happens when you press Tab while typing. To see the book's examples behave as
printed, use a practice folder that looks like the book's home directory (if you made it in
chapter 7, the `mkdir` lines change nothing):

```bash
mkdir -p ~/playground/home_like
cd ~/playground/home_like
mkdir -p Desktop Documents Music Pictures Public Templates Videos
ls -l /usr/bin > ls-output.txt
ls
```

Now type each line below **without pressing Enter**, then press the key shown:

| You type | Then press | What happens |
|---|---|---|
| `ls l` | Tab | The line becomes `ls ls-output.txt`: only one name starts with `l` |
| `ls D` | Tab | Nothing (the terminal may beep): `D` matches both `Desktop` and `Documents` |
| `ls D` | Tab Tab | The second Tab lists the choices: `Desktop/` and `Documents/` |
| `ls Do` | Tab | The line becomes `ls Documents/` |

For completion to work, the start you type must match only one name. Bash adds a `/` after a
folder name (the book's older output shows none). Press `Ctrl-u` after each line, or press
Enter: these are only `ls` commands.

In your real home folder there is usually a `Downloads` folder too, so `Do` matches two
names there and Tab does nothing. Type one more letter: `Doc` then Tab gives `Documents/`.
The rule is the same: one match, one completion.

Completion works on more than file names:

| You type | Then press | Completes to | Because |
|---|---|---|---|
| `upti` | Tab | `uptime` | The first word on the line completes from command names |
| `echo $HOM` | Tab | `echo $HOME` | A word starting with `$` completes from variable names |
| `echo ~ro` | Tab | `echo ~root/` | A word starting with `~` completes from user names |

A word starting with `@` completes from host names, but only the few listed in `/etc/hosts`.
Note that `echo $HO` and Tab does nothing: `$HO` matches `$HOME`, `$HOSTNAME` and `$HOSTTYPE`,
as Tab Tab shows.

Two more completion keys (the book's Table 8-4):

| Key | Action |
|---|---|
| `Alt-?` | List the possible completions (Tab twice does the same, and is easier) |
| `Alt-*` | Insert all possible completions: `ls D` then `Alt-*` becomes `ls Desktop Documents` |

### Programmable Completion

Your distribution adds extra completion rules for many programs, so Tab can complete things
it could never work out from the file system: command options, for example. Type
`ls --he` and press Tab: the line becomes `ls --help`.

These rules are written as shell functions (small named pieces of shell code; chapter 26
starts using them). You can find them in the list of everything the shell knows:

```bash
set | less
```

In `less`, type `/^_` and press Enter to jump to the first function whose name starts with
an underscore, which is how most completion functions are named; `n` jumps to the next
match and `q` quits. The list is long.

### Using History

Bash remembers the commands you type and keeps the list in a hidden file in your home
folder, `.bash_history`:

```bash
ls -a ~
```

Bash writes the commands of a session to that file when the shell exits, so a command you
typed a minute ago may not be in the file yet. The `history` command shows the full list,
including this session.

### Searching History

```bash
history | less
history | grep /usr/bin
```

The first line pages through the whole list (`q` quits). The book says bash keeps the last
500 commands; on Mint, `~/.bashrc` raises that to 1000 (`echo $HISTSIZE` shows it; chapter 11
explains how to change it). The second line uses a pipe and `grep` (chapter 6) to keep only
the commands that mention `/usr/bin`. Each line starts with a number; in the book, one of the
lines found was:

```text
   88  ls -l /usr/bin > ls-output.txt
```

The number is the command's place in the list. `!88` would run line 88 again (this is
history expansion, below). Your numbers are different: always look up the number in your own
list before you use it.

**Incremental search** finds a command as you type. Press `Ctrl-r` and the prompt changes:

```text
(reverse-i-search)`':
```

Type part of a command, for example `/usr/bin`. Each letter narrows the search, and the most
recent matching command appears at once:

```text
(reverse-i-search)`/usr/bin': ls -l /usr/bin > ls-output.txt
```

"Reverse" means it searches from now back into the past. Then:

| Key | What it does |
|---|---|
| `Enter` | Run the command shown |
| `Ctrl-j` | Stop searching and copy the command to the command line, so you can edit it first |
| `Ctrl-r` again | Find the next older match |
| `Ctrl-g` or `Ctrl-c` | Give up the search |

The other history keys (the book's Table 8-5):

| Key | Action |
|---|---|
| `Ctrl-p` | Previous history entry (same as the Up arrow) |
| `Ctrl-n` | Next history entry (same as the Down arrow) |
| `Alt-<` | Move to the beginning (top) of the history list |
| `Alt->` | Move to the end (bottom) of the list, which is the line you are typing |
| `Ctrl-r` | Reverse incremental search |
| `Alt-p` | Reverse search, not incremental: type the text, then press Enter to search |
| `Alt-n` | Forward search, not incremental |
| `Ctrl-o` | Run the current history entry and move to the next one; handy for rerunning a sequence of commands |

### History Expansion

An exclamation mark starts **history expansion**: bash replaces it with a command from the
history list before running the line. The forms (the book's Table 8-6):

| Sequence | Action |
|---|---|
| `!!` | Repeat the last command (Up arrow then Enter is easier) |
| `!number` | Repeat history list item *number* |
| `!string` | Repeat the last command that starts with *string* |
| `!?string` | Repeat the last command that contains *string* |

Try them safely with `echo`:

```bash
echo hello history
!!
!echo
!?hello
```

```text
$ echo hello history
hello history
$ !!
echo hello history
hello history
$ !echo
echo hello history
hello history
$ !?hello
echo hello history
hello history
```

Bash prints the expanded command first, then its output. Always read that line. The book's
caution: use `!string` and `!?string` only when you are sure what the last match is, because
bash runs whatever it finds, with no question asked. With `rm` instead of `echo`, a wrong
guess deletes files.

One more form, not in the book's table but used all the time: `!$` is the last word of the
previous command.

```text
$ echo one > notes.txt
$ cat !$
cat notes.txt
one
```

### script

Besides the history list, most Linux systems include `script`, a program that records a
whole terminal session, commands and output, into a file. The syntax is `script [file]`; with
no file name, the recording goes into a file named `typescript`. Everything you do is
recorded until you type `exit`:

```bash
cd ~/playground
script session.txt
echo this line goes into the recording
exit
cat session.txt
```

```text
$ script session.txt
Script started, output log file is 'session.txt'.
$ echo this line goes into the recording
this line goes into the recording
$ exit
exit
Script done.
```

`cat session.txt` shows the recording; its first line records when it started. (`less`
shows the colour codes of your prompt as odd characters; `cat` lets the terminal
interpret them.)

## Common mistakes

| You type | What bash says | Fix |
|---|---|---|
| `echo "Wow!Great"` | `bash: !Great: event not found` | `!` starts history expansion, even inside double quotes; use single quotes: `echo 'Wow!Great'` |
| `!88`, without checking the number | Bash runs whatever command is number 88 in your list | Run `history` first and use a number from your own list |
| `ls D` then Tab | Nothing happens (maybe a beep) | More than one name matches: press Tab again to list them, then type another letter |
| `Alt-f` | The terminal's File menu opens | The window took the Alt key: press Esc, then f |
| `Ctrl-d` on an empty line | The terminal window closes | On an empty line Ctrl-d means "end of input", so the shell exits; open a new terminal |
| `Ctrl-c` to copy text | The running command stops | In a terminal window, copy is `Ctrl-Shift-c` and paste is `Ctrl-Shift-v` |
| `Ctrl-s` | The terminal seems frozen | Ctrl-s pauses the output; `Ctrl-q` starts it again |

## Check yourself

1. You typed a long command, and the typo is in the first word. Which two keys take you to
   the start of the line and back to the end?
   <details><summary>Answer</summary><code>Ctrl-a</code> jumps to the beginning of the line and
   <code>Ctrl-e</code> to the end. (Enter runs the whole line from anywhere, so you do not even need
   <code>Ctrl-e</code> before pressing it.)</details>
2. You type `ls Mu` and press Tab, and nothing happens. Give two possible reasons.
   <details><summary>Answer</summary>More than one name starts with <code>Mu</code> (Tab twice lists
   them), or no name does, because of a typo or because you are in a different folder.</details>
3. What is the difference between pressing Enter and pressing `Ctrl-j` during a `Ctrl-r`
   search?
   <details><summary>Answer</summary>Enter runs the command that was found. <code>Ctrl-j</code> stops
   the search and puts the command on the line, so you can read and edit it before you run
   it.</details>
4. What does `!!` do, and why does the book prefer the Up arrow for the same job?
   <details><summary>Answer</summary><code>!!</code> repeats the last command. The Up arrow shows you
   the command before you press Enter, while <code>!!</code> runs it at once.</details>
5. You cut a word with `Alt-d`. Where did it go, and how do you get it back?
   <details><summary>Answer</summary>Into Readline's kill-ring, a buffer in memory (not the desktop
   clipboard). <code>Ctrl-y</code> yanks it back at the cursor.</details>
