# Chapter 11: The Environment

*The Linux Command Line* (TLCL), chapter 11. The book is free: https://linuxcommand.org/tlcl.php

## What you will learn

- The shell keeps facts about your session in **variables**: `HOME`, `USER`, `PATH` and many
  more. Together with your aliases they make up the **environment**.
- How to look at it: `printenv` lists the environment variables, `set` adds the shell's own
  variables, `echo $NAME` prints one value, and `alias` lists the aliases.
- `export` hands a variable on to every program the shell starts; a variable that is not
  exported stays inside the shell.
- When bash starts it reads **startup files**. A terminal window reads `~/.bashrc`; a login
  reads `~/.profile` on Linux Mint, and that file reads `~/.bashrc` too.
- How to make a setting permanent the safe way: back up `~/.bashrc`, add your lines with a
  text editor, then reload the file with `source ~/.bashrc`.

## Files in this folder

This chapter has no scripts. The book's examples are commands you type at the prompt,
explained below. The book also prints two startup-file listings; they are here as text files.

| File | Book name | What it shows |
|---|---|---|
| `book_01_bash_profile.txt` | `.bash_profile` (section "What's in a Startup File?") | A typical login startup file: read `~/.bashrc` if it exists, add `~/bin` to `PATH`, export `PATH` |
| `book_02_bashrc_additions.txt` | the additions of Table 11-4 (section "Using a Text Editor") | Five lines the book adds to the bottom of `~/.bashrc`: a umask, two history settings, two aliases, with the book's comments |

Both files start with a block of comment lines (each begins with `#`) that says where the
listing comes from. The book's own lines start after the line of dashes, `# ----...`, and
they are exactly as printed. Neither file is a script to run: read them with `less`, and add
the second one's lines to your `~/.bashrc` only after the backup step shown below.

## The book's examples

Run these in a terminal window. Your user name appears wherever this guide shows `student`.
Nothing here needs `sudo`; the only file you change is your own `~/.bashrc`, and only after
you have made a backup.

### What is Stored in the Environment?

No commands. The shell stores two kinds of variable: **shell variables**, which bash sets up
for its own bookkeeping, and **environment variables**, everything else. It also stores your
**aliases** (chapter 5) and **shell functions** (small scripts kept in the shell, Part 4 of
the book). The book says that in bash the two kinds of variable are "largely
indistinguishable". In practice the difference that shows is whether a variable is
**exported** (see "Examining The Environment").

### Examining The Environment

```bash
printenv | less     # every environment variable, a page at a time (q quits)
printenv USER       # the value of one environment variable
set | less          # shell AND environment variables, sorted, plus shell functions
echo $HOME          # any variable's value, through parameter expansion (chapter 7)
alias               # the aliases: neither set nor printenv shows them
```

Each line of `printenv` has the form `NAME=value`. The start of the list on Mint looks like
this (trimmed; yours is longer and in another order):

```text
SHELL=/bin/bash
PWD=/home/student
LOGNAME=student
HOME=/home/student
LANG=en_US.UTF-8
USER=student
TERM=xterm-256color
```

`printenv USER` prints only the value, `student`, and so does `echo $USER`. The `$` is what
asks for the value: `echo USER` prints the word `USER`. The `|` sends the long list into
`less` so you can page through it (pipelines are chapter 6). `set` sorts its list, and it
is longer, because it adds the variables that stay inside the shell and every shell
function.

`alias` on a new Mint account prints these, among others:

```text
alias l='ls -CF'
alias la='ls -A'
alias ll='ls -alF'
alias ls='ls --color=auto'
```

**A correction to the slides.** The book calls the variables bash sets for itself "shell
variables", and a slide puts `PWD`, `OLDPWD`, `HOME` and `SHLVL` in that group. But bash
exports all four, so `printenv` lists them. Whether `printenv` shows a variable depends only
on whether it is exported, not on who set it:

```bash
printenv PWD HOME SHLVL    # all three print: they are exported
printenv OLDPWD            # nothing yet in a new terminal: exported, but still empty
cd /tmp
cd
printenv OLDPWD            # now /tmp, the folder you were in before
printenv PS1               # nothing: your prompt is a shell variable, not exported
echo "$PS1"                # but the shell has it
```

```text
/home/student
/home/student
1
```

That is the output of the first line. `SHLVL` counts how many shells deep you are: type
`bash`, run `echo $SHLVL` (it went up by one), then `exit`.

What `export` does, shown at the prompt (not in the book):

```bash
greeting=hello
printenv greeting                             # nothing: a shell variable only
bash -c 'echo "the child sees: [$greeting]"'  # a child process does not get it
export greeting
printenv greeting                             # hello
bash -c 'echo "the child sees: [$greeting]"'  # now the child gets it
```

```text
the child sees: []
hello
the child sees: [hello]
```

`printenv` and `bash -c` are separate programs, children of your shell. A child receives a
copy of the exported variables only. No spaces are allowed around `=`.

### Some Interesting Variables

The book's Table 11-1, with the command to see each one:

| Variable | Holds | Try |
|---|---|---|
| `DISPLAY` | The graphical display, usually `:0` (may be missing on a Wayland desktop) | `echo $DISPLAY` |
| `EDITOR` | The editor other programs open for you | `echo $EDITOR` |
| `SHELL` | Your login shell, `/bin/bash` | `echo $SHELL` |
| `HOME` | Your home directory, `/home/student` | `echo $HOME` |
| `LANG` | Your language, character set and sort order, such as `en_US.UTF-8` | `echo $LANG` |
| `OLDPWD` | The previous working directory (what `cd -` returns to) | `echo $OLDPWD` |
| `PAGER` | The program used to page output, such as `less` | `echo $PAGER` |
| `PATH` | The folders bash searches for commands, separated by colons | `echo $PATH` |
| `PS1` | "Prompt string 1": the text of your prompt | `echo "$PS1"` |
| `PWD` | The current working directory | `echo $PWD` |
| `TERM` | The terminal type, such as `xterm-256color` | `echo $TERM` |
| `TZ` | Your time zone, if it is set this way | `echo $TZ` |
| `USER` | Your user name | `echo $USER` |

`EDITOR`, `PAGER` and `TZ` are often not set on Mint, so `echo` prints an empty line. That
is normal: the book says the list varies by distribution.

`PATH` deserves a closer look. On a new Mint account it looks like this:

```text
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games
```

Bash searches the folders from left to right and runs the first match. The folder you are in
is not on the list, on purpose, which is why a script in the current folder needs `./` in
front of its name (chapter 24).

### How Is The Environment Established?

When bash starts it reads **startup files**. Which ones depends on the kind of session:

| Session | When you get one | Startup files read (Tables 11-2 and 11-3) |
|---|---|---|
| Login shell | You typed a user name and password: a virtual console (Ctrl-Alt-F3), an `ssh` login | `/etc/profile`, then the **first** of `~/.bash_profile`, `~/.bash_login`, `~/.profile` that exists |
| Non-login shell | You opened a terminal window on the desktop | `/etc/bash.bashrc`, then `~/.bashrc` |

The files in `/etc` are global: they apply to every user. The ones in your home directory are
yours. A non-login shell also inherits the environment of its parent process. The names
start with a dot (hidden files), so `ls` needs `-a`:

```bash
ls -a ~                               # look for .bashrc and .profile
ls -l /etc/profile /etc/bash.bashrc   # the global ones (owned by root: read, do not edit)
```

On Mint you find `.bashrc` and `.profile` in your home directory, and no `.bash_profile`.
Do not create a `.bash_profile`: bash would read it instead of `.profile` and skip
`.profile` from then on.

### What's in a Startup File?

The book's listing is `book_01_bash_profile.txt`. Look at it, then at the file Mint uses for
the same job:

```bash
less book_01_bash_profile.txt     # q quits
less ~/.profile                   # your own login startup file, to compare
```

The book's lines (below the dashes in the file):

```bash
# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
        . ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/bin
export PATH
```

| Line | What it does |
|---|---|
| `# .bash_profile` | A comment: bash skips every line that starts with `#`. This one names the file. |
| `# Get the aliases and functions` | A comment that says what the next three lines are for. |
| `if [ -f ~/.bashrc ]; then` | An *if compound command* (chapter 27). The book's translation: "If the file `~/.bashrc` exists, then". `-f` tests for a regular file. |
| `. ~/.bashrc` | The dot command reads `~/.bashrc` and runs its lines in this shell. `source` is the same command with a longer name. This is how a login shell gets your `.bashrc` settings too. |
| `fi` | Ends the `if` (it is `if` backwards). |
| `# User specific environment and startup programs` | A comment. |
| `PATH=$PATH:$HOME/bin` | The new `PATH` is the old one, a colon, then `/home/student/bin`: your own `bin` folder is added to the **end** of the search list. |
| `export PATH` | Makes the new `PATH` available to every program this shell starts (its child processes). |

The `PATH=$PATH:...` line works by parameter expansion: bash replaces `$PATH` with the old
value before it assigns. The book shows the same trick with a variable of its own:

```bash
foo="This is some "
echo $foo
foo=$foo"text."
echo $foo
```

```text
This is some
This is some text.
```

Mint's `~/.profile` does the same two jobs in its own words: if bash is the shell reading it
and `~/.bashrc` exists, it reads `~/.bashrc`; and if `~/bin` exists, it puts it at the
**front** of `PATH` (`PATH="$HOME/bin:$PATH"`), where the book puts it at the end. Only the
folders that exist when you log in are added, so after you create `~/bin`, log out and back
in.

Do not type `PATH=...` lines at the prompt to experiment: a typo such as `PATH=$HOME/bin`
replaces the whole list, and every command says `command not found` until you close the
terminal.

### Modifying the Environment

No commands. The book's rule for which file to change ("Which Files Should We Modify?"):

| Change | File on Mint | File in the book (CentOS) |
|---|---|---|
| Add a folder to `PATH`, define a new environment variable | `~/.profile` | `~/.bash_profile` |
| Everything else: aliases, prompt, history settings | `~/.bashrc` | `~/.bashrc` |

Leave the files in `/etc` alone. They set the defaults for every user, belong to `root`, and
only the system administrator changes them.

### Text Editors

No commands. A **text editor** edits plain text, the kind every configuration file is made
of. Graphical editors: `gedit` (GNOME), `kate` (KDE); Mint's is `xed`. Text-based editors,
which run inside the terminal: `nano` (simple, shows its keys at the bottom), `vi` (on every
Unix-like system; it is chapter 12) and `emacs` (large, rarely installed by default).

### Using a Text Editor

An editor takes the name of the file to edit; if the file does not exist, it starts a new
one. The book's example uses `gedit`. Mint's graphical editor is `xed`, used the same way.
Try it on a practice file, not on a startup file:

```bash
mkdir -p ~/playground
cd ~/playground
xed some_file        # book: gedit some_file. Close the window when you are done.
```

Now the real thing. First the book's "safe computing" step: a backup copy. `cp` overwrites
silently, so the order of the two names matters.

```bash
cd ~
cp .bashrc .bashrc.bak     # the backup
nano .bashrc               # open the file in nano
```

In `nano`, press PageDown (or the down arrow) until you reach the end of the file and type
the lines below. `Ctrl-o` then Enter saves ("write out"), and `Ctrl-x` exits. The `^X` you
see at the bottom of the screen means `Ctrl-x`.

The book adds five lines, then rewrites them with comments "to help explain things to the
humans". The commented version is `book_02_bashrc_additions.txt` (below the dashes):

```bash
# Change umask to make directory sharing easier
umask 0002

# Ignore duplicates in command history and increase
# history size to 1000 lines
export HISTCONTROL=ignoredups
export HISTSIZE=1000

# Add some helpful aliases
alias l.='ls -d .* --color=auto'
alias ll='ls -l --color=auto'
```

| Line | What it does (Table 11-4) |
|---|---|
| `umask 0002` | New files and folders get write permission for your group (chapter 9). On Mint a normal user's umask is usually 0002 already, so this changes nothing there. |
| `export HISTCONTROL=ignoredups` | The command history skips a command that repeats the one just before it. Mint's `.bashrc` sets `ignoreboth` higher up (which also skips commands that start with a space); this later line replaces it. |
| `export HISTSIZE=1000` | Keep the last 1000 commands in memory. The book says the usual default is 500; Mint's `.bashrc` already sets 1000. |
| `alias l.='ls -d .* --color=auto'` | A new command, `l.`, that lists only the names that begin with a dot (hidden files). `-d` lists a folder's name instead of its contents. |
| `alias ll='ls -l --color=auto'` | `ll` gives a long listing. Mint already has `alias ll='ls -alF'`; this later line replaces it, so `ll` stops showing hidden files. |
| the `#` lines | Comments. Bash skips them; they tell the next reader (you, later) what each line is for. |

The book notes that your system may already have some of these and that "duplicates won't
hurt anything": bash reads the file from top to bottom, and the last definition wins.

**Try the lines before you keep them.** `bash --rcfile` (not in the book) starts a new shell
that reads this file instead of your `~/.bashrc` (on Mint it still reads the global
`/etc/bash.bashrc` first, which sets your usual prompt). The top comment block is skipped
like any other comment. Run it in the chapter folder:

```bash
bash --rcfile book_02_bashrc_additions.txt
alias ll
umask
echo $HISTSIZE $HISTCONTROL
l.
exit
```

```text
alias ll='ls -l --color=auto'
0002
1000 ignoredups
```

`l.` lists the hidden names in the folder, if it has any (current bash no longer lists `.`
and `..` for `.*`). `exit` returns you to your normal shell, which never saw the lines.

**Keep them.** Either type them in `nano` as the book does, or append the whole file. Type
**two** `>` signs: `>>` adds to the end of a file (chapter 6), while one `>` would replace
your whole `.bashrc` with these lines.

```bash
cp ~/.bashrc ~/.bashrc.bak
cat book_02_bashrc_additions.txt >> ~/.bashrc
```

Never run the file as a script (`bash book_02_bashrc_additions.txt`): the script runs in a
child shell, and its umask, variables and aliases vanish the moment it ends. A child process
can never change the environment of the shell that started it.

### Why Comments Are Important

No new commands. Comment every change you make to a configuration file: in six months you
will not remember why a line is there. Files often hold lines that are **commented out**,
valid settings with a `#` in front so they are not used. Removing the `#` ("uncommenting")
turns the line on; adding one turns it off and keeps the text.

The book shows three aliases that Ubuntu 18.04 shipped commented out. Look for them in your
own file:

```bash
grep -A3 'some more ls aliases' ~/.bashrc     # the comment line and the 3 lines after it
```

```text
# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
```

On current Mint and Ubuntu the three aliases are already active (no `#` in front), which is
why `ll`, `la` and `l` work on a new account.

### Activating Our Changes

Bash reads `~/.bashrc` only when a shell starts, so the terminal you edited in still has the
old settings. Make it reread the file:

```bash
source ~/.bashrc     # the short form is: . ~/.bashrc
alias ll             # alias ll='ls -l --color=auto'
ll
```

Opening a new terminal window works too. To undo everything, put the backup back and reload:

```bash
cp ~/.bashrc.bak ~/.bashrc
source ~/.bashrc
```

`source` rereads the file but does not remove an alias the old file defined, so the cleanest
check after an undo is a new terminal window.

### Summing Up and Further Reading

```bash
man bash     # type /^INVOCATION and press Enter for the startup-file rules; q quits
```

## Common mistakes

| You type | What bash says | Fix |
|---|---|---|
| `echo PATH` | `PATH` (the word, not the value) | Put `$` in front: `echo $PATH` |
| `echo $home` | an empty line, and no error | Names are case sensitive: `echo $HOME` |
| `greeting = hello` | `bash: greeting: command not found` | No spaces around `=`: `greeting=hello` |
| `printenv greeting` after `greeting=hello` | nothing | It is a shell variable: `export greeting` |
| A new alias, in the terminal where you edited `~/.bashrc` | `bash: foo: command not found` | `source ~/.bashrc`, or open a new terminal |
| `bash book_02_bashrc_additions.txt` | nothing, and nothing changes | A script runs in a child shell. Append the lines to `~/.bashrc` and `source` it |
| `cat book_02_bashrc_additions.txt > ~/.bashrc` (one `>`) | nothing, but your `.bashrc` now holds only these lines | `cp ~/.bashrc.bak ~/.bashrc`; use `>>` to append |
| `PATH=$HOME/bin` at the prompt | then every command: `bash: ls: command not found` | Close the terminal and open a new one |
| Lines pasted from a file with Windows line endings | `$'\r': command not found` (with the file name and line number) each time a terminal opens | `sed -i 's/\r$//' ~/.bashrc` |
| A typo in `~/.bashrc` | error messages each time a terminal opens | `cp ~/.bashrc.bak ~/.bashrc`, open a new terminal, fix the line |

## Check yourself

1. What is the difference between `printenv` and `set`, and which command lists aliases?
   <details><summary>Answer</summary><code>printenv</code> lists only the environment
   (exported) variables. <code>set</code> lists the shell variables too, sorted, plus the shell
   functions. Neither shows aliases: only <code>alias</code> with no arguments lists
   them.</details>
2. `printenv PWD` prints your current folder, but `printenv PS1` prints nothing. Why?
   <details><summary>Answer</summary>Bash exports <code>PWD</code>, so it is in the environment
   that <code>printenv</code> (a separate program) receives. <code>PS1</code> is a shell variable
   that is not exported: the shell has it (<code>echo "$PS1"</code> shows it), but child
   programs do not.</details>
3. In `book_01_bash_profile.txt`, what do `PATH=$PATH:$HOME/bin` and `export PATH` each do?
   <details><summary>Answer</summary>The first replaces <code>PATH</code> with its old value plus
   <code>:/home/you/bin</code>, so your own <code>bin</code> folder is searched last. The second
   makes the new <code>PATH</code> available to every program the shell starts.</details>
4. You added an alias to `~/.bashrc`, saved, and typed the alias. Bash says `command not
   found`. What happened, and what are two fixes?
   <details><summary>Answer</summary>The running shell read <code>~/.bashrc</code> when it started,
   before your edit. Run <code>source ~/.bashrc</code> to make it reread the file, or open a new
   terminal window.</details>
5. Why does running `bash book_02_bashrc_additions.txt` leave your shell unchanged?
   <details><summary>Answer</summary>It starts a child shell that runs the lines and then exits.
   The umask, variables and aliases lived in that child and vanish with it; a child process
   cannot change its parent's environment.</details>
