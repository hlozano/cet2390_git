# Chapter 6: Redirection

*The Linux Command Line* (TLCL), chapter 6. The book is free: https://linuxcommand.org/tlcl.php

## What you will learn

- Every command has three **streams**: standard input (stream 0, the keyboard), standard
  output (stream 1, the results) and standard error (stream 2, the error messages). Both
  output streams go to the screen unless you say otherwise.
- **Redirection** points a stream at a file: `>` writes a file from scratch, `>>` adds to the
  end of it, `2>` catches the error messages, and `<` reads a file as the input.
- `>` empties its file **before** the command starts. That one fact explains most lost files.
- `/dev/null` throws away whatever is sent to it.
- A **pipe** `|` connects the output of one command to the input of the next, so small
  programs called **filters** (`sort`, `uniq`, `wc`, `grep`, `head`, `tail`, `tee`) combine
  into one tool.

## Files in this folder

Chapter 6 has no scripts: every example in it is a command you type at the prompt, and all of
them are explained below. The folder holds one data file from the book:

| File | Book name | What it shows |
|---|---|---|
| `book_distros.txt` | `distros.txt` | The book's sample data (it first appears in chapter 20): 16 lines, one Linux release per line, three fields separated by tabs (a name, a version number and a release date). Chapter 6 itself does not use it; this guide uses it in the `<`, `uniq`, `wc`, `grep` and `tee` sections, because a 16-line file is small enough to check every count by hand. |

## The book's examples

**Work in a practice folder.** `>` can overwrite a file without asking, so try this chapter
where nothing important lives, as the book does in chapter 4. Open a terminal, go to this
folder (`ch06_redirection`) in your copy of the repository, and copy the data file across:

```bash
mkdir -p ~/playground
cp book_distros.txt ~/playground/
cd ~/playground
```

The book's prompt `[me@linuxbox ~]$` is the same thing as your own prompt. In the output
below, `student` stands for your user name, and `...` stands for the date and time that
`ls -l` prints. Your sizes and counts will differ from the ones shown: they depend on how
many programs are installed on your machine.

### Standard Input, Output, and Error

A program's **results** go to standard output; its **error and status messages** go to
standard error. Both are connected to the screen, so they look the same until you redirect
one of them. This command produces one of each:

```bash
ls /etc/hostname /bin/usr
```

```text
$ ls /etc/hostname /bin/usr
ls: cannot access '/bin/usr': No such file or directory
/etc/hostname
```

The first line came from standard error (`/bin/usr` does not exist; the book uses this
mistyped name on purpose all through the chapter). The second line came from standard output.

### Redirecting Standard Output

`>` followed by a file name sends standard output to that file instead of the screen:

```bash
ls -l /usr/bin > ls-output.txt
ls -l ls-output.txt
less ls-output.txt
```

```text
$ ls -l /usr/bin > ls-output.txt
$ ls -l ls-output.txt
-rw-rw-r-- 1 student student 60603 ... ls-output.txt
```

The first command prints nothing: the listing went into the file. `ls` does not know or care;
the shell connected its standard output to the file before `ls` started. `less` shows the
listing (Space for the next page, `q` to quit).

Now the twist: the same redirection with the folder that does not exist.

```bash
ls -l /bin/usr > ls-output.txt
ls -l ls-output.txt
```

```text
$ ls -l /bin/usr > ls-output.txt
ls: cannot access '/bin/usr': No such file or directory
$ ls -l ls-output.txt
-rw-rw-r-- 1 student student 0 ... ls-output.txt
```

Two surprises, two reasons:

- The error still reached the screen, because `>` redirects only standard output, and the
  error travels on standard error.
- The file is now **0 bytes**. The shell opens the file named after `>` and empties it
  *before* it runs the command. `ls` then found nothing to list and wrote nothing to
  standard output, so the file stayed empty. The old listing is gone for good.

That second fact gives you a trick: `>` with no command in front of it empties a file, or
creates a new empty one.

```bash
> ls-output.txt
```

To **add** to the end of a file instead of starting over, use `>>`. If the file does not
exist, `>>` creates it, just like `>`:

```bash
ls -l /usr/bin >> ls-output.txt
ls -l /usr/bin >> ls-output.txt
ls -l /usr/bin >> ls-output.txt
ls -l ls-output.txt
```

```text
$ ls -l ls-output.txt
-rw-rw-r-- 1 student student 181809 ... ls-output.txt
```

Three listings, so the file is three times as large as one listing (60603 times 3 here).

Try this:

- Run `echo one > test.txt`, then `echo two > test.txt`, then `cat test.txt`. Predict what
  you will see. Then repeat with `>>` for the second line.

### Redirecting Standard Error

There is no special symbol for standard error; you name it by its number, its **file
descriptor**. The shell numbers the three streams 0 (input), 1 (output) and 2 (error), and a
number written right in front of `>` redirects that stream. (`>` on its own means `1>`.)

```bash
ls -l /bin/usr 2> ls-error.txt
cat ls-error.txt
```

```text
$ ls -l /bin/usr 2> ls-error.txt
$ cat ls-error.txt
ls: cannot access '/bin/usr': No such file or directory
```

The screen stayed clean; the message is in the file. The `2` and the `>` must touch: with a
space, `2` becomes one more file name for `ls` to look for (see Common mistakes below).
`2>>` appends, just as `>>` does.

### Redirecting Standard Output and Standard Error to One File

To capture everything a command prints in one file, redirect both streams. The traditional
way works in every shell:

```bash
ls -l /bin/usr > ls-output.txt 2>&1
cat ls-output.txt
```

```text
$ ls -l /bin/usr > ls-output.txt 2>&1
$ cat ls-output.txt
ls: cannot access '/bin/usr': No such file or directory
```

Read it left to right, the way the shell does: `> ls-output.txt` points stream 1 at the
file; then `2>&1` points stream 2 at **wherever stream 1 points right now**, which is the
file. **The order matters.** Written the other way around, the errors still reach the screen:

```text
$ ls -l /bin/usr 2>&1 > ls-output.txt
ls: cannot access '/bin/usr': No such file or directory
```

Here `2>&1` ran first, while stream 1 still pointed at the screen, so stream 2 was pointed
at the screen too; only then did `> ls-output.txt` move stream 1 to the file.

Bash also has a shorter form, `&>`, for "both streams to this file", and `&>>` to append both:

```bash
ls -l /bin/usr &> ls-output.txt
ls -l /bin/usr &>> ls-output.txt
cat ls-output.txt
```

```text
$ cat ls-output.txt
ls: cannot access '/bin/usr': No such file or directory
ls: cannot access '/bin/usr': No such file or directory
```

The message is there twice: once from `&>` (which started the file over) and once from
`&>>` (which added to it). `&>` is a bash feature; a script that must run under a plainer
shell should use `> file 2>&1`.

### Disposing of Unwanted Output

`/dev/null` is a special file, often called the **bit bucket**: it accepts anything written
to it and keeps nothing. Sending error messages there hides them:

```bash
ls -l /bin/usr 2> /dev/null
```

Nothing at all appears. The three forms you will use:

| You write | You keep | You throw away |
|---|---|---|
| `cmd 2> /dev/null` | the results | the error messages |
| `cmd > /dev/null` | the error messages | the results |
| `cmd &> /dev/null` | nothing | both |

Throw away only messages you expect and understand: a command whose errors are hidden cannot
tell you what went wrong. (When someone says they sent your comments to `/dev/null`, now you
know what they mean.)

### Redirecting Standard Input

To see standard input at work, the book first introduces `cat`.

### cat - Concatenate Files

`cat` reads one or more files and copies them, one after another, to standard output:

```bash
cat ls-error.txt
```

`cat ls-output.txt` works too, but a long file scrolls past faster than you can read it;
for long files, `less` is the better choice.

Because `cat` takes several files, it can join them. The book's example is a large download
split into parts named `movie.mpeg.001`, `movie.mpeg.002` and so on. Three small text files
stand in for the parts here:

```bash
echo "part 1" > movie.mpeg.001
echo "part 2" > movie.mpeg.002
echo "part 3" > movie.mpeg.003
cat movie.mpeg.0* > movie.mpeg
cat movie.mpeg
```

```text
$ cat movie.mpeg
part 1
part 2
part 3
```

The shell expands `movie.mpeg.0*` into the matching names **in sorted order**, so the parts
are joined in the right order.

With **no** file name, `cat` reads standard input, which is the keyboard. It seems to hang,
but it is waiting for you to type:

```bash
cat
```

Type `The quick brown fox jumped over the lazy dog.` and press Enter: `cat` prints the line
back. Then press **Ctrl-d** (hold Ctrl, press d) at the start of an empty line. Ctrl-d means
"end of file": there is no more input, so `cat` stops and the prompt returns.

```text
$ cat
The quick brown fox jumped over the lazy dog.
The quick brown fox jumped over the lazy dog.
```

The first line is what you typed; the second is `cat`'s output. Redirect the output and you
have the world's simplest text editor:

```bash
cat > lazy_dog.txt
```

Type the same sentence, press Enter, then Ctrl-d. Now look at the file two ways:

```bash
cat lazy_dog.txt
cat < lazy_dog.txt
```

```text
$ cat lazy_dog.txt
The quick brown fox jumped over the lazy dog.
$ cat < lazy_dog.txt
The quick brown fox jumped over the lazy dog.
```

Same output, different mechanism. In the first line `cat` opens the file itself. In the
second, `<` tells the **shell** to open the file and connect it to standard input, so `cat`
just reads its input as usual and never learns the file's name. `wc -l` (counts lines, see
below) shows the difference, because it prints the file name when it knows it:

```bash
wc -l book_distros.txt
wc -l < book_distros.txt
```

```text
$ wc -l book_distros.txt
16 book_distros.txt
$ wc -l < book_distros.txt
16
```

### Pipelines

The pipe operator `|` connects the standard output of one command to the standard input of
the next. `less` reads standard input when it is given no file name, so it can page through
any command's output:

```bash
ls -l /usr/bin | less
```

No file is created: the data flows straight from `ls` into `less`. Press `q` to quit.

### The Difference Between > and |

`>` connects a command to a **file**; `|` connects a command to another **command**. The book
tells of an administrator who, working as the superuser (the all-powerful `root` account,
chapter 9), typed `cd /usr/bin` and then `ls > less`. He meant to page through a listing.
Instead, the shell created a file named `less`, which in `/usr/bin` meant overwriting the
`less` program itself with a list of names. A regular user could not do that damage: in
`/usr/bin` bash would only answer `bash: less: Permission denied`.

You can watch the same mistake safely in your practice folder, where it only creates a
harmless file:

```bash
ls > less
cat less
rm less
```

`cat less` shows the listing that `ls` wrote into the new file named `less`. The lesson:
`>` silently creates or overwrites files, so treat it with respect.

### Filters

A **filter** reads standard input, changes the data somehow, and writes the result to
standard output, so filters can be chained with pipes. The first one is `sort`:

```bash
ls /bin /usr/bin | sort | less
```

`ls` given two folders prints two lists, one per folder; `sort` turns them into one sorted
list.

On Linux Mint (and Ubuntu and other current systems) `/bin` is a **symbolic link** to
`/usr/bin` (`ls -ld /bin` shows `/bin -> usr/bin`), so the two folders are the same folder
and every name appears twice. When `ls` lists two folders, it also prints a heading line for
each (`/bin:` and `/usr/bin:`) and a blank line between them. Both facts matter for the
counts in the next sections.

### uniq - Report or Omit Repeated Lines

`uniq` removes repeated lines, but only lines that are **next to each other**, which is why
it almost always follows `sort`. `uniq -d` does the opposite: it shows only the lines that
were repeated.

```bash
ls /bin /usr/bin | sort | uniq | less
ls /bin /usr/bin | sort | uniq -d | less
```

On a current system the first list holds every program name once (plus the two headings
and the blank line), and the second holds every program name, because every name was listed
twice. The book's machine had separate `/bin` and `/usr/bin` folders, so its `uniq -d`
showed only the few names found in both.

The same idea on the data file: `cat` it twice into one stream, and `uniq` removes the
copies again.

```bash
cat book_distros.txt book_distros.txt | wc -l
cat book_distros.txt book_distros.txt | sort | uniq | wc -l
```

```text
$ cat book_distros.txt book_distros.txt | wc -l
32
$ cat book_distros.txt book_distros.txt | sort | uniq | wc -l
16
```

### wc - Print Line, Word, and Byte Counts

`wc` (word count) prints three numbers: lines, words and bytes. `wc -l` prints only the line
count, which makes it the standard way to count things at the end of a pipeline.

```bash
wc book_distros.txt
ls -l /usr/bin > ls-output.txt
wc ls-output.txt
```

```text
$ wc book_distros.txt
 16  48 343 book_distros.txt
$ ls -l /usr/bin > ls-output.txt
$ wc ls-output.txt
  906  8663 60603 ls-output.txt
```

16 lines and 48 words: three words (name, version, release date) on each line. The listing
(the book's example; the second line makes a fresh one, since the last sections left only
error messages in the file) has one line per program plus the `total` line at the top.

Now count the programs, one stage at a time. Run each line and read the number before you
add the next stage:

```bash
ls /usr/bin | wc -l
ls /bin /usr/bin | wc -l
ls /bin /usr/bin | sort | uniq | wc -l
```

```text
$ ls /usr/bin | wc -l
905
$ ls /bin /usr/bin | wc -l
1813
$ ls /bin /usr/bin | sort | uniq | wc -l
908
```

Your numbers will differ (a Mint desktop has far more programs than this machine), but the
arithmetic will not. If one folder holds N names, two listings of the same folder give
N + N + 3 lines (the 3 are the two headings and the blank line), and after `uniq` you are
left with N + 3. With `ls /usr/bin` alone there are no headings, so you get exactly N.

### grep - Print Lines Matching a Pattern

`grep pattern file` prints the lines that contain the pattern (for now, plain text; chapter
19 covers the advanced patterns called regular expressions). With no file name it reads
standard input, so it works in a pipeline:

```bash
ls /bin /usr/bin | sort | uniq | grep zip
```

```text
$ ls /bin /usr/bin | sort | uniq | grep zip
gunzip
gzip
streamzip
zipdetails
```

The list depends on what is installed; a Mint desktop shows more names, such as `bunzip2`
and `bzip2`. Every name that contains `zip` anywhere is printed.

Two options the book names, tried on the data file:

```bash
grep Ubuntu book_distros.txt | wc -l
grep student book_distros.txt | wc -l
grep -i student book_distros.txt | wc -l
grep -v Ubuntu book_distros.txt | wc -l
```

```text
$ grep Ubuntu book_distros.txt | wc -l
6
$ grep student book_distros.txt | wc -l
0
$ grep -i student book_distros.txt | wc -l
6
$ grep -v Ubuntu book_distros.txt | wc -l
10
```

- `grep` is case sensitive: `student` matches nothing, because the file says `Ubuntu`.
- `-i` ignores case, so `student` finds the 6 Ubuntu lines.
- `-v` inverts the match: it keeps the lines that do **not** contain the pattern
  (16 - 6 = 10).

### head / tail - Print First / Last Part of Files

`head` prints the first 10 lines of a file and `tail` the last 10; `-n` changes the number.

```bash
head -n 5 ls-output.txt
tail -n 5 ls-output.txt
```

On the listing from the last section, `head` shows the `total` line that `ls -l` prints first, then the first four programs;
`tail` shows the last five. Both work in pipelines too:

```bash
ls /usr/bin | tail -n 5
```

```text
$ ls /usr/bin | tail -n 5
zgrep
zipdetails
zless
zmore
znew
```

`tail -f` ("follow") keeps watching a file and prints new lines as they are added, until you
press **Ctrl-c**. The book watches the system log `/var/log/messages`. Mint has no file by
that name; its log (when there is one) is `/var/log/syslog`, and reading it may need extra
rights. You can see `tail -f` work just as well on a file of your own, with **two terminal
windows**. In the first:

```bash
cd ~/playground
echo "first line" > watch.txt
tail -f watch.txt
```

In the second:

```bash
cd ~/playground
echo "a new line" >> watch.txt
echo "another line" >> watch.txt
```

Each line appears in the first window the moment you add it. Press Ctrl-c in the first
window to stop `tail`.

### tee - Read from Stdin and Output to Stdout and Files

`tee` works like a T-shaped pipe fitting: it copies its standard input to a file **and**
passes it on down the pipeline. It is a way to save the data at a middle stage:

```bash
ls /usr/bin | tee ls.txt | grep zip
wc -l ls.txt
```

```text
$ ls /usr/bin | tee ls.txt | grep zip
gunzip
gzip
streamzip
zipdetails
$ wc -l ls.txt
905 ls.txt
```

The screen shows only the `zip` lines, but `ls.txt` holds the whole list. The same on the
data file:

```bash
grep Fedora book_distros.txt | tee fedora.txt | wc -l
cat fedora.txt
```

The pipeline prints `6`, and `fedora.txt` holds the 6 Fedora lines.

Try this:

- Count the SUSE lines in `book_distros.txt` with `grep` and `wc -l`. Then check: do the
  Fedora, SUSE and Ubuntu counts add up to 16?
- Run `sort book_distros.txt | head -n 3` and `sort book_distros.txt | tail -n 3`. Which
  name comes first in sorted order, and which last?

## Common mistakes

| You type | What bash says | Fix |
|---|---|---|
| `sort notes.txt > notes.txt` | Nothing, but `notes.txt` is now empty: the shell emptied it for `>` before `sort` started | Write to a new file: `sort notes.txt > sorted.txt` |
| `ls -l /bin/usr > out.txt` | `ls: cannot access '/bin/usr': No such file or directory` still on the screen, and `out.txt` is empty | `>` saves only standard output: add `2> err.txt`, or use `&> out.txt` for both |
| `ls -l /bin/usr 2>&1 > out.txt` | `ls: cannot access '/bin/usr': No such file or directory` on the screen | File first, then `2>&1`: `ls -l /bin/usr > out.txt 2>&1` |
| `ls -l /bin/usr 2 > err.txt` | `ls: cannot access '/bin/usr': No such file or directory` and `ls: cannot access '2': No such file or directory` | No space between the number and `>`: `2>` |
| `ls > less` (meant to page the listing) | Nothing: it wrote a **file** named `less` | `ls \| less`: the pipe sends output to a command |
| `cat` with no file name | Nothing: it waits | It is reading the keyboard. Type, then Ctrl-d to end the input, or Ctrl-c to quit |
| `echo hello > /etc/hostname` | `bash: /etc/hostname: Permission denied` | You may not write outside your own folders; redirect into `~/playground` |
| `uniq names.txt` on an unsorted file | Repeated lines are still there | `uniq` removes only neighbouring copies: `sort names.txt \| uniq` |

## Check yourself

1. You run `ls /etc/hostname /nothing > out.txt`. What appears on the screen, and what is in
   `out.txt`?
   <details><summary>Answer</summary>The screen shows the error message for
   <code>/nothing</code>, because errors travel on standard error, which <code>&gt;</code> does not
   redirect. <code>out.txt</code> holds the one result, <code>/etc/hostname</code>.</details>
2. Why does `sort notes.txt > notes.txt` leave you with an empty file?
   <details><summary>Answer</summary>The shell sets up the redirection first: it opens
   <code>notes.txt</code> for <code>&gt;</code> and empties it. Only then does <code>sort</code> start, and it
   reads a file that is already empty.</details>
3. What is the difference between `> file 2>&1` and `2>&1 > file`?
   <details><summary>Answer</summary>Redirections are read left to right, and <code>2&gt;&amp;1</code>
   points stream 2 wherever stream 1 points at that moment. In the first form stream 1
   already points at the file, so both streams go there. In the second, stream 1 still
   points at the screen when <code>2&gt;&amp;1</code> runs, so the errors keep going to the screen.</details>
4. On Mint, `ls /bin /usr/bin | sort | uniq -d` lists every program name. Why, when the
   book's machine showed only a few?
   <details><summary>Answer</summary>On current systems <code>/bin</code> is a symbolic link to
   <code>/usr/bin</code>, so both listings are the same and every name appears twice.
   <code>uniq -d</code> prints the names that were repeated: all of them.</details>
5. What does `tee` do that `>` cannot?
   <details><summary>Answer</summary><code>&gt;</code> sends the output into a file and nothing
   goes on. <code>tee</code> writes a copy into a file and also passes the same data on to the next
   command in the pipeline (or to the screen).</details>
