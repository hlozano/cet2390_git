# Chapter 12: A Gentle Introduction to vi

*The Linux Command Line* (TLCL), chapter 12. The book is free: https://linuxcommand.org/tlcl.php

## What you will learn

- `vi` is the text editor found on every Unix-like system, even a server with no desktop. On
  Linux the program behind the name is `vim` ("vi improved").
- vi has **modes**. In **command mode** every key is a command; in **insert mode** keys
  become text. Esc always takes you back to command mode.
- Enough vi to create, edit and save any file from the keyboard: insert, move, delete, copy,
  paste, undo, join lines, search, replace, save and quit.
- How to work with several files in one session: switch between them, copy a line from one
  into another, insert a whole file, and save under a new name.

## Files in this folder

This chapter has no scripts: everything happens inside the editor. The keys and commands are
explained below, section by section.

| File | Book name | What it shows |
|---|---|---|
| `book_foo.txt` | `foo.txt` | The book's practice file as it stands at the end of "Appending Text": the fox sentence and `Line 2` to `Line 5`. Every exercise after that section starts from these five lines. |

`book_foo.txt` is plain text exactly as the book prints it, with no header, because a header
would change the line numbers and the results of the search examples. The book builds this
file by typing, and between exercises it asks you to "return the file to its original
state". With this file you can do that in one step: copy it again.

## The book's examples

Work in a practice folder, so nothing you care about gets changed. Copy the book's file there
under the name the book uses (run the first two lines inside this chapter folder):

```bash
mkdir -p ~/playground
cp book_foo.txt ~/playground/foo.txt
cd ~/playground
```

Commands for the shell are in `bash` blocks. Keys you press inside vi are in tables; they
work in command mode, so press Esc first if you are not sure which mode you are in. A key
like `:w` starts with a colon and ends with Enter.

### Why We Should Learn vi; A Little Background

No commands. vi is always available (the POSIX standard requires it), it is fast, and your
hands never leave the keyboard. Bill Joy wrote it in 1976 for video terminals; its name comes
from "visual". It contains an older line editor, **ex**, and every command that starts with
`:` is an ex command. Bram Moolenaar wrote `vim`, which Linux installs under the name `vi`.

Find out which vi you have. The book assumes the full `vim`:

```bash
readlink -f "$(command -v vi)"   # /usr/bin/vim.basic is full vim; /usr/bin/vim.tiny is the small one
vim --version | head -n 1        # works only when full vim is installed
```

A new Mint system may have only `vim-tiny`, which lacks features this chapter uses. The book
says to install the full version if a feature is missing. That is an **administrator
command**: it needs `sudo` (the machine's administrator password), so run it only on a
machine you own, such as your own virtual machine, never on a shared computer:

```text
sudo apt install vim
```

### Starting and Stopping vi

```bash
vi          # start vi with no file: a welcome screen
```

The welcome screen names the version and lists a few commands. The first thing to learn is
how to get out:

| Key | What it does |
|---|---|
| `:q` | Quit (the colon is part of the command; press Enter after it) |
| `:q!` | Quit even if there are unsaved changes; the changes are lost |
| Esc Esc | When you are lost: back to command mode |

### Compatibility Mode

If the welcome screen says "Running in Vi compatible mode", vim behaves like the old vi: no
`-- INSERT --` line, and `u` undoes only one change. The book offers three ways out: run
`vim` instead of `vi`; add `alias vi='vim'` to your `~/.bashrc` (chapter 11); or put one line
in vim's own startup file, `~/.vimrc`:

```bash
echo "set nocp" >> ~/.vimrc     # nocp = nocompatible: vim's enhanced behavior every time
```

`>>` appends to the file (and creates it if it does not exist). With full vim installed and
no `~/.vimrc`, vim already starts in its enhanced mode.

### Editing Modes

The book creates a new file. Do it in the practice folder; this removes the copy you made
above, and you can copy it back at any time:

```bash
cd ~/playground
rm -f foo.txt      # -f: no complaint if the file is not there
vi foo.txt         # the bottom line says "foo.txt" [New]; do not type yet
```

Current vim writes `[New]` where the book shows `[New File]`. The `~` signs down the left
edge mean "no line here": the file is empty. vi starts in
**command mode**, where almost every key is a command. If you start typing now, vi runs your
letters as commands and makes a mess (Esc, then `u` until it is clean).

### Entering Insert Mode

| Key | What it does |
|---|---|
| `i` | Insert mode: `-- INSERT --` appears at the bottom (not in compatible mode) |
| Esc | Back to command mode |

Press `i`, type this line, then press Esc:

```text
The quick brown fox jumped over the lazy dog.
```

### Saving Our Work

| Key | What it does |
|---|---|
| `:` | Start an ex command: a colon appears on the bottom line |
| `:w` | Write (save) the file |

After `:w` and Enter, vim confirms on the bottom line:

```text
"foo.txt" [New] 1L, 46B written
```

`1L` is one line and `46B` is 46 bytes (45 characters plus the end-of-line). The book shows
`46C` (characters); current vim writes `B` for bytes. The vim documentation calls command
mode "normal mode" and calls ex commands "command mode": same things, other names.

### Moving the Cursor Around

| Key | Moves the cursor (Table 12-1) |
|---|---|
| `l` or Right arrow | Right one character |
| `h` or Left arrow | Left one character |
| `j` or Down arrow | Down one line |
| `k` or Up arrow | Up one line |
| `0` (zero) | To the beginning of the line |
| `^` | To the first character on the line that is not a space or tab |
| `$` | To the end of the line |
| `w` | To the start of the next word or punctuation character |
| `W` | To the start of the next word, ignoring punctuation (only spaces separate words) |
| `b` | To the start of the previous word or punctuation character |
| `B` | To the start of the previous word, ignoring punctuation |
| `Ctrl-f` or Page Down | Down one page |
| `Ctrl-b` or Page Up | Up one page |
| `numberG` | To line *number*: `1G` is the first line, `25G` line 25 |
| `G` | To the last line of the file |

A number in front repeats most commands: `5j` moves down five lines. The `h j k l` keys
exist because early terminals had no arrow keys, and a typist never has to leave the home
row.

### Basic Editing

| Key | What it does |
|---|---|
| `u` | Undo the last change. In vim, press it again to undo the change before that. |

### Appending Text

`i` inserts before the cursor, and the cursor cannot move past the last character of a line,
so `i` cannot add text at the end. Two keys can:

| Key | What it does |
|---|---|
| `a` | Insert mode **after** the cursor |
| `A` | Jump to the end of the line, then insert mode |

Press `$` (end of line), press `a`, type ` It was cool.` (with the leading space), press Esc.
Then press `0`, press `A`, press Enter and type `Line 2`, Enter, `Line 3`, and so on to
`Line 5`, then press Esc. `A` worked even though the cursor was at the start of the line.
Save with `:w`:

```text
"foo.txt" 5L, 87B written
```

The file now holds exactly what `book_foo.txt` holds:

```text
The quick brown fox jumped over the lazy dog. It was cool.
Line 2
Line 3
Line 4
Line 5
```

From here on, if an exercise goes wrong, quit with `:q!` and start over from a fresh copy:

```bash
cp book_foo.txt ~/playground/foo.txt   # run it in this chapter folder: replaces the old copy
vi ~/playground/foo.txt
```

### Opening a Line

| Key | Opens a new line (Table 12-2) and starts insert mode |
|---|---|
| `o` | Below the current line |
| `O` | Above the current line |

Put the cursor on `Line 3` (`3G`) and press `o`: a blank line opens between `Line 3` and
`Line 4`, and you are in insert mode. Press Esc, then `u` to undo. Do the same with `O`: the
blank line opens above `Line 3`. Esc, `u`.

### Deleting Text

`x` deletes characters. `d` is more general: it is always followed by a **movement** (any key
from Table 12-1), and it deletes from the cursor to wherever that movement would go. A number
in front repeats either one.

| Command | Deletes (Table 12-3) |
|---|---|
| `x` | The character at the cursor |
| `3x` | The character at the cursor and the next two |
| `dd` | The current line |
| `5dd` | The current line and the next four |
| `dW` | From the cursor to the beginning of the next word |
| `d$` | From the cursor to the end of the line |
| `d0` | From the cursor to the beginning of the line |
| `d^` | From the cursor to the first non-blank character of the line |
| `dG` | From the current line to the end of the file |
| `d20G` | From the current line to line 20 |

The book's exercise, on the five-line file:

1. Put the cursor on `It` in line 1 (`1G`, then `fI`, a search explained below, or the arrow
   keys). Press `x` again and again until the rest of the sentence is gone, then press `u`
   until it is all back.
2. On `It` again, press `dW`. Line 1 becomes:
   `The quick brown fox jumped over the lazy dog. was cool.`
3. Press `d$`. Line 1 becomes: `The quick brown fox jumped over the lazy dog.`
4. Press `dG`. The whole file is gone: only `~` lines are left.
5. Press `u` three times. Everything is back.

The book notes that the original vi had only one level of undo; vim has many.

### Cutting, Copying, and Pasting Text

Every `d` command also **cuts**: the deleted text goes into a paste buffer (think
clipboard). `y` ("yank") **copies** into the same buffer with the same movements, without
deleting anything.

| Command | What it does (Table 12-4) |
|---|---|
| `p` | Paste after the cursor (a whole line goes **below** the current line) |
| `P` | Paste before the cursor (a whole line goes **above** the current line) |
| `yy` | Copy the current line |
| `5yy` | Copy the current line and the next four |
| `yW` | Copy from the cursor to the beginning of the next word |
| `y$` | Copy from the cursor to the end of the line |
| `y0` | Copy from the cursor to the beginning of the line |
| `y^` | Copy from the cursor to the first non-blank character of the line |
| `yG` | Copy from the current line to the end of the file |
| `y20G` | Copy from the current line to line 20 |

The book's exercise: go to line 1 (`1G`), press `yy`, go to the last line (`G`), press `p`:

```text
The quick brown fox jumped over the lazy dog. It was cool.
Line 2
Line 3
Line 4
Line 5
The quick brown fox jumped over the lazy dog. It was cool.
```

Press `u`, then `P` (the cursor is still on `Line 5`):

```text
The quick brown fox jumped over the lazy dog. It was cool.
Line 2
Line 3
Line 4
The quick brown fox jumped over the lazy dog. It was cool.
Line 5
```

Press `u` again. Since `dd` cuts, `dd` then `p` moves a line down by one.

### Joining Lines

vi will not delete the end of a line to pull the next line up. Use `J` (capital; lowercase
`j` moves down):

| Key | What it does |
|---|---|
| `J` | Join the next line onto the end of the current one, with a space between |

Put the cursor on `Line 3` and press `J`:

```text
The quick brown fox jumped over the lazy dog. It was cool.
Line 2
Line 3 Line 4
Line 5
```

Press `u`.

### Search-and-Replace

#### Searching Within a Line

| Key | What it does |
|---|---|
| `fa` | Move to the next `a` on the current line (any character can follow `f`) |
| `;` | Repeat the last `f` search |

#### Searching the Entire File

| Key | What it does |
|---|---|
| `/Line` then Enter | Move to the next place in the file where `Line` appears (the same key as in `less`) |
| `n` | Repeat the search |

With the cursor on line 1, `/Line` and Enter moves to line 2. Each `n` moves down one more
line, until there are no more matches below (then vim starts again from the top). Search
patterns can be regular expressions, which the book covers in chapter 19.

#### Global Search-and-Replace

vi calls search-and-replace **substitution**. To change every `Line` to `line` in the whole
file:

```text
:%s/Line/line/g
```

| Part | Meaning (Table 12-5) |
|---|---|
| `:` | Starts an ex command |
| `%` | The range of lines: first line to last. `1,5` (the file has five lines) or `1,$` ("line 1 to the last line") would do the same. With no range, only the current line is changed. |
| `s` | The operation: substitute |
| `/Line/line/` | The search pattern, then the replacement text |
| `g` | "Global": every match on each line. Without it, only the first match on each line changes. |

The file afterwards, and vim's message on the bottom line:

```text
The quick brown fox jumped over the lazy dog. It was cool.
line 2
line 3
line 4
line 5
```

```text
4 substitutions on 4 lines
```

**A correction to the slides.** Only four lines contain `Line` (`Line 2` to `Line 5`; the fox
line does not), so the command changes four lines, not five, and vim says so.

Add `c` at the end to confirm each change. This changes the file back:

```text
:%s/line/Line/gc
```

At every match vim asks:

```text
replace with Line (y/n/a/q/l/^E/^Y)?
```

| Key | Action (Table 12-6) |
|---|---|
| `y` | Make this change |
| `n` | Skip this one |
| `a` | Make this change and all the rest |
| `q` or Esc | Stop |
| `l` | Make this change, then stop ("last") |
| `Ctrl-e`, `Ctrl-y` | Scroll down, scroll up, to see the context |

### Editing Multiple Files

Save and quit the current session with `:wq`. Then make a second file to play with, in the
practice folder (the book makes it in your home directory):

```bash
cd ~/playground
ls -l /usr/bin > ls-output.txt   # a long listing of /usr/bin, saved to a file (> is chapter 6)
vi foo.txt ls-output.txt         # vi file1 file2 ...: both open, foo.txt on screen
```

#### Switching Between Files

| Command | What it does |
|---|---|
| `:bn` | Next file ("buffer next") |
| `:bp` | Previous file ("buffer previous") |
| `:bn!` | Switch even though this file has unsaved changes; the changes are abandoned |
| `:buffers` | List the open files |
| `:buffer 2` | Switch to file number 2 |

vim will not switch away from a file with unsaved changes: `:bn` then answers
`E37: No write since last change (add ! to override)`. Save with `:w` first, or use `:bn!`.

`:buffers` right after starting shows:

```text
  1 %a   "foo.txt"                      line 1
  2      "ls-output.txt"                line 0
Press ENTER or type command to continue
```

`%` marks the file on screen and `a` means it is active (loaded and shown). `line 0` means
vim has not opened the second file yet.

#### Opening Additional Files for Editing

Quit (`:q`), then start with one file and add the second from inside vi:

```bash
vi foo.txt
```

| Command | What it does |
|---|---|
| `:e ls-output.txt` | Open another file in the same session ("edit") |
| `:buffers` | Both files are listed |

```text
  1 #    "foo.txt"                      line 1
  2 %a   "ls-output.txt"                line 1
```

`#` marks the "alternate" file, the one you were in before. The book's copy shows `line 0`
for the second file; current vim shows the line the cursor is on, 1.

#### Copying Content from One File into Another

| Steps | What happens |
|---|---|
| `:buffer 1`, then `1G`, then `yy` | Go to `foo.txt` and copy its first line |
| `:buffer 2`, then `1G`, then `p` | Go to the listing and paste the line below its first line |

The listing now starts like this (your file names, sizes and times differ):

```text
total ...
The quick brown fox jumped over the lazy dog. It was cool.
-rwxr-xr-x 1 root root ...
```

#### Inserting an Entire File into Another

Quit and throw away the pasted line with `:q!`. If vim refuses because the other open file
has changes too, `:qa!` quits them all without saving. Then:

```bash
vi ls-output.txt
```

| Command | What it does |
|---|---|
| `3G` | Go to line 3 |
| `:r foo.txt` | Read `foo.txt` in below the cursor: its five lines now follow line 3 |

Quit without saving (`:q!`) when you have seen it.

### Saving Our Work (more ways)

| Command | What it does |
|---|---|
| `ZZ` | Save and quit (command mode, no colon, no Enter) |
| `:wq` | Save and quit |
| `:w foo1.txt` | Save a copy as `foo1.txt` ("Save As"); you are still editing `foo.txt` |

After `:w foo1.txt` vim says `"foo1.txt" [New] 5L, 87B written`. Quit, then check with `ls`
that both files are in `~/playground`.

## Common mistakes

| You type | What vi says | Fix |
|---|---|---|
| `:q` with unsaved changes | `E37: No write since last change (add ! to override)` | `:wq` to save and quit, or `:q!` to throw the changes away |
| Text, right after opening a file | your letters run as commands; the file jumps around | Esc, `u` until it is clean, then `i` and type again |
| `:wq` while still in insert mode | `:wq` appears inside the file | Esc, `u`, then `:wq` |
| `:bn` with unsaved changes | `E37: No write since last change (add ! to override)` | `:w` first, or `:bn!` to abandon the changes |
| `u` a second time, and the change comes back | vim is in vi-compatible mode (vim-tiny) | `echo "set nocp" >> ~/.vimrc`, or install full vim (administrator) |
| `vi /etc/profile`, then `:w` | `E45: 'readonly' option is set (add ! to override)` | The file belongs to root: `:q!` and edit files in your home directory |
| `vi foo.txt` after a terminal was closed with vi still open | `E325: ATTENTION` ... `Found a swap file` | Press `R` to recover the unsaved work, or `D` to delete the old swap file (offered when no other vi has the file open); `E` edits the saved file anyway |
| A file that came from Windows | `[dos]` on the bottom line, or `^M` at the end of every line | `:q!`, then `sed -i 's/\r$//' file.txt` |

## Check yourself

1. You opened a file and typed a sentence, but the screen went wild. What happened, and how
   do you recover?
   <details><summary>Answer</summary>vi starts in command mode, so your letters ran as commands.
   Press Esc, then <code>u</code> until the file is back to normal; press <code>i</code> (or
   <code>a</code>, <code>A</code>, <code>o</code>, <code>O</code>) before you type text.</details>
2. What is the difference between `:q`, `:q!` and `:wq`?
   <details><summary>Answer</summary><code>:q</code> quits, but refuses if there are unsaved
   changes. <code>:q!</code> quits and throws the changes away. <code>:wq</code> saves, then
   quits (<code>ZZ</code> does the same).</details>
3. How do you copy the first line of `foo.txt` to the end of the file?
   <details><summary>Answer</summary><code>1G</code> to go to line 1, <code>yy</code> to copy it,
   <code>G</code> to go to the last line, <code>p</code> to paste below it.</details>
4. On the five-line `foo.txt`, `:%s/Line/line/g` reports `4 substitutions on 4 lines`. Why
   four, and what would change without the `%`?
   <details><summary>Answer</summary>Only lines 2 to 5 contain <code>Line</code>; the fox line
   does not. Without <code>%</code> the command works on the current line only.</details>
5. `dW`, `d$` and `dG`: what does each delete, and what do they have in common?
   <details><summary>Answer</summary>To the start of the next word, to the end of the line, and
   from the current line to the end of the file. Each is <code>d</code> followed by a cursor
   movement: <code>d</code> deletes from the cursor to wherever the movement would go.</details>
