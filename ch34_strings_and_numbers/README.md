# Chapter 34: Strings and Numbers

*The Linux Command Line* (TLCL), chapter 34. The book is free: https://linuxcommand.org/tlcl.php

## What you will learn

- **Parameter expansion** changes the text in a variable as it is used, without running another
  program: its length (`${#name}`), upper or lower case (`${name^^}`, `${name,,}`), a piece cut
  off the front or the end (`${name#...}`, `${name%...}`), or a search and replace
  (`${name//old/new}`). The variable itself does not change.
- `$(( ))` does whole-number arithmetic: `+ - * / % **`. Division throws the fraction away
  (`5 / 2` is 2), and the remainder operator `%` tells you what was left over.
- Assignment operators such as `++` and `+=` change a variable in place, and the ternary
  operator `test ? this : that` is a one-line if/else inside `(( ))`.
- For decimals, bash hands the work to `bc`, a calculator program, through a pipe, a here
  string or a here document.

## Files in this folder

| File | Book name | What it shows |
|---|---|---|
| `book_01_longest_word3.sh` | `longest-word3` | The longest word in each file you name, each word measured with `${#j}` |
| `book_02_ul_declare.sh` | `ul-declare` | `declare -u` and `declare -l`: variables that always store uppercase or lowercase |
| `book_03_ul_param.sh` | `ul-param` | The four case expansions `${1,,}` `${1,}` `${1^^}` `${1^}` |
| `book_04_modulo.sh` | `modulo` | `%` in a loop: brackets around every multiple of 5 |
| `book_05_modulo2.sh` | `modulo2` | The same loop tightened with `++i` and the test inside one `(( ))` |
| `book_06_arith_loop.sh` | `arith-loop` | A table of squares and cubes: `**`, `until` and the ternary operator |
| `book_07_loan_calc.sh` | `loan-calc` | A monthly loan payment: `$#` checks the input, `bc` does the decimals |

## How to run

```bash
cd ch34_strings_and_numbers
chmod u+x *.sh
./book_04_modulo.sh
```

`chmod u+x` gives you, the owner of the files (`u`), permission to execute them (`x`); `./`
means "the program is in this folder". Some of these scripts read the words you type after the
script's name: in `./book_03_ul_param.sh aBc`, the word `aBc` becomes `$1`, "the first word
after the script's name" (positional parameters are chapter 32, which CET 2390 does not teach;
each script's section explains the one or two it uses).

Two programs these scripts call may be missing from a fresh machine: `bc` (for
`book_07_loan_calc.sh`) and `strings`, from the GNU binutils package (for
`book_01_longest_word3.sh`). If bash says `command not found` for one of them, install that
package with your system's package manager (chapter 14) or ask your instructor.

The examples that create files work in a practice folder, `~/playground`, so your own files are
never touched. If a script stops with `/bin/bash^M: bad interpreter`, the file has Windows line
endings; this fixes every script in the folder:

```bash
sed -i 's/\r$//' *.sh
```

## Walkthrough

### book_01_longest_word3.sh

Chapter 33's `longest-word2`, with one line changed to make it much faster.

```bash
#!/bin/bash

# longest-word3: find longest string in a file

for i; do
    if [[ -r "$i" ]]; then
        max_word=
        max_len=0
        for j in $(strings $i); do
            len="${#j}"
            if (( len > max_len )); then
                max_len="$len"
                max_word="$j"
            fi
        done
        echo "$i: '$max_word' ($max_len characters)"
    fi
done
```

| Line | What it does |
|---|---|
| `for i; do` | A `for` with no list walks the words typed after the script's name: one file name per pass. |
| `if [[ -r "$i" ]]; then` | Skips a file you cannot read. |
| `max_word=` / `max_len=0` | Resets the record for each file. |
| `for j in $(strings $i); do` | `strings` prints the readable text in the file; the unquoted `$( )` splits it into words, one per pass. This listing writes `$i` without quotes, where `longest-word2` had `"$i"`: a file name with a space is split in two. |
| `len="${#j}"` | **The change.** `${#j}` is the number of characters in `j`'s value, counted by bash itself. `longest-word2` ran `$(echo -n "$j" \| wc -c)`, which starts a new shell and two programs for every word. |
| `if (( len > max_len )); then` ... `fi` | Keeps the longest word so far. |
| `echo "$i: '$max_word' ($max_len characters)"` | Prints the file name and the winner. |

Make two small files in the practice folder and run it (`>` saves `echo`'s line in a new file:
redirection, chapter 6):

```bash
mkdir -p ~/playground
echo "The quick brown fox jumps over the lazy dog" > ~/playground/fox.txt
echo "one two three four five six seven" > ~/playground/count.txt
./book_01_longest_word3.sh ~/playground/fox.txt ~/playground/count.txt
```

```
/home/student/playground/fox.txt: 'quick' (5 characters)
/home/student/playground/count.txt: 'three' (5 characters)
```

Your user name appears in place of `student` (`~` is your home folder). The book timed both
versions on a list of the programs in `/usr/bin`: 3.618 seconds became 0.060. Repeat the test
(the times depend on your machine; the chapter 33 script needs `chmod u+x` in its own folder
first):

```bash
ls /usr/bin > ~/playground/dirlist-usr-bin.txt
time ../ch33_flow_control_looping_with_for/book_03_longest_word2.sh ~/playground/dirlist-usr-bin.txt
time ./book_01_longest_word3.sh ~/playground/dirlist-usr-bin.txt
```

On a test machine with 905 names, both found `dbus-update-activation-environment`
(34 characters); `time` reported `real 0m1.488s` for `longest-word2` and `real 0m0.013s` for
`longest-word3`.

Try this:

- Make a file whose name has a space, and run the script on it:

  ```bash
  echo "hello there" > ~/playground/"my notes.txt"
  ./book_01_longest_word3.sh ~/playground/"my notes.txt"
  ```

  ```
  strings: '/home/student/playground/my': No such file
  strings: 'notes.txt': No such file
  /home/student/playground/my notes.txt: '' (0 characters)
  ```

  The unquoted `$i` in `$(strings $i)` split the name in two. Chapter 33's version, with
  `"$i"`, reports `'hello' (5 characters)`.
- At the prompt: `title="CET 2390"; echo ${#title}`. Do spaces count? (It prints 8.)

### book_02_ul_declare.sh

Prints the word you type after the script's name in uppercase, then in lowercase.

```bash
#!/bin/bash

# ul-declare: demonstrate case conversion via declare

declare -u upper
declare -l lower

if [[ $1 ]]; then
        upper="$1"
        lower="$1"
        echo "$upper"
        echo "$lower"
fi
```

| Line | What it does |
|---|---|
| `declare -u upper` | Gives `upper` the uppercase attribute: whatever is assigned to it is stored in capitals. |
| `declare -l lower` | The same for lowercase. |
| `if [[ $1 ]]; then` | `$1` is the first word typed after the script's name; `[[ ]]` with a value and no operator is true when the value is not empty. No word, no output. |
| `upper="$1"` / `lower="$1"` | The same word goes into both variables; each stores it in its own case. |
| `echo "$upper"` / `echo "$lower"` | Prints the two results. |

```bash
./book_02_ul_declare.sh aBc
```

```
ABC
abc
```

Converting input to one standard form before you use it is called **normalizing**: after it,
`Yes`, `YES` and `yes` are the same answer.

Try this:

- Run `./book_02_ul_declare.sh hello World`. It prints only `HELLO` and `hello`: without
  quotes, `World` is a second word (`$2`), which the script never uses. With quotes,
  `"hello World"` is one word and prints `HELLO WORLD` and `hello world`.
- At the prompt: `declare -u shout; shout="quiet please"; echo "$shout"`.

### book_03_ul_param.sh

The same idea with parameter expansion and no `declare`.

```bash
#!/bin/bash

# ul-param: demonstrate case conversion via parameter expansion

if [[ "$1" ]]; then
        echo "${1,,}"
        echo "${1,}"
        echo "${1^^}"
        echo "${1^}"
fi
```

| Line | What it does |
|---|---|
| `if [[ "$1" ]]; then` | True when the first word after the script's name is not empty. |
| `echo "${1,,}"` | Two commas: every character lowercase. |
| `echo "${1,}"` | One comma: only the first character lowercase. |
| `echo "${1^^}"` | Two carets: every character uppercase. |
| `echo "${1^}"` | One caret: only the first character uppercase. |

The `1` inside the braces is the parameter's name; the same expansions work on any variable,
such as `${name^}`. Unlike `ul-declare`, the variable keeps what was typed: the conversion
happens when the value is used.

```bash
./book_03_ul_param.sh aBc
```

```
abc
aBc
ABC
ABc
```

The second line looks unchanged because the first character, `a`, was already lowercase.

Try this:

- Run `./book_03_ul_param.sh "ana rivera"`. The last line is `Ana rivera`: `^` changes the first
  character of the whole value, not of each word.
- At the prompt: `answer="YeS"; [[ ${answer,,} == yes ]] && echo "accepted"`. One test now
  accepts every mix of capitals.

### book_04_modulo.sh

Prints 0 to 20 on one line, with brackets around every multiple of 5.

```bash
#!/bin/bash

# modulo: demonstrate the modulo operator

for ((i = 0; i <= 20; i = i + 1)); do
    remainder=$((i % 5))
    if (( remainder == 0 )); then
        printf "<%d> " "$i"
    else
        printf "%d " "$i"
    fi
done
printf "\n"
```

| Line | What it does |
|---|---|
| `for ((i = 0; i <= 20; i = i + 1)); do` | Chapter 33's C language form of `for`: `i` from 0 up to and including 20. |
| `remainder=$((i % 5))` | `$(( ))` is **arithmetic expansion**, replaced by the result. `%` (modulo) is the remainder of a division: 7 % 5 is 2, 10 % 5 is 0. |
| `if (( remainder == 0 )); then` | `==` compares. The remainder is 0 exactly on the multiples of 5. |
| `printf "<%d> " "$i"` | `printf` (chapter 21) prints its format and puts the next argument where `%d` is, as a whole number. It adds no line break, so the numbers stay on one line. |
| `printf "%d " "$i"` | The other numbers, with no brackets. |
| `printf "\n"` | After the loop, ends the line. |

```bash
./book_04_modulo.sh
```

```
<0> 1 2 3 4 <5> 6 7 8 9 <10> 11 12 13 14 <15> 16 17 18 19 <20>
```

Bash arithmetic uses whole numbers only, so division throws the fraction away; `%` tells you
what was left over:

```bash
echo $(( 17 / 5 )) $(( 17 % 5 ))
```

```
3 2
```

Try this:

- Change `% 5` to `% 3`. Which numbers get brackets now? (0, 3, 6, 9, 12, 15 and 18.)
- In a copy, delete the last line, `printf "\n"`. Where does your prompt appear, and why?

### book_05_modulo2.sh

The same output from a shorter program.

```bash
#!/bin/bash

# modulo2: demonstrate the modulo operator

for ((i = 0; i <= 20; ++i )); do
    if (((i % 5) == 0 )); then
        printf "<%d> " "$i"
    else
        printf "%d " "$i"
    fi
done
printf "\n"
```

| Line | What it does |
|---|---|
| `for ((i = 0; i <= 20; ++i )); do` | The step `i = i + 1` became `++i`: the increment operator, "add 1 to i". |
| `if (((i % 5) == 0 )); then` | The `remainder` variable is gone: the outer `(( ))` is the test, and the inner `( )` groups `i % 5` so it is read first. |
| The `printf` lines | Unchanged. |

```
<0> 1 2 3 4 <5> 6 7 8 9 <10> 11 12 13 14 <15> 16 17 18 19 <20>
```

`++i` and `i++` both add 1; they differ in the value they hand back. `++i` adds first and gives
the new value; `i++` gives the old value, then adds:

```bash
i=1; echo $(( i++ )); echo $i
i=1; echo $(( ++i ))
```

```
1
2
2
```

As the step of a `for` loop nobody uses that value, so both forms give the same output; the
book prefers `++i`. The other assignment operators work the same way: `(( total += 5 ))` adds
5 to `total`, and `-=`, `*=`, `/=` and `%=` follow the same pattern.

Try this:

- In a copy, make the step `i += 5`. The output becomes `<0> <5> <10> <15> <20>`: why does every
  number get brackets?

### book_06_arith_loop.sh

A table of the numbers 0 to 10 with their squares and cubes.

```bash
#!/bin/bash

# arith-loop: script to demonstrate arithmetic operators

finished=0
a=0
printf "a\ta**2\ta**3\n"
printf "=\t====\t====\n"

until ((finished)); do
    b=$((a**2))
    c=$((a**3))
    printf "%d\t%d\t%d\n" "$a" "$b" "$c"
    ((a<10?++a:(finished=1)))
done
```

| Line | What it does |
|---|---|
| `finished=0` / `a=0` | Starting values. |
| `printf "a\ta**2\ta**3\n"` / `printf "=\t====\t====\n"` | The two heading lines. `\t` is a tab, which lines up the columns; `\n` ends the line. |
| `until ((finished)); do` | Inside `(( ))`, 0 is false and any other number is true. `until` loops while its test is false (chapter 29), so it runs while `finished` is 0. |
| `b=$((a**2))` / `c=$((a**3))` | `**` is the power operator: the square and the cube of `a`. |
| `printf "%d\t%d\t%d\n" "$a" "$b" "$c"` | One row: three whole numbers separated by tabs. |
| `((a<10?++a:(finished=1)))` | The **ternary operator**, `test ? this : that`: if `a<10`, add 1 to `a`; otherwise set `finished` to 1, which ends the loop. After the row for 10, `a<10` is false, so 10 is the last row. |

```
a       a**2    a**3
=       ====    ====
0       0       0
1       1       1
2       4       8
3       9       27
4       16      64
5       25      125
6       36      216
7       49      343
8       64      512
9       81      729
10      100     1000
```

The parentheses around `finished=1` are required. Without them bash reads the expression the
wrong way:

```bash
a=10; finished=0; ((a<10?++a:finished=1))
```

```
bash: ((: a<10?++a:finished=1: attempted assignment to non-variable (error token is "=1")
```

Try this:

- Which one change makes the table stop at 5? Predict the last row before you run it.
- At the prompt, run `a=0; ((a<1?++a:--a)); echo $a` and then `((a<1?++a:--a)); echo $a`. The
  book calls this a toggle: `a` switches between 1 and 0.

### book_07_loan_calc.sh

The monthly payment on a loan, from three numbers typed after the script's name: the amount,
the yearly interest rate as a decimal, and the number of months.

```bash
#!/bin/bash

# loan-calc: script to calculate monthly loan payments

PROGNAME="${0##*/}" # Use parameter expansion to get basename

usage () {
    cat <<- EOF
	Usage: $PROGNAME PRINCIPAL INTEREST MONTHS

	Where:

	PRINCIPAL is the amount of the loan.
	INTEREST is the APR as a number (7% = 0.07).
	MONTHS is the length of the loan's term.

	EOF
}

if (($# != 3)); then
    usage
    exit 1
fi

principal=$1
interest=$2
months=$3

bc <<- EOF
	scale = 10
	i = $interest / 12
	p = $principal
	n = $months
	a = p * ((i * ((1 + i) ^ n)) / (((1 + i) ^ n) - 1))
	print a, "\n"
EOF
```

| Line | What it does |
|---|---|
| `PROGNAME="${0##*/}"` | `$0` holds the name the script was run with, such as `./book_07_loan_calc.sh`. `##*/` removes the longest match of `*/` from the front (everything up to the last `/`), leaving the bare name. |
| `usage () { cat <<- EOF` ... `EOF }` | A function that prints the help text with a here document (chapter 25). `<<-` removes the **tabs** at the start of each line, so the text can be indented in the script. |
| `if (($# != 3)); then` ... `fi` | `$#` is how many words were typed after the script's name. Anything but three prints the usage and `exit 1` stops the script, before any math. |
| `principal=$1` / `interest=$2` / `months=$3` | The first, second and third words typed after the script's name. |
| `bc <<- EOF` | Hands the lines below to `bc` as its input. Bash first replaces `$interest`, `$principal` and `$months` with the numbers. |
| `scale = 10` | `bc` keeps 10 digits after the decimal point. |
| `i = $interest / 12` | The monthly rate: the yearly rate divided by 12. |
| `p = $principal` / `n = $months` | The amount and the number of months. |
| `a = p * ((i * ((1 + i) ^ n)) / (((1 + i) ^ n) - 1))` | The standard loan-payment formula. In `bc`, `^` is the power operator (bash writes `**`). |
| `print a, "\n"` | Prints the payment and a line break. |
| `EOF` | Ends the here document. It starts at the left edge; with `<<-` a tab before it would work too. |

The book's example: $135,000 at 7.75% a year for 180 months (15 years):

```bash
./book_07_loan_calc.sh 135000 0.0775 180
```

```
1270.7222490000
```

With any other number of words, it prints the usage and ends with status 1:

```bash
./book_07_loan_calc.sh
echo $?
```

```
Usage: book_07_loan_calc.sh PRINCIPAL INTEREST MONTHS

Where:

PRINCIPAL is the amount of the loan.
INTEREST is the APR as a number (7% = 0.07).
MONTHS is the length of the loan's term.

1
```

The script checks how many numbers you typed, not what they are: `7.75` instead of `0.0775`
gives `87187.4999955000` without a word of warning. The book's extra credit asks you to add
full checking of the input.

Try this:

- In a copy, change `scale = 10` to `scale = 20`, then to `scale = 4`. You get
  `1270.72226660429165940000` and `1255.5000`: `bc` cuts every result along the way to `scale`
  digits, so a small scale makes the final answer wrong, and even scale 10 is off after the
  fourth decimal. With `scale = 2`, `0.0775 / 12` becomes `0.00` and `bc` reports
  `Runtime error (func=(main), adr=22): Divide by zero` (wording from bc 1.07.1).
- Run it with two numbers. Which line stops it?

## More from the chapter, at the prompt

The chapter shows many expansions as commands typed at the prompt. These are the book's
examples; type them and compare.

**Braces around a name.** A variable name runs on through letters, digits and `_`, so
`$a_file` is a different, empty variable. Braces mark where the name ends:

```bash
a="foo"
echo "$a_file"
echo "${a}_file"
```

The first `echo` prints an empty line; the second prints `foo_file`.

**An empty variable.** `${foo:-word}` gives `word` when `foo` is empty and leaves `foo`
alone; `${foo:=word}` also stores `word` in `foo`:

```bash
foo=
echo ${foo:-"substitute value if unset"}
echo ${foo:="default value if unset"}
echo $foo
```

```
substitute value if unset
default value if unset
default value if unset
```

**Length and pieces.** Positions count from 0; a negative position needs a space after the
colon, or bash reads `:-` as the default-value form above:

```bash
foo="This string is long."
echo ${#foo}
echo ${foo:5}
echo ${foo:5:6}
echo ${foo: -5}
```

```
20
string is long.
string
long.
```

**Cutting the front or the end.** `#` cuts from the front and `%` from the end; one symbol cuts
the shortest match, two cut the longest. The pattern is a wildcard, so `*.` means "any text,
then a dot":

```bash
foo=file.txt.zip
echo ${foo#*.} ${foo##*.} ${foo%.*} ${foo%%.*}
```

```
txt.zip zip file.txt file
```

**Search and replace.** One `/` replaces the first match, `//` every match; `/#` and `/%` only a
match at the start or the end:

```bash
foo=JPG.JPG
echo ${foo/JPG/jpg} ${foo//JPG/jpg} ${foo/#JPG/jpg} ${foo/%JPG/jpg}
```

```
jpg.JPG jpg.jpg jpg.JPG JPG.jpg
```

**Other number bases.** `0xff` is hexadecimal and `2#11111111` is binary; both are 255:

```bash
echo $((0xff)) $((2#11111111))
```

**bc three ways.** `bc` reads a program from a file, from a here string (`<<<`) or from a pipe.
The book's `foo.bc` is a two-line `bc` program; make it in the practice folder:

```bash
mkdir -p ~/playground
printf '/* A very simple bc script */\n2 + 2\n' > ~/playground/foo.bc
bc < ~/playground/foo.bc
bc <<< "2+2"
bc <<< "scale=2; 5 / 2"
```

```
4
4
2.50
```

`bc -q ~/playground/foo.bc` also prints 4, then waits for more input at its own prompt; type
`quit` to leave. Without `scale`, `bc` divides like the shell: `echo "5 / 2" | bc` prints 2.

## Common mistakes

| You type | What bash says | Fix |
|---|---|---|
| `echo $(( 08 + 1 ))` | `08: value too great for base (error token is "08")` | A leading 0 means octal (base 8); write `10#08` for base 10 |
| `echo $(( 7 / 2 ))`, expecting 3.5 | Prints `3` | Bash arithmetic has whole numbers only: `bc <<< "scale=1; 7 / 2"` |
| `((a<10?++a:finished=1))` | `attempted assignment to non-variable (error token is "=1")` | Put the assignment in parentheses: `((a<10?++a:(finished=1)))` |
| `echo "${ name }"` | `${ name }: bad substitution` | No spaces inside the braces: `${name}` |
| `echo "$a_file"`, meaning `$a` then `_file` | An empty line, no message | `echo "${a}_file"` |
| `${title:-7}` to get the last 7 characters | The whole value: `:-` is the default-value form | Put a space after the colon: `${title: -7}` |
| `echo $( 2 + 3 )` | `2: command not found` (one pair of parentheses runs a command) | Two pairs do arithmetic: `$(( 2 + 3 ))` |
| `./book_07_loan_calc.sh 135000 0.0775` | The usage text, and exit status 1 | Type all three numbers |
| `./book_07_loan_calc.sh` on a machine without `bc` | `bc: command not found` (after the script's name and a line number) | Install the `bc` package |
| The tab before the first `EOF` in `book_07` turned into spaces | `syntax error: unexpected end of file` | `<<-` strips tabs only: indent the here-document lines with tabs |
| A file saved on Windows | `/bin/bash^M: bad interpreter: No such file or directory` | `sed -i 's/\r$//' myscript.sh` |

## Check yourself

1. What is the difference between `${#name}` and `$name`?
   <details><summary>Answer</summary><code>$name</code> is the value itself;
   <code>${#name}</code> is the number of characters in that value. With
   <code>name=Linux</code>, the first gives <code>Linux</code> and the second
   <code>5</code>.</details>
2. What do `$(( 17 / 5 ))` and `$(( 17 % 5 ))` print, and why?
   <details><summary>Answer</summary><code>3</code> and <code>2</code>. Bash divides whole
   numbers and throws the fraction away; <code>%</code> gives the remainder, 17 minus 3 times
   5.</details>
3. With `f=report.txt.zip`, what do `${f%.*}` and `${f##*.}` give?
   <details><summary>Answer</summary><code>report.txt</code> (the shortest match of
   <code>.*</code> cut from the end) and <code>zip</code> (the longest match of <code>*.</code>
   cut from the front).</details>
4. In `book_06_arith_loop.sh`, what does `((a<10?++a:(finished=1)))` do, and why are the
   parentheses around `finished=1` needed?
   <details><summary>Answer</summary>If <code>a</code> is less than 10 it adds 1 to
   <code>a</code>; otherwise it sets <code>finished</code> to 1, which ends the
   <code>until</code> loop. Without the parentheses bash groups the expression the wrong way and
   reports "attempted assignment to non-variable".</details>
5. Why does `loan-calc` hand its math to `bc`, and what does `scale = 10` do?
   <details><summary>Answer</summary>Bash arithmetic has no decimals, and a loan payment needs
   them. <code>scale = 10</code> tells <code>bc</code> to keep 10 digits after the decimal point
   in every result.</details>
