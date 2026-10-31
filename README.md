# The Linux Command Line: textbook examples, explained

A study companion for **CET 2390 Operating Systems Laboratory** at New York City College of
Technology (CityTech), CUNY. It holds the examples from the free textbook *The Linux Command
Line* by William Shotts (edition 19.01), chapter by chapter, with explanations written for
students: what each script does, how it works line by line, what it prints, and what to try
next.

The book is free to read and download: https://linuxcommand.org/tlcl.php

## What is in each chapter folder

- **`README.md`**: the study guide for the chapter. Start here. It explains every example,
  shows the output, lists the mistakes students make most often, and ends with questions to
  check yourself.
- **`book_NN_name.sh`**: a script from the book. The top of the file is a comment block that
  explains the script; below the line `# ----...` is the book's own code, exactly as printed.
- **`book_name.txt`**: a data file from the book that a script or an exercise reads.

Chapters 1 to 12 teach commands you type at the prompt, so most of their folders hold only the
study guide. The scripts start in chapter 24.

## How to use it

Use a Linux machine or virtual machine (the course uses Linux Mint). Get the files with the
green **Code** button on this page: **Download ZIP**, or copy the address shown there and run
`git clone` with it. Then open a terminal in a chapter folder:

```bash
cd ch27_flow_control_branching_with_if
chmod u+x *.sh          # allow yourself to run the scripts (once per folder)
./book_01_if_x_equals_5.sh
```

If a script stops with `/bin/bash^M: bad interpreter`, the file picked up Windows line endings
on the way to your machine. This fixes every script in the folder:

```bash
sed -i 's/\r$//' *.sh
```

Read a script before you run it: the comment block at the top tells you what it will do. None
of the scripts uses `sudo` or changes your system.

## Chapters

| Chapter | Folder | What is inside |
|---|---|---|
| 1. What Is the Shell? | [`ch01_what_is_the_shell/`](ch01_what_is_the_shell/) | commands at the prompt |
| 2. Navigation | [`ch02_navigation/`](ch02_navigation/) | commands at the prompt |
| 3. Exploring the System | [`ch03_exploring_the_system/`](ch03_exploring_the_system/) | commands at the prompt |
| 4. Manipulating Files and Directories | [`ch04_manipulating_files_and_directories/`](ch04_manipulating_files_and_directories/) | commands at the prompt |
| 5. Working with Commands | [`ch05_working_with_commands/`](ch05_working_with_commands/) | commands at the prompt |
| 6. Redirection | [`ch06_redirection/`](ch06_redirection/) | commands at the prompt, 1 data file |
| 7. Seeing the World as the Shell Sees It | [`ch07_seeing_the_world_as_the_shell_sees_it/`](ch07_seeing_the_world_as_the_shell_sees_it/) | commands at the prompt |
| 8. Advanced Keyboard Tricks | [`ch08_advanced_keyboard_tricks/`](ch08_advanced_keyboard_tricks/) | commands at the prompt |
| 9. Permissions | [`ch09_permissions/`](ch09_permissions/) | commands at the prompt |
| 10. Processes | [`ch10_processes/`](ch10_processes/) | commands at the prompt |
| 11. The Environment | [`ch11_the_environment/`](ch11_the_environment/) | commands at the prompt, 2 data files |
| 12. A Gentle Introduction to vi | [`ch12_a_gentle_introduction_to_vi/`](ch12_a_gentle_introduction_to_vi/) | commands at the prompt, 1 data file |
| 14. Package Management (not on the current CET 2390 schedule) | [`ch14_package_management/`](ch14_package_management/) | commands at the prompt |
| 16. Networking (not on the current CET 2390 schedule) | [`ch16_networking/`](ch16_networking/) | commands at the prompt |
| 17. Searching for Files (not on the current CET 2390 schedule) | [`ch17_searching_for_files/`](ch17_searching_for_files/) | commands at the prompt |
| 18. Archiving and Backup (not on the current CET 2390 schedule) | [`ch18_archiving_and_backup/`](ch18_archiving_and_backup/) | commands at the prompt |
| 24. Writing Your First Script | [`ch24_writing_your_first_script/`](ch24_writing_your_first_script/) | 1 script |
| 25. Starting a Project | [`ch25_starting_a_project/`](ch25_starting_a_project/) | 9 scripts |
| 26. Top-Down Design | [`ch26_top_down_design/`](ch26_top_down_design/) | 7 scripts |
| 27. Flow Control: Branching with if | [`ch27_flow_control_branching_with_if/`](ch27_flow_control_branching_with_if/) | 12 scripts |
| 28. Reading Keyboard Input | [`ch28_reading_keyboard_input/`](ch28_reading_keyboard_input/) | 10 scripts |
| 29. Flow Control: Looping with while / until | [`ch29_flow_control_looping_with_while_until/`](ch29_flow_control_looping_with_while_until/) | 6 scripts, 1 data file |
| 31. Flow Control: Branching with case | [`ch31_flow_control_branching_with_case/`](ch31_flow_control_branching_with_case/) | 6 scripts |
| 33. Flow Control: Looping with for | [`ch33_flow_control_looping_with_for/`](ch33_flow_control_looping_with_for/) | 5 scripts |
| 34. Strings and Numbers | [`ch34_strings_and_numbers/`](ch34_strings_and_numbers/) | 7 scripts |

CET 2390 teaches the chapters in this order: 1 to 5, 11, 12, 24 to 29, 31, 33, 34, then 6 to 10.

## Credit and license

The scripts and data files are from *The Linux Command Line* by William E. Shotts, Jr., which is
licensed under the Creative Commons Attribution-NonCommercial-NoDerivs 3.0 United States
License. They are reproduced here unchanged. The explanations are by Prof. Hernan Lozano for
CET 2390. Details: [LICENSE.md](LICENSE.md).
