# Chapter 10: Processes

*The Linux Command Line* (TLCL), chapter 10. The book is free: https://linuxcommand.org/tlcl.php

## What you will learn

- Every running program is a **process**. Linux gives each one a number (its **PID**,
  process ID), an owner, and a parent: the process that started it.
- `ps` takes a snapshot of the processes (`ps`, `ps x`, `ps aux`); `top` shows the same
  picture live, busiest first.
- **Job control**: `&` starts a program in the background, `jobs` lists the programs you
  started from this terminal, `Ctrl-z` pauses the one in front, and `bg` and `fg` move a job
  to the background or the foreground.
- `kill` and `killall` send **signals**: `TERM` (15, the default) asks a program to stop,
  `KILL` (9) makes the kernel remove it, and `INT` (2) is what `Ctrl-c` sends.
- `shutdown` and `reboot` stop the whole machine in an orderly way; they need administrator
  rights.

## Files in this folder

This chapter has no scripts and no data files. The book's examples are commands you type at
the prompt; they are all below, section by section. None of them creates files, so you can
run them from any folder.

## The book's examples

**The test program.** The book experiments on `xlogo`, a small program that opens a window
with the X logo. A current Linux Mint installation does not include it (it comes in the
`x11-apps` package, and installing software needs administrator rights). This guide uses
`sleep 300` in its place: `sleep` waits for the number of seconds you give it (here 300,
five minutes) and then ends. It has no window to watch, but job control and signals work on
it exactly as the book describes. The book's own tip, if you want a window, is to use a
graphical text editor instead; on Mint that is `xed`.

**Your numbers will differ.** Every PID below is just the number one machine assigned. Read
the PID your own shell prints, and use that. In the `TIME` column of `ps`, this guide writes
`...` where your screen shows a number.

### How a Process Works

When the system starts, the kernel starts a few processes of its own and then one program
that starts all the others. The book calls that program `init` and describes the **init
scripts** in `/etc` that it runs. On current systems, Linux Mint included, PID 1 is
**systemd**, which starts and supervises the system services itself. You can check (this
command is not in the book; `-p 1` picks process 1, and `-o pid,comm` chooses the columns):

```bash
ps -p 1 -o pid,comm
```

```text
$ ps -p 1 -o pid,comm
    PID COMMAND
      1 systemd
```

Many services are **daemons**: programs that run in the background with no user interface,
so the system is busy even when nobody is logged in. A program that starts another program
is its **parent**; the new one is its **child**. Every command you type is a child of your
shell, `bash`. The kernel keeps track of each process: its PID (assigned in increasing
order), its memory, whether it is ready to run, and its owner, which works just like the
owner of a file in chapter 9.

### Viewing Processes

`ps` with no options shows only the processes of the current terminal session:

```bash
ps
```

```text
$ ps
    PID TTY          TIME CMD
   3568 pts/0    ...      bash
   3571 pts/0    ...      ps
```

Two processes: your shell, and `ps` itself, which was running at the moment it took the
snapshot. The columns:

- `PID`: the process ID.
- `TTY` ("teletype"): the process's **controlling terminal**, here `pts/0`, your terminal
  window.
- `TIME`: how much **CPU time** the process has used so far, in hours, minutes and seconds
  (not how long ago it started). For both processes your screen shows all zeros: neither has
  made the computer work hard.
- `CMD`: the command.

`ps x` (an option with no leading dash) shows **every process you own**, whether or not it
has a terminal. The list is long, so page through it with `less` (`q` quits):

```bash
ps x
ps x | less
```

```text
$ ps x
    PID TTY      STAT   TIME COMMAND
    389 ?        Ss     0:00 /usr/lib/systemd/systemd --user
    393 ?        S      0:00 (sd-pam)
...
```

A `?` in the `TTY` column means the process has no controlling terminal. The new `STAT`
column is the process **state** (the book's Table 10-1):

| State | Meaning |
|---|---|
| `R` | Running, or ready to run |
| `S` | Sleeping: waiting for something, such as a keystroke or a network packet |
| `D` | Uninterruptible sleep: waiting for input or output, such as a disk |
| `T` | Stopped: told to pause (you will do this with `Ctrl-z` below) |
| `Z` | A zombie: a child process that has ended, but that its parent has not cleaned up yet |
| `<` | High priority: it gets more CPU time. A high-priority process is called less "nice" |
| `N` | Low priority (a "nice" process): it gets CPU time only after the higher-priority ones |

Other letters may follow the state (`s`, `l`, `+`); `man ps` explains them. Most processes
are sleeping (`S`) most of the time, which is normal.

`ps aux` shows **every process of every user**, with more columns:

```bash
ps aux | less
```

```text
$ ps aux
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root           1  1.0  0.0  24156 15508 ?        Ss   ...     0:00 /sbin/init
...
```

(`...` replaces the start time.) PID 1 appears as `/sbin/init`, the command it was started
with; on Mint `/sbin/init` is a link to systemd. The new columns (the book's Table 10-2):

| Header | Meaning |
|---|---|
| `USER` | The owner of the process |
| `%CPU` | CPU usage, in percent |
| `%MEM` | Memory usage, in percent |
| `VSZ` | Virtual memory size: memory reserved, much of it never used |
| `RSS` | Resident set size: the physical memory (RAM) the process is using, in kilobytes |
| `START` | When the process started; a date is shown for processes older than a day |

Options written without a dash, like `x` and `aux`, are **BSD style**: the Linux `ps` copies
the behavior of the `ps` from several Unix families, and a leading dash changes how it reads
the letters.

### Viewing Processes Dynamically with top

`ps` is a snapshot. `top` shows a continuously updated view (every three seconds), with the
busiest processes first:

```bash
top
```

The screen has two parts: a system summary at the top, then a table of processes sorted by
CPU use. On one current system the summary looked like this (the clock time is replaced by
`...`; your numbers will differ):

```text
top - ... up 6 min,  1 user,  load average: 0.01, 0.05, 0.02
Tasks: 100 total,   1 running,  99 sleeping,   0 stopped,   0 zombie
%Cpu(s):  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
MiB Mem :  31930.7 total,  30469.4 free,   1002.3 used,    772.1 buff/cache
MiB Swap:   8192.0 total,   8192.0 free,      0.0 used.  30928.4 avail Mem
```

The five summary rows (the book's Table 10-3):

| Row | Shows |
|---|---|
| 1 | The current time; **uptime**, the time since the machine was last started (here 6 minutes); the number of users logged in; and the **load average**: the number of processes waiting to run, averaged over the last 1, 5 and 15 minutes. Below 1.0 means the machine is not busy (on a computer with several cores, compare it with the number of cores) |
| 2 | `Tasks:` the number of processes, counted by state |
| 3 | `%Cpu(s):` how the CPU spends its time: `us` user processes (outside the kernel), `sy` system (kernel) processes, `ni` nice (low-priority) processes, `id` idle, `wa` waiting for input or output |
| 4 | `Mem:` how the physical RAM is used |
| 5 | `Swap:` how the swap space (virtual memory on disk) is used |

The two keys the book names: `h` shows the help screen, and `q` quits `top`. (`M` sorts the
list by memory use and `P` goes back to CPU.) Linux Mint also has a graphical System
Monitor, but `top` is faster and uses far fewer resources, which matters when the machine
is already slow.

### Controlling Processes

Start the test program:

```bash
sleep 300
```

The prompt does not come back. The shell is waiting for the program to finish, as it does
for every command you type; with `sleep 300` that would take five minutes. (The book's
`xlogo` would wait until you closed its window.)

### Interrupting a Process

While `sleep 300` is running, press **Ctrl-c** in the terminal:

```text
$ sleep 300
^C
$
```

`Ctrl-c` **interrupts** the program: it asks the program to end, and most command-line
programs do. The prompt returns at once.

### Putting a Process in the Background

The terminal has a **foreground** (the program you are talking to, or the prompt) and a
**background** (programs running behind it). An `&` at the end of a command starts it in the
background, and the prompt comes back at once:

```bash
sleep 300 &
ps
jobs
```

```text
$ sleep 300 &
[1] 3581
$ ps
    PID TTY          TIME CMD
   3568 pts/0    ...      bash
   3581 pts/0    ...      sleep
   3583 pts/0    ...      ps
$ jobs
[1]+  Running                 sleep 300 &
```

`[1] 3581` is the shell's **job control** talking: you started job number 1, and its PID is
3581. `ps` lists it, and `jobs` lists the jobs started from this terminal.

### Returning a Process to the Foreground

A background job does not listen to the keyboard, not even to `Ctrl-c`. To bring it back to
the foreground, use `fg` with a percent sign and the job number (a **jobspec**):

```bash
jobs
fg %1
```

```text
$ jobs
[1]+  Running                 sleep 300 &
$ fg %1
sleep 300
^C
$
```

`fg` prints the command it brought back, and the prompt is gone again until the job ends;
press `Ctrl-c` to end it. With only one job, plain `fg` works too: the jobspec is optional.

### Stopping (Pausing) a Process

**Ctrl-z** stops (pauses) the program in the foreground without ending it, and gives you the
prompt back:

```text
$ sleep 300
^Z
[1]+  Stopped                 sleep 300
$
```

A stopped process does nothing at all; `ps x` shows it with the state `T`. You can let it
continue in the **foreground** with `fg`, or in the **background** with `bg`:

```bash
bg %1
jobs
```

```text
$ bg %1
[1]+ sleep 300 &
$ jobs
[1]+  Running                 sleep 300 &
```

This is the fix for a graphical program you started without the `&`: press `Ctrl-z`, then
type `bg`, and you have your prompt back while the program keeps running. The book gives two
reasons to start graphical programs from the command line at all: a program may not be on
the desktop menus, and when a program fails to start, the terminal shows you its error
messages.

The job from the last example is still running in the background; the next section ends it.

### Signals

The `kill` command ends a process, the book's way:

```text
$ jobs -l
[1]+  3593 Running                 sleep 300 &
$ kill 3593
$
[1]+  Terminated              sleep 300
```

`jobs -l` lists the jobs with their PIDs. Use the PID your own machine shows, or the
jobspec: `kill %1` means the same process. The `Terminated` line appears the next time bash
shows a prompt, so you may need to press Enter once.

`kill` does not really "kill" anything: it sends the process a **signal**, one of the ways
the operating system talks to programs. You have used signals already: `Ctrl-c` makes the
terminal send the signal `INT` (interrupt) and `Ctrl-z` sends `TSTP` (terminal stop).
Programs listen for signals and may act on them, for example by saving their work before
they end.

### Sending Signals to Processes with kill

The syntax is `kill [-signal] PID...`. With no signal named, `kill` sends `TERM`. The signals
used most often (the book's Table 10-4):

| Number | Name | Meaning |
|---|---|---|
| 1 | `HUP` | Hangup: the controlling terminal "hung up" (closing a terminal window sends it to the program running in it). Many daemons take it as a request to reread their configuration |
| 2 | `INT` | Interrupt: the same as `Ctrl-c`. It usually ends the program |
| 9 | `KILL` | Special: it never reaches the program. The kernel ends the process at once, with no chance to clean up or save its work. Use it only when the other signals fail |
| 15 | `TERM` | Terminate: the default. A program that is still alive enough to receive signals ends |
| 18 | `CONT` | Continue a process stopped by `STOP` or `TSTP`; `bg` and `fg` send it |
| 19 | `STOP` | Pause the process. Like `KILL`, it never reaches the program, so it cannot be ignored |
| 20 | `TSTP` | Terminal stop: what `Ctrl-z` sends. Unlike `STOP`, the program receives it and may ignore it |

Signals may be written by number, by name, or by name with `SIG` in front. The book's
examples, each on a new test job:

```bash
sleep 300 &
kill -1 %1
sleep 300 &
kill -INT %1
sleep 300 &
kill -SIGINT %1
```

```text
$ sleep 300 &
[1] 3636
$ kill -1 %1
$
[1]+  Hangup                  sleep 300
$ sleep 300 &
[1] 3697
$ kill -INT %1
$
[1]+  Interrupt               sleep 300
$ sleep 300 &
[1] 3717
$ kill -SIGINT %1
$
[1]+  Interrupt               sleep 300
```

The shell's message names the signal that ended the job. Try `kill -9 %1` on another test
job: the message is `Killed`. To see every signal:

```bash
kill -l
```

```text
$ kill -l
 1) SIGHUP       2) SIGINT       3) SIGQUIT      4) SIGILL       5) SIGTRAP
 6) SIGABRT      7) SIGBUS       8) SIGFPE       9) SIGKILL     10) SIGUSR1
11) SIGSEGV     12) SIGUSR2     13) SIGPIPE     14) SIGALRM     15) SIGTERM
16) SIGSTKFLT   17) SIGCHLD     18) SIGCONT     19) SIGSTOP     20) SIGTSTP
...
```

Processes have owners, like files: you may send signals only to your own processes (the
superuser may signal any). Process 1 belongs to root:

```text
$ kill 1
bash: kill: (1) - Operation not permitted
```

Three more signals the system itself sends (the book's Table 10-5): `QUIT` (3), `SEGV` (11,
sent when a program uses memory it is not allowed to touch) and `WINCH` (28, sent when a
window changes size, so programs like `top` and `less` can redraw themselves).

### Sending Signals to Multiple Processes with killall

`killall` sends a signal to every process with a given name (or, with `-u user`, belonging
to a given user). The syntax is `killall [-u user] [-signal] name...`:

```bash
sleep 300 &
sleep 300 &
killall sleep
```

```text
$ sleep 300 &
[1] 3725
$ sleep 300 &
[2] 3727
$ killall sleep
[1]-  Terminated              sleep 300
$
[2]+  Terminated              sleep 300
```

Both jobs got `TERM`. (In the `jobs` list, `+` marks the current job and `-` the one before
it.) Type the name carefully: `killall` signals **every** process with that name that you are
allowed to signal, which means all of yours, in every terminal. As with `kill`, other users'
processes need superuser rights.

**What `killall bash` does not do.** An interactive shell, the one you type into, ignores
`TERM`, so plain `killall bash` does not close your terminals (it ends only bash scripts that
happen to be running). You can see the shell ignore the signal by sending `TERM` to your own
shell; `$$` is your shell's PID:

```text
$ kill $$
$
```

Nothing happens. Do **not** try `kill -9 $$` or `killall -9 bash`: `KILL` cannot be ignored,
so they close your shell, and with `killall`, every open terminal.

### Shutting Down the System

Shutting down ends every process in an orderly way and finishes the housekeeping (such as
writing all data to the disks) before the power goes off. Four commands do it: `halt`,
`poweroff`, `reboot` and `shutdown`. All of them need superuser rights, and all of them end
your session. For reading only:

```text
$ sudo reboot
$ sudo shutdown -h now
$ sudo shutdown -r now
```

`shutdown -h now` halts (powers off) the machine now, and `shutdown -r now` reboots it.
`shutdown` also takes a delay, as in `shutdown -r +10` (in ten minutes), and `shutdown -c`
cancels a planned shutdown. Once `shutdown` runs, a warning is sent to every logged-in user.
On a virtual machine, shutting down from inside is the clean way; closing the window and
choosing "power off" is like pulling the plug.

### More Process-Related Commands

The book's Table 10-6 lists a few more tools to play with:

```bash
pstree
pstree -p $$
vmstat 5
tload
```

- `pstree` draws the process list as a tree, showing which process started which. With
  `-p` it adds the PIDs, and `$$` (your shell's PID) starts the tree at your shell:

  ```text
  $ pstree -p $$
  bash(3568)───pstree(3756)
  ```

- `vmstat 5` prints memory, swap and disk activity every 5 seconds. Stop it with `Ctrl-c`.
- `tload` draws a graph of the system load in the terminal. Stop it with `Ctrl-c`.
- `xload`, the graphical version of `tload`, is in the same `x11-apps` package as `xlogo`,
  so it is not installed either.

## Common mistakes

| You type | What bash says | Fix |
|---|---|---|
| `xlogo` | `xlogo: command not found` (or a longer message naming the package to install) | Not installed on Mint; use `sleep 300` in its place |
| `fg %1` with no jobs | `bash: fg: %1: no such job` | `jobs` lists this terminal's jobs; a job started in another terminal belongs to that terminal |
| `kill 99999` | `bash: kill: (99999) - No such process` | The process already ended, or the PID is mistyped: check with `ps x` |
| `kill 1` | `bash: kill: (1) - Operation not permitted` | You may signal only your own processes |
| `Ctrl-c` while a job runs in the background | Nothing happens to the job | Background jobs ignore the keyboard: `fg %1` then `Ctrl-c`, or `kill %1` |
| `ps aux \| grep sleep` | One extra line: `grep sleep` itself | Expected: `grep` was running when `ps` took the snapshot |
| `kill -9` as the first try | The process is gone, with no chance to save its work | Send plain `kill` (`TERM`) first, wait a few seconds, use `-9` only if that fails |
| `top` | It fills the screen and keeps updating | Press `q` to quit |

## Check yourself

1. What is the difference between `Ctrl-c` and `Ctrl-z`?
   <details><summary>Answer</summary><code>Ctrl-c</code> sends <code>INT</code>, which normally ends
   the program. <code>Ctrl-z</code> sends <code>TSTP</code>, which only pauses it: the job stays
   in the <code>jobs</code> list as Stopped, and <code>fg</code> or <code>bg</code> lets it
   continue.</details>
2. You type `sleep 300 &` and see `[1] 3581`. What are the two numbers?
   <details><summary>Answer</summary><code>1</code> is the job number, which belongs to this
   terminal (use it as <code>%1</code>). <code>3581</code> is the PID, the process ID the kernel
   gave the process; it is unique on the whole machine.</details>
3. Plain `ps` shows only two lines. Why, and how do you see everything?
   <details><summary>Answer</summary>With no options, <code>ps</code> lists only the processes of
   the current terminal session: your shell and <code>ps</code> itself. <code>ps x</code> shows
   all of your processes, and <code>ps aux</code> shows every process of every user.</details>
4. Why should `kill -9` be your last resort?
   <details><summary>Answer</summary>Signal 9 never reaches the program: the kernel ends the
   process at once, so it cannot clean up or save its work. <code>TERM</code> (plain
   <code>kill</code>) lets a program finish properly.</details>
5. Why does `killall bash` leave your terminal open, while `killall sleep` ends your `sleep`
   jobs?
   <details><summary>Answer</summary><code>killall</code> sends <code>TERM</code> by default.
   <code>sleep</code> ends when it receives it, but an interactive bash shell ignores
   <code>TERM</code>. Only <code>KILL</code> (signal 9), which cannot be ignored, would close
   it.</details>
