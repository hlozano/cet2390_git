# Chapter 16: Networking

*The Linux Command Line* (TLCL), chapter 16. The book is free: https://linuxcommand.org/tlcl.php

This chapter is in the book but not on the current CET 2390 schedule; it is here for study on your own.

## What you will learn

- `ping` asks "can I reach that machine?"; `traceroute` (or `tracepath`) lists every router
  on the way there.
- `ip` shows this machine's network interfaces, addresses and routes. The book's `netstat`
  is no longer installed on Mint; `ip` and `ss` do its jobs.
- `wget` downloads files from the web. The old `ftp` program sends passwords as plain text
  and is not installed any more.
- `ssh` gives you an encrypted shell on another machine and can run a single command there.
  `scp` and `sftp` copy files through the same encrypted connection.
- Which of these commands need an administrator, and why.

## Files in this folder

This chapter has no scripts and no data files. The book's examples are commands you type at
the prompt, explained below.

## The book's examples

The commands that only look at the network run as yourself. A few things in this chapter
need `sudo` (the machine's administrator password): installing a missing program and
running an ssh server. Those are marked **Administrator** and shown in plain `text` blocks.
Run them only on a machine you own and administer, such as your own virtual machine; never
on a shared lab or school computer.

Where the book is out of date, the guide shows what to type on Linux Mint now:

| The book says | On Mint now | Why |
|---|---|---|
| `netstat -ie` | `ip -s link` (or `ip a`) | The `net-tools` package (`netstat`, `ifconfig`) is no longer installed |
| `netstat -r` | `ip route` | Same |
| (listening ports with `netstat`) | `ss -tuln` | Same |
| `traceroute` | `tracepath`, or install `traceroute` (administrator) | Not always installed |
| `ftp` | `sftp`, `scp` | Not installed; `ftp` sends passwords as plain text |
| `telnet`, `rlogin` | `ssh` | Not installed; plain text, as the book warns |
| delete a line of `~/.ssh/known_hosts` by hand | `ssh-keygen -R host` | Removes the old key for you |
| PuTTY on Windows | `ssh`, `scp`, `sftp` in Windows PowerShell | Built into Windows 10 and 11 |

Commands that save a file (`wget`, `scp`, `sftp`, the ssh redirection examples) go in a
practice folder:

```bash
mkdir -p ~/playground
cd ~/playground
```

The book assumes you know three terms: an **IP address** (a machine's number on a network,
such as `10.0.2.15`), a **host name** and **domain name** (the human name, such as
`linuxcommand.org`), and a **URI** (a full address such as `http://linuxcommand.org/index.php`).

### Examining and Monitoring a Network

The heading for the next four sections; no commands of its own.

### ping

`ping` sends a small "echo request" packet to a host and waits for the reply.

```bash
ping linuxcommand.org           # one packet a second until you press Ctrl-c
ping -c 3 linuxcommand.org      # -c 3: three packets, then stop (not in the book)
```

```text
PING linuxcommand.org (216.105.38.11) 56(84) bytes of data.
64 bytes from secureprojects.sourceforge.net (216.105.38.11): icmp_seq=1 ttl=51 time=64.1 ms
64 bytes from secureprojects.sourceforge.net (216.105.38.11): icmp_seq=2 ttl=51 time=63.5 ms
64 bytes from secureprojects.sourceforge.net (216.105.38.11): icmp_seq=3 ttl=51 time=63.1 ms

--- linuxcommand.org ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2003ms
rtt min/avg/max/mdev = 63.058/63.538/64.105/0.431 ms
```

The first line shows the address the name turned into. Each reply shows how long the round
trip took. `0% packet loss` means the network between you and that host works: interface,
cabling, routing and gateways. Some hosts and firewalls ignore ping packets on purpose, so no
answer does not always mean a broken network.

### traceroute

`traceroute` lists every **hop** (router) between you and a host. It is often not installed;
`tracepath`, which the book names too, does the same job and needs no installing on many
systems:

```bash
tracepath slashdot.org          # book: traceroute slashdot.org
```

**Administrator** (to get the book's command):

```text
sudo apt install traceroute
```

After that, `traceroute slashdot.org` works for any user. Each numbered line is one hop: the
router's name and address, then three round-trip times (it sends three probes per hop). A
line of `* * *` is a router that did not answer, usually because of a firewall; the traffic
still passes through it. Hop 1 is your own gateway. The book's `-T` and `-I` options, which
sometimes get past a silent router, need root on current systems.

### ip

`ip` shows (and, for an administrator, changes) the network interfaces and the routing table.
It replaced the old `ifconfig`.

```bash
ip a                            # every interface, in detail (a is short for address)
ip -br addr                     # one brief line per interface (not in the book)
```

On a VirtualBox virtual machine, `ip -br addr` looks like this (trimmed; your names and
numbers differ):

```text
lo               UNKNOWN        127.0.0.1/8 ::1/128
enp0s3           UP             10.0.2.15/24 fe80::...
```

`lo` is the **loopback** interface, a virtual one the machine uses to talk to itself. The
other is the network card: the book's `eth0` is the old naming, current systems use names
like `enp0s3`. In the full `ip a` listing, the book says to look for two things: `UP` on the
interface's first line (the interface is enabled) and an address on the `inet` line. A valid
address there also tells you that DHCP, the service that hands out addresses, is working.

### netstat

`netstat` is no longer installed on Mint (typing it gives `command not found`). Its jobs, done
with `ip` and `ss`:

```bash
ip -s link                      # book: netstat -ie (interfaces, with packet and error counts)
ip route                        # book: netstat -r (the routing table)
ss -tuln                        # the ports this machine listens on (not in the book)
```

`ip route` on a typical VirtualBox virtual machine:

```text
default via 10.0.2.2 dev enp0s3 proto dhcp src 10.0.2.15 metric 100
10.0.2.0/24 dev enp0s3 proto kernel scope link src 10.0.2.15 metric 100
```

Read each line as "to reach this destination, go that way". `10.0.2.0/24 dev enp0s3`: the
local network is reached directly through the card, with no gateway. `default via 10.0.2.2`:
everything else goes to the **gateway** (the router) at `10.0.2.2`. This is the book's
`default` line in a newer format.

**A correction to the slides.** The order of the lines does not matter, and `default` does
not mean "whatever is not listed above it". For each packet the kernel picks the **most
specific** route that matches the destination. `default` (every address, `0.0.0.0/0`) is the
least specific, so it is used only when no other line matches; here `ip route` even prints it
first.

`ss -tuln` lists the **sockets** (network endpoints) that are waiting for connections: `t`
TCP, `u` UDP, `l` listening only, `n` numbers instead of names. On Mint you will probably
see a line like `udp UNCONN 0 0 127.0.0.53%lo:53 0.0.0.0:*`: the local name-lookup service,
listening on port 53. Once `openssh-server` is installed (below), a `tcp LISTEN` line for
port 22 appears too.

### Transporting Files Over a Network

The heading for `ftp`, `lftp` and `wget`; no commands of its own.

### ftp

`ftp` talks to FTP servers, the main way to download files before the web. It sends your
name and password as plain text, so anyone watching the network can read them, and it is not
installed on Mint. The book's session, for reading (Table 16-1); `sftp`, below, does the same
job encrypted:

| Typed in the session | What it does |
|---|---|
| `ftp fileserver` | Start `ftp` and connect to the FTP server named `fileserver` |
| `anonymous` | The login name for a public server; a password prompt follows |
| `cd pub/cd_images/Ubuntu-18.04` | Change directory **on the server** (public files are usually under `pub`) |
| `ls` | List the server's directory |
| `lcd Desktop` | Change directory on **your** machine (`l` for local) |
| `get ubuntu-18.04-desktop-amd64.iso` | Copy the file from the server to your current local directory |
| `bye` | Log off and end the session (`quit` and `exit` also work) |

### lftp - A Better ftp

No commands. `lftp` works like `ftp` with more features (several protocols, retries, tab
completion). It is not installed by default either, and it has the same plain-text problem
unless the server uses encryption.

### wget

`wget` downloads files from the web (and FTP sites): one file, many files or a whole site.

```bash
cd ~/playground
wget http://linuxcommand.org/index.php
ls -l index.php
```

`wget` prints its progress (trimmed here; it also prints the date and time on its first and
last lines):

```text
Resolving linuxcommand.org (linuxcommand.org)... 216.105.38.11
Connecting to linuxcommand.org (linuxcommand.org)|216.105.38.11|:80... connected.
HTTP request sent, awaiting response... 200 OK
Length: 3956 (3.9K) [text/html]
Saving to: 'index.php'
```

`200 OK` is the web server's "here it is". The page is saved as `index.php` in the current
folder. The size changes whenever the site changes.

### Secure Communication with Remote Hosts

No commands. `rlogin` and `telnet`, the old remote-login programs, send everything (passwords
included) as plain text, so they are "wholly inappropriate for use in the Internet age". They
are not installed on Mint.

### ssh

SSH (Secure Shell) solves the two problems: it **authenticates** the remote host (it is who it
says it is) and it **encrypts** everything sent between the two machines. An SSH **server**
runs on the remote machine and listens on port 22; the `ssh` **client** runs on yours.

You need a machine to connect to, where you have an account. Put its name where the book
writes `remote-sys`. The book's tip, if you have no second machine: install the server on
your own virtual machine and connect to `localhost`, your own machine.

**Administrator** (your own virtual machine only):

```text
sudo apt install openssh-server
```

Then, as yourself:

```bash
ssh localhost                   # book: ssh remote-sys
```

The first time, `ssh` cannot confirm the host and asks:

```text
The authenticity of host 'localhost (127.0.0.1)' can't be established.
ED25519 key fingerprint is SHA256:...
Are you sure you want to continue connecting (yes/no/[fingerprint])?
```

Type `yes`. `ssh` records the host's key in `~/.ssh/known_hosts` (`Warning: Permanently
added ...`) and asks for your password on that machine. Then you get its prompt, and every
command you type runs there until you type `exit`. A current system shows an ED25519 key with
a `SHA256:` fingerprint; the book's example shows an older RSA key.

```bash
exit                            # back to your own prompt
ssh "$USER"@localhost           # book: ssh bob@remote-sys (log in as another account name)
exit
```

`user@host` logs in to the account `user` on `host`; without it, `ssh` uses your own user
name.

If `ssh` ever prints `WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!`, the key the host
sends is not the one recorded. It may be an attacker in the middle, or the remote system may
have been reinstalled. Ask whoever runs that machine before you go on. Once you know the
change is harmless, remove the old key (the book edits `known_hosts` with vim; this command
does it for you):

```bash
ssh-keygen -R remote-sys        # use the host's real name, such as localhost
```

```text
# Host localhost found: line 1
/home/student/.ssh/known_hosts updated.
Original contents retained as /home/student/.ssh/known_hosts.old
```

`ssh` can also run **one command** on the remote machine and show the result here:

```bash
ssh localhost free              # book: ssh remote-sys free
```

`free` reports memory; its output starts with a header line, `total  used  free  shared
buff/cache  available`, then one line for memory (`Mem:`) and one for swap. The book's copy
shows an older layout.

```bash
cd ~/playground
ssh localhost 'ls *' > dirlist.txt    # book: ssh remote-sys 'ls *' > dirlist.txt
cat dirlist.txt
```

The single quotes keep your shell from expanding `*`: the remote shell expands it, in your
home directory over there. The `>` is outside the quotes, so your own shell redirects the
output, and `dirlist.txt` lands here, in `~/playground`. Put the redirection inside the quotes
and the file is written on the remote machine instead. The book's line is
`ssh remote-sys 'ls * > dirlist.txt'`; with `localhost`, "over there" is your own home
directory, so this version moves into the practice folder first:

```bash
ssh localhost 'cd playground && ls * > dirlist2.txt'   # the file is written by the remote shell
```

### Tunneling with SSH

An ssh connection is an encrypted **tunnel**, and other traffic can travel through it. The
classic use is running a graphical program on the remote machine with its window on your
screen:

```bash
ssh -X localhost                # book: ssh -X remote-sys
xload                           # at the remote prompt: a small graphical program
exit
```

`xload` is part of the `x11-apps` package and is often not installed. X forwarding needs an
X11 desktop session (Mint's default); on a Wayland session it may not work. The book says to
try `-Y` if `-X` fails.

### scp and sftp

`scp` (secure copy) works like `cp`, except that a source or destination may start with a host
name and a **colon**: `host:path` means "that path on that host". A relative path after the
colon starts in your home directory there.

```bash
cd ~/playground
scp localhost:/etc/hostname .          # book: scp remote-sys:document.txt .
scp "$USER"@localhost:/etc/hostname .  # book: scp bob@remote-sys:document.txt .
ls -l hostname
```

There is no `document.txt` on a new machine, so these lines copy `/etc/hostname`, which every
machine has. `.` (the current directory) is the destination. `scp` prints one progress line
per file: its name, `100%`, the size and the speed.

**A correction to the slides.** The silent `scp` mistake is a missing colon. Without it, both
names are local, so `scp notes.txt student@localhost` makes a local copy named
`student@localhost`, prints nothing, and returns success. Check with `ls`, and remove the
stray file with `rm`.

`sftp` is the encrypted replacement for the `ftp` session above. It needs only the SSH server
on the other machine, not an FTP server:

```bash
cd ~/playground
sftp localhost                  # book: sftp remote-sys
```

At the `sftp>` prompt:

| Typed at `sftp>` | What it does |
|---|---|
| `ls` | List your home directory over there |
| `lpwd` | Print the local directory (`l` for local): here `~/playground`, where you started `sftp` |
| `get /etc/hostname` | Copy the file into the current local directory |
| `bye` | End the session |

`lcd dir` changes the local directory, as in the book's `lcd Desktop`, so a later `get` saves
there.

Graphical file managers accept `sftp://` addresses too: in Mint's file manager, `sftp://localhost`
in the location bar shows your files through the same connection.

When you are done with the ssh examples on your own virtual machine, you may remove the
server again (a machine that accepts logins is a machine someone can try to log in to).

**Administrator:**

```text
sudo apt remove openssh-server
```

### An SSH Client for Windows?

No Linux commands. The book recommends PuTTY. Windows 10 and 11 now include `ssh`, `scp` and
`sftp`; open PowerShell and use them exactly as above.

### Summing Up

No commands. Linux runs much of the Internet's networking equipment, and many more network
tools can be installed; the basic set above already covers checking a connection, moving
files and working on another machine.

## Common mistakes

| You type | What the system says | Fix |
|---|---|---|
| `netstat -r` or `ifconfig` | `command not found` | `ip route`, `ip a` (or `ip -br addr`) |
| `traceroute slashdot.org` | `command not found` | `tracepath slashdot.org`, or install `traceroute` (administrator) |
| `ftp fileserver` | `command not found` | `sftp host` |
| `ping linuxcommand.org`, and it never stops | (replies, one a second) | `Ctrl-c`; next time `ping -c 3` |
| `ping` with no network or no name service | `ping: linuxcommand.org: Temporary failure in name resolution` | Try `ping -c 3 8.8.8.8`; if that works, name lookup (DNS) is the problem; also check `ip route` for a `default via` line |
| `ssh localhost` with no server running | `ssh: connect to host localhost port 22: Connection refused` | The machine you connect **to** needs `openssh-server` (administrator) |
| A wrong password or user name | `Permission denied, please try again.` | The password is the one for that account on the other machine; check `user@host` |
| `scp notes.txt student@localhost` | nothing, and success | The colon is missing: `scp notes.txt student@localhost:` |
| `ssh remote-sys` after the host was reinstalled | `WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!` | Ask the machine's administrator; once sure, `ssh-keygen -R remote-sys` |

## Check yourself

1. `ping -c 3 8.8.8.8` works but `ping -c 3 linuxcommand.org` fails with `Temporary failure in
   name resolution`. What is broken, and what is not?
   <details><summary>Answer</summary>The network works (packets reach an address and come back).
   What fails is name resolution: turning the name into an address (DNS).</details>
2. In `ip route`, what does the `default via` line tell you, and does it matter that it is
   printed first?
   <details><summary>Answer</summary>It names the gateway that receives every packet bound for a
   network not covered by a more specific route. The order does not matter: the kernel always
   picks the most specific route that matches, and <code>default</code> is the least specific.</details>
3. Name the two problems SSH solves that `ftp` and `telnet` do not.
   <details><summary>Answer</summary>It authenticates the remote host (so you know you reached
   the right machine) and it encrypts everything, passwords included.</details>
4. In `ssh localhost 'ls *' > dirlist.txt`, which machine expands the `*`, and where is
   `dirlist.txt` written?
   <details><summary>Answer</summary>The quotes send <code>ls *</code> to the remote shell, which
   expands the <code>*</code>. The <code>&gt;</code> is outside the quotes, so your local shell
   writes <code>dirlist.txt</code> in your current local directory.</details>
5. You ran `scp report.txt student@server` and saw no error, but nothing arrived on the server.
   Why?
   <details><summary>Answer</summary>Without a colon, <code>student@server</code> is just a local
   file name, so <code>scp</code> made a local copy with that name. The destination must be
   <code>student@server:</code> (or <code>student@server:path</code>).</details>
