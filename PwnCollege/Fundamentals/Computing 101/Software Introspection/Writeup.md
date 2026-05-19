
## Tracing Syscalls

In this challenge, you must `strace` the `/challenge/trace-me` program to figure out what value it passes as a parameter to the `alarm` system call, then call `/challenge/submit-number` with the number you've retrieved as the argument. `strace` monitors and records the **system calls** made by a process and the **signals** it receives.

```bash
$ strace /challenge/trace-me
execve("/challenge/trace-me", ["/challenge/trace-me"], 0x7ffc88409690 /* 30 vars */) = 0
alarm(4850)                             = 0
exit(0)                                 = ?
+++ exited with 0 +++
$ /challenge/submit-number 4850
CORRECT! Here is your flag:
pwn.college{redacted}
```

## Starting GDB

In this challenge, the binary that holds the secret is `/challenge/debug-me`. Once you load it in gdb, the rest will happen magically.

```bash
$ gdb /challenge/debug-me
GNU gdb (Ubuntu 9.2-0ubuntu1~20.04.2) 9.2
Copyright (C) 2020 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.
Type "show copying" and "show warranty" for details.
This GDB was configured as "x86_64-linux-gnu".
Type "show configuration" for configuration details.
For bug reporting instructions, please see:
<http://www.gnu.org/software/gdb/bugs/>.
Find the GDB manual and other documentation resources online at:
    <http://www.gnu.org/software/gdb/documentation/>.

For help, type "help".
Type "apropos word" to search for commands related to "word"...
Reading symbols from /challenge/debug-me...
(No debugging symbols found in /challenge/debug-me)


You successfully started GDB!
Here is the secret number: 31757
Submit that with /challenge/submit-number. Goodbye!
$ /challenge/submit-number 31757
CORRECT! Here is your flag:
pwn.college{redacted}
```

## Starting Programs in GDB

In this challenge we need to use `gdb` and to use the `starti` command in `gdb` which basically starts the program at the very first instruction.

```bash
$ gdb /challenge/debug-me 
GNU gdb (Ubuntu 9.2-0ubuntu1~20.04.2) 9.2
Copyright (C) 2020 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.
Type "show copying" and "show warranty" for details.
This GDB was configured as "x86_64-linux-gnu".
Type "show configuration" for configuration details.
For bug reporting instructions, please see:
<http://www.gnu.org/software/gdb/bugs/>.
Find the GDB manual and other documentation resources online at:
    <http://www.gnu.org/software/gdb/documentation/>.

For help, type "help".
Type "apropos word" to search for commands related to "word"...
Reading symbols from /challenge/debug-me...
(No debugging symbols found in /challenge/debug-me)
(gdb) starti


You successfully started your program!
Here is the secret number: 19654
Submit that with /challenge/submit-number. Goodbye!
$ /challenge/submit-number 19654
CORRECT! Here is your flag:
pwn.college{redacted}
```

