# Chapter 7: Seeing the World as the Shell Sees It

*The Linux Command Line* (TLCL), chapter 7. The book is free: https://linuxcommand.org/tlcl.php

## What you will learn

- When you press Enter, bash rewrites your command line before it runs anything. This is
  called **expansion**: bash fills in wildcards, `~`, braces, variables, arithmetic and the
  output of other commands, and the command sees only the result.
- There are six kinds of expansion: pathname (wildcards), tilde, arithmetic, brace,
  parameter (variables) and command substitution.
- Unquoted text is split into words at spaces, tabs and newlines (**word splitting**), which
  is why a file name with a space in it causes trouble.
- **Quoting** controls expansion: double quotes stop most of it, single quotes stop all of
  it, and a backslash stops exactly one character.
- `echo`, the one new command, shows you what bash did to your line: put it in front of a
  command and you see the arguments the command would receive.

## Files in this folder

This chapter has no scripts and no data files. The book's examples are commands you type at
the prompt; they are all below, section by section, with what you should see.

## The book's examples

**Set up a practice folder that looks like the book's home directory**, so the examples
print what the book prints. The book's home holds seven folders and the file
`ls-output.txt` from chapter 6; this makes the same thing inside `~/playground`:

```bash
mkdir -p ~/playground/home_like
cd ~/playground/home_like
mkdir Desktop Documents Music Pictures Public Templates Videos
ls -l /usr/bin > ls-output.txt
ls
```

```text
$ ls
Desktop  Documents  ls-output.txt  Music  Pictures  Public  Templates  Videos
```

Stay in this folder for the whole chapter unless a section says otherwise. In the output
below, `student` stands for your user name.

### Expansion

`echo` prints its arguments, and nothing else:

```bash
echo this is a test
echo *
```

```text
$ echo this is a test
this is a test
$ echo *
Desktop Documents ls-output.txt Music Pictures Public Templates Videos
```

Why didn't `echo` print a star? Because it never received one. When you pressed Enter, bash
replaced `*` with the names in the current folder, and then ran `echo` with those eight
names as its arguments. Every command works this way: the shell does the expanding, not the
command.

### Pathname Expansion

The mechanism that makes wildcards work is called **pathname expansion**. Each of these is a
pattern that bash turns into the matching names:

```bash
echo D*
echo *s
echo [[:upper:]]*
echo /usr/*/share
```

```text
$ echo D*
Desktop Documents
$ echo *s
Documents Pictures Templates Videos
$ echo [[:upper:]]*
Desktop Documents Music Pictures Public Templates Videos
$ echo /usr/*/share
/usr/local/share
```

- `D*`: names that start with D. `*s`: names that end with s.
- `[[:upper:]]*`: names whose first character is an uppercase letter, so `ls-output.txt`
  is left out.
- `/usr/*/share`: a wildcard can sit in the middle of a path. The book's machine had two
  matches; a current Mint system usually has only `/usr/local/share`.

When **nothing** matches, bash leaves the pattern as you typed it, and the command receives
the pattern itself:

```text
$ echo *.zzz
*.zzz
$ ls *.zzz
ls: cannot access '*.zzz': No such file or directory
```

That is where the familiar `ls` error comes from: `ls` was asked for a file literally named
`*.zzz`.

### Pathname Expansion of Hidden Files

Names that begin with a dot are **hidden**, and `*` skips them. Make two hidden files to
experiment on (the second name starts with two dots):

```bash
touch .hidden ..backup
echo *
echo .*
```

```text
$ echo *
Desktop Documents ls-output.txt Music Pictures Public Templates Videos
$ echo .*
..backup .hidden
```

**Here a current system differs from the book.** The book warns that `.*` also matches `.`
(this folder) and `..` (the parent folder), so `echo .*` would print `. .. ..backup .hidden`,
and `ls -d .* | less` would list both of those special names along with the hidden files.
That was true when the book was written. Since bash 5.2 (Linux Mint 22 has it; `echo
$BASH_VERSION` shows yours), an option named `globskipdots` is on by default, and a pattern
never matches `.` or `..`. So on your system `.*` lists just the hidden names:

```bash
ls -d .* | less
```

The book's other two answers still work and are worth knowing:

```bash
echo .[!.]*
ls -A
```

```text
$ echo .[!.]*
.hidden
```

- `.[!.]*` means "a dot, then one character that is **not** a dot, then anything". It
  matches most hidden names, but not names that start with two dots, such as `..backup`.
- `ls -A` ("almost all") lists every name, hidden ones included, but leaves out `.` and
  `..`. Compare it with `ls -a`, which shows `.` and `..` too.

Try this:

- Turn the option off to see the book's behavior, then turn it back on:
  `shopt -u globskipdots`, `echo .*`, `shopt -s globskipdots`.

### Tilde Expansion

At the start of a word, `~` expands to your home directory, and `~name` to the home of the
user `name`:

```bash
echo ~
echo ~root
echo ~foo
```

```text
$ echo ~
/home/student
$ echo ~root
/root
$ echo ~foo
~foo
```

`root` exists on every system, so `~root` becomes its home, `/root`. There is no user named
`foo` on your machine, so bash leaves `~foo` as it is (on the book's machine, which had a
user `foo`, it became `/home/foo`).

### Arithmetic Expansion

`$((expression))` does arithmetic, so the prompt works as a calculator. It handles whole
numbers only (integers, no decimals). The operators (the book's Table 7-1):

| Operator | Meaning |
|---|---|
| `+` `-` `*` | Add, subtract, multiply |
| `/` | Divide; the result is a whole number, the remainder is dropped |
| `%` | Modulo: the remainder of a division |
| `**` | Exponent (power) |

```bash
echo $((2 + 2))
echo $(($((5**2)) * 3))
echo $(((5**2) * 3))
echo Five divided by two equals $((5/2))
echo with $((5%2)) left over.
```

```text
$ echo $((2 + 2))
4
$ echo $(($((5**2)) * 3))
75
$ echo $(((5**2) * 3))
75
$ echo Five divided by two equals $((5/2))
Five divided by two equals 2
$ echo with $((5%2)) left over.
with 1 left over.
```

Spaces inside `$(( ))` do not matter. The second line nests one expansion inside another
(5 squared, then times 3); the third does the same with plain parentheses for grouping
inside a single expansion. `5/2` is 2, not 2.5, and `5%2` gives back the remainder, 1.
Chapter 34 covers arithmetic in depth.

### Brace Expansion

Brace expansion builds several pieces of text from one pattern. The pattern can have a
**preamble** (text before the braces) and a **postscript** (text after), and inside the
braces either a comma-separated list or a range written with `..`:

```bash
echo Front-{A,B,C}-Back
echo Number_{1..5}
echo {01..15}
echo {001..15}
echo {Z..A}
echo a{A{1,2},B{3,4}}b
```

```text
$ echo Front-{A,B,C}-Back
Front-A-Back Front-B-Back Front-C-Back
$ echo Number_{1..5}
Number_1 Number_2 Number_3 Number_4 Number_5
$ echo {01..15}
01 02 03 04 05 06 07 08 09 10 11 12 13 14 15
$ echo {001..15}
001 002 003 004 005 006 007 008 009 010 011 012 013 014 015
$ echo {Z..A}
Z Y X W V U T S R Q P O N M L K J I H G F E D C B A
$ echo a{A{1,2},B{3,4}}b
aA1b aA2b aB3b aB4b
```

A leading zero pads every number to the same width, a range can run backwards, and braces
can be nested. The pattern may not contain an unquoted space: `echo {a, b}` prints
`{a, b}` unchanged.

The result is plain text, so the names do not have to exist yet. That makes brace expansion
the perfect partner for `mkdir`. The book's photographer wants one folder per month,
named so they sort in order:

```bash
mkdir Photos
cd Photos
mkdir {2007..2009}-{01..12}
ls
```

```text
$ ls
2007-01  2007-05  2007-09  2008-01  2008-05  2008-09  2009-01  2009-05  2009-09
2007-02  2007-06  2007-10  2008-02  2008-06  2008-10  2009-02  2009-06  2009-10
2007-03  2007-07  2007-11  2008-03  2008-07  2008-11  2009-03  2009-07  2009-11
2007-04  2007-08  2007-12  2008-04  2008-08  2008-12  2009-04  2009-08  2009-12
```

One command made 36 folders: 3 years times 12 months. (The number of columns depends on the
width of your terminal window.) Go back up before the next section:

```bash
cd ..
```

Try this:

- Put `echo` in front first to see what a command will receive: `echo mkdir {2007..2009}-{01..12}`.

### Parameter Expansion

A **variable** is a name the shell keeps a small piece of text under. A `$` in front of the
name asks for its value:

```bash
echo $USER
printenv | less
echo $SUER
```

```text
$ echo $USER
student
$ echo $SUER

```

`printenv | less` lists every variable in your environment (chapter 11 explains them; `q`
quits). The last line is the trap: `$SUER` is a misspelling of `$USER`. A wildcard typo
leaves the pattern on the screen, but a variable typo **expands to nothing**, with no error
message at all.

### Command Substitution

`$(command)` runs the command and puts its output in its place on the line:

```bash
echo $(ls)
ls -l $(which cp)
file $(ls -d /usr/bin/* | grep zip)
ls -l `which cp`
```

```text
$ echo $(ls)
Desktop Documents ls-output.txt Music Photos Pictures Public Templates Videos
$ ls -l $(which cp)
-rwxr-xr-x 1 root root ... /usr/bin/cp
```

(Here `...` stands for the size and date.) In the second line, `which cp` runs first and
prints `/usr/bin/cp` (the book's older system printed `/bin/cp`); that path becomes the
argument of `ls -l`, so you get the listing of `cp` without knowing where it lives.

The third line puts a whole pipeline inside: the names in `/usr/bin` that contain `zip`
become the list of files that `file` describes. Part of the output on one current system
(yours depends on what is installed):

```text
$ file $(ls -d /usr/bin/* | grep zip)
/usr/bin/gunzip:     POSIX shell script, ASCII text executable
/usr/bin/gzip:       ELF 64-bit LSB pie executable, x86-64, version 1 (SYSV), ...
/usr/bin/streamzip:  Perl script text executable
/usr/bin/zipdetails: Perl script text executable
```

The last line uses the older form of command substitution, **backquotes** (the key left of
1). It does the same thing; you will meet it in old scripts, but write `$( )` in your own.

### Quoting

Two lines that do not do what you meant:

```bash
echo this is a     test
echo The total is $100.00
```

```text
$ echo this is a     test
this is a test
$ echo The total is $100.00
The total is 00.00
```

- **Word splitting** removed the extra spaces: unquoted spaces only separate words, so
  `echo` received four arguments and printed them with one space between each.
- **Parameter expansion** saw `$1` and replaced it with its value, which is empty. (`$1` is
  a special variable that holds a script's first argument; at the prompt it holds nothing.)

**Quoting** is how you switch off the expansions you do not want.

### Double Quotes

Inside double quotes, every special character loses its meaning except three: `$`, `\`
(backslash) and the backquote. So word splitting, pathname expansion, tilde expansion and
brace expansion stop, while parameter expansion, arithmetic expansion and command
substitution still happen.

The book's example is a file named `two words.txt`. Make it first (`touch` creates an empty
file), then try to list it:

```bash
touch "two words.txt"
ls -l two words.txt
ls -l "two words.txt"
mv "two words.txt" two_words.txt
```

```text
$ ls -l two words.txt
ls: cannot access 'two': No such file or directory
ls: cannot access 'words.txt': No such file or directory
$ ls -l "two words.txt"
-rw-rw-r-- 1 student student 0 ... 'two words.txt'
```

Without quotes, word splitting made two arguments, `two` and `words.txt`, and `ls` looked for
two files. With quotes it is one argument. A current `ls` prints a name with a space inside
single quotes, as shown; the quotes are not part of the name. The `mv` line repairs the name
for good, so you never need the quotes again.

The three expansions that survive double quotes, and the spaces that survive with them:

```bash
echo "$USER $((2+2))"
echo "this is a     test"
```

```text
$ echo "$USER $((2+2))"
student 4
$ echo "this is a     test"
this is a     test
```

Newlines count as word separators too, which changes what command substitution gives you.
The book shows it with `cal`, which prints a calendar:

```bash
echo $(cal)
echo "$(cal)"
```

Unquoted, the calendar collapses into one line of words; quoted, it keeps its shape. If bash
answers `cal: command not found`, the program is not installed on your machine (installing
it needs administrator rights). The same effect with a command you have, in the practice
folder (`ls` prints one name per line when its output goes into a pipe or a substitution):

```bash
echo $(ls)
echo "$(ls)"
```

```text
$ echo $(ls)
Desktop Documents ls-output.txt Music Photos Pictures Public Templates two_words.txt Videos
$ echo "$(ls)"
Desktop
Documents
ls-output.txt
Music
Photos
Pictures
Public
Templates
two_words.txt
Videos
```

Unquoted, the output of `ls` was split into ten separate arguments. Quoted, it stayed one
argument, newlines included.

### Single Quotes

Single quotes stop **every** expansion. The book's comparison, the same text at three levels
of quoting:

```bash
echo text ~/*.txt {a,b} $(echo foo) $((2+2)) $USER
echo "text ~/*.txt {a,b} $(echo foo) $((2+2)) $USER"
echo 'text ~/*.txt {a,b} $(echo foo) $((2+2)) $USER'
```

```text
$ echo text ~/*.txt {a,b} $(echo foo) $((2+2)) $USER
text /home/student/*.txt a b foo 4 student
$ echo "text ~/*.txt {a,b} $(echo foo) $((2+2)) $USER"
text ~/*.txt {a,b} foo 4 student
$ echo 'text ~/*.txt {a,b} $(echo foo) $((2+2)) $USER'
text ~/*.txt {a,b} $(echo foo) $((2+2)) $USER
```

- **No quotes**: everything expands. `~/*.txt` became `/home/student/*.txt`: the tilde
  expanded, but there is no `.txt` file directly in this home folder, so the wildcard was
  left as typed. If your home folder has `.txt` files, you see their full paths instead
  (the book's machine showed `/home/me/ls-output.txt`).
- **Double quotes**: the tilde, the wildcard and the braces stay literal; `$( )`, `$(( ))`
  and `$USER` still expand.
- **Single quotes**: nothing changes. `echo` receives exactly what you typed.

### Escaping Characters

A backslash in front of a character quotes just that one character. It is often used inside
double quotes to stop a single expansion:

```bash
echo "The balance for user $USER is: \$5.00"
```

```text
$ echo "The balance for user $USER is: \$5.00"
The balance for user student is: $5.00
```

`$USER` expanded; `\$` printed a plain dollar sign. A backslash also lets a special
character be part of a file name. The book renames a file called `bad&filename` (an
unquoted `&` would send a command to the background, chapter 10). Make the file first:

```bash
touch bad\&filename
mv bad\&filename good_filename
```

To print a backslash itself, write two. Inside single quotes a backslash is an ordinary
character:

```text
$ echo "a backslash: \\"
a backslash: \
$ echo 'inside single quotes \ is ordinary'
inside single quotes \ is ordinary
```

### Backslash Escape Sequences

A backslash followed by a letter can also stand for a **control code**, a special
character with no key of its own:

| Sequence | Meaning |
|---|---|
| `\a` | Bell (an alert: the computer beeps) |
| `\b` | Backspace |
| `\n` | Newline |
| `\r` | Carriage return |
| `\t` | Tab |

`echo` turns these on only with the `-e` option, or inside `$' '`. The book's countdown
timer waits 10 seconds (`sleep 10`), then prints a message and rings the bell (`;`
separates two commands on one line):

```bash
sleep 10; echo -e "Time's up\a"
sleep 10; echo "Time's up" $'\a'
```

Whether you hear a beep depends on your terminal's settings. A tab and a newline are easier
to see:

```text
$ echo -e "Name\tGrade\nAda\t95"
Name    Grade
Ada     95
$ echo "Name\tGrade"
Name\tGrade
```

Without `-e`, bash's `echo` prints the backslashes as they are.

## Common mistakes

| You type | What bash says | Fix |
|---|---|---|
| `ls -l two words.txt` | `ls: cannot access 'two': No such file or directory` and the same for `'words.txt'` | Quote the name: `ls -l "two words.txt"` |
| `echo The total is $100.00` | `The total is 00.00` | Stop the `$`: `\$100.00` or `'$100.00'` |
| `echo $(2+2)` | `bash: 2+2: command not found` | One pair of parentheses runs a command; arithmetic needs two: `$((2+2))` |
| `echo 'Hello $USER'` | `Hello $USER` | Single quotes stop every expansion; use double quotes: `"Hello $USER"` |
| `echo {a, b}` | `{a, b}` | No spaces inside the braces: `{a,b}` |
| `ls *.zzz` (nothing matches) | `ls: cannot access '*.zzz': No such file or directory` | bash passed the pattern unchanged; check the names with `ls` |
| `echo $SUER` (typo) | An empty line, no message | Check the spelling; `echo` the line first |
| `echo "Wow!Great"` | `bash: !Great: event not found` | `!` starts a history expansion (chapter 8); use single quotes: `echo 'Wow!Great'` |
| `echo "A\tB"` | `A\tB` | `echo -e "A\tB"` turns on the escape sequences |

## Check yourself

1. Why does `echo *` print file names instead of a star?
   <details><summary>Answer</summary>Bash expands <code>*</code> into the matching names before it
   runs the command, so <code>echo</code> receives the names as its arguments and never sees the
   star.</details>
2. What does `echo $((7/2))` print, and why?
   <details><summary>Answer</summary><code>3</code>. Arithmetic expansion works with whole numbers
   only, so division drops the remainder. <code>$((7%2))</code> gives the remainder, 1.</details>
3. What do double quotes stop, and what do they let through?
   <details><summary>Answer</summary>They stop word splitting, wildcards, tilde expansion and
   brace expansion. They let through parameter expansion (<code>$USER</code>), arithmetic
   expansion (<code>$(( ))</code>) and command substitution (<code>$( )</code>), and the backslash
   still escapes.</details>
4. Which folders does `mkdir {red,blue}-{1,2}` create? Check with `echo` before you run it.
   <details><summary>Answer</summary>Four: <code>red-1 red-2 blue-1 blue-2</code>. Brace expansion
   combines every item of the first list with every item of the second.</details>
5. The book says `echo .*` includes `.` and `..`. Does it on your system?
   <details><summary>Answer</summary>No, if your bash is version 5.2 or newer (Mint 22 is):
   the <code>globskipdots</code> option, on by default, keeps patterns from matching
   <code>.</code> and <code>..</code>. <code>ls -a</code> still shows them.</details>
