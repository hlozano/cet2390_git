# Chapter 9: Permissions

*The Linux Command Line* (TLCL), chapter 9. The book is free: https://linuxcommand.org/tlcl.php

## What you will learn

- Linux is a **multi-user** system. Every file has an **owner**, a **group owner**, and rules
  for everybody else (the **world**); `id` shows who you are to the system.
- How to read the first ten characters of an `ls -l` line: the file type, then read (`r`),
  write (`w`) and execute (`x`) permission for the owner, the group and the world. On a
  folder, the same three letters mean list, change the contents, and enter.
- `chmod` changes a file's permissions with a number (`chmod 600`) or with letters
  (`chmod u+x`); `umask` decides the permissions every new file starts with.
- The three special permissions: setuid, setgid and the sticky bit.
- `su` and `sudo` run commands as another user (on Linux Mint, `sudo` is the one that works),
  and `chown`, `chgrp` and `passwd` change owners, groups and passwords.

## Files in this folder

This chapter has no scripts and no data files. The book's examples are commands you type at
the prompt; they are all below, section by section.

## The book's examples

**Work in a practice folder.** The book's commands create files such as `foo.txt` in
whatever folder you are in, and they change permissions, so type them where nothing
important lives:

```bash
mkdir -p ~/playground
cd ~/playground
```

In the output below, `student` stands for your user name, and `...` stands for the size and
date that `ls -l` prints where they do not matter.

**About the commands for reading only.** A few of the book's examples need administrator
(root) rights: they use `sudo`, change other users' files, or change your password. They are
shown in plain text blocks, labelled "for reading only", so you can follow the book. Do not
type them: a wrong permission on a system file can stop the machine from working. Everything
in a `bash` block is safe to type in the practice folder.

### Owners, Group Members, and Everybody Else

In chapter 3 you may have been refused when you looked at `/etc/shadow`:

```bash
file /etc/shadow
less /etc/shadow
```

```text
$ file /etc/shadow
/etc/shadow: regular file, no read permission
$ less /etc/shadow
/etc/shadow: Permission denied
```

Nothing is broken: a regular user is not allowed to read that file. In the Unix security
model a user may **own** files and folders and decide who may use them. Users also belong to
**groups**, and an owner can give a group some access, and give some access to everybody else
(the **world**). `id` shows who you are:

```bash
id
```

```text
$ id
uid=1000(student) gid=1000(student) groups=1000(student),4(adm),24(cdrom),27(sudo),...
```

- `uid` is your **user ID**, a number, shown with the user name it stands for. The first
  regular account on Mint (and Ubuntu) gets 1000.
- `gid` is your **primary group ID**. Modern Linux gives every user a private group with the
  same name and number as the user.
- `groups` lists every group you belong to. Membership in group `sudo` is what lets your
  account use the `sudo` command (later in this chapter).

The information comes from text files. `/etc/passwd` holds one line per account: the user
name, an `x` where the password used to be, the uid, the gid, the person's real name, the home
folder and the login shell. `/etc/group` lists the groups and their members. The password
hashes are in `/etc/shadow`, which only root and the system group `shadow` may read:

```bash
grep "^root:" /etc/passwd
less /etc/group
ls -l /etc/shadow
```

```text
$ grep "^root:" /etc/passwd
root:x:0:0:root:/root:/bin/bash
$ ls -l /etc/shadow
-rw-r----- 1 root shadow ... /etc/shadow
```

`root` is the **superuser**, uid 0. The other accounts you see in `/etc/passwd` are system
users that run services; chapter 10 shows them at work.

### Reading, Writing, and Executing

Create an empty file and look at its listing (`>` with no command creates an empty file,
chapter 6):

```bash
> foo.txt
ls -l foo.txt
```

```text
$ ls -l foo.txt
-rw-rw-r-- 1 student student 0 ... foo.txt
```

The first 10 characters are the **file attributes**. The first one is the **file type**
(the book's Table 9-1):

| Attribute | File type |
|---|---|
| `-` | A regular file |
| `d` | A directory (folder) |
| `l` | A symbolic link. Its `rwxrwxrwx` is a dummy; the real permissions are those of the file it points to |
| `c` | A character special file: a device that handles a stream of bytes, such as a terminal or `/dev/null` |
| `b` | A block special file: a device that handles data in blocks, such as a disk |

You can see four of them with one command (`-d` lists the folders themselves, not what is
inside):

```bash
ls -ld /bin /dev/null /etc /usr/bin/passwd
```

```text
$ ls -ld /bin /dev/null /etc /usr/bin/passwd
lrwxrwxrwx  1 root root ... /bin -> usr/bin
crw-rw-rw-  1 root root ... /dev/null
drwxr-xr-x 89 root root ... /etc
-rwsr-xr-x  1 root root ... /usr/bin/passwd
```

(The number after the mode is the link count, which this book does not use; yours may
differ.)

The other nine characters are the **file mode**: three letters for the owner, three for the
group owner, three for the world, always in that order. A dash means "no".

```text
-    rw-    rw-    r--
type owner  group  world
```

So `foo.txt` is a regular file that its owner and its group may read and write, and that
everybody else may only read. What the three letters allow (the book's Table 9-2):

| Attribute | On a file | On a directory |
|---|---|---|
| `r` | Open and read the file | List the names inside (together with `x`) |
| `w` | Write to the file or empty it. It does **not** allow renaming or deleting the file: that is decided by the directory | Create, delete and rename files inside (together with `x`) |
| `x` | Run the file as a program. A script must also be readable (`r`), because the shell has to read it | Enter it with `cd` and reach the files inside |

The directory column surprises most people, so try it on a folder of your own:

```bash
mkdir stuff
echo hi > stuff/notes.txt
chmod 600 stuff
cd stuff
chmod 700 stuff
chmod u-w stuff
rm stuff/notes.txt
echo more >> stuff/notes.txt
chmod u+w stuff
```

```text
$ chmod 600 stuff
$ cd stuff
bash: cd: stuff: Permission denied
$ chmod 700 stuff
$ chmod u-w stuff
$ rm stuff/notes.txt
rm: cannot remove 'stuff/notes.txt': Permission denied
$ echo more >> stuff/notes.txt
$ chmod u+w stuff
```

- With mode `600` (`rw-------`) the folder has no `x`, so even its owner cannot enter it.
- With `w` taken away from the folder, you cannot delete the file inside, although the file
  itself is still writable: the `>>` line worked. Deleting changes the folder, not the file.

(`chmod` is explained in the next section.) Some examples of whole modes (the book's
Table 9-3):

| File attributes | Meaning |
|---|---|
| `-rwx------` | A regular file the owner may read, write and run. No one else has any access |
| `-rw-------` | A regular file the owner may read and write. No one else has any access |
| `-rw-r--r--` | The owner may read and write; the group and the world may read |
| `-rwxr-xr-x` | The owner may read, write and run; everybody else may read and run |
| `-rw-rw----` | The owner and the group may read and write; the world has no access |
| `lrwxrwxrwx` | A symbolic link: dummy permissions |
| `drwxrwx---` | A directory the owner and group may enter and change; the world has no access |
| `drwxr-x---` | A directory the owner may enter and change; the group may enter and list it but not change it |

### chmod - Change File Mode

`chmod` changes the mode of a file or folder. Only the file's owner, or the superuser, may
do it. There are two ways to write the new mode: as a number, or with letters.

**What the heck is octal?** Computers count in binary (base 2), with only the digits 0 and 1.
Octal (base 8) uses the digits 0 to 7, and each octal digit stands for exactly three binary
digits. A file mode is three groups of three yes/no bits, so one octal digit describes one
group (the book's Table 9-4):

| Octal | Binary | File mode |
|---|---|---|
| `0` | `000` | `---` |
| `1` | `001` | `--x` |
| `2` | `010` | `-w-` |
| `3` | `011` | `-wx` |
| `4` | `100` | `r--` |
| `5` | `101` | `r-x` |
| `6` | `110` | `rw-` |
| `7` | `111` | `rwx` |

An easy way to remember it: `r` is worth 4, `w` is worth 2, `x` is worth 1; add up the
letters you want. Three digits set the owner, the group and the world, in that order. The
book's example:

```bash
> foo.txt
ls -l foo.txt
chmod 600 foo.txt
ls -l foo.txt
```

```text
$ ls -l foo.txt
-rw-rw-r-- 1 student student 0 ... foo.txt
$ chmod 600 foo.txt
$ ls -l foo.txt
-rw------- 1 student student 0 ... foo.txt
```

`6` is `rw-` for the owner, and the two `0`s take everything away from the group and the
world. You will use only a few digits: 7 (`rwx`), 6 (`rw-`), 5 (`r-x`), 4 (`r--`) and
0 (`---`), and a few whole modes:

| Mode | Letters | Use it for |
|---|---|---|
| `755` | `rwxr-xr-x` | A script or program everyone may run; also normal for folders |
| `644` | `rw-r--r--` | An ordinary file everyone may read |
| `700` | `rwx------` | A private script or folder |
| `600` | `rw-------` | A private file |

**Symbolic notation** changes only what you name and leaves the rest alone. It has three
parts: who, what to do, and which permission. Who (the book's Table 9-5):

| Symbol | Meaning |
|---|---|
| `u` | "user", but it means the file's owner |
| `g` | The group owner |
| `o` | "others": the world |
| `a` | "all": `u`, `g` and `o` together |

What to do: `+` adds a permission, `-` takes one away, and `=` sets exactly the listed
permissions and removes all others. Which permission: `r`, `w`, `x`. With no who letter,
`chmod` acts on all three. The book lists the forms in its Table 9-6 without running them;
here they are, one after another, on `foo.txt`, starting from `-rw-rw-r--`:

```bash
chmod 664 foo.txt
chmod u+x foo.txt; ls -l foo.txt
chmod u-x foo.txt; ls -l foo.txt
chmod +x foo.txt; ls -l foo.txt
chmod o-rw foo.txt; ls -l foo.txt
chmod go=rw foo.txt; ls -l foo.txt
chmod u+x,go=rx foo.txt; ls -l foo.txt
```

(`;` separates two commands on one line.) The modes you see, in order:

| Command | Result | What changed |
|---|---|---|
| `chmod u+x` | `-rwxrw-r--` | The owner may now run it |
| `chmod u-x` | `-rw-rw-r--` | The owner's `x` is gone again |
| `chmod +x` | `-rwxrwxr-x` | `x` for the owner, the group and the world (same as `a+x`) |
| `chmod o-rw` | `-rwxrwx--x` | The world lost `r` and `w`; its `x` stayed |
| `chmod go=rw` | `-rwxrw-rw-` | Group and world have exactly `rw`; their `x` was removed |
| `chmod u+x,go=rx` | `-rwxr-xr-x` | Two changes at once, separated by a comma |

(One fine point: with no who letter, `chmod` skips any bit your umask, described below,
blocks. With the usual umask, `chmod +w` therefore does not give the world write permission;
write `a+w` when you mean all three.) A number sets all nine bits at once; letters change
one thing. Use a number when you know the final mode, letters to add or remove one
permission. The book also warns about `chmod --recursive` (change a folder and everything in
it): it gives files and folders the same mode, which is rarely what you want.

**Why your scripts needed `chmod u+x`.** One bit decides whether a script runs:

```bash
echo 'echo "it runs"' > try.sh
./try.sh
chmod u+x try.sh
./try.sh
```

```text
$ ./try.sh
bash: ./try.sh: Permission denied
$ chmod u+x try.sh
$ ./try.sh
it runs
```

### Setting File Mode with the GUI

The file manager shows the same settings. On Mint (the Nemo file manager), right-click a
file or folder, choose **Properties**, and open the **Permissions** tab: the owner, the group
and the world, each with its own access setting.

### umask - Set Default Permissions

The `umask` command controls the permissions a new file gets. It is a **mask**, written in
octal: every bit that is 1 in the mask is taken away from the new file's mode.

```bash
rm -f foo.txt
umask
> foo.txt
ls -l foo.txt
```

```text
$ umask
0002
$ ls -l foo.txt
-rw-rw-r-- 1 student student 0 ... foo.txt
```

A program that creates a file asks for `rw-rw-rw-` (666: never `x`, which is why a new file
is never executable). The mask `0002` removes the world's `w`:

```text
--- rw- rw- rw-    the mode a new file asks for
000 000 000 010    the mask 0002, in binary
--- rw- rw- r--    the result: 664
```

(Ignore the first digit of the mask for now; it is for the special permissions in the next
section.) Now turn the mask off:

```bash
rm foo.txt
umask 0000
> foo.txt
ls -l foo.txt
```

```text
$ ls -l foo.txt
-rw-rw-rw- 1 student student 0 ... foo.txt
```

With nothing masked, the file is writable by everyone. The other common default is `0022`,
which also removes the group's `w`:

```text
--- rw- rw- rw-    the mode a new file asks for
000 000 010 010    the mask 0022
--- rw- r-- r--    the result: 644
```

A new folder asks for `rwxrwxrwx` (777), so under `0002` it gets `775` (`drwxrwxr-x`) and
under `0022` it gets `755`. The book says to "try some sevens":

```bash
umask 0077
> secret.txt
mkdir secret_dir
ls -ld secret.txt secret_dir
```

```text
$ ls -ld secret.txt secret_dir
-rw------- 1 student student 0 ... secret.txt
drwx------ 2 student student ... secret_dir
```

`077` masks everything for the group and the world. When you are done, clean up and put the
mask back to the value `umask` printed first, as the book does:

```bash
rm foo.txt; umask 0002
```

A `umask` you type at the prompt lasts only in **that shell**: another terminal window, or a
new one, starts with the default again. Chapter 11 shows how to make a change permanent.
Most of the time the default is right.

### Some Special Permissions

A mode really has four octal digits. The first holds three rarely used settings:

- The **setuid bit** (4000). On a program, it makes the program run with the permissions of
  the program's **owner** instead of the user who started it. A program owned by root with
  this bit set runs as root, which is how `passwd` can change `/etc/shadow` for you. Because
  that is risky, very few programs have it.
- The **setgid bit** (2000). On a program it does the same for the group. On a **directory**,
  it makes new files inside belong to the directory's group instead of the creator's group,
  which helps a group share a folder.
- The **sticky bit** (1000). Linux ignores it on files. On a directory, it stops users from
  deleting or renaming files they do not own (unless they own the directory or are root).
  `/tmp`, which everyone may write in, uses it.

The book's three commands need a file named `program` and a folder named `dir`; the first
line makes them:

```bash
> program; mkdir dir
chmod u+s program
chmod g+s dir
chmod +t dir
ls -l program
ls -ld dir
```

```text
$ ls -l program
-rwSrw-r-- 1 student student 0 ... program
$ ls -ld dir
drwxrwsr-t 2 student student ... dir
```

The special bits show up in the `x` positions. `ls` prints a **capital** `S` when setuid is
set but the owner has no `x`: here the bit does nothing, because `program` is an empty file
nobody can run. After `chmod u+x program`, the listing shows a small `s`: `-rwsrw-r--`. On
`dir`, the `s` in the group's position is setgid and the `t` at the end is the sticky bit.

The book's three example modes are on real system files:

```bash
ls -l /usr/bin/passwd
ls -ld /tmp
```

```text
$ ls -l /usr/bin/passwd
-rwsr-xr-x 1 root root ... /usr/bin/passwd
$ ls -ld /tmp
drwxrwxrwt 8 root root ... /tmp
```

`passwd` is setuid and owned by root; `/tmp` is open to everyone (`rwxrwxrwx`) with the
sticky bit (`t`). The book's third example, `drwxrwsr-x`, a setgid directory, appears in
"Exercising Our Privileges" below.

### Changing Identities

Sometimes you need to act as another user, most often as the superuser to do an
administrative job. There are three ways: log out and log back in as the other user, use
`su`, or use `sudo`.

### su - Run a Shell with Substitute User and Group IDs

`su` starts a shell as another user (with no user named, the superuser), and asks for **that
user's** password. `su -` (short for `su -l`) gives a **login shell**: the other user's
environment and home folder. `su -c 'command'` runs a single command; the quotes keep your
shell from expanding the command, so the new shell does it. For reading only:

```text
$ su -
Password:
su: Authentication failure
$ su -c 'ls -l /root/*'
Password:
su: Authentication failure
```

On the book's system, the root password opened a root shell, whose prompt ends in `#`
instead of `$`, and `exit` returned to the normal shell. On Linux Mint and Ubuntu the root
account has **no usable password**, so `su` always fails this way. That is deliberate; see
"Ubuntu and sudo" below.

### sudo - Execute a Command as Another User

`sudo` runs one command as another user (usually root) and asks for **your own** password.
The administrator decides, in a file named `/etc/sudoers`, who may run what. Unlike `su`,
`sudo` does not start a new shell, so the command is quoted as usual. For reading only (the
book's `backup_script` is a made-up program):

```text
$ sudo backup_script
[sudo] password for student:
System Backup Starting...
$ sudo -l
...
User student may run the following commands on mint:
    (ALL : ALL) ALL
```

`sudo -l` lists what you may do; `(ALL : ALL) ALL` means any command, as any user. On Mint
the first account gets that right through the `sudo` group you saw in `id`. `sudo -i` opens
a root shell (like `su -`, but with your password); its prompt ends in `#`, and `exit`
leaves it. After you type your password once, `sudo` trusts you for a few minutes without
asking again.

Root ignores the `r` and `w` permissions on every file, which is why each root command
deserves a second reading before you press Enter. One limit remains: even root cannot run a
file that has no `x` bit at all.

### Ubuntu and sudo

Giving everyday users full administrator rights also gives those rights to every program
they run, including malware. Unix has always kept a clearer line between regular users and
the administrator, and grants superuser rights only when they are needed. Traditionally
that meant `su` and a root password, which tempted people to stay logged in as root. Ubuntu
took a different path: it gives root no password and lets the first user run single
commands as root with `sudo`. Linux Mint, which is built on Ubuntu, does the same, so on
your system `sudo` is the way to do administrative work.

### chown - Change File Owner and Group

`chown` changes a file's owner and group owner. It always needs superuser rights, because
giving a file away is a security decision. The syntax is `chown [owner][:[group]] file...`,
and the first argument decides what changes (the book's Table 9-7):

| Argument | Result |
|---|---|
| `bob` | The owner becomes user `bob`; the group stays |
| `bob:users` | The owner becomes `bob` and the group becomes `users` |
| `:admins` | Only the group changes, to `admins` |
| `bob:` | The owner becomes `bob` and the group becomes `bob`'s login group |

The book's example: user `janet`, who may use `sudo`, copies a file into the home folder of
user `tony` and gives it to him. For reading only (your machine has no user `tony`):

```text
$ sudo cp myfile.txt ~tony
[sudo] password for janet:
$ sudo ls -l ~tony/myfile.txt
-rw-r--r-- 1 root root ... /home/tony/myfile.txt
$ sudo chown tony: ~tony/myfile.txt
$ sudo ls -l ~tony/myfile.txt
-rw-r--r-- 1 tony tony ... /home/tony/myfile.txt
```

The copy belonged to `root`, because `sudo` made it. `tony:` with the trailing colon made
`tony` the owner and his login group, also named `tony`, the group. (The book's printed
listing shows a third `root`/`tony` column; real output has only the owner and the group.)

What happens when you try it without root, on a new `foo.txt`:

```bash
> foo.txt
chown root foo.txt
```

```text
$ chown root foo.txt
chown: changing ownership of 'foo.txt': Operation not permitted
```

### chgrp - Change Group Ownership

In older Unix versions `chown` changed only the owner, and `chgrp` changed the group. It
works much like `chown`, with one difference worth knowing: you may move **your own** file to
any group you belong to (the groups in your `id` line) without root. Any other group is
refused:

```bash
chgrp sudo foo.txt
ls -l foo.txt
chgrp root foo.txt
chgrp $USER foo.txt
```

```text
$ chgrp sudo foo.txt
$ ls -l foo.txt
-rw-rw-r-- 1 student sudo 0 ... foo.txt
$ chgrp root foo.txt
chgrp: changing group of 'foo.txt': Operation not permitted
```

The last line gives the file back to your private group, which has your user name.

### Exercising Our Privileges

The book puts the chapter together to set up a folder that two users, `bill` and `karen`,
can both write in. `bill` first creates a group named `music` with both users in it (with the
graphical user manager), then creates the folder. For reading only, since every step changes
the system:

```text
$ sudo mkdir /usr/local/share/Music
$ ls -ld /usr/local/share/Music
drwxr-xr-x 2 root root ... /usr/local/share/Music
$ sudo chown :music /usr/local/share/Music
$ sudo chmod 775 /usr/local/share/Music
$ ls -ld /usr/local/share/Music
drwxrwxr-x 2 root music ... /usr/local/share/Music
```

Now members of `music` may create files in the folder. Two problems remain, as a test file
shows:

```text
$ > /usr/local/share/Music/test_file
$ ls -l /usr/local/share/Music
-rw-r--r-- 1 bill bill ... test_file
```

- The file belongs to group `bill` (bill's private group), not `music`.
- Its mode is `rw-r--r--`: bill's umask was `0022`, so the group may not write the file.

The fixes: the setgid bit on the folder, so new files take the folder's group, and a umask
of `0002`, so new files are group-writable:

```text
$ sudo chmod g+s /usr/local/share/Music
$ ls -ld /usr/local/share/Music
drwxrwsr-x 2 root music ... /usr/local/share/Music
$ umask 0002
$ rm /usr/local/share/Music/test_file
$ > /usr/local/share/Music/test_file
$ mkdir /usr/local/share/Music/test_dir
$ ls -l /usr/local/share/Music
drwxrwsr-x 2 bill music ... test_dir
-rw-rw-r-- 1 bill music ... test_file
```

Both new items now belong to group `music`, and the group may write them. The book notes
the remaining issue: the typed `umask` does not last (as you saw above, only in that shell).

You can watch the setgid part work without root, in the practice folder. The group stays your
own, but the `s` carries over to every new folder made inside:

```bash
mkdir Music
chmod 775 Music
chmod g+s Music
umask 0002
> Music/test_file
mkdir Music/test_dir
ls -ld Music
ls -l Music
```

```text
$ ls -ld Music
drwxrwsr-x 3 student student ... Music
$ ls -l Music
total 4
drwxrwsr-x 2 student student ... test_dir
-rw-rw-r-- 1 student student 0 ... test_file
```

### Changing Your Password

`passwd [user]` sets a password. With no user name it changes yours: it asks for the current
password, then the new one twice. For reading only, because it really changes your password,
which is also the password `sudo` asks for:

```text
$ passwd
Changing password for student.
Current password:
New password:
Retype new password:
```

`passwd` tries to enforce strong passwords: it refuses ones that are too short, too similar
to the old one, or too easy to guess (the exact messages vary from system to system). With
superuser rights, `sudo passwd name` sets another user's password.

## Common mistakes

| You type | What bash says | Fix |
|---|---|---|
| `./try.sh` | `bash: ./try.sh: Permission denied` | The script has no `x`: `chmod u+x try.sh` |
| `chmod 600 /etc/passwd` | `chmod: changing permissions of '/etc/passwd': Operation not permitted` | Only the owner may change a mode; work on your own files |
| `chown root foo.txt` | `chown: changing ownership of 'foo.txt': Operation not permitted` | Giving a file away always needs root |
| `cd stuff` (folder without `x`) | `bash: cd: stuff: Permission denied` | `chmod u+x stuff` |
| `ls stuff` (folder without `r`) | `ls: cannot open directory 'stuff': Permission denied` | `chmod u+r stuff` |
| `rm stuff/notes.txt` (folder without `w`) | `rm: cannot remove 'stuff/notes.txt': Permission denied` | Deleting needs `w` on the **folder**: `chmod u+w stuff` |
| `chmod 6OO foo.txt` (letter O) | `chmod: invalid mode: ‘6OO’` | Octal modes use only the digits 0 to 7 |
| `less /etc/shadow` | `/etc/shadow: Permission denied` | Expected: only root and group `shadow` may read it |
| `su -` | `su: Authentication failure` | Root has no password on Mint; administrative commands go through `sudo` |
| `chmod 777 myscript.sh` to fix a refusal | No message, but now every account may change your script | Find the one missing bit, usually `chmod u+x` |

## Check yourself

1. Decode `-rwxr-x---`. Who may run the file, who may not even read it, and what is the mode
   as a number?
   <details><summary>Answer</summary>A regular file. The owner may read, write and run it
   (<code>rwx</code> = 7); the group may read and run it (<code>r-x</code> = 5); the world has no
   access at all (<code>---</code> = 0). The mode is 750.</details>
2. What is the difference between `chmod u+x file` and `chmod 755 file`?
   <details><summary>Answer</summary><code>u+x</code> adds one bit (execute for the owner) and
   leaves the other eight as they were. <code>755</code> sets all nine bits:
   <code>rwxr-xr-x</code>, whatever the file had before.</details>
3. Your umask is `0002`. What mode does a new file get, and a new folder?
   <details><summary>Answer</summary>A file asks for 666 and loses the world's <code>w</code>:
   664, <code>rw-rw-r--</code>. A folder asks for 777: 775, <code>rwxrwxr-x</code>.</details>
4. You have no write permission on a file, yet you can delete it. How?
   <details><summary>Answer</summary>Deleting a file changes the folder that lists it, so it is
   decided by the folder's <code>w</code> (and <code>x</code>) permission, not by the file's
   own mode.</details>
5. Why does `ls -l program` show a capital `S` after `chmod u+s program`, while
   `/usr/bin/passwd` shows a small `s`?
   <details><summary>Answer</summary>Both have the setuid bit. A small <code>s</code> means the
   owner's <code>x</code> is set too; a capital <code>S</code> means it is not, so the setuid
   bit has no effect on that file.</details>
