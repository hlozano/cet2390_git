# Chapter 18: Archiving and Backup

*The Linux Command Line* (TLCL), chapter 18. The book is free: https://linuxcommand.org/tlcl.php

This chapter is in the book but not on the current CET 2390 schedule; it is here for study on your own.

## What you will learn

- **Compression** makes a file smaller by removing redundancy: `gzip` / `gunzip` / `zcat`
  and `bzip2` / `bunzip2`. Both are lossless: the restored file is identical.
- **Archiving** bundles many files into one: `tar` with the modes `c` (create), `t` (list),
  `x` (extract) and `r` (append); the `z` and `j` options compress the archive too.
- `tar` stores relative pathnames, works with `find`, and can read standard input and write
  standard output, even through `ssh`.
- `zip` and `unzip` are for exchanging files with Windows users.
- `rsync` keeps a copy in step with the original and copies only what changed; a trailing
  slash on the source changes what it copies.

## Files in this folder

This chapter has no scripts and no data files. The book's examples are commands you type at
the prompt, explained below.

## The book's examples

Almost every command here creates, extracts or deletes files in the current directory. Do all
of it in a practice folder:

```bash
mkdir -p ~/playground/ch18
cd ~/playground/ch18
```

Where the book types a bare `cd` (back to the home directory) before its next example, this
guide goes back to `~/playground/ch18` instead. Commands that need `sudo`, a USB drive or a
second machine are marked **Administrator** or "for reading" and shown in plain `text`
blocks; run administrator commands only on a machine you own and administer, never on a
shared computer.

### Compressing Files

No commands. **Data compression** removes redundancy. The book's example: an all-black image
of 100 by 100 pixels at 3 bytes per pixel takes 30,000 bytes, but "10,000 black pixels"
says the same thing in a few bytes. That idea is **run-length encoding**. **Lossless**
compression keeps every bit (needed for programs and text); **lossy** compression, as in JPEG
images and MP3 music, throws away detail you are unlikely to notice. This chapter is about
lossless tools.

### gzip

`gzip` replaces a file with a compressed copy ending in `.gz`; `gunzip` restores it.

```bash
cd ~/playground/ch18
ls -l /etc > foo.txt            # a text file to work with: a listing of /etc
ls -l foo.*
gzip foo.txt                    # foo.txt is REPLACED by foo.txt.gz
ls -l foo.*
gunzip foo.txt                  # gunzip adds the .gz for you
ls -l foo.*
```

After `gzip`, the listing shows only `foo.txt.gz`, about a fifth of the size (in one test,
9746 bytes became 1888), with the same permissions and timestamp as the original. After
`gunzip`, `foo.txt` is back, unchanged.

| Option | Long option | What it does (Table 18-1) |
|---|---|---|
| `-c` | `--stdout`, `--to-stdout` | Write to standard output and keep the original file |
| `-d` | `--decompress`, `--uncompress` | Decompress: `gzip` acts like `gunzip` |
| `-f` | `--force` | Compress even if a compressed version already exists |
| `-h` | `--help` | Show usage information |
| `-l` | `--list` | Show compression statistics for each compressed file |
| `-r` | `--recursive` | Compress the files inside any directory named |
| `-t` | `--test` | Test that a compressed file is intact |
| `-v` | `--verbose` | Report what it does |
| `-number` | | Compression level from 1 (fastest, `--fast`) to 9 (smallest, `--best`); 6 is the default |

The book's second example uses three of them:

```bash
gzip foo.txt
gzip -tv foo.txt.gz             # test (-t) and say so (-v)
gzip -d foo.txt.gz              # decompress
```

```text
foo.txt.gz:      OK
```

`gzip` also works with standard input and output. The book's next lines, in a slightly
different order, with one line added at the top. `gunzip foo.txt` works only when no plain
`foo.txt` is in the way (the book says the name must not be "in conflict with an existing
uncompressed file"), and `gunzip -c` needs the `.gz` file to still be there:

```bash
cd ~/playground/ch18
rm -f foo.txt foo.txt.gz        # added: start clean, so no name is in conflict
ls -l /etc | gzip > foo.txt.gz  # a compressed listing; no foo.txt is ever written
gunzip -c foo.txt | less        # read it without unpacking (q quits)
zcat foo.txt.gz | less          # the same: zcat is gunzip -c
gunzip foo.txt                  # now unpack it: foo.txt.gz becomes foo.txt
```

The book's tip: `zless foo.txt.gz` does what the `zcat ... | less` pipeline does.

### bzip2

`bzip2` uses a different method: it usually compresses more, and takes longer.

```bash
cd ~/playground/ch18
ls -l /etc > foo.txt
ls -l foo.txt
bzip2 foo.txt                   # foo.txt is replaced by foo.txt.bz2
ls -l foo.txt.bz2
bunzip2 foo.txt.bz2
```

In one test, a 22,405-byte listing became 3,153 bytes with `bzip2` and 3,801 with `gzip`.
`bzip2` takes the same options as `gzip` except `-r`; `bzcat` reads a `.bz2` file without
unpacking it, and `bzip2recover` tries to rescue a damaged one.

### Don't Be Compressive Compulsive

The book's example of what **not** to do: `gzip picture.jpg`. A JPEG is already compressed,
so there is no redundancy left, and the format's overhead usually makes the result a little
**bigger**. You can see it with a file you just compressed (not in the book):

```bash
cd ~/playground/ch18
gzip foo.txt
gzip -c foo.txt.gz > twice.gz   # compress the compressed file; -c keeps the original
ls -l foo.txt.gz twice.gz       # twice.gz is larger (1888 bytes became 1922 in one test)
rm twice.gz
gunzip foo.txt.gz
```

### Archiving Files

No commands. **Archiving** gathers many files into one big file, for backups or for moving
old data to long-term storage. It is often combined with compression.

### tar

`tar` ("tape archive") is the classic archiver. `.tar` marks a plain archive, `.tgz` (or
`.tar.gz`) a gzip-compressed one. The form is `tar mode[options] pathname...`:

| Mode | What it does (Table 18-2) |
|---|---|
| `c` | Create an archive from files and directories |
| `x` | Extract an archive |
| `r` | Append pathnames to the end of an archive |
| `t` | List the contents of an archive |

Re-create the playground from chapter 17, archive it, list it, and extract it somewhere else:

```bash
cd ~/playground/ch18
mkdir -p playground/dir-{001..100}
touch playground/dir-{001..100}/file-{A..Z}
tar cf playground.tar playground        # c: create; f: the archive's name comes next
tar tf playground.tar | less            # t: list the names (2,701 of them)
tar tvf playground.tar | less           # v: details, like ls -l
mkdir foo
cd foo
tar xf ../playground.tar                # x: extract, here inside foo
ls                                      # playground
```

The archive holds 2,701 names: `playground/`, its 100 directories and the 2,600 files. Unless
you are root, extracted files belong to you, not to their original owner.

**How `tar` letters work.** The mode and `f` are joined, with no dash. `f` takes the **next
word** as the archive's name, so it goes last among the letters. **A correction to the
slides:** GNU `tar` is more forgiving about order than the book suggests (`tar fc x.tar
playground` works, because `f` still takes the next word), and `tar cf` and `tar -cf` are the
same. The real trap is a letter after `f`:

```bash
cd ~/playground/ch18
tar -cfz project.tar.gz playground      # WRONG: f takes "z" as the archive's name
ls                                      # an archive named z has appeared
rm z
```

```text
tar: project.tar.gz: Cannot stat: No such file or directory
tar: Exiting with failure status due to previous errors
```

`tar` made an archive named `z` and tried to add a file named `project.tar.gz` to it. The
right order is `tar -czf project.tar.gz playground` (or `tar czf ...`).

`tar` stores **relative** pathnames: it removes a leading `/`. To see it, the book archives
the playground by its absolute pathname:

```bash
cd ~/playground/ch18                            # book: cd
tar cf playground2.tar ~/playground/ch18/playground   # book: tar cf playground2.tar ~/playground
cd foo
tar xf ../playground2.tar
ls                                              # home  playground
ls home                                         # your user name (the book's is me)
ls home/"$USER"/playground/ch18                 # playground: the whole path, rebuilt under foo
```

```text
tar: Removing leading `/' from member names
```

That message, printed by the first `tar`, is the relative-path rule at work, not an error.
The archive can therefore be extracted anywhere, not only where it came from.

The book's example of moving every home directory to another machine needs root and a USB
drive. **Administrator, for reading:**

```text
sudo tar cf /media/BigDisk/home.tar /home     (on the first machine: archive /home onto the drive)
cd /                                          (on the second machine: go to the root directory...)
sudo tar xf /media/BigDisk/home.tar           (...so the relative paths land under /)
```

To extract part of an archive, name the pathname after the archive: `tar xf archive.tar
pathname`. It must match the stored name exactly. GNU `tar` accepts wildcards with
`--wildcards`. The book's stored names start `home/me/playground`; yours start with your own
home directory:

```bash
cd ~/playground/ch18/foo
rm -rf home                                     # added: clear the earlier extraction
tar xf ../playground2.tar --wildcards "home/$USER/playground/ch18/playground/dir-*/file-A"
find home -type f | wc -l                       # 100: only the file-A files
```

The double quotes let `$USER` expand but keep the `*` away from the shell, so `tar` gets it.
(Book: `tar xf ../playground2.tar --wildcards 'home/me/playground/dir-*/file-A'`.)

`tar` with `find`: append (`r`) every `file-A` to the existing archive:

```bash
cd ~/playground/ch18
find playground -name 'file-A' -exec tar rf playground.tar '{}' '+'
tar tf playground.tar | wc -l                   # 2801: the 100 files were added again
```

Combined with `find -newer` (chapter 17), this is a way to make **incremental backups**:
archive only the files newer than a timestamp file, then touch the timestamp.

`tar` with standard input and output. A filename of `-` means standard input or output;
`--files-from` (short form `-T`) reads the list of names from a file; `z` compresses with
gzip and `j` with bzip2:

```bash
cd ~/playground/ch18                            # book: cd
find playground -name 'file-A' | tar cf - --files-from=- | gzip > playground.tgz
find playground -name 'file-A' | tar czf playground.tgz -T -
find playground -name 'file-A' | tar cjf playground.tbz -T -
tar tzf playground.tgz | wc -l                  # added: 100 names
```

The book breaks each of the three long commands across two lines; each is one command. All
three make an archive of the 100 `file-A` files; the second and third let `tar` do the
compressing.

The book's last `tar` example copies a directory from another machine through `ssh`
(chapter 16): `tar` on the remote machine writes the archive to standard output, `ssh`
carries it, and the local `tar` unpacks it from standard input. For reading, or to try with
your own machine as the "remote" one (that needs the ssh server, which an administrator
installs, as chapter 16 explains):

```text
mkdir remote-stuff
cd remote-stuff
ssh remote-sys 'tar cf - Documents' | tar xf -                       (book)
ssh localhost 'tar cf - playground/ch18/playground' | tar xf -       (with your own machine)
```

### zip

`zip` compresses **and** archives, in the `.zip` format Windows uses. If `zip` or `unzip` is
missing, installing them is an administrator job (`sudo apt install zip unzip`).

```bash
cd ~/playground/ch18
zip -r playground.zip playground        # -r: the directory AND everything in it
```

```text
  adding: playground/ (stored 0%)
  adding: playground/dir-001/ (stored 0%)
  adding: playground/dir-001/file-A (stored 0%)
```

One line per file. `stored 0%` means the file was kept as is: the files are empty, so there
is nothing to compress. A file that shrinks shows `deflated` and a percentage. Without `-r`,
only the empty directory `playground` is stored.

```bash
cd foo
unzip ../playground.zip
```

`foo` already holds a `playground` from the `tar` extraction, so `unzip` asks before it
replaces a file: `replace playground/dir-.../file-...? [y]es, [n]o, [A]ll, [N]one, [r]ename:`.
Type `A` to replace them all. Unlike `tar`, `zip` **updates** an existing archive instead of
replacing it: new files are added and matching ones replaced.

List or extract a single file by naming it:

```bash
cd ~/playground/ch18
unzip -l playground.zip playground/dir-087/file-Z    # -l: list only, extract nothing
cd foo
unzip ../playground.zip playground/dir-087/file-Z    # one file; answer y to replace it
```

```text
Archive:  playground.zip
  Length      Date    Time    Name
---------  ---------- -----   ----
        0  (date)     (time)  playground/dir-087/file-Z
---------                     -------
        0                     1 file
```

The real listing shows the file's date and time where this one shows words.

`zip` with standard input and output:

```bash
cd ~/playground/ch18                            # book: cd
find playground -name "file-A" | zip -@ file-A.zip   # -@: read the names from standard input
ls -l /etc/ | zip ls-etc.zip -                  # the - : compress standard input
unzip -p ls-etc.zip | less                      # -p: unpack to standard output (q quits)
```

The second command prints `adding: - (deflated 73%)` (the percentage depends on the listing).
`unzip` cannot read an archive from standard input, so `zip` and `unzip` cannot copy over a
network the way `tar` and `ssh` do. Their main use is exchanging files with Windows; on Linux,
`tar` with `gzip` is preferred.

### Synchronizing Files and Directories

`rsync` keeps a copy (a **mirror**) in step with the original. It finds the differences and
copies only what is needed. Its form is `rsync options source destination`, where each is a
local file or directory, a remote one written `[user@]host:path`, or an rsync server
(`rsync://host/path`); at least one side must be local. If `rsync` is not installed, that is
an administrator job (`sudo apt install rsync`).

```bash
cd ~/playground/ch18
rm -rf foo/*                    # book: empty foo (a relative path: only inside the practice folder)
rsync -av playground foo        # -a: recurse and keep attributes; -v: list what is copied
rsync -av playground foo        # again: nothing to copy, nothing listed
touch playground/dir-099/file-Z
rsync -av playground foo        # only that one file is copied
```

The first run lists every directory and file, then a summary. The second and third, from
this guide's test:

```text
sending incremental file list

sent 36,423 bytes  received 125 bytes  73,096.00 bytes/sec
total size is 0  speedup is 0.00
```

```text
sending incremental file list
playground/dir-099/file-Z

sent 36,476 bytes  received 150 bytes  73,252.00 bytes/sec
total size is 0  speedup is 0.00
```

The trailing slash on the source. The book starts from a directory `source` that holds one
file, `file1`, and an empty `destination`; the first line makes them. The book also leaves out
`-a` here, and current `rsync` skips a directory without it:

```bash
cd ~/playground/ch18
mkdir source destination; touch source/file1    # added: the two directories the book describes
rsync source destination        # book: current rsync prints "skipping directory source"
rsync -a source destination     # with -a it copies the directory itself...
ls destination                  # source
rm -rf destination; mkdir destination           # added: an empty destination again
rsync source/ destination       # book: also skipped without -a ("skipping directory .")
rsync -a source/ destination    # ...with a trailing / it copies only what is INSIDE source
ls destination                  # file1
```

The book compares `source/` to `source/*`, except that it also copies hidden files.

The book's practical backup copies `/etc`, `/home` and `/usr/local` to a USB drive mounted at
`/media/BigDisk`. It needs the drive and root. **Administrator, for reading:**

```text
mkdir /media/BigDisk/backup
sudo rsync -av --delete /etc /home /usr/local /media/BigDisk/backup
alias backup='sudo rsync -av --delete /etc /home /usr/local /media/BigDisk/backup'
```

`--delete` removes from the copy whatever no longer exists in the original. The alias is a
line for `~/.bashrc` (chapter 11), so that one word runs the whole backup; the book prints it
on two lines, but it is one line. See `--delete` work inside the practice folder (not in the
book):

```bash
cd ~/playground/ch18
rsync -a --delete playground/ playground_backup/    # make the copy
rm playground/dir-001/file-A
rsync -av --delete playground/ playground_backup/   # the copy loses that file too
```

```text
sending incremental file list
deleting dir-001/file-A
dir-001/
```

### Using rsync Over a Network

The `r` in `rsync` stands for "remote". The book's first network example backs up to another
machine through an ssh tunnel (`--rsh=ssh`), with the remote host's name before the
destination path. It needs root and a second machine. **Administrator, for reading:**

```text
sudo rsync -av --delete --rsh=ssh /etc /home /usr/local remote-sys:/backup
```

Current `rsync` uses `ssh` by default for a `host:path` destination, so `--rsh=ssh` is no
longer needed. With an ssh server on your own machine (chapter 16), this ordinary-user version
copies the playground "over the network" to yourself:

```bash
cd ~/playground/ch18
rsync -av playground localhost:playground/ch18/over_ssh
```

The book's last example mirrors a software repository from an **rsync server**, named by an
`rsync://` address. For reading only: a distribution mirror is many gigabytes, and a server
address from the book may no longer answer. The book's copy prints the option as `-delete`
with one dash; it must be `--delete`.

```text
mkdir fedora-devel
rsync -av --delete rsync://archive.linux.duke.edu/fedora/linux/development/rawhide/Everything/x86_64/os/ fedora-devel
```

### Summing Up

No commands. For archives on Linux, `tar` with `gzip`; for Windows users, `zip` and `unzip`;
to keep copies in step, `rsync`. To clean up: `rm -r ~/playground/ch18`.

## Common mistakes

| You type | What the system says | Fix |
|---|---|---|
| `gunzip foo.txt` while a plain `foo.txt` exists | `gzip: foo.txt: unknown suffix -- ignored` | Remove or rename `foo.txt`, or name the file in full: `gunzip foo.txt.gz` |
| `gzip foo.txt` when `foo.txt.gz` already exists | `gzip: foo.txt.gz already exists; do you wish to overwrite (y or n)?` | `n`, then remove the old one; or `gzip -f` to overwrite |
| `gzip foo.txt.gz` | `gzip: foo.txt.gz already has .gz suffix -- unchanged` | It is already compressed; compressing again gains nothing |
| `tar -cfz project.tar.gz playground` | `tar: project.tar.gz: Cannot stat: No such file or directory` (and a file named `z`) | `f` takes the next word: `tar -czf project.tar.gz playground` |
| `tar czf a.tgz` with nothing after it | `tar: Cowardly refusing to create an empty archive` | Name what to archive: `tar czf a.tgz playground` |
| `tar tzf playground.tar` (not compressed) | `gzip: stdin: not in gzip format` | Drop the `z`: `tar tf playground.tar` |
| `tar xf ../playground2.tar playground/dir-001/file-A` | `tar: playground/dir-001/file-A: Not found in archive` | Copy the exact stored name from `tar tf` |
| `tar cf archive.tar /some/full/path` | `` tar: Removing leading `/' from member names `` | Not an error: names are stored as relative paths |
| `rsync source destination` | `skipping directory source` | Add `-a`: `rsync -a source destination` |
| `rsync -a my_dir backup/` when you wanted the files only | (no message) `backup/my_dir/...` appears | A trailing slash on the source copies only its contents: `rsync -a my_dir/ backup/` |

## Check yourself

1. What does `gzip foo.txt` do to `foo.txt`, and how do you compress a file but keep the
   original?
   <details><summary>Answer</summary>It replaces <code>foo.txt</code> with <code>foo.txt.gz</code>.
   To keep the original, write to standard output: <code>gzip -c foo.txt &gt; foo.txt.gz</code>.</details>
2. Why does compressing a `.jpg` (or a `.gz`) file usually make it bigger?
   <details><summary>Answer</summary>It is already compressed, so no redundancy is left to remove,
   and the compression format adds a little overhead of its own.</details>
3. `tar -cfz backup.tar.gz notes` fails and leaves a file named `z`. Why, and what is the
   correct command?
   <details><summary>Answer</summary><code>f</code> takes the next word as the archive's name, so
   the archive was named <code>z</code> and <code>backup.tar.gz</code> was taken as a file to add.
   Put <code>f</code> last: <code>tar -czf backup.tar.gz notes</code>.</details>
4. Why does the book `cd /` before extracting `home.tar` on the second machine?
   <details><summary>Answer</summary><code>tar</code> stored the names as relative paths
   (<code>home/...</code>), and it extracts relative to the current directory. From
   <code>/</code>, they land in <code>/home</code>.</details>
5. What is the difference between `rsync -a source destination` and `rsync -a source/
   destination`?
   <details><summary>Answer</summary>Without the slash, <code>rsync</code> copies the directory
   itself: you get <code>destination/source/file1</code>. With the slash it copies only what is
   inside: <code>destination/file1</code>.</details>
