# Chapter 1: What Is the Shell?

*The Linux Command Line* (TLCL), chapter 1. The book is free: https://linuxcommand.org/tlcl.php

## What you will learn

- The **shell** is a program that reads the commands you type and asks Linux to carry them
  out. On Linux Mint (and almost every Linux system) the shell is called **bash**.
- The **terminal** is only the window the shell runs in: it shows what you type and what the
  shell answers.
- How to read the **prompt**, and what a `$` or a `#` at its end tells you.
- How to bring back and fix an earlier command with the arrow keys instead of retyping it.
- Four commands that only look and never change anything: `date`, `cal`, `df` and `free`;
  and three ways to end a session.

## Files in this folder

This folder holds only this guide. Chapter 1 of the book has no scripts: every example in it
is a command you type at the prompt, and each one is explained below, in the order of the
book's sections. The book's first script comes in chapter 24.

## The book's examples

How to read this guide:

- A box marked `bash` holds what you type. Type one line, then press Enter.
- Text after a `#` on a line is a note for you. Bash ignores everything from `#` to the end of
  the line, so you may type the note or leave it out.
- A box that starts with `$` shows what you see on the screen: the `$` stands for the prompt,
  then the command, then the shell's answer. Do not type the `$`.
- The output is shown as Linux Mint prints it (bash 5.2 and the GNU tools). Your user name,
  computer name, sizes, and the date and time will be different; the shape of the output is
  what matters.

### What is the shell? (the start of the chapter)

People say "the command line" when they mean the **shell**: a program that takes the commands
you type on the keyboard and passes them to the operating system (Linux) to carry out. The
shell on Linux Mint is `bash`, short for **B**ourne **A**gain **SH**ell: an improved version
of `sh`, the original Unix shell written by Steve Bourne.

Four layers work together every time you press Enter:

| Layer | What it does |
|---|---|
| You | Type a command and press Enter |
| Terminal | The window: it shows your typing and the answers |
| Shell (`bash`) | Reads the line, works out what you asked for, starts the program |
| Kernel | The core of Linux: it does the real work with the disk, memory and processor |

The shell is an ordinary program. If it stops, Linux keeps running; you open a new terminal
and get a new shell.

### Terminal Emulators

No command in this section. A **terminal emulator** (most people just say **terminal**) is the
window you type in. The book names `konsole` (on the KDE desktop) and `gnome-terminal` (on
GNOME). On Linux Mint the program is simply called **Terminal**: open it from the menu, or press
Ctrl-Alt-T. The terminal draws the text; the shell inside it does the work.

### Making Your First Keystrokes

When the terminal opens you see the **prompt**: the text the shell prints whenever it is ready
for your next command. The book's prompt is `[me@linuxbox ~]$`. On Linux Mint it looks like
this, with your own names in it:

```text
student@mint:~$
```

| Part | Meaning |
|---|---|
| `student` | Your user name (the name you log in with) |
| `@` | Separates the user name from the computer name |
| `mint` | The computer's name, chosen when Linux was installed (yours may be longer) |
| `~` | The directory (folder) you are in. `~` means your **home directory**, your own folder; chapter 2 explains it |
| `$` | You are a regular user. The shell is waiting for a command |

If the prompt ends in `#` instead of `$`, the shell has **superuser** rights: you are working
as **root**, the administrator account that may change anything on the system. Read every
command twice before you press Enter, and type `exit` to go back to your own account.

Now type something that is not a command at all, on purpose:

```bash
kaekfjaeifj
```

```text
$ kaekfjaeifj
bash: kaekfjaeifj: command not found
$
```

Read an error message in pieces: `bash:` is the program that is complaining, `kaekfjaeifj:` is
the thing it could not handle, and `command not found` is what went wrong. Then a new prompt
appears and nothing has changed. (Some systems leave out the `bash:` part or add a "did you
mean" suggestion; it reads the same way.) Mistakes like this are free, so experiment.

### Command History

Press the **Up arrow**: the line you typed last (`kaekfjaeifj`) comes back after the prompt.
This is **command history**. Bash remembers your recent commands (1000 of them by default on
most systems). Press Up again to go further back, and **Down** to come forward again. The
`history` command, which lists them all with numbers, comes in chapter 8.

### Cursor Movement

Press Up to bring back a line, then use the **Left** and **Right** arrows to move the cursor
anywhere inside it. Fix a typo, then press Enter: the cursor does not need to be at the end of
the line. Two more keys save time: Ctrl-a jumps to the start of the line and Ctrl-e to the end.

### A Few Words About Mice and Focus

No command in this section, but one warning matters:

- **Ctrl-c does not copy in a terminal.** It stops (interrupts) the command that is running,
  or throws away the line you were typing. Ctrl-v does not paste either.
- In the Mint Terminal, copy with **Ctrl-Shift-c** and paste with **Ctrl-Shift-v**, or use the
  right-click menu.
- The book's quick method also works: select text with the mouse (or double-click a word) and
  it is copied at once; the **middle mouse button** pastes it where the cursor is.

The book also describes "focus follows mouse", a desktop setting where a window takes your
typing as soon as the mouse pointer is over it, without a click. It is optional; Mint uses
click to focus unless you change it in the window settings.

### Try Some Simple Commands

Four commands that only report information. None of them can change anything.

```bash
date        # the current date and time
```

`date` prints one line: the day of the week, the month and the day, the time (on a system set
to US English, with AM or PM), the time zone, and the year. Run it twice a minute apart and
watch the time change.

```bash
cal         # a calendar of the current month
```

`cal` prints the month and year as a title, a row of day names (`Su Mo Tu We Th Fr Sa`), and
the days of the month in a grid, with the current day highlighted. Type `cal` followed by a
year (try the year you were born) to see all twelve months of that year. If bash answers
`cal: command not found`, the program is not installed on your system: it comes in a package
called `ncal` (chapter 14 is about installing software).

```bash
df          # disk free: space on each disk, counted in 1K blocks
free        # memory in use and free, counted in kibibytes
```

The numbers in plain `df` and `free` are long and hard to read. Add the **option** `-h`
(human-readable) to print sizes in G (gigabytes) and M (megabytes). An option is a dash and a
letter typed after the command, with a space between them; it changes how the command works.
Chapter 3 explains options fully.

```bash
df -h
free -h
```

Here is the kind of output a virtual machine with a 25 GB disk and 4 GB of memory prints
(the `df` list is shortened to three of its lines):

```text
$ df -h
Filesystem      Size  Used Avail Use% Mounted on
tmpfs           393M  1.6M  391M   1% /run
/dev/sda2        24G  7.8G   15G  35% /
tmpfs           1.9G     0  1.9G   0% /dev/shm
$ free -h
               total        used        free      shared  buff/cache   available
Mem:           3.8Gi       1.1Gi       1.4Gi        38Mi       1.3Gi       2.7Gi
Swap:          2.0Gi          0B       2.0Gi
```

| What to read | What it tells you |
|---|---|
| `df`: the line that ends in `/` | Your main disk. **Size** is how big it is, **Avail** how much is free, **Use%** how full it is |
| `df`: the `tmpfs` lines | Small areas kept in memory, not on the disk; you can ignore them |
| `free`: **total** on the `Mem:` line | The memory (RAM) the system has |
| `free`: **available** | How much memory programs can still use |
| `free`: **Swap** | Disk space used as extra memory when RAM runs short |

The book's `free` output has a `-/+ buffers/cache` line. Current versions of `free` dropped
it and print the `buff/cache` and `available` columns instead.

### Ending a Terminal Session

Three ways out, all safe: type `exit`, press **Ctrl-d** on an empty line, or close the window.
Your files stay where they are; only that shell ends.

```bash
exit        # the shell ends and the Terminal window closes
```

Ctrl-d means "end of input": the shell has nothing more to read, so it stops. Run `exit`
last, after you have tried everything else in this guide.

### The Console Behind the Curtain

No command to type, only keys, and nothing later depends on this section. Even when no
terminal window is open, Linux keeps several text-only sessions running behind the desktop,
called **virtual consoles**. Press **Ctrl-Alt-F3** to switch to one: you see a login prompt
where you can log in with your user name and password, look around, and type `exit` to log out.
On Linux Mint, **Ctrl-Alt-F7** brings the desktop back.

On a virtual machine in VirtualBox, your own computer catches Ctrl-Alt-F keys. Press the Host
key (Right Ctrl, unless you changed it) together with F3 instead, and Host plus F7 to return.

## Common mistakes

| You type | What bash says | Fix |
|---|---|---|
| `DATE` | `bash: DATE: command not found` | Commands are lowercase: `date` |
| `dtae` | `bash: dtae: command not found` | Press Up, move with Left to the typo, fix it, Enter |
| `df-h` | `bash: df-h: command not found` | Put a space between the command and the option: `df -h` |
| `cal` | `bash: cal: command not found` | The program is missing; it is in the `ncal` package (chapter 14 installs software) |
| Ctrl-c, to copy | `^C` and a new prompt: your line was thrown away | Copy with Ctrl-Shift-c, paste with Ctrl-Shift-v |
| `exit`, by mistake | The window closes | Open a new terminal with Ctrl-Alt-T; nothing was lost |
| The prompt ends in `#` | No error: you are working as root | Type `exit` to return to your own account |

## Check yourself

1. What is the difference between the shell and the terminal?
   <details><summary>Answer</summary>The shell (<code>bash</code>) is the program that reads your
   commands and has Linux carry them out. The terminal is the window that shows what you type
   and what the shell prints.</details>
2. Your prompt reads `student@mint:~$`. What does each part mean?
   <details><summary>Answer</summary><code>student</code> is your user name, <code>mint</code> the
   computer's name, <code>~</code> the directory you are in (your home directory), and
   <code>$</code> says you are a regular user and the shell is ready.</details>
3. You typed a long command and bash said `command not found` because of one wrong letter. What
   is the fastest way to fix it?
   <details><summary>Answer</summary>Press Up to bring the line back, move to the typo with the
   Left arrow, fix it, and press Enter. The cursor does not need to be at the end of the
   line.</details>
4. In the output of `df -h`, which line shows your main disk, and which column tells you how
   full it is?
   <details><summary>Answer</summary>The line whose last column (Mounted on) is <code>/</code>.
   The <code>Use%</code> column shows how full it is.</details>
5. Why should you not press Ctrl-c to copy text in a terminal?
   <details><summary>Answer</summary>In a terminal Ctrl-c interrupts: it stops the running
   command or throws away the line you are typing. Copy with Ctrl-Shift-c, or select the text
   with the mouse.</details>
