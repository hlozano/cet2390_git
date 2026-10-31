# Chapter 5: Working with Commands

*The Linux Command Line* (TLCL), chapter 5. The book is free: https://linuxcommand.org/tlcl.php

## What you will learn

- Every command you type is one of four kinds: an **executable program**, a **shell builtin**,
  a **shell function** or an **alias**. `type` tells you which; `which` finds a program's file.
- The kind of command decides where its documentation is: `help` for builtins, `--help` for a
  quick summary of a program, `man` for its full manual page.
- How to read the short syntax lines in documentation: `[ ]` means optional, `|` means
  "one or the other", `...` means "may repeat".
- How to search the manual when you do not know a command's name (`apropos`), get a one-line
  description (`whatis`), and read the GNU `info` manuals.
- How to make a command of your own with `alias`, and why it disappears when the terminal
  closes.

## Files in this folder

This folder holds only this guide. Chapter 5 of the book has no scripts: every example in it
is a command you type at the prompt, and each one is explained below, in the order of the
book's sections. These commands only ask questions and show documentation; the alias you
create at the end lasts only until you close the terminal.

## The book's examples

How to read this guide:

- A box marked `bash` holds what you type. Type one line, then press Enter. Text after a `#`
  is a note for you; bash ignores it.
- A box that starts with `$` shows what you see: the `$` stands for the prompt. Do not type it.
- The output is shown as Linux Mint and Ubuntu print it (bash 5.2 and the GNU tools). The
  user is called `student`. The book's output comes from an older Fedora system, so some lines
  differ; this guide says where.

### What Exactly Are Commands?

No command in this section. A **command** is one of four things:

| Kind | What it is | Example |
|---|---|---|
| Executable program | A file on the disk, like the thousands in `/usr/bin`. It may be a **compiled** program (written in a language such as C and turned into machine code) or a **script** (a text file of commands for bash, Python and so on) | `cp`, `ls` |
| Shell builtin | A command built into bash itself: there is no separate file | `cd`, `type` |
| Shell function | A small shell script kept in the shell's memory (chapter 26 writes them) | (none yet) |
| Alias | A short name you define for a longer command | `ll` on Mint |

### Identifying Commands

No command of its own: the next two sections are two ways to find out what a name is.

### type - Display a Command's Type

`type` is a shell builtin that tells you what the shell will run for a name:

```text
type command
```

The book's three examples:

```bash
type type
type ls
type cp
```

```text
$ type type
type is a shell builtin
$ type ls
ls is aliased to `ls --color=auto'
$ type cp
cp is /usr/bin/cp
```

- `type` is itself a builtin.
- `ls` is an **alias**: when you type `ls`, the shell actually runs `ls --color=auto`. That
  option is why your listings are in color. (The book's Fedora says `--color=tty`; Mint and
  Ubuntu say `--color=auto`. Both mean "use color when the output is a screen".) The alias is
  set up for you in the file `~/.bashrc` (chapter 11).
- `cp` is a program, the file `/usr/bin/cp`. (The book says `/bin/cp`; on current systems
  `/bin` is a link to `/usr/bin`, chapter 3.)

If you have already run `cp` in this terminal, `type cp` answers `cp is hashed (/usr/bin/cp)`
instead: bash remembered where it found the program last time, so it does not have to search
again. It is the same file.

### which - Display an Executable's Location

`which` searches the directories where programs live and prints the path of the program that
would run:

```bash
which ls
which cd
```

```text
$ which ls
/usr/bin/ls
$ which cd
$
```

`which` knows only about program files. It knows nothing about builtins or aliases, so for
`cd`, a builtin, there is no file to find. The book's Fedora `which` prints an error message
(`no cd in (...)`); the `which` on Mint and Ubuntu prints nothing at all. Both mean "no program
file by that name". When in doubt, use `type`: it knows all four kinds.

### Getting a Command's Documentation

No command of its own: the next sections each cover one place where documentation lives.

### help - Get Help for Shell Builtins

Bash documents its own builtins. Type `help` and the builtin's name:

```bash
help cd
```

```text
$ help cd
cd: cd [-L|[-P [-e]] [-@]] [dir]
    Change the shell working directory.

    Change the current directory to DIR.  The default DIR is the value of the
    HOME shell variable. If DIR is "-", it is converted to $OLDPWD.
(about thirty more lines: the options, then the exit status)
```

The first line is the command's **syntax**, written in a notation you will meet in every
command description:

| Notation | Means | In the `cd` line above |
|---|---|---|
| `[ ]` | Optional: you may leave it out | Plain `cd` works, because `[dir]` is optional |
| a vertical bar | One or the other, never both | `-L` or `-P` |
| `[ ]` inside `[ ]` | Optional, and only together with what surrounds it | `-e` is allowed only after `-P` |

So `cd` may be followed by `-L` or `-P` (and `-e` only with `-P`), then optionally `-@`, then
optionally a directory. (The book's line has no `[-@]`; newer bash added that option.) Like most
documentation, `help` is accurate but not a tutorial, and it mentions things not covered yet.
That is normal.

### --help - Display Usage Information

Most programs print a summary of their syntax and options when you give them the option
`--help`:

```bash
mkdir --help
```

```text
$ mkdir --help
Usage: mkdir [OPTION]... DIRECTORY...
Create the DIRECTORY(ies), if they do not already exist.

Mandatory arguments to long options are mandatory for short options too.
  -m, --mode=MODE   set file mode (as in chmod), not a=rwx - umask
(more lines: each option, with what it does)
```

Read the usage line with the notation from above: `[OPTION]...` means options are optional
and you may give several; `DIRECTORY...` means at least one directory name, and more are
allowed. That is why `mkdir dir1 dir2` worked in chapter 4. Among the options listed below the
usage line you will find `-p` (make missing parent directories) and `-v` (print a message for
each directory made). A program without `--help` usually answers with an error message that
shows the same usage, so it is always worth trying.

### man - Display a Program's Manual Page

Most programs come with a formal manual page, a **man page**, which the program `man` shows:

```text
man program
```

```bash
man ls
```

A man page usually has a title, a **SYNOPSIS** (the syntax, in the notation above), a
**DESCRIPTION** of what the command does, and a list of its options. It is a reference, not a
tutorial, and seldom has examples. `man` shows the page in `less`, so the chapter 3 keys work:
Space and `b` to page, `/word` and `n` to search, `q` to quit.

The manual is divided into numbered sections (Table 5-1):

| Section | Contents |
|---|---|
| 1 | User commands |
| 2 | Programming interfaces for kernel system calls |
| 3 | Programming interfaces to the C library |
| 4 | Special files such as device nodes and drivers |
| 5 | File formats |
| 6 | Games and amusements such as screen savers |
| 7 | Miscellaneous |
| 8 | System administration commands |

Without a section number, `man` shows the first match it finds, usually in section 1. To ask
for a section, put its number first:

```text
man section search_term
```

```bash
man passwd       # section 1: the passwd command, which changes your password
man 5 passwd     # section 5: the format of the file /etc/passwd from chapter 3
```

### apropos - Display Appropriate Commands

When you know what you want to do but not the command's name, `apropos` searches the short
descriptions of every man page for a word. The book searches for `partition`, but its example
is misspelled as `partiton`, so it finds nothing:

```bash
apropos partiton     # the book's spelling: a typo
apropos partition    # spelled right
```

```text
$ apropos partiton
partiton: nothing appropriate.
$ apropos partition
cfdisk (8)           - display or manipulate a disk partition table
fdisk (8)            - manipulate disk partition table
partx (8)            - tell the kernel about the presence and numbering of on-disk partitions
sfdisk (8)           - display or manipulate a disk partition table
```

(The list is shortened here; yours depends on what is installed.) Each line is the page name,
the section in parentheses, and the description. `man -k partition` does the same search. If
`apropos` says `nothing appropriate` for a word you are sure is there, the manual's search
index may not have been built yet on a brand-new system; the system builds it automatically
after a while.

### whatis - Display One-line Manual Page Descriptions

`whatis` prints the name and the one-line description of the man pages with exactly that name:

```bash
whatis ls
whatis passwd
```

```text
$ whatis ls
ls (1)               - list directory contents
$ whatis passwd
passwd (1)           - change user password
passwd (5)           - the password file
```

`whatis passwd` shows why section numbers matter: one name, two pages. (You may see a third
line, such as `passwd (1ssl)`, if another package has a page with that name.)

### The Most Brutal Man Page Of Them All

```bash
man bash
```

The book's author calls the bash man page the hardest of all: more than 80 pages when
printed, very dense, and ordered in a way that makes no sense to a beginner. It is also
complete and accurate. Open it, scroll a little, press `q`, and come back to it at the end of
the course.

### info - Display a Program's Info Entry

The GNU Project, which wrote `ls`, `cp`, `mkdir` and most of the commands so far, also writes
longer manuals called **info** pages. The program `info` shows them. Info pages are split into
**nodes** (one topic each) joined by **hyperlinks**, like a small web site. A link starts with
an asterisk (`*`).

```bash
info coreutils
```

This opens a menu with a link to every program in the **coreutils** package: `ls`, `cp`, `mv`,
`rm`, `mkdir`, `ln` and dozens more. Move the cursor onto a link (Tab jumps to the next link)
and press Enter to follow it.

**A note about the keys:** `info` is its own reader. It does **not** use `less` the way `man`
does, so the keys are different (Table 5-2, plus two useful extras):

| Key | What it does |
|---|---|
| `?` | Show the list of `info` commands |
| Page Up or Backspace | Previous page |
| Page Down or Space | Next page |
| `n` | Next node |
| `p` | Previous node |
| `u` | Up to the parent node, usually a menu |
| Enter | Follow the link under the cursor |
| Tab | Move the cursor to the next link |
| `l` | Go back to the last node you looked at |
| `q` | Quit |

If bash answers `info: command not found`, the `info` reader is not installed on your system;
the same documentation is online at https://www.gnu.org/software/coreutils/manual/.

### README and Other Program Documentation Files

Most installed packages also put documentation files in `/usr/share/doc`, one directory per
package. Most are plain text, which you read with `less`. A name that ends in `.gz` is
**compressed** (made smaller with the `gzip` program); `zless` shows a compressed text file the
way `less` shows a plain one.

```bash
ls /usr/share/doc                        # one directory per installed package (hundreds)
ls /usr/share/doc/bash                   # the files of the bash package
less /usr/share/doc/bash/copyright       # plain text: less
zless /usr/share/doc/bash/README.gz      # compressed text: zless
```

```text
$ ls /usr/share/doc/bash
changelog.Debian.gz  INTRO.gz  README.abs-guide    README.md.bash_completion.gz
COMPAT.gz            NEWS.gz   README.commands.gz
copyright            POSIX.gz  README.Debian.gz
inputrc.arrows       RBASH     README.gz
```

(Your list may differ a little.) The book names no particular file here; any file in
`/usr/share/doc` works the same way.

### Creating Our Own Commands with alias

First, a trick: several commands can share one line if you separate them with **semicolons**.
They run one after the other:

```text
command1; command2; command3...
```

```bash
cd /usr; ls; cd -
```

```text
$ cd /usr; ls; cd -
bin  games  include  lib  lib64  libexec  local  sbin  share  src
/home/student
```

Bash went to `/usr`, listed it, and came back (`cd -` prints the directory it returns to), so
you end where you started. Now turn that line into a command of your own with `alias`. First
pick a name and check that it is free, with `type`:

```bash
type test        # the book's first choice of name
type foo         # its second choice
```

```text
$ type test
test is a shell builtin
$ type foo
bash: type: foo: not found
```

`test` is taken (it is a builtin), but `foo` is free. Create the alias, use it, look at it,
and remove it:

```bash
alias foo='cd /usr; ls; cd -'
foo
type foo
unalias foo
type foo
```

```text
$ alias foo='cd /usr; ls; cd -'
$ foo
bin  games  include  lib  lib64  libexec  local  sbin  share  src
/home/student
$ type foo
foo is aliased to `cd /usr; ls; cd -'
$ unalias foo
$ type foo
bash: type: foo: not found
```

The shape of the command is `alias name='string'`: the name, then `=` with **no spaces** on
either side, then the commands in quotes. After that, `foo` works anywhere a command does, and
`unalias` removes it.

Aliases often reuse the name of an existing command to add an option to it, as the `ls` alias
does. `alias` with no arguments lists every alias in your shell:

```bash
alias
```

```text
$ alias
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
alias l='ls -CF'
alias la='ls -A'
alias ll='ls -alF'
alias ls='ls --color=auto'
```

These are the aliases Mint and Ubuntu set up for you (the book's Fedora list is different).
Work out what `l`, `la` and `ll` do from what you learned about `ls` options in chapter 3, then
try them. (`alert` is advanced; ignore it.)

One catch: an alias typed at the prompt lives only in that shell. Close the terminal and it is
gone. Chapter 11 shows how to keep an alias by adding it to the file `~/.bashrc`, which bash
reads every time it starts.

## Common mistakes

| You type | What you see | Fix |
|---|---|---|
| `man cd` | `No manual entry for cd` | `cd` is a builtin, documented by bash: `help cd` |
| `which cd` | Nothing at all | `which` finds only program files; `type cd` says it is a shell builtin |
| `whatis cd` | `cd: nothing appropriate.` | Same reason: builtins have no man page. Use `help cd` |
| `apropos partiton` | `partiton: nothing appropriate.` | Check the spelling: `partition` |
| `mkdir -help` | `mkdir: invalid option -- 'h'` then `Try 'mkdir --help' for more information.` | Long options take two dashes: `mkdir --help` |
| `alias foo = 'cd /usr; ls; cd -'` | `bash: alias: foo: not found`, then the same for `=` and for the quoted text | No spaces around `=`: `alias foo='cd /usr; ls; cd -'` |
| `foo` in a new terminal | `bash: foo: command not found` | Aliases end with the shell that made them; chapter 11 keeps them in `~/.bashrc` |
| `man ls` or `info coreutils`, then typing commands | Nothing happens; there is no prompt | You are still in the reader: press `q` |

## Check yourself

1. Name the four kinds of command, and the one command that tells you which kind a name is.
   <details><summary>Answer</summary>An executable program, a shell builtin, a shell function
   and an alias. <code>type name</code> tells you which.</details>
2. Why does `which cd` print nothing, while `help cd` prints a full page?
   <details><summary>Answer</summary><code>cd</code> is a builtin, part of bash, not a file.
   <code>which</code> looks only for program files, so it finds nothing; <code>help</code> shows
   bash's own documentation for its builtins.</details>
3. What is the difference between `man passwd` and `man 5 passwd`?
   <details><summary>Answer</summary><code>man passwd</code> shows the first match, section 1:
   the <code>passwd</code> command. <code>man 5 passwd</code> shows section 5 (file formats): the
   format of the file <code>/etc/passwd</code>.</details>
4. In the syntax line `mkdir [OPTION]... DIRECTORY...`, which parts must you type, and which may
   you repeat?
   <details><summary>Answer</summary>At least one <code>DIRECTORY</code> is required (it has no
   brackets). <code>[OPTION]</code> is optional. The <code>...</code> after each means you may
   give more than one of it.</details>
5. You made `alias up='cd ..'`. How do you check it, how do you remove it, and why is it gone
   when you open a new terminal?
   <details><summary>Answer</summary><code>type up</code> shows
   <code>up is aliased to `cd ..'</code>; <code>unalias up</code> removes it. An alias typed at
   the prompt belongs to that one shell, and closing the terminal ends the shell. To keep it,
   put it in <code>~/.bashrc</code> (chapter 11).</details>
