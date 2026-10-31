# Chapter 4: Manipulating Files and Directories

*The Linux Command Line* (TLCL), chapter 4. The book is free: https://linuxcommand.org/tlcl.php

## What you will learn

- **Wildcards** (`*`, `?`, `[abc]`, `[[:digit:]]` and friends) name a whole group of files
  with one pattern. The shell turns the pattern into a list of names before the command runs.
- Five commands that change things: `mkdir` makes directories, `cp` copies, `mv` moves and
  renames, `rm` removes, and `ln` makes links. They share options: `-i` asks first, `-r` works
  on a whole directory, `-v` reports what was done.
- `rm` has no undo and no Trash. Test a wildcard with `ls` before you give it to `rm`.
- A **hard link** is a second name for the same data; a **symbolic link** is a small file that
  points to a name and breaks if that name disappears.
- Everything is practiced in `~/playground`, a directory made only for practice, exactly as the
  book does.

## Files in this folder

This folder holds only this guide. Chapter 4 of the book has no scripts: every example in it
is a command you type at the prompt, and each one is explained below, in the order of the
book's sections.

**From this chapter on, commands change and delete files.** Work only inside `~/playground`,
as this guide does, and nowhere else. If you use a virtual machine, take a snapshot before you
start: it is the only undo `rm` has.

## The book's examples

How to read this guide:

- A box marked `bash` holds what you type. Type one line, then press Enter. Text after a `#`
  is a note for you; bash ignores it.
- A box that starts with `$` shows what you see: the `$` stands for the prompt. Do not type it.
  When a command asks a question (`overwrite 'file2'?`), the box shows the answer that was
  typed after it, followed by Enter.
- The output comes from GNU coreutils 9 and bash 5, the versions on Linux Mint and Ubuntu. The
  user is called `student`, and sizes and numbers will differ on your system. In long listings,
  **`MMM DD hh:mm` stands for the date and time** that `ls -l` prints in that column.

The book first explains each command with tables of examples, and later runs everything for
real in a directory called `playground`. This guide does the same: the table examples run in
two practice directories inside `~/playground` (`wildcards` and `tables`), which are removed
afterwards, and then the book's own playground exercise starts from scratch.

### The five commands (the start of the chapter)

| Command | What it does |
|---|---|
| `cp` | Copy files and directories |
| `mv` | Move or rename files and directories |
| `mkdir` | Create directories |
| `rm` | Remove (delete) files and directories |
| `ln` | Create hard and symbolic links |

Why type these instead of dragging files in a window? Because a command can say exactly what
you mean. The book's first example:

```text
cp -u *.html destination
```

copies every file whose name ends in `.html` into the directory `destination`, but only the
files that are missing there or newer than the copy already there. That is hard to do with a
mouse and easy at the prompt. It runs for real, with other names, in the `cp` section below.

### Wildcards

Many commands take file names as arguments, so the shell offers special characters for naming
many files at once. They are called **wildcards**, and using them is called **globbing**. The
shell replaces the pattern with every matching name, in alphabetical order, **before** the
command runs, so wildcards work with any command that takes file names.

| Wildcard | Matches |
|---|---|
| `*` | Any characters, any number of them (also none) |
| `?` | Exactly one character, any character |
| `[characters]` | One character from the set, such as `[abc]` |
| `[!characters]` | One character that is not in the set |
| `[[:class:]]` | One character from the class (next table) |

| Class | Matches |
|---|---|
| `[:alnum:]` | A letter or a digit |
| `[:alpha:]` | A letter |
| `[:digit:]` | A digit (a numeral, 0 to 9) |
| `[:lower:]` | A lowercase letter |
| `[:upper:]` | An uppercase letter |

A class always sits inside a second pair of brackets: `[[:digit:]]` matches one digit.

To see what each pattern matches, make a practice directory full of empty files and aim the
book's patterns at it. `mkdir -p` makes a directory together with any missing directories
above it (here `playground`). `touch` creates an empty file for each name you give it (it
returns in a later chapter; here it only gives the patterns something to match).

```bash
mkdir -p ~/playground/wildcards
cd ~/playground/wildcards
touch apple banana.txt bill.txt bob.log cherry grape3 Data001 Data12 DataXYZ
touch BACKUP.001 BACKUP.1 2fast Zoo
ls
```

```text
$ ls
2fast  BACKUP.001  banana.txt  bob.log  Data001  DataXYZ  Zoo
apple  BACKUP.1    bill.txt    cherry   Data12   grape3
```

Now try each pattern of Table 4-3 with `echo`. `echo` prints its arguments, so it shows you the
list of names the shell made out of the pattern, and it changes nothing:

```bash
echo *
echo g*
echo b*.txt
echo Data???
echo [abc]*
echo BACKUP.[0-9][0-9][0-9]
echo [[:upper:]]*
echo [![:digit:]]*
echo *[[:lower:]123]
```

```text
$ echo *
2fast apple BACKUP.001 BACKUP.1 banana.txt bill.txt bob.log cherry Data001 Data12 DataXYZ grape3 Zoo
$ echo g*
grape3
$ echo b*.txt
banana.txt bill.txt
$ echo Data???
Data001 DataXYZ
$ echo [abc]*
apple banana.txt bill.txt bob.log cherry
$ echo BACKUP.[0-9][0-9][0-9]
BACKUP.001
$ echo [[:upper:]]*
BACKUP.001 BACKUP.1 Data001 Data12 DataXYZ Zoo
$ echo [![:digit:]]*
apple BACKUP.001 BACKUP.1 banana.txt bill.txt bob.log cherry Data001 Data12 DataXYZ grape3 Zoo
$ echo *[[:lower:]123]
2fast apple BACKUP.001 BACKUP.1 banana.txt bill.txt bob.log cherry Data001 Data12 grape3 Zoo
```

| Pattern | Matches names that... | Why |
|---|---|---|
| `*` | (all names) | `*` matches anything |
| `g*` | begin with `g` | `grape3` |
| `b*.txt` | begin with `b` and end with `.txt` | `bob.log` does not end with `.txt` |
| `Data???` | are `Data` plus exactly three characters | `Data12` has only two after `Data` |
| `[abc]*` | begin with `a`, `b` or `c` | Uppercase `BACKUP` does not count: case matters |
| `BACKUP.[0-9][0-9][0-9]` | are `BACKUP.` plus exactly three digits | `BACKUP.1` has one digit |
| `[[:upper:]]*` | begin with an uppercase letter | |
| `[![:digit:]]*` | do not begin with a digit | Only `2fast` is left out |
| `*[[:lower:]123]` | end with a lowercase letter or 1, 2 or 3 | Only `DataXYZ` is left out: it ends in an uppercase `Z` |

When nothing matches, bash leaves the pattern as it is and the command receives it unchanged.
`echo` prints it back; `ls` looks for a file with that strange name and fails:

```text
$ echo *.html
*.html
$ ls *.html
ls: cannot access '*.html': No such file or directory
```

### Character Ranges

The book warns about ranges such as `[A-Z]` and `[a-z]`, common in older books and web pages:
in some language settings they used to match letters you did not expect (`[A-Z]` could match
lowercase letters too). Bash 5, the version on current systems, treats a range in a wildcard as
plain ASCII, so `[A-Z]` matches only the 26 capital letters:

```text
$ echo [A-Z]*
BACKUP.001 BACKUP.1 Data001 Data12 DataXYZ Zoo
```

The book's advice still stands, though: the classes (`[[:upper:]]`, `[[:lower:]]`,
`[[:digit:]]`) say exactly what they mean and work the same in every program, so use them.

### Wildcards Work in the GUI Too

No command in this section. The book shows that some graphical file managers also accept
wildcard patterns to select files: ideas from the command line often show up on the desktop.

### mkdir - Create Directories

```text
mkdir directory...
```

**About the notation:** three periods after an argument mean "you may repeat it". So `mkdir`
takes one directory name or several. The tables examples run in their own practice directory:

```bash
mkdir -p ~/playground/tables
cd ~/playground/tables
mkdir dir1               # one directory
mkdir dir1 dir2 dir3     # the book's second example: three names in one command
ls
```

```text
$ mkdir dir1
$ mkdir dir1 dir2 dir3
mkdir: cannot create directory ‘dir1’: File exists
$ ls
dir1  dir2  dir3
```

`dir1` already existed from the first command, so `mkdir` complained about that one name and
still created `dir2` and `dir3`. Commands that take several arguments handle each one on its
own. (Silence means success: `mkdir dir1` printed nothing because it worked.)

### cp - Copy Files and Directories

`cp` is used in two ways:

| Form | What it does |
|---|---|
| `cp item1 item2` | Copies the file or directory *item1* to the name *item2* |
| `cp item... directory` | Copies one or more items into an existing *directory* |

The options of Table 4-4:

| Option | Long form | What it does |
|---|---|---|
| `-a` | `--archive` | Copy files and directories with all their attributes, such as owner and permissions (chapter 9). A normal copy belongs to you |
| `-i` | `--interactive` | Ask before overwriting a file that already exists. **Without `-i`, `cp` overwrites silently** |
| `-r` | `--recursive` | Copy a directory and everything inside it (`-a` does this too). Needed for any directory |
| `-u` | `--update` | Copy only files that are missing in the destination or newer than the copy there |
| `-v` | `--verbose` | Print a line for each copy as it is made |

Now each example of Table 4-5, in order. First copy a real file into the practice directory, so
there is something to work with: `/etc/passwd`, the account list from chapter 3. Copying only
reads the original.

```bash
cp /etc/passwd file1     # something to copy
cp file1 file2           # file2 does not exist yet, so cp creates it
cp -i file1 file2        # file2 exists now: -i asks first. Answer n (keep it)
cp file1 file2 dir1      # two files into a directory that already exists
ls dir1
cp dir1/* dir2           # the wildcard: every file in dir1, copied into dir2
ls dir2
cp -r dir1 dir4          # dir4 does not exist: it is created as a copy of dir1
ls dir4
cp -r dir1 dir2          # dir2 exists: dir1 itself is copied INTO dir2
ls dir2
```

```text
$ cp /etc/passwd file1
$ cp file1 file2
$ cp -i file1 file2
cp: overwrite 'file2'? n
$ cp file1 file2 dir1
$ ls dir1
file1  file2
$ cp dir1/* dir2
$ ls dir2
file1  file2
$ cp -r dir1 dir4
$ ls dir4
file1  file2
$ cp -r dir1 dir2
$ ls dir2
dir1  file1  file2
```

The last two lines are the ones to remember. `cp -r dir1 dir4` made a **new** directory `dir4`
holding what `dir1` holds. `cp -r dir1 dir2`, with `dir2` already there, put a copy of `dir1`
**inside** `dir2`. The same command does two different things depending on whether the last
name already exists.

The other options:

```bash
cp -v file1 file3            # -v: report the copy
mkdir backup
cp -u -v dir1/* backup       # -u: backup is empty, so both files are copied
cp -u -v dir1/* backup       # again: the copies are not older, so nothing is copied
```

```text
$ cp -v file1 file3
'file1' -> 'file3'
$ mkdir backup
$ cp -u -v dir1/* backup
'dir1/file1' -> 'backup/file1'
'dir1/file2' -> 'backup/file2'
$ cp -u -v dir1/* backup
$
```

That is the book's opening example, `cp -u *.html destination`, with other names: the second
run printed nothing because there was nothing new to copy.

### mv - Move and Rename Files

`mv` moves a file or directory to a new place, or gives it a new name; renaming is just a move
inside the same directory. Either way, **the old name no longer exists afterwards**.

| Form | What it does |
|---|---|
| `mv item1 item2` | Moves or renames *item1* to *item2* |
| `mv item... directory` | Moves one or more items into an existing *directory* |

`mv` has the same `-i` (ask before overwriting), `-u` (only move what is new) and `-v` (report)
options as `cp` (Table 4-6). Without `-i`, `mv` also overwrites silently. It needs no `-r`: it
moves a directory with everything inside it. The examples of Table 4-7:

```bash
mv file3 file4           # rename: file3 is gone, file4 holds its contents
mv -i file4 file1        # file1 exists: -i asks first. Answer n
mv file2 file4 dir3      # two files into a directory that exists
mv dir4 dir5             # dir5 does not exist: dir4 is renamed dir5
ls
mv dir5 dir3             # dir3 exists: dir5 moves INTO dir3
ls dir3
```

```text
$ mv file3 file4
$ mv -i file4 file1
mv: overwrite 'file1'? n
$ mv file2 file4 dir3
$ mv dir4 dir5
$ ls
backup  dir1  dir2  dir3  dir5  file1
$ mv dir5 dir3
$ ls dir3
dir5  file2  file4
```

Same rule as `cp`: when the last name is an existing directory, things go **into** it; when
it does not exist, the item is **renamed** to it.

### rm - Remove Files and Directories

```text
rm item...
```

`rm` deletes files and, with `-r`, directories. There is no Trash and no undo. The options of
Table 4-8:

| Option | Long form | What it does |
|---|---|---|
| `-i` | `--interactive` | Ask before deleting each file. **Without `-i`, `rm` deletes silently** |
| `-r` | `--recursive` | Delete directories, with everything inside them. Needed for any directory |
| `-f` | `--force` | Never ask, and say nothing about names that do not exist |
| `-v` | `--verbose` | Print a line for each deletion |

The examples of Table 4-9:

```bash
rm file1                 # deleted at once: no question, no message
rm -i dir3/file2         # -i asks first. Answer y (yes, delete it)
rm dir2                  # fails: dir2 is a directory
rm -r dir3/file4 dir2    # a file, and a directory with everything inside it
rm -rf dir3 nosuchfile   # -f: no complaint about the name that does not exist
ls
```

```text
$ rm file1
$ rm -i dir3/file2
rm: remove regular file 'dir3/file2'? y
$ rm dir2
rm: cannot remove 'dir2': Is a directory
$ rm -r dir3/file4 dir2
$ rm -rf dir3 nosuchfile
$ ls
backup  dir1
```

Without `-f`, a missing name is an error: `rm nosuchfile` prints
`rm: cannot remove 'nosuchfile': No such file or directory`.

**A correction to the book:** it says `-f` overrides `-i`. With GNU `rm`, the version on Mint
and Ubuntu, whichever of the two comes **last** on the line wins:

```text
$ rm -fi dir1/file1
rm: remove regular file 'dir1/file1'? n
$ rm -if dir1/file1
$ ls dir1
file2
```

`rm -fi` asked, because `-i` came last. `rm -if` deleted the file without a word, because `-f`
came last.

### Be Careful with rm!

Linux has no "undelete" command. Wildcards make `rm` powerful and dangerous. Say you want to
delete only the HTML files in a directory:

```text
rm *.html
```

That is correct. But one extra space, `rm * .html`, gives `rm` two arguments: `*`, which the
shell turns into **every name in the directory**, and `.html`. `rm` deletes every file, then
complains that there is no file called `.html`. Do not type that line. You can see what it
would do, safely, by putting `echo` in front: `echo` only prints the list `rm` would receive.

The habit that prevents it: **test the wildcard with `ls` first**, read the list, then press
Up, replace `ls` with `rm`, and run it.

```bash
cp /etc/passwd page1.html    # two files to delete
cp /etc/passwd page2.html
ls *.html                    # 1. exactly the files rm will remove
rm *.html                    # 2. Up arrow, change ls to rm, check the line, Enter
ls
echo rm * .html              # what the mistyped line WOULD do (echo only prints it)
```

```text
$ ls *.html
page1.html  page2.html
$ rm *.html
$ ls
backup  dir1
$ echo rm * .html
rm backup dir1 .html
```

The practice directories have done their job. Leave them and remove the whole `playground`
tree, so the book's exercise below starts empty:

```bash
cd
rm -r ~/playground
```

### ln - Create Links

No example to run yet; the playground below makes both kinds.

| Form | What it makes |
|---|---|
| `ln file link` | A hard link named *link* to *file* |
| `ln -s item link` | A symbolic link named *link* to *item*, which may be a file or a directory |

### Hard Links

No command in this section, only the idea. Think of a file as two parts: the **data** (the
contents, kept on the disk in a structure called an **inode**) and a **name** that points to
it. Every file starts with one name, which is its one hard link. `ln` adds another name for the
same data. The two names are equal: nothing marks one as the original. The data stays on the
disk until its **last** name is removed. Two limits:

1. A hard link cannot point to a file on another disk or partition.
2. A hard link cannot point to a directory.

### Symbolic Links

No command in this section either. A **symbolic link** is a small, separate file that holds
the path of its target, like a shortcut in Windows. Reading or writing the link reads or writes
the target, but deleting the link deletes only the link. If the target is deleted (or renamed),
the link stays behind and points to nothing: it is **broken**, and `ls` usually shows it in red.
Symbolic links have neither limit of hard links: they can point to a directory and to another
disk.

### Let's Build a Playground

The rest of the chapter is the book's exercise. First check that you have no `playground`
directory (you removed the practice one above):

```bash
ls -d ~/playground
```

```text
$ ls -d ~/playground
ls: cannot access '/home/student/playground': No such file or directory
```

That error is what you want. If the directory is listed instead, it holds your own files:
rename it before you go on.

### Creating Directories

```bash
cd                   # make sure you start in your home directory
mkdir playground     # the safe place to practice
cd playground
mkdir dir1 dir2      # two directories in one command
```

### Copying Files

```bash
cp /etc/passwd .         # copy passwd into the current directory
ls -l
cp -v /etc/passwd .      # the same copy, verbose
cp -i /etc/passwd .      # the same copy, asking first
```

The trailing `.` is the current working directory: "copy it here".

```text
$ cp /etc/passwd .
$ ls -l
total 12
drwxrwxr-x 2 student student 4096 MMM DD hh:mm dir1
drwxrwxr-x 2 student student 4096 MMM DD hh:mm dir2
-rw-r--r-- 1 student student 1380 MMM DD hh:mm passwd
$ cp -v /etc/passwd .
'/etc/passwd' -> './passwd'
$ cp -i /etc/passwd .
cp: overwrite './passwd'? n
```

The second copy overwrote the first without a warning; `-v` only reported it. With `-i`, `cp`
asked: `y` overwrites, any other answer (here `n`) leaves the file alone. The book prints the
names in its messages as `` `./passwd' ``; current versions use straight quotes on both sides,
`'./passwd'`.

### Moving and Renaming Files

`passwd` is not a playful name, so rename it, then pass it around:

```bash
mv passwd fun        # rename passwd to fun
mv fun dir1          # move fun into dir1
mv dir1/fun dir2     # from dir1 into dir2
mv dir2/fun .        # back to the current directory
mv fun dir1          # into dir1 again
mv dir1 dir2         # dir2 exists, so dir1 (with fun inside) moves INTO dir2
ls -l dir2
ls -l dir2/dir1
```

```text
$ ls -l dir2
total 4
drwxrwxr-x 2 student student 4096 MMM DD hh:mm dir1
$ ls -l dir2/dir1
total 4
-rw-r--r-- 1 student student 1380 MMM DD hh:mm fun
```

Had `dir2` not existed, `mv dir1 dir2` would have renamed `dir1` to `dir2`. Put everything back:

```bash
mv dir2/dir1 .       # dir1 back into the playground
mv dir1/fun .        # fun back into the playground
```

### Creating Hard Links

```bash
ln fun fun-hard          # a second name for fun's data, here
ln fun dir1/fun-hard     # a third, in dir1
ln fun dir2/fun-hard     # a fourth, in dir2
ls -l
ls -li
```

```text
$ ls -l
total 16
drwxrwxr-x 2 student student 4096 MMM DD hh:mm dir1
drwxrwxr-x 2 student student 4096 MMM DD hh:mm dir2
-rw-r--r-- 4 student student 1380 MMM DD hh:mm fun
-rw-r--r-- 4 student student 1380 MMM DD hh:mm fun-hard
$ ls -li
total 16
25795 drwxrwxr-x 2 student student 4096 MMM DD hh:mm dir1
28138 drwxrwxr-x 2 student student 4096 MMM DD hh:mm dir2
33866 -rw-r--r-- 4 student student 1380 MMM DD hh:mm fun
33866 -rw-r--r-- 4 student student 1380 MMM DD hh:mm fun-hard
```

Column 2 of `fun` and `fun-hard` now says `4`: the data has four names. Same size, but is it
really the same file? `ls -i` answers that: it adds the **inode number** at the start of each
line, and `fun` and `fun-hard` share one (your numbers will differ, but the two will match).
One inode, one set of data, four names.

### Creating Symbolic Links

```bash
ln -s fun fun-sym            # a symbolic link to fun, here
ln -s ../fun dir1/fun-sym    # a link in dir1 to the fun one level up
ln -s ../fun dir2/fun-sym    # the same in dir2
ls -l dir1
```

```text
$ ls -l dir1
total 4
-rw-r--r-- 4 student student 1380 MMM DD hh:mm fun-hard
lrwxrwxrwx 1 student student    6 MMM DD hh:mm fun-sym -> ../fun
```

Why `../fun` for the links in `dir1` and `dir2`? A symbolic link stores a path **relative to
where the link itself sits**. Seen from `dir1`, `fun` is one level up: `../fun`. The line starts
with `l` (a link), and its size is `6`, the number of characters in `../fun`, not the size of
`fun`. The book's other way is an absolute path:

```text
ln -s /home/me/playground/fun dir1/fun-sym
```

Read it, but do not run it: `me` is the book's user, and `dir1/fun-sym` exists now. Relative
links are usually better: you can move or rename the whole `playground` and its links still
work. Symbolic links can point to directories too:

```bash
ln -s dir1 dir1-sym
ls -l
ls -F
```

```text
$ ls -l
total 16
drwxrwxr-x 2 student student 4096 MMM DD hh:mm dir1
lrwxrwxrwx 1 student student    4 MMM DD hh:mm dir1-sym -> dir1
drwxrwxr-x 2 student student 4096 MMM DD hh:mm dir2
-rw-r--r-- 4 student student 1380 MMM DD hh:mm fun
-rw-r--r-- 4 student student 1380 MMM DD hh:mm fun-hard
lrwxrwxrwx 1 student student    3 MMM DD hh:mm fun-sym -> fun
$ ls -F
dir1/  dir1-sym@  dir2/  fun  fun-hard  fun-sym@
```

(`ls -F`, from chapter 3, marks directories with `/` and symbolic links with `@`.)

### Removing Files and Directories

Now clean up, one step at a time, and watch the links:

```bash
rm fun-hard      # remove one hard link
ls -l
rm -i fun        # remove fun itself; -i asks: answer y
ls -l
less fun-sym     # try to read through the broken link
```

```text
$ rm fun-hard
$ ls -l
total 12
drwxrwxr-x 2 student student 4096 MMM DD hh:mm dir1
lrwxrwxrwx 1 student student    4 MMM DD hh:mm dir1-sym -> dir1
drwxrwxr-x 2 student student 4096 MMM DD hh:mm dir2
-rw-r--r-- 3 student student 1380 MMM DD hh:mm fun
lrwxrwxrwx 1 student student    3 MMM DD hh:mm fun-sym -> fun
$ rm -i fun
rm: remove regular file 'fun'? y
$ ls -l
total 8
drwxrwxr-x 2 student student 4096 MMM DD hh:mm dir1
lrwxrwxrwx 1 student student    4 MMM DD hh:mm dir1-sym -> dir1
drwxrwxr-x 2 student student 4096 MMM DD hh:mm dir2
lrwxrwxrwx 1 student student    3 MMM DD hh:mm fun-sym -> fun
$ less fun-sym
fun-sym: No such file or directory
```

- After `rm fun-hard`, the link count of `fun` dropped from 4 to 3.
- After `rm -i fun`, `fun-sym` is still listed, still pointing to `fun`, but `fun` is gone: the
  link is **broken** (on screen, `ls` shows it in red). Using it gives
  `No such file or directory`.
- The data of `fun` is **not** gone: `dir1/fun-hard` and `dir2/fun-hard` are still names for
  it. Try `ls -l dir1`: `fun-hard` shows a link count of 2.

Remove the symbolic links. `rm` removes the link itself, never its target (most other commands
work on the target):

```bash
rm fun-sym dir1-sym
ls -l
```

```text
$ rm fun-sym dir1-sym
$ ls -l
total 8
drwxrwxr-x 2 student student 4096 MMM DD hh:mm dir1
drwxrwxr-x 2 student student 4096 MMM DD hh:mm dir2
```

Finally, remove the playground. Go home first, then use `rm -r` to delete `playground` and
everything inside it, subdirectories included (this removes the last two names of the old
`fun` data, so its space is finally freed):

```bash
cd
rm -r playground
```

The book's advice: do the playground exercise again, from "Creating Directories", until every
result is the one you predicted. Then add files and directories of your own and practice
wildcards on them.

### Creating Symlinks With The GUI

No command in this section. The book notes that graphical file managers can also create a
symbolic link, for example when you drag a file while holding certain keys. On the command
line, `ln -s` does it.

## Common mistakes

| You type | What you see | Fix |
|---|---|---|
| `cp dir1 dir5` | `cp: -r not specified; omitting directory 'dir1'` | A directory needs `-r`: `cp -r dir1 dir5` |
| `cp file1 file2 dir9` (no `dir9`) | `cp: target 'dir9': No such file or directory` | To copy several files, the last name must be an existing directory: `mkdir dir9` first |
| `rm dir2` | `rm: cannot remove 'dir2': Is a directory` | Check what is inside with `ls dir2`, then `rm -r dir2` |
| `mkdir dir1` (it exists) | `mkdir: cannot create directory ‘dir1’: File exists` | Pick another name, or check with `ls` |
| `mkdir playground/a/b` (no `a`) | `mkdir: cannot create directory ‘playground/a/b’: No such file or directory` | `mkdir -p playground/a/b` makes the missing directories too |
| `mkdir test` in `/etc` | `mkdir: cannot create directory ‘test’: Permission denied` | Work in your home directory: `cd ~/playground` |
| `ln dir1 dir1-hard` | `ln: dir1: hard link not allowed for directory` | Use a symbolic link: `ln -s dir1 dir1-sym` |
| `ln -s fun fun-sym` (it exists) | `ln: failed to create symbolic link 'fun-sym': File exists` | Pick another name, or remove the old link first |
| `ls *.tmp` (no match) | `ls: cannot access '*.tmp': No such file or directory` | Nothing matched, so bash passed the pattern on unchanged; check the spelling |
| `rm nosuchfile` | `rm: cannot remove 'nosuchfile': No such file or directory` | Check the name with `ls` |
| `less fun-sym` (broken link) | `fun-sym: No such file or directory` | The target is gone: remove the link, or create the target again |
| `rm * .html` | Every file is gone, then `rm: cannot remove '.html': No such file or directory` | No fix: restore from a snapshot or backup. Always test with `ls` first |

## Check yourself

1. A directory holds `bill.txt`, `bob.log`, `Data001`, `Data12` and `DataXYZ`. What do
   `echo b*.txt` and `echo Data???` print?
   <details><summary>Answer</summary><code>echo b*.txt</code> prints <code>bill.txt</code>
   (<code>bob.log</code> does not end in <code>.txt</code>). <code>echo Data???</code> prints
   <code>Data001 DataXYZ</code>: <code>Data12</code> has only two characters after
   <code>Data</code>.</details>
2. What does `cp -r dir1 dir2` do if `dir2` does not exist? And if it does?
   <details><summary>Answer</summary>If <code>dir2</code> does not exist, it is created as a copy
   of <code>dir1</code>. If it exists, a copy of <code>dir1</code> is put inside it, as
   <code>dir2/dir1</code>.</details>
3. In the playground, after `rm -i fun`, the file `dir1/fun-hard` still holds the data. Why?
   <details><summary>Answer</summary><code>fun</code> and <code>fun-hard</code> were hard links:
   names for the same data. <code>rm</code> removed one name; the data stays on the disk until
   its last name is removed.</details>
4. How can you prove that two names are hard links to the same file?
   <details><summary>Answer</summary>Run <code>ls -li</code>: hard links share the same inode
   number (the first column), and their link count (column 2 of <code>ls -l</code>) is more than
   1.</details>
5. You want to delete every file that ends in `.bak`. What do you type, in what order?
   <details><summary>Answer</summary>First <code>ls *.bak</code> and read the list. Then press Up,
   change <code>ls</code> to <code>rm</code>, check the line (no space between <code>*</code> and
   <code>.bak</code>), and press Enter.</details>
