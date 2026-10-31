# Chapter 14: Package Management

*The Linux Command Line* (TLCL), chapter 14. The book is free: https://linuxcommand.org/tlcl.php

This chapter is in the book but not on the current CET 2390 schedule; it is here for study on your own.

## What you will learn

- Linux software comes as **packages** from your distribution's **repositories**, not from
  installers you download one by one.
- Two big families: Debian style (`.deb` files: Debian, Ubuntu, Linux Mint) and Red Hat
  style (`.rpm` files: Fedora, Red Hat Enterprise Linux).
- A package lists its **dependencies**. A high-level tool (`apt`) fetches them for you; a
  low-level tool (`dpkg`) works on one package file and stops when one is missing.
- The everyday questions you can ask as an ordinary user: search, describe, list, "is it
  installed?" and "which package put this file here?".
- Installing, removing and updating change the whole system, so they are **administrator
  commands**. You will learn what they do, and that `apt update` and `apt upgrade` are two
  different jobs.

## Files in this folder

This chapter has no scripts and no data files. The book's examples are commands you type at
the prompt, explained below.

## The book's examples

**Two kinds of command in this chapter.** Commands that only ask questions (search, show,
list, status) run as yourself, and you can try every one of them. Commands that install,
remove or update software change the system for every user. They need `sudo`, which asks for
the machine's administrator password, and they are marked **Administrator** below and shown
in plain `text` blocks, not as steps to follow. Run them only on a machine you own and
administer, such as your own virtual machine; never on a shared lab or school computer.

The book also leaves `sudo` off its `apt-get` examples. Typed as printed, as an ordinary
user, they stop at once:

```text
$ apt-get install emacs
E: Could not open lock file /var/lib/dpkg/lock-frontend - open (13: Permission denied)
E: Unable to acquire the dpkg frontend lock (/var/lib/dpkg/lock-frontend), are you root?
```

**The book's commands, then and now.** The ideas have not changed; some command names have.
`apt` is the friendlier command for people at the prompt; `apt-get` and `apt-cache` still
work and are the ones to put in scripts, because their output format does not change.
`yum` has been replaced by `dnf` on Red Hat systems, and `aptitude` is not installed on Mint.

| Job | Book, Debian style | Book, Red Hat style | Mint now | Who |
|---|---|---|---|---|
| Search (Table 14-3) | `apt-cache search string` | `yum search string` | `apt search string` | anyone |
| Install (14-4) | `apt-get update; apt-get install name` | `yum install name` | `sudo apt update`, then `sudo apt install name` | administrator |
| Install a file (14-5) | `dpkg -i file` | `rpm -i file` | `sudo apt install ./file.deb` | administrator |
| Remove (14-6) | `apt-get remove name` | `yum erase name` | `sudo apt remove name` | administrator |
| Update all (14-7) | `apt-get update; apt-get upgrade` | `yum update` | `sudo apt update`, then `sudo apt upgrade` | administrator |
| Upgrade from a file (14-8) | `dpkg -i file` | `rpm -U file` | `sudo apt install ./file.deb` | administrator |
| List installed (14-9) | `dpkg -l` | `rpm -qa` | `dpkg -l` or `apt list --installed` | anyone |
| Installed? (14-10) | `dpkg -s name` | `rpm -q name` | `dpkg -s name` | anyone |
| Describe (14-11) | `apt-cache show name` | `yum info name` | `apt show name` | anyone |
| Which package owns a file (14-12) | `dpkg -S file` | `rpm -qf file` | `dpkg -S file` | anyone |

### Packaging Systems

No commands. A package made for one family does not install on the other (Table 14-1):

| Family | Distributions (partial list) |
|---|---|
| Debian style (`.deb`) | Debian, Ubuntu, Linux Mint, Raspberry Pi OS |
| Red Hat style (`.rpm`) | Fedora, Red Hat Enterprise Linux, CentOS, openSUSE |

Gentoo, Slackware and Arch have systems of their own.

### How a Package System Works; Package Files; Repositories; Dependencies

These sections explain ideas:

- A **package file** is a compressed bundle of a program's files plus **metadata** (its
  name, version, description and the packages it needs) and scripts that run when it is
  installed or removed.
- A **package maintainer** builds it from the author's source code (the **upstream**
  provider) and often adjusts it to fit the distribution.
- A **repository** is a server holding thousands of packages built and signed for your
  distribution. There may be testing and development repositories too, and third-party ones.
- **Dependencies**: programs share code kept in **shared libraries**. If a package needs a
  library, the package system installs that too.

Three read-only commands (not in the book) make the ideas visible:

```bash
ls /etc/apt/sources.list.d/                          # the files that name your repositories
apt show bash 2>/dev/null | grep -E '^(Package|Depends):'   # a package's name and dependencies
```

```text
Package: bash
Depends: base-files (>= 2.1.12), debianutils (>= 5.6-0.1)
```

On Mint the repositories are listed in `official-package-repositories.list`. `2>/dev/null`
hides a warning `apt` prints when its output goes into a pipe (chapter 6).

### High and Low-level Package Tools

No commands. The book's Table 14-2, brought up to date:

| Family | Low-level tool (one package file, no dependency help) | High-level tool (repositories, searching, dependencies) |
|---|---|---|
| Debian style | `dpkg` | `apt` (the book: `apt-get`, `aptitude`) |
| Red Hat style | `rpm` | `dnf` (the book: `yum`) |

### Common Package Management Tasks

In the commands below, `package_name` is a package's name and `package_file` is the file that
holds it, as in the book.

#### Finding a Package in a Repository

```bash
apt-cache search emacs          # book, Debian style: searches names and descriptions
apt search emacs | less         # the same search on Mint now (q quits)
```

`apt-cache search` prints one line per package, `name - description`, for example
`emacsen-common - Common facilities for all emacsen`. `apt search` prints two lines per
package: `name/release version architecture`, then the description indented. Both search
the descriptions too, so a common word returns a long list. The book's Red Hat example is
`yum search emacs`.

#### Installing a Package from a Repository

**Administrator.** The book's line, then what an administrator types on Mint:

```text
apt-get update; apt-get install emacs          (book: fails without sudo)
sudo apt update && sudo apt install emacs      (Mint now)
```

`apt update` refreshes the list of available packages first, so `apt install` asks for a
version the server still has. When the package needs others (its dependencies), `apt
install` lists every package it will add and asks `Do you want to continue? [Y/n]`: read the
list before answering.

#### Installing a Package from a Package File

**Administrator.** A package file downloaded from outside the repositories:

```text
rpm -i emacs-22.1-7.fc7-i386.rpm               (book: Red Hat style)
sudo dpkg -i package_file.deb                  (book: Debian style, no dependency help)
sudo apt install ./package_file.deb            (Mint now: installs the file and its dependencies)
```

The `./` matters: without a path, `apt` looks for a repository package with that name. If
`dpkg -i` meets a missing dependency it stops with `dependency problems prevent
configuration`; `sudo apt install -f` then fetches what is missing. Install a downloaded
package only if you trust where it came from: its scripts run as root.

#### Removing a Package

**Administrator.**

```text
apt-get remove emacs           (book: needs sudo)
sudo apt remove emacs          (removes the program, keeps its system-wide settings files)
sudo apt purge emacs           (removes the settings files too)
sudo apt autoremove            (removes dependencies that nothing needs any more)
```

#### Updating Packages from a Repository

**Administrator** for the two commands that change things:

```text
apt-get update; apt-get upgrade       (book: needs sudo)
sudo apt update                       (download the newest package lists; installs nothing)
sudo apt upgrade                      (install the newer versions those lists name)
```

Anyone can ask what is waiting since the last `apt update`:

```bash
apt list --upgradable
```

`update` and `upgrade` are the classic mix-up: `update` refreshes the **list**, `upgrade`
installs the **software**. An upgrade without a recent update finds nothing new.

#### Upgrading a Package from a Package File

**Administrator.**

```text
rpm -U emacs-22.1-7.fc7-i386.rpm      (book: Red Hat style)
sudo dpkg -i package_file.deb         (book: dpkg has no separate "upgrade" option)
sudo apt install ./package_file.deb   (Mint now: replaces the older version)
```

#### Listing Installed Packages

```bash
dpkg -l | less                   # book, Debian style (q quits)
dpkg -l bash                     # one package
apt list --installed | wc -l     # how many lines apt lists (one per package, plus a header)
```

In `dpkg -l`, each package is one line: two status letters, the name, the version, the
architecture and a description. `ii` means "wanted installed, and installed". For `bash` the
line starts `ii  bash` and ends `GNU Bourne Again SHell`. `apt` prints a warning when its
output goes into a pipe; it is harmless (it goes to the screen, not into `wc`). The book's
Red Hat command is `rpm -qa`.

#### Determining Whether a Package is Installed

```bash
dpkg --status emacs              # book, Debian style
dpkg -s bash | head -n 3         # a package every system has (-s is short for --status)
```

```text
dpkg-query: package 'emacs' is not installed and no information is available
Use dpkg --info (= dpkg-deb --info) to examine archive files.
```

```text
Package: bash
Essential: yes
Status: install ok installed
```

`install ok installed` is the answer you want. The book's Red Hat command is `rpm -q emacs`.

#### Displaying Information About an Installed Package

```bash
apt-cache show emacs | less      # book, Debian style: still works
apt show emacs | less            # Mint now: version, size, dependencies, description
```

Both work for packages you have not installed too, because they read the repository
metadata. The book's Red Hat command is `yum info emacs`.

#### Finding Which Package Installed a File

The book's example is for Red Hat: `rpm -qf /usr/bin/vim`. The Debian-style command is
`dpkg -S`:

```bash
dpkg -S /usr/bin/ls                       # coreutils: /usr/bin/ls
dpkg -S /usr/bin/vim                      # no path found (see below)
dpkg -S "$(readlink -f /usr/bin/vi)"      # follow the link to the real program first
dpkg -S /etc/passwd                       # no path found: no package owns this file
```

```text
coreutils: /usr/bin/ls
dpkg-query: no path found matching pattern /usr/bin/vim
vim: /usr/bin/vim.basic
dpkg-query: no path found matching pattern /etc/passwd
```

Read an answer as `package: file`. `/usr/bin/vim` and `/usr/bin/vi` are symbolic links that
the system's "alternatives" mechanism creates, not files that came in a package, so `dpkg`
does not know them. `readlink -f` (not in the book) prints the real file a link leads to:
`/usr/bin/vim.basic` with full vim, or `/usr/bin/vim.tiny`, owned by `vim-tiny`, on a system
that has only the small vim. Ask about `/bin/ls` and you get "no path found" as well: `/bin`
is a link to `/usr/bin` on current systems, and `dpkg` knows each file only by the path its
package used.

**A correction to the slides.** `dpkg -S /etc/passwd` does not name a package. The account
file is created when the system is installed, from a template, so no package owns it, and
`dpkg` says "no path found". The same is true of other files written at install time, such as
`/etc/fstab`.

### Summing Up; The Linux Software Installation Myth

No commands. On Linux, almost all software, device drivers included, comes from your
distribution's repositories, built to fit the system. Hardware is a problem only when the
device is very new, very unusual, or its maker keeps the details secret. Newer than the book:
Flatpak (Mint's Software Manager uses it) and Snap (Ubuntu's) are a second kind of package
that carries its own libraries, so one package runs on many distributions.

## Common mistakes

| You type | What the system says | Fix |
|---|---|---|
| `apt-get install emacs` as an ordinary user | `E: Could not open lock file /var/lib/dpkg/lock-frontend - open (13: Permission denied)` | Installing is an administrator job: on your own machine, `sudo apt install emacs` |
| `yum search emacs` on Mint | `yum: command not found` | Mint is Debian style: `apt search emacs` |
| `dpkg -S /usr/bin/vim` | `dpkg-query: no path found matching pattern /usr/bin/vim` | It is a link: `dpkg -S "$(readlink -f /usr/bin/vim)"` |
| `dpkg -S /bin/ls` | `dpkg-query: no path found matching pattern /bin/ls` | Ask with the path the package used: `dpkg -S /usr/bin/ls` |
| `dpkg -S /etc/passwd` | `dpkg-query: no path found matching pattern /etc/passwd` | Correct answer: no package owns a file created at install time |
| `apt list --installed \| wc -l` | `WARNING: apt does not have a stable CLI interface. Use with caution in scripts.` | Harmless; add `2>/dev/null`, or use `dpkg -l` |
| `sudo dpkg -i file.deb` (administrator) | `dependency problems prevent configuration` | `sudo apt install -f`, or install with `sudo apt install ./file.deb` |

## Check yourself

1. What is the difference between a high-level and a low-level package tool? Name one of each
   for Mint.
   <details><summary>Answer</summary>A high-level tool (<code>apt</code>) works with repositories:
   it searches the metadata, works out the dependencies and downloads everything needed. A
   low-level tool (<code>dpkg</code>) installs, removes and queries one package file and knows
   nothing about repositories or missing dependencies.</details>
2. Explain `apt update` and `apt upgrade` in one sentence each.
   <details><summary>Answer</summary><code>apt update</code> downloads the newest lists of what the
   repositories offer and installs nothing. <code>apt upgrade</code> installs the newer versions
   those lists name. Both are administrator commands.</details>
3. Which command tells you whether `bash` is installed, and what line do you look for?
   <details><summary>Answer</summary><code>dpkg -s bash</code> (or <code>dpkg --status bash</code>);
   the line <code>Status: install ok installed</code>.</details>
4. `dpkg -S /usr/bin/vim` and `dpkg -S /etc/passwd` both answer "no path found". Why, in each
   case?
   <details><summary>Answer</summary><code>/usr/bin/vim</code> is a link made by the alternatives
   system; the package installed the file it points to (<code>/usr/bin/vim.basic</code>).
   <code>/etc/passwd</code> was created when the system was installed, so no package owns it.</details>
