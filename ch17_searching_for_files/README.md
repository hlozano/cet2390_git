# Chapter 17: Searching for Files

*The Linux Command Line* (TLCL), chapter 17. The book is free: https://linuxcommand.org/tlcl.php

This chapter is in the book but not on the current CET 2390 schedule; it is here for study on your own.

## What you will learn

- `locate` finds files by name in a database: fast, but only as fresh as the database.
- `find` searches the directory tree itself and picks files by **tests**: name, type, size,
  age, permissions, owner.
- **Operators** (`-and`, `-or`, `-not`, `\( \)`) combine tests, and their order decides what
  runs.
- **Actions** do something with each file found: `-print`, `-delete`, `-exec`, `-ok`; and
  `xargs` turns a list of names into arguments for one command.
- `touch` creates empty files and updates their times; `stat` shows everything the system
  knows about a file.

## Files in this folder

This chapter has no scripts and no data files. The book's examples are commands you type at
the prompt, explained below.

## The book's examples

The `find ~` commands only read your home directory and print names. Everything that creates,
changes or deletes files goes in a practice folder. The book builds its playground in your
home directory; this guide builds it one level down, so it does not mix with files from other
chapters:

```bash
mkdir -p ~/playground/ch17
cd ~/playground/ch17
```

### locate - Find Files the Easy Way

`locate` searches a database of pathnames and prints every one that contains the text you
give it.

```bash
locate bin/zip                  # every path containing bin/zip: /usr/bin/zip, /usr/bin/zipinfo, ...
locate zip | grep bin           # a broad search, narrowed with grep
```

The book looks for programs whose names begin with `zip`: programs live in folders whose
names end in `bin`, so `bin/zip` matches them and little else. On current Mint and Ubuntu the
`locate` command comes from the `plocate` package (the book names the older `slocate` and
`mlocate`); the options the book uses work the same. If `locate` is not installed you get
`locate: command not found`; installing it is an administrator job (`sudo apt install
plocate`, on a machine you administer).

### Where Does the locate Database Come From?

The database is built by `updatedb`, which the system runs on a timer, usually once a day.
So `locate` finds nothing on a freshly installed system, and it never finds a file created
since the last run. Running `updatedb` by hand needs root, so it is an **administrator**
command:

```text
sudo updatedb
```

`find`, next, has neither problem: it looks at the disk every time.

### find - Find Files the Hard Way

`find` takes one or more directories and lists everything in them, all the way down:

```bash
find ~ | less                   # every file and directory in your home (q quits)
find ~ | wc -l                  # how many there are
```

The list goes to standard output, so it can be piped into other commands. What makes `find`
powerful is that it can pick files by their attributes, with **options**, **tests** and
**actions**.

### Tests

```bash
find ~ -type d | wc -l                              # directories only
find ~ -type f | wc -l                              # regular files only
find ~ -type f -name "*.JPG" -size +1M | wc -l      # .JPG files bigger than 1 MiB (often 0)
```

The pattern after `-name` is in quotes so that the shell passes `*.JPG` to `find` unchanged;
`find` then matches it against each name.

| `-type` letter | File type (Table 17-1) |
|---|---|
| `b` | Block special device file |
| `c` | Character special device file |
| `d` | Directory |
| `f` | Regular file |
| `l` | Symbolic link |

| `-size` unit | Meaning (Table 17-2) |
|---|---|
| `b` | 512-byte blocks (the default when no unit is given) |
| `c` | Bytes |
| `w` | 2-byte words |
| `k` | Kibibytes (units of 1024 bytes) |
| `M` | Mebibytes (units of 1,048,576 bytes) |
| `G` | Gibibytes (units of 1,073,741,824 bytes) |

A number with `+` means "more than", with `-` "less than", with no sign "exactly".

**A correction to the slides.** `find` rounds every file's size **up** to whole units before
it compares. So `-size +1M` does mean "more than 1 MiB", but `-size -1M` means "less than one
whole MiB after rounding up", which only an empty file is: it matches empty files and nothing
else. For "smaller than a megabyte" use a smaller unit:

```bash
mkdir -p ~/playground/ch17/sizes
cd ~/playground/ch17/sizes
touch empty                                  # 0 bytes
head -c 100 /dev/zero > small                # 100 bytes (head -c: the first 100 bytes)
head -c 500000 /dev/zero > half              # about half a MiB
find . -type f -size -1M                     # ./empty only
find . -type f -size -1024k                  # ./empty, ./small and ./half (in some order)
```

The most useful of the other tests (Table 17-3):

| Test | Matches files or directories... |
|---|---|
| `-name pattern` | whose name matches the wildcard pattern |
| `-iname pattern` | the same, ignoring upper and lower case |
| `-mtime n` | whose contents were modified `n` days (n times 24 hours) ago; `-mtime -7` means within the last 7 days |
| `-mmin n` | whose contents were modified `n` minutes ago |
| `-ctime n`, `-cmin n` | whose contents **or attributes** (such as permissions) changed `n` days or minutes ago |
| `-newer file` | whose contents were modified more recently than `file`'s |
| `-cnewer file` | whose contents or attributes changed more recently than `file`'s |
| `-empty` | that are empty files or empty directories |
| `-perm mode` | whose permissions are exactly `mode`, such as `0600` |
| `-user name`, `-group name` | that belong to that user or group |
| `-nouser`, `-nogroup` | that belong to no existing user or group |
| `-inum n`, `-samefile name` | with inode number `n` / that are the same file as `name` (hard links, chapter 4) |

### Operators

The book's example finds files whose permissions are not `0600` **or** directories whose
permissions are not `0700`:

```bash
find ~ \( -type f -not -perm 0600 \) -or \( -type d -not -perm 0700 \) | less
```

The book prints it on two lines; it is one command.

| Operator | Meaning (Table 17-4) |
|---|---|
| `-and` (or `-a`) | Both sides must be true. It is implied when two tests stand side by side. |
| `-or` (or `-o`) | Either side may be true |
| `-not` (or `!`) | The test after it must be false |
| `\( \)` | Group tests, to control the order of evaluation |

Read the command from the top level: `( file with bad permissions ) -or ( directory with bad
permissions )`. It is `-or`, because nothing is both a file and a directory. Each group is
"type, and not the good permission", with the `-and` left out. The parentheses mean something
to the shell, so each is escaped with a backslash and reaches `find` as an argument. (In the
explanation, the book writes `-perms`; the test is `-perm`.)

`find` stops evaluating as soon as it knows the answer (Table 17-5):

| Result of `expr1` | Operator | `expr2` is... |
|---|---|---|
| True | `-and` | always performed |
| False | `-and` | never performed |
| True | `-or` | never performed |
| False | `-or` | always performed |

This is about speed, but it also decides when an **action** runs, as the next section shows.

### Predefined Actions

| Action | What it does (Table 17-6) |
|---|---|
| `-print` | Print the pathname. The default when no action is given. |
| `-ls` | List the file like `ls -dils` |
| `-delete` | Delete the file |
| `-quit` | Stop after the first match |

```bash
find ~                          # these two print the same list:
find ~ -print                   # -print is the default action
```

The book's `-delete` example removes every file ending in `.bak` under your home directory:
`find ~ -type f -name '*.bak' -delete`. Do not run it there. The book's own advice is to run
the command with `-print` first, to see what would be deleted. Practice in the playground:

```bash
cd ~/playground/ch17
touch a.bak b.bak keep.txt
find . -type f -name '*.bak' -print       # the dry run: ./a.bak and ./b.bak
find . -type f -name '*.bak' -delete      # the real thing
ls                                        # keep.txt is still there
```

With every `-and` written out, the book's command reads
`find ~ -type f -and -name '*.bak' -and -print`: the action runs only when both tests are
true. Put the action first and it runs for **every** file, before any test is checked:

```bash
find ~ -print -and -type f -and -name '*.bak'    # prints EVERY name in your home
```

That is why an action always goes **last**. With `-delete` in front, the same mistake deletes
everything.

### User-Defined Actions

`-exec command '{}' ';'` runs any command on each file found. `{}` stands for the current
pathname and `';'` ends the command; both are quoted because braces and semicolons mean
something to the shell (`\;` works too). The book's fragment `-exec rm '{}' ';'` does what
`-delete` does.

`-ok` works like `-exec` but asks first. Make sure there is something to find, then try it:

```bash
touch ~/playground/ch17/foo.txt
find ~ -type f -name 'foo*' -ok ls -l '{}' ';'
```

```text
< ls ... /home/student/playground/ch17/foo.txt > ?
```

Type `y` and Enter to run `ls -l` on that file, or `n` to skip it. You may see other files
whose names start with `foo` (from chapter 12, for example).

### Improving Efficiency

```bash
find ~ -type f -name 'foo*' -exec ls -l '{}' ';'    # runs ls once for EVERY file found
find ~ -type f -name 'foo*' -exec ls -l '{}' +      # runs ls once, with all of them
```

The output is the same; the second form starts `ls` only once (`ls -l file1 file2` instead of
`ls -l file1`, then `ls -l file2`), which is much faster when there are many matches.

### xargs

`xargs` reads names from standard input and turns them into arguments for a command:

```bash
find ~ -type f -name 'foo*' -print | xargs ls -l
xargs --show-limits < /dev/null     # how long a command line may be
```

The second line starts like this (the numbers depend on the system):

```text
Your environment variables take up 2600 bytes
POSIX upper limit on argument length (this system): 2092504
```

When the list is longer than the limit, `xargs` runs the command several times. `< /dev/null`
(not in the book) gives `xargs` an empty input, so it prints the limits and stops instead of
waiting for you to type. One surprise: if `find` matches nothing, `xargs ls -l` still runs a
plain `ls -l` and lists the current folder. GNU `xargs -r` skips the command when the list is
empty.

### Dealing with Funny Filenames

A space in a filename splits it in two for `xargs`. The fix is to separate names with the
**null character** (byte value 0), which can never appear in a name:

```bash
find ~ -iname '*.jpg' -print0 | xargs --null ls -l
```

`-print0` writes the names separated by nulls; `--null` (short form `-0`) tells `xargs` to
expect that. See the difference in the playground (not in the book):

```bash
cd ~/playground/ch17
touch "my notes.txt"
find . -name 'my*' | xargs ls -l              # split into ./my and notes.txt
find . -name 'my*' -print0 | xargs -0 ls -l   # one argument: works
```

```text
ls: cannot access './my': No such file or directory
ls: cannot access 'notes.txt': No such file or directory
```

That is the first command; the second lists the file.

### A Return to the Playground

Build the book's playground: 100 directories with 26 empty files in each.

```bash
cd ~/playground/ch17
mkdir -p playground/dir-{001..100}                  # 100 directories, by brace expansion
touch playground/dir-{001..100}/file-{A..Z}         # 26 empty files in each: 2,600 files
find playground -type f -name 'file-A'              # one file-A per directory
find playground -type f -name 'file-A' | wc -l      # 100
```

`touch` creates an empty file if the name does not exist, and updates the file's times if it
does. The first `find` prints its 100 names in the order the directories happen to be stored,
not sorted.

Now a reference file, and `stat` to see its times:

```bash
touch playground/timestamp
stat playground/timestamp
```

```text
  File: playground/timestamp
  Size: 0          Blocks: 0          IO Block: 4096   regular empty file
Device: ...        Inode: ...         Links: 1
Access: (0664/-rw-rw-r--)  Uid: ( 1000/ student)   Gid: ( 1000/ student)
Access: (the date and time)
Modify: (the date and time)
Change: (the date and time)
 Birth: (the date and time)
```

The times are shown here as words; yours are real. **Access** is when the file was last
read, **Modify** when its contents last changed, **Change** when its contents or attributes
(owner, permissions) last changed. Current systems add **Birth**, when the file was created.
Run `touch playground/timestamp` and `stat` again: the times move forward.

Update every `file-B`, then ask which files are newer than `timestamp`:

```bash
find playground -type f -name 'file-B' -exec touch '{}' ';'
find playground -type f -newer playground/timestamp
find playground -type f -newer playground/timestamp | wc -l     # 100: the file-B files
```

This is the idea behind an **incremental backup**: touch a timestamp file after each backup,
and next time copy only the files `-newer` than it (chapter 18).

The bad-permissions test from "Operators", then the same test with an action on each side
that fixes what it finds:

```bash
find playground \( -type f -not -perm 0600 \) -or \( -type d -not -perm 0700 \) | wc -l
find playground \( -type f -not -perm 0600 -exec chmod 0600 '{}' ';' \) -or \( -type d -not -perm 0700 -exec chmod 0700 '{}' ';' \)
find playground \( -type f -not -perm 0600 \) -or \( -type d -not -perm 0700 \) | wc -l
```

```text
2702
0
```

The first count is every name: 2,600 files, `timestamp`, 100 directories and `playground`
itself (new files get `0664` or `0644` and directories `0775` or `0755`, depending on your
umask, so none of them was "good"). The second
command prints nothing; it changes the permissions. The last count (not in the book) proves
the fix worked. The book prints the long middle command on several lines; it is one command.

### Options

Options change how far `find` searches (Table 17-7):

| Option | What it does |
|---|---|
| `-depth` | Handle a directory's contents before the directory itself (`-delete` turns it on) |
| `-maxdepth levels` | Go at most this many levels down |
| `-mindepth levels` | Apply tests and actions only this many levels down or deeper |
| `-mount` | Do not enter directories that belong to other file systems |
| `-noleaf` | Do not assume a Unix-like file system (for DOS/Windows disks and CD-ROMs) |

Two of them, tried on the playground (not in the book):

```bash
cd ~/playground/ch17
find playground -maxdepth 1 -type d | wc -l    # 101: playground and its 100 directories
find playground -mindepth 2 -type f | wc -l    # 2600: the files two levels down (not timestamp)
```

### Summing Up

No commands. `locate` is quick for names; `find` does everything else, and its tests,
operators and actions come back again in later chapters. To clean up, remove the practice
folder: `rm -r ~/playground/ch17`.

## Common mistakes

| You type | What the system says | Fix |
|---|---|---|
| `find . -name *.txt` in a folder with two or more `.txt` files | ``find: paths must precede expression: `b.txt'`` | Quote the pattern: `find . -name '*.txt'` |
| `find . -perms 0600` | ``find: unknown predicate `-perms'`` | The test is `-perm` (the book's explanation has the typo) |
| `find . -name 'foo*' -exec ls '{}'` | ``find: missing argument to `-exec'`` | End the command with `';'` (or `\;`, or `+`) |
| `find / -name hosts` | many lines like `find: ‘/root’: Permission denied` | Search where you can read, or hide the errors: `2>/dev/null` |
| `find . -size -1M` | only empty files | `find` rounds up: use `-size -1024k` |
| `find . -name 'my*' \| xargs ls -l` on `my notes.txt` | `ls: cannot access './my': No such file or directory` | `find ... -print0 \| xargs -0 ...` |
| `locate` for a file you just made | nothing | The database is older than the file: use `find` |
| `locate bin/zip` | `locate: command not found` | Not installed; use `find`, or install `plocate` (administrator) |
| An action before the tests (`-print` or `-delete` first) | it acts on every file | Tests first, action last; dry-run with `-print` before `-delete` |

## Check yourself

1. Why is `locate` faster than `find`, and why might it miss a file you created a minute ago?
   <details><summary>Answer</summary><code>locate</code> searches a prepared database instead of
   the disk. The database is rebuilt by <code>updatedb</code> only now and then (usually daily),
   so a file created since the last run is not in it.</details>
2. Why must the pattern in `find ~ -name '*.sh'` be in quotes?
   <details><summary>Answer</summary>Without quotes the shell expands <code>*.sh</code> against
   the current directory before <code>find</code> runs, so <code>find</code> gets the names of
   whatever matching files are here (or an error), not the pattern.</details>
3. What does `find ~ -print -and -type f -and -name '*.bak'` print, and why?
   <details><summary>Answer</summary>Every file and directory in your home. <code>-print</code>
   comes first, and an <code>-and</code> chain runs left to right, so the action is performed for
   every name before the tests are checked.</details>
4. What is the difference between `-exec ls -l '{}' ';'` and `-exec ls -l '{}' +`?
   <details><summary>Answer</summary>With <code>';'</code>, <code>ls</code> runs once for each file
   found. With <code>+</code>, <code>find</code> collects the names and runs <code>ls</code> once
   (or a few times) with all of them as arguments. The output is the same; the second is
   faster.</details>
5. You want files smaller than one megabyte. Why does `-size -1M` find only empty files, and
   what do you write instead?
   <details><summary>Answer</summary><code>find</code> rounds each size up to whole MiB, so any
   file with at least one byte counts as 1M, which is not less than 1. Write
   <code>-size -1024k</code>.</details>
