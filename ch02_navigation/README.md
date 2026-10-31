# Chapter 2: Navigation

*The Linux Command Line* (TLCL), chapter 2. The book is free: https://linuxcommand.org/tlcl.php

## What you will learn

- Linux keeps every file in **one tree** of directories (folders) that starts at the **root
  directory**, written `/`. There are no drive letters such as `C:`.
- At every moment you are standing in one directory, your **current working directory**.
  `pwd` tells you where you are, `ls` shows what is there, and `cd` moves you.
- A **path** (the book says pathname) is the route through the tree to a file or directory.
  An **absolute** path starts at `/`; a **relative** path starts where you are standing.
- The shortcuts `.` (this directory), `..` (one level up), `~` (your home directory),
  `cd` alone (go home) and `cd -` (go back).
- Four facts about file names: a leading `.` hides a file, upper and lower case are different,
  extensions are only a habit, and spaces cause trouble.

## Files in this folder

This folder holds only this guide. Chapter 2 of the book has no scripts: every example in it
is a command you type at the prompt, and each one is explained below, in the order of the
book's sections. Nothing in this chapter creates, changes or deletes a file: you only look and
move around, so you cannot break anything.

## The book's examples

How to read this guide:

- A box marked `bash` holds what you type. Type one line, then press Enter. Text after a `#`
  is a note for you; bash ignores it.
- A box that starts with a prompt shows what you see on the screen. Do not type the prompt.
- The output is shown as Linux Mint prints it (bash 5.2 and the GNU tools). The user is
  called `student`; yours has your own user name, and your home directory is `/home/`
  followed by that name.

### Understanding the File System Tree

No command in this section, only ideas. A **directory** is what Windows and macOS call a
folder: a place that holds files and other directories. A directory inside another one is a
**subdirectory**. Linux arranges all of them in a **tree**, drawn upside down, with the
**root directory** at the top. The root directory is written as a single slash: `/`.

```text
/                  the root directory: everything is somewhere below it
├── bin            programs (a link to usr/bin, chapter 3)
├── etc            system settings, kept in text files
├── home           one directory per user
│   └── student    your home directory
│       ├── Desktop
│       └── Documents
├── tmp            temporary files
└── usr            installed software
    └── bin        most of the commands you type: ls, cp, date
```

Windows gives every disk its own tree with a letter (`C:\`, `D:\`). Linux has exactly one tree,
however many disks there are. A disk or USB stick is **mounted** (attached) at some directory
inside the tree, and its files then appear there. The **system administrator**, the person who
runs the computer (on your own machine, you), decides where.

To see the top of the tree for yourself (this line is not in the book):

```bash
ls /
```

`ls /` lists about twenty names, among them `bin`, `boot`, `dev`, `etc`, `home`, `tmp`,
`usr` and `var`. Chapter 3 visits each of them.

### The Current Working Directory

You are always "standing" in one directory of the tree. From there you can see what it
contains, the directory above it (its **parent directory**), and the directories below it. The
directory you are standing in is your **current working directory**. `pwd` (print working
directory) prints it:

```bash
pwd
```

```text
student@mint:~$ pwd
/home/student
```

A new terminal always starts in your **home directory**: the directory that belongs to you,
`/home/student`. It is the only place where a regular user may create files. The `~` in the
prompt is short for it.

### Listing the Contents of a Directory

`ls` (list) shows the files and directories in the current working directory:

```bash
ls
```

```text
student@mint:~$ ls
Desktop  Documents  Downloads  Music  Pictures  Public  Templates  Videos
```

Every name here is a directory that Linux Mint creates in a new home directory. `ls` can also
list a directory you are not in: `ls /usr` lists `/usr` without moving you. Chapter 3 does much
more with `ls`.

### Changing the Current Working Directory

`cd` (change directory) moves you. Type `cd`, a space, and the **path** of the directory you
want. A path (the book's word is **pathname**) is the route through the tree: directory names
joined by `/`. There are two kinds, absolute and relative, explained in the next two sections.

### Absolute Pathnames

An **absolute path** starts with `/`, the root, and names every directory on the way down. Read
`/usr/bin` as: from the root (the first `/`), into `usr`, into `bin`. Every later `/` only
separates two names. An absolute path works from anywhere in the tree.

```bash
cd /usr/bin
pwd
ls
```

```text
student@mint:~$ cd /usr/bin
student@mint:/usr/bin$ pwd
/usr/bin
student@mint:/usr/bin$ ls
(a long list of names: most of the system's programs live here)
```

Look at the prompt: after `cd`, the part before the `$` changed from `~` to `/usr/bin`. The
Mint prompt always shows the full path of where you are. (The book's prompt shows only the last
part, `bin`.) When you are lost, look at the prompt or type `pwd`.

### Relative Pathnames

A **relative path** does not start with `/`. It starts from your current working directory and
uses two special names:

| Name | Means |
|---|---|
| `.` (dot) | The current working directory |
| `..` (dot dot) | The parent directory: one level up |

The book reaches the same places two ways. Type these in order and check each `pwd`:

```bash
cd /usr/bin     # start in /usr/bin
cd /usr         # up to the parent, with an absolute path
pwd
cd /usr/bin     # back to /usr/bin
cd ..           # up to the parent, with a relative path
pwd
```

```text
student@mint:~$ cd /usr/bin
student@mint:/usr/bin$ cd /usr
student@mint:/usr$ pwd
/usr
student@mint:/usr$ cd /usr/bin
student@mint:/usr/bin$ cd ..
student@mint:/usr$ pwd
/usr
```

Both ways end in `/usr`. Now go down again, from `/usr` to `/usr/bin`, three ways:

```bash
cd /usr/bin     # absolute: works from anywhere
cd ..           # back up to /usr
cd ./bin        # relative: the bin inside . (here)
pwd
cd ..           # back up to /usr
cd bin          # relative, without the ./
pwd
```

```text
student@mint:/usr$ cd /usr/bin
student@mint:/usr/bin$ cd ..
student@mint:/usr$ cd ./bin
student@mint:/usr/bin$ pwd
/usr/bin
student@mint:/usr/bin$ cd ..
student@mint:/usr$ cd bin
student@mint:/usr/bin$ pwd
/usr/bin
```

`cd ./bin` and `cd bin` do the same thing: when a path does not start with `/`, the shell
starts from the current working directory anyway, so the `./` can almost always be left out.
Which kind of path should you use? The book's answer: whichever needs less typing.

### Some Helpful Shortcuts

| You type | Where you go |
|---|---|
| `cd` | Your home directory, from anywhere |
| `cd -` | Back to the previous working directory (`cd -` prints its name) |
| `cd ~user_name` | The home directory of that user: `cd ~bob` goes to bob's home |

```bash
cd /usr/share   # go somewhere
cd              # cd alone: home
pwd
cd -            # back to the previous directory
cd -            # and back again: cd - switches between the last two
```

```text
student@mint:/usr/bin$ cd /usr/share
student@mint:/usr/share$ cd
student@mint:~$ pwd
/home/student
student@mint:~$ cd -
/usr/share
student@mint:/usr/share$ cd -
/home/student
student@mint:~$
```

The book's example `cd ~bob` works only if there is a user named bob. Your system has no bob,
so try it with your own user name instead (`whoami` prints it):

```bash
cd ~student     # use your own user name after the ~
pwd
cd ~bob         # fails: there is no user bob
```

```text
student@mint:~$ cd ~student
student@mint:~$ pwd
/home/student
student@mint:~$ cd ~bob
bash: cd: ~bob: No such file or directory
```

### Important Facts About Filenames

1. **A name that starts with a period is hidden.** `ls` does not list it unless you add the
   option `-a` (all). Your home directory holds several hidden files with your settings
   (chapter 11 looks at them).

   ```bash
   cd
   ls -a
   ```

   ```text
   student@mint:~$ ls -a
   .   .bash_logout  .cache   Desktop    Downloads  Music     .profile  Templates
   ..  .bashrc       .config  Documents  .local     Pictures  Public    Videos
   ```

   (Your list of hidden names will differ.) `.` and `..` appear in every directory: they are
   the "this directory" and "parent directory" names from the table above.

2. **Upper and lower case are different.** `File1` and `file1` are two different files, and
   `Documents` and `documents` are two different names. Commands are case sensitive too: `cd`
   works, `CD` does not.

   ```bash
   cd ~/Documents     # works
   cd ~/documents     # fails: the directory is Documents, with a capital D
   ```

3. **Linux has no file extensions of its own.** A name like `notes.txt` is a habit that helps
   people (and some programs), but Linux does not need the `.txt`. A file called `notes` is just
   as good. Chapter 3's `file` command looks inside a file to tell what it really holds.

4. **Do not put spaces in the names you create.** Use letters, digits, the period `.`, the dash
   `-` and the underscore `_`. Write `my_report.txt`, not `my report.txt`: the shell reads a
   space as the end of one name and the start of the next, so `ls my report.txt` looks for two
   files, `my` and `report.txt`.

## Common mistakes

| You type | What bash says | Fix |
|---|---|---|
| `cd..` | `bash: cd..: command not found` | `cd` and `..` are two words: `cd ..` |
| `cd documents` | `bash: cd: documents: No such file or directory` | Case matters: `ls` shows the exact name, `Documents` |
| `cd /ETC` | `bash: cd: /ETC: No such file or directory` | The directory is `/etc`, in lowercase |
| `cd bin` (in your home) | `bash: cd: bin: No such file or directory` | A relative path starts where you are, and your home has no `bin`. Use `cd /usr/bin` |
| `cd /etc/passwd` | `bash: cd: /etc/passwd: Not a directory` | `cd` goes only into directories; `/etc/passwd` is a file |
| `ls my report.txt` | `ls: cannot access 'my': No such file or directory` and the same for `report.txt` | Name files with underscores. For a name that already has a space, use quotes: `ls "my report.txt"` (chapter 7) |
| `cd ~bob` | `bash: cd: ~bob: No such file or directory` | There is no user bob; use a user name that exists |
| `Cd /usr` | `bash: Cd: command not found` | Commands are lowercase: `cd` |

## Check yourself

1. What is the difference between `/usr/bin` and `usr/bin`?
   <details><summary>Answer</summary><code>/usr/bin</code> is an absolute path: it starts at the
   root and works from anywhere. <code>usr/bin</code> is relative: it means the <code>usr</code>
   directory inside the directory you are in now, which usually does not exist.</details>
2. You are in `/usr/share/doc`. How many `cd ..` commands take you to `/`? What happens if you
   type `cd ..` once more at `/`?
   <details><summary>Answer</summary>Three: to <code>/usr/share</code>, to <code>/usr</code>,
   then to <code>/</code>. At <code>/</code>, <code>cd ..</code> leaves you at <code>/</code>:
   the root has no parent.</details>
3. You went from your home directory to `/etc`. Name two ways to get home again.
   <details><summary>Answer</summary><code>cd</code> alone always goes home. <code>cd -</code>
   goes back to the previous directory, which here is your home. (<code>cd ~</code> and
   <code>cd /home/student</code> also work.)</details>
4. Why does `ls` not show the file `.bashrc` in your home directory, and how do you see it?
   <details><summary>Answer</summary>Its name starts with a period, so it is hidden.
   <code>ls -a</code> lists hidden names too.</details>
5. Which of these is the best name for a new file: `My Report.txt`, `my_report.txt` or
   `my report.TXT`? Why?
   <details><summary>Answer</summary><code>my_report.txt</code>. It has no spaces, so the shell
   reads it as one name, and it is all lowercase, so there is no doubt about the case when you
   type it later.</details>
