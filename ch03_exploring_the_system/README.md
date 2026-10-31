# Chapter 3: Exploring the System

*The Linux Command Line* (TLCL), chapter 3. The book is free: https://linuxcommand.org/tlcl.php

## What you will learn

- Most commands have the same shape: `command -options arguments`. An **option** changes how
  the command works; an **argument** is what the command works on.
- The `ls` options you will use every day, and how to read each column of a long listing
  (`ls -l`).
- `file` looks inside a file and tells you what it really holds; the name promises nothing.
- `less` lets you read a text file one page at a time, forward and back (`q` quits).
- A guided tour of the main directories of a Linux system, and what a **symbolic link** looks
  like in a listing.

## Files in this folder

This folder holds only this guide. Chapter 3 of the book has no scripts: every example in it
is a command you type at the prompt, and each one is explained below, in the order of the
book's sections. Every command here only looks: nothing creates, changes or deletes a file.

## The book's examples

How to read this guide:

- A box marked `bash` holds what you type. Type one line, then press Enter. Text after a `#`
  is a note for you; bash ignores it.
- A box that starts with `$` shows what you see: the `$` stands for the prompt. Do not type it.
- The output is shown as Linux Mint and Ubuntu print it (bash 5.2 and the GNU tools). Your
  user name, sizes and some file names will be different. In long listings, **`MMM DD hh:mm`
  stands for the date and time** that `ls` prints in that column (the month, the day, and the
  time of the last change).

### Having More Fun with ls

`ls` alone lists the current working directory. Give it a directory name (an argument) to list
that directory instead, without moving there. Give it several and it lists each one under a
heading. `~` stands for your home directory.

```bash
ls              # the current working directory
ls /usr         # the directory /usr, wherever you are
ls ~ /usr       # two directories, one after the other
ls -l           # the current directory again, in long format
```

```text
$ ls /usr
bin  games  include  lib  lib64  libexec  local  sbin  share  src
$ ls ~ /usr
/home/student:
Desktop  Documents  Downloads  Music  Pictures  Public  Templates  Videos

/usr:
bin  games  include  lib  lib64  libexec  local  sbin  share  src
$ ls -l
total 32
drwxr-xr-x 2 student student 4096 MMM DD hh:mm Desktop
drwxr-xr-x 2 student student 4096 MMM DD hh:mm Documents
drwxr-xr-x 2 student student 4096 MMM DD hh:mm Downloads
drwxr-xr-x 2 student student 4096 MMM DD hh:mm Music
drwxr-xr-x 2 student student 4096 MMM DD hh:mm Pictures
drwxr-xr-x 2 student student 4096 MMM DD hh:mm Public
drwxr-xr-x 2 student student 4096 MMM DD hh:mm Templates
drwxr-xr-x 2 student student 4096 MMM DD hh:mm Videos
```

(The list in `/usr` can differ by a name or two from system to system.) The `-l` changed the
output to the **long format**: one line of details per name. "A Longer Look at Long Format"
below reads every column.

### Options and Arguments

Most commands are typed in this shape:

```text
command -options arguments
```

| Part | Example | What it is |
|---|---|---|
| command | `ls` | The program to run: always the first word |
| option | `-l` | A dash and a letter that changes how the command works |
| several options | `-lt` | Short options can share one dash: `-lt` is the same as `-l -t` |
| long option | `--reverse` | Two dashes and a whole word: longer to type, easier to read |
| argument | `/usr` | What the command works on, such as a file or directory name |

The words are separated by spaces. Options are **case sensitive**, like file names: `-r` and
`-R` are two different options. The book's two examples:

```bash
ls -lt              # long format (-l), sorted by modification time (-t), newest first
ls -lt --reverse    # the same list in reverse order: oldest first
```

Try both in your home directory, then in `/etc`, where the times differ more. Table 3-1 of the
book lists the common `ls` options. Here is each one, with a command to try:

| Option | Long form | What it does | Try |
|---|---|---|---|
| `-a` | `--all` | Also list hidden names (they start with a period) | `ls -a ~` |
| `-A` | `--almost-all` | Like `-a`, but without `.` and `..` | `ls -A ~` |
| `-d` | `--directory` | With `-l`, show the directory itself, not what is inside it | `ls -ld /usr` |
| `-F` | `--classify` | Add a mark after each name: `/` for a directory, `@` for a symbolic link, `*` for a program | `ls -F /` |
| `-h` | `--human-readable` | With `-l`, sizes like `1.5M` instead of a count of bytes | `ls -lh /usr/bin/bash` |
| `-l` | | Long format | `ls -l` |
| `-r` | `--reverse` | Reverse the order (normally alphabetical) | `ls -r ~` |
| `-S` | | Sort by size, largest first | `ls -lS /etc` |
| `-t` | | Sort by modification time, newest first | `ls -lt /etc` |

What some of them print:

```text
$ ls -ld /usr
drwxr-xr-x 12 root root 4096 MMM DD hh:mm /usr
$ ls -dF /bin /boot /etc /usr
/bin@  /boot/  /etc/  /usr/
$ ls -l /usr/bin/bash
-rwxr-xr-x 1 root root 1540520 MMM DD hh:mm /usr/bin/bash
$ ls -lh /usr/bin/bash
-rwxr-xr-x 1 root root 1.5M MMM DD hh:mm /usr/bin/bash
```

Without `-d`, `ls -l /usr` would list the ten or so directories inside `/usr`; with it you get
one line about `/usr` itself. The `@` after `/bin` says it is a symbolic link (see "Symbolic
Links" below). `1540520` bytes is about 1.5 megabytes, which `-h` prints as `1.5M`.

### A Longer Look at Long Format

The book shows a long listing of an `Examples` directory from an older Ubuntu. Any long listing
reads the same way; one line is enough to practice on:

```bash
ls -l /etc/passwd
```

```text
$ ls -l /etc/passwd
-rw-r--r-- 1 root root 1380 MMM DD hh:mm /etc/passwd
```

| Column | Example | Meaning |
|---|---|---|
| 1 | `-rw-r--r--` | The first character is the **type**: `-` a regular file, `d` a directory, `l` a symbolic link. The next nine are the access rights: three for the owner, three for the group, three for everyone else (chapter 9) |
| 2 | `1` | The number of **hard links**: names this file has (chapter 4) |
| 3 | `root` | The user who owns the file |
| 4 | `root` | The group that owns the file |
| 5 | `1380` | The size in bytes |
| 6 | `MMM DD hh:mm` | The date and time of the last change to the contents (older files show the year instead of the time) |
| 7 | `/etc/passwd` | The name, always last |

The `total` line at the top of a directory listing is the disk space used by the files listed,
counted in blocks of 1024 bytes.

### Determining a File's Type with file

On Linux a file's name does not have to say what is inside it: a file called `picture.jpg`
does not have to hold a picture. `file` reads the first bytes of the contents and reports what
kind of data it finds:

```text
file filename
```

The book's example is `file picture.jpg`, which answers `JPEG image data, JFIF standard 1.01`
(a current system adds details such as the size in pixels). If you have a picture in your
`Pictures` directory, try `file` on it. These work on every system:

```bash
file /etc/passwd                     # a text file
file /etc/hostname                   # a text file with no extension at all
file /usr/bin/ls                     # a program
file /usr/share/doc/bash/README.gz   # a compressed file
file /etc                            # a directory
file /bin                            # a symbolic link
file /dev/null                       # a device
```

```text
$ file /etc/passwd
/etc/passwd: ASCII text
$ file /etc/hostname
/etc/hostname: ASCII text
$ file /usr/bin/ls
/usr/bin/ls: ELF 64-bit LSB pie executable, x86-64, version 1 (SYSV), dynamically linked, ...
$ file /usr/share/doc/bash/README.gz
/usr/share/doc/bash/README.gz: gzip compressed data, max compression, from Unix, ...
$ file /etc
/etc: directory
$ file /bin
/bin: symbolic link to usr/bin
$ file /dev/null
/dev/null: character special (1/3)
```

**ASCII text** is plain text that `less` can show you (next section). **ELF** is the format of
programs on Linux: do not try to read it as text. (On a computer with an ARM processor, such as
an Apple Silicon Mac, it says `ARM aarch64` instead of `x86-64`.) `/dev/null` is a device, not a
file on the disk: Linux shows devices as files too. The book puts it this way: on a Unix-like
system "everything is a file".

### Viewing File Contents with less

`less` shows a text file one screen at a time:

```text
less filename
```

The book's example opens `/etc/passwd`, the file that lists every user account on the system:

```bash
less /etc/passwd
```

The first lines look like this (your file has more lines, and one of them is yours):

```text
root:x:0:0:root:/root:/bin/bash
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
bin:x:2:2:bin:/bin:/usr/sbin/nologin
sys:x:3:3:sys:/dev:/usr/sbin/nologin
```

Each line is one account, and colons separate its fields: the user name, an `x` (the password
is kept in another file), the user and group numbers, the full name, the home directory, and
the shell. Find your own line: press `/`, type your user name, press Enter.

While `less` is open, the keyboard controls `less`, not the shell. The keys (Table 3-3):

| Key | What it does |
|---|---|
| Page Down or Space | Forward one page |
| Page Up or `b` | Back one page |
| Down arrow / Up arrow | Down one line / up one line |
| `G` | Go to the end of the file |
| `1G` or `g` | Go to the beginning of the file |
| `/characters` then Enter | Search forward for *characters* |
| `n` | Find the next match of the last search |
| `h` | Show the help screen |
| `q` | Quit `less` and get the prompt back |

### What Is "Text"?

No command in this section. A computer stores everything as numbers. **Plain text** (the book
uses ASCII, the oldest and simplest form) stores each character as one number, one byte per
character, and nothing else: fifty characters of text take fifty bytes. A word processor file
(Word, LibreOffice) is *not* plain text: it also holds fonts, layout and other data, so `less`
shows it as garbage. Linux keeps most of its settings in plain text files, called
**configuration files**, and many of its programs are plain text **scripts**. That is why
reading text files with `less` teaches you so much about the system.

### Less Is More

No command in this section. `less` is a **pager**: a program for reading long text one page at
a time. It replaced an older pager called `more`, which could only move forward; the name is a
joke on "less is more". The manual pages in chapter 5 open in `less`, so the same keys work
there.

### Taking a Guided Tour

The book suggests a method for exploring any directory:

```bash
cd /etc          # 1. go into a directory
ls -l            # 2. list what is there, in long format
file passwd      # 3. if a name looks interesting, ask file what it holds
less passwd      # 4. if file says it is text, read it with less (q quits)
reset            # 5. only if a non-text file scrambled the terminal: this repairs it
```

Looking cannot damage anything: a regular user cannot change system files. When a command
answers `Permission denied`, the system is protecting a file from regular users; move on. Here
is the book's list of directories (Table 3-4), each with one command to look at it:

| Directory | What is there | Try |
|---|---|---|
| `/` | The root directory, where everything begins | `ls /` |
| `/bin` | Programs the system needs to start and run. On current systems it is a link to `/usr/bin` | `ls -ld /bin` |
| `/boot` | The Linux kernel (a file named `vmlinuz...`), the initial RAM disk (`initrd.img...`, the drivers needed while the computer starts) and the boot loader in `grub/` | `ls /boot` |
| `/dev` | Device nodes: every device the kernel knows about, shown as a file | `ls /dev` |
| `/etc` | System-wide configuration files, nearly all plain text. Favorites: `crontab` (when automatic jobs run), `fstab` (which storage devices are mounted where), `passwd` (the user accounts) | `less /etc/fstab` |
| `/home` | One directory per regular user; a regular user may write only in their own | `ls /home` |
| `/lib` | Shared libraries for the system's programs (like DLL files in Windows). Now a link to `/usr/lib` | `ls -ld /lib` |
| `/lost+found` | Used only to recover files after file system damage; normally empty, and only root may look in | `ls -ld /lost+found` |
| `/media` | Where USB drives and other removable media appear when you plug them in | `ls /media` |
| `/mnt` | Where devices mounted by hand used to go; often empty | `ls /mnt` |
| `/opt` | "Optional" software, mostly commercial; often empty | `ls /opt` |
| `/proc` | Not on the disk at all: the kernel makes these "files" up on the spot to show what it knows | `less /proc/cpuinfo` |
| `/root` | The home directory of the root account; you may not look inside | `ls -ld /root` |
| `/sbin` | System programs, mostly for the superuser. Now a link to `/usr/sbin` | `ls -ld /sbin` |
| `/tmp` | Temporary files; every user may write here, and it may be emptied when the computer restarts | `ls -ld /tmp` |
| `/usr` | The largest tree: the programs and support files for regular users | `ls /usr` |
| `/usr/bin` | The programs your Linux installed: thousands of them | `ls /usr/bin` |
| `/usr/lib` | The shared libraries for those programs | `ls /usr/lib` |
| `/usr/local` | Software the administrator adds for everyone; nearly empty on a new system | `ls /usr/local` |
| `/usr/sbin` | More system administration programs | `ls /usr/sbin` |
| `/usr/share` | Data the programs share: icons, backgrounds, sounds, default settings | `ls /usr/share` |
| `/usr/share/doc` | Documentation, one directory per installed package | `ls /usr/share/doc` |
| `/var` | Data that changes: databases, mail, files waiting to be printed | `ls /var` |
| `/var/log` | Log files: records of what the system did. Some only the superuser may read | `ls -l /var/log` |

Two of the book's file names are out of date on Linux Mint and Ubuntu: the boot loader's
settings are in `/boot/grub/grub.cfg` (not `grub.conf` or `menu.lst`), and there is no
`/var/log/messages`; on most installs the main system log is `/var/log/syslog`.

### Symbolic Links

A **link** is an extra name for a file. A **symbolic link** (also called a soft link or
symlink) is a tiny file that holds the path of another file or directory, like a shortcut in
Windows. In a long listing its line starts with `l` and shows an arrow to the file it points
to.

The book's example is the line for `libc.so.6` in `/lib` on an old Fedora system, which was a
link to `libc-2.6.so`. That example is out of date: since version 2.34 of the C library
(glibc), `libc.so.6` is the library itself, a regular file, so its line starts with `-` and has
no arrow. Here are two symbolic links every current Mint or Ubuntu system has:

```bash
ls -l /bin
ls -l /usr/bin/python3
```

```text
$ ls -l /bin
lrwxrwxrwx 1 root root 7 MMM DD hh:mm /bin -> usr/bin
$ ls -l /usr/bin/python3
lrwxrwxrwx 1 root root 10 MMM DD hh:mm /usr/bin/python3 -> python3.12
```

(Your Python version number may be different.) The second one is exactly the book's story.
Many programs run `python3`, but the installed program carries its version in its name,
`python3.12`. The link `python3` points to it, so every program finds Python under the short
name, and you can still see which version is installed. When a new version is installed, only
the link is changed to point to the new file; to go back, point the link at the old file again.
Notice the size column: `7` and `10` are the number of characters in `usr/bin` and
`python3.12`, the paths the links hold. Chapter 4 shows how to make links.

### Hard Links

No command in this section. A **hard link** is the second kind of link: another name for the
same data, with no arrow and no special mark in a listing. The number in column 2 of `ls -l`
counts them. Chapter 4 makes both kinds and shows the difference.

## Common mistakes

| You type | What you see | Fix |
|---|---|---|
| `ls l` | `ls: cannot access 'l': No such file or directory` | An option starts with a dash: `ls -l` |
| `ls - l` | `ls: cannot access '-': No such file or directory` and the same for `'l'` | No space between the dash and the letter: `ls -l` |
| `ls -y` | `ls: invalid option -- 'y'` then `Try 'ls --help' for more information.` | A typo in the option; `ls --help` lists them all |
| `less /usr/bin/ls` | `"/usr/bin/ls" may be a binary file.  See it anyway?` | Answer `n`. Run `file` first: only text is worth reading with `less` |
| You saw a program file anyway | The screen fills with strange symbols | Type `reset` and press Enter, even if you cannot see what you type |
| `less /etc/passwd`, then typing commands | Nothing happens; there is no prompt | `less` is still open: press `q` |
| `ls /root` | `ls: cannot open directory '/root': Permission denied` | Expected: only root may look inside |
| `less /var/log/messages` | `/var/log/messages: No such file or directory` | Mint and Ubuntu use other names: `ls /var/log` |

## Check yourself

1. In `ls -lt --reverse /etc`, which word is the command, which are options, and which is the
   argument?
   <details><summary>Answer</summary><code>ls</code> is the command; <code>-lt</code> (two short
   options, <code>-l</code> and <code>-t</code>) and <code>--reverse</code> (a long option) are the
   options; <code>/etc</code> is the argument, the directory to list.</details>
2. A long listing has three lines that start with `-rw-r--r--`, `drwxr-xr-x` and `lrwxrwxrwx`.
   What kind of file is each?
   <details><summary>Answer</summary><code>-</code> is a regular file, <code>d</code> a directory,
   and <code>l</code> a symbolic link.</details>
3. A file is called `photo.jpg`, but `file photo.jpg` answers `ASCII text`. What is in it?
   <details><summary>Answer</summary>Plain text. Linux does not care about the name: the
   contents decide what a file is, and <code>file</code> reads the contents.</details>
4. You are reading a long file with `less`. How do you search for the word `bash`, jump to the
   next match, and get back to the prompt?
   <details><summary>Answer</summary>Type <code>/bash</code> and press Enter, press
   <code>n</code> for the next match, and press <code>q</code> to quit.</details>
5. What does `ls -ld /usr` show that `ls -l /usr` does not?
   <details><summary>Answer</summary><code>ls -ld /usr</code> shows one line about the directory
   <code>/usr</code> itself (its rights, owner, date). <code>ls -l /usr</code> lists the contents
   of <code>/usr</code> instead.</details>
