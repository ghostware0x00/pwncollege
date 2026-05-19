
## Redirecting Output

Redirection can be done using `>` symbol but remember this overwrites the data present in the file with the redirected data.

```bash
$ echo "PWN" > COLLEGE
Correct! You successfully redirected 'PWN' to the file 'COLLEGE'! Here is your 
flag:
pwn.college{redacted}
```

## Redirecting more output

```bash
$ /challenge/run > myflag
[INFO] WELCOME! This challenge makes the following asks of you:
[INFO] - the challenge will check that output is redirected to a specific file path : myflag
[INFO] - the challenge will output a reward file if all the tests pass : /flag

[HYPE] ONWARDS TO GREATNESS!

[INFO] This challenge will perform a bunch of checks.
[INFO] If you pass these checks, you will receive the /flag file.

[TEST] You should have redirected my stdout to a file called myflag. Checking...

[PASS] The file at the other end of my stdout looks okay!
[PASS] Success! You have satisfied all execution requirements.
$ cat myflag

[FLAG] Here is your flag:
[FLAG] pwn.college{redacted}
```

## Appending output

Appending output is done using `>>` operator. Appending is basically adding the data to the destination file without modifying the existing data.

```bash
$ /challenge/run >> the-flag
[INFO] WELCOME! This challenge makes the following asks of you:
[INFO] - the challenge will check that output is redirected to a specific file path : /home/hacker/the-flag

[HYPE] ONWARDS TO GREATNESS!

[INFO] This challenge will perform a bunch of checks.
[INFO] Good luck!

[TEST] You should have redirected my stdout to a file called /home/hacker/the-flag. Checking...

[HINT] File descriptors are inherited from the parent, unless the FD_CLOEXEC is set by the parent on the file descriptor.
[HINT] For security reasons, some programs, such as python, do this by default in certain cases. Be careful if you are
[HINT] creating and trying to pass in FDs in python.

[PASS] The file at the other end of my stdout looks okay!
[PASS] Success! You have satisfied all execution requirements.
I will write the flag in two parts to the file /home/hacker/the-flag! I'll do 
the first write directly to the file, and the second write, I'll do to stdout 
(if it's pointing at the file). If you redirect the output in append mode, the 
second write will append to (rather than overwrite) the first write, and you'll 
get the whole flag!
$ cat the-flag
 | 
\|/ This is the first half:
 v 
pwn.college{redacted}
                              ^
     that is the second half /|\
                              |

If you only see the second half above, you redirected in *truncate* mode (>) 
rather than *append* mode (>>), and so the write of the second half to stdout 
overwrote the initial write of the first half directly to the file. Try append 
mode!
```

## Redirecting errors

We will redirect error in this challenge. There are 3 types of errors. They are:-
- FD 0: Standard Input
- FD 1: Standard Output
- FD 3: Standard Error

We were instructed to redirect the output of `/challenge/run` to `myflag` and redirect stderr output to `instructions`

```bash
$ /challenge/run 1>> myflag 2>>instructions
$ cat myflag 

[FLAG] Here is your flag:
[FLAG] pwn.college{redacted}
```

## Redirecting input

Just like we can redirect output from programs, we can also redirect input to programs. This is exactly what to need to do in this challenge.

```bash
$ echo "COLLEGE" > PWN
$ /challenge/run < PWN
Reading from standard input...
Correct! You have redirected the PWN file into my standard input, and I read 
the value 'COLLEGE' out of it!
Here is your flag:
pwn.college{redacted}
```

## Grepping stored results

```bash
$ /challenge/run >> /tmp/data.txt
[INFO] WELCOME! This challenge makes the following asks of you:
[INFO] - the challenge will check that output is redirected to a specific file path : /tmp/data.txt
[INFO] - the challenge will output a reward file if all the tests pass : /challenge/.data.txt

[HYPE] ONWARDS TO GREATNESS!

[INFO] This challenge will perform a bunch of checks.
[INFO] If you pass these checks, you will receive the /challenge/.data.txt file.

[TEST] You should have redirected my stdout to a file called /tmp/data.txt. Checking...

[HINT] File descriptors are inherited from the parent, unless the FD_CLOEXEC is set by the parent on the file descriptor.
[HINT] For security reasons, some programs, such as python, do this by default in certain cases. Be careful if you are
[HINT] creating and trying to pass in FDs in python.

[PASS] The file at the other end of my stdout looks okay!
[PASS] Success! You have satisfied all execution requirements.
$ grep "pwn.college" /tmp/data.txt
pwn.college{redacted}
```

## Grepping live output

We are basically taking the out of the `/challenge/run` as input for `grep` using the piping(`|`) and then searching for the `pwn.college` flag string. Piping(`|`) only takes the stdout/standard output not stderr/standard error

```bash
$ /challenge/run | grep 'pwn.college'
[INFO] WELCOME! This challenge makes the following asks of you:
[INFO] - the challenge checks for a specific process at the other end of stdout : grep
[INFO] - the challenge will output a reward file if all the tests pass : /challenge/.data.txt

[HYPE] ONWARDS TO GREATNESS!

[INFO] This challenge will perform a bunch of checks.
[INFO] If you pass these checks, you will receive the /challenge/.data.txt file.

[TEST] You should have redirected my stdout to another process. Checking...
[TEST] Performing checks on that process!

[INFO] The process' executable is /nix/store/8b4vn1iyn6kqiisjvlmv67d1c0p3j6wj-gnugrep-3.11/bin/grep.
[INFO] This might be different than expected because of symbolic links (for example, from /usr/bin/python to /usr/bin/python3 to /usr/bin/python3.8).
[INFO] To pass the checks, the executable must be grep.

[PASS] You have passed the checks on the process on the other end of my stdout!
[PASS] Success! You have satisfied all execution requirements.
pwn.college{redacted}
```

## Grepping errors

In the previous challenge we found out that in Piping (`|`) we can only redirect stdout/standard output but if the flag is in stderr/standard error then we will not get the flag so we are going to use `2>&1` which will combine both stdout+stderr into one single channel and send that output to us and then we will get our flag.

```bash
$ /challenge/run 2>& 1 | grep 'pwn.college'
[INFO] WELCOME! This challenge makes the following asks of you:
[INFO] - the challenge checks for a specific process at the other end of stderr : grep
[INFO] - the challenge will output a reward file if all the tests pass : /challenge/.data.txt

[HYPE] ONWARDS TO GREATNESS!

[INFO] This challenge will perform a bunch of checks.
[INFO] If you pass these checks, you will receive the /challenge/.data.txt file.

[TEST] You should have redirected my stderr to another process. Checking...
[TEST] Performing checks on that process!

[INFO] The process' executable is /nix/store/8b4vn1iyn6kqiisjvlmv67d1c0p3j6wj-gnugrep-3.11/bin/grep.
[INFO] This might be different than expected because of symbolic links (for example, from /usr/bin/python to /usr/bin/python3 to /usr/bin/python3.8).
[INFO] To pass the checks, the executable must be grep.

[PASS] You have passed the checks on the process on the other end of my stderr!
[PASS] Success! You have satisfied all execution requirements.
pwn.college{redacted}
```

## Filtering with grep -v 

`-v` switch in `grep` is used for invert matching i.e. matching everything else other than the mentioned string.

```bash
$ /challenge/run | grep -v "DECOY"
pwn.college{redacted}
```

## Filtering with sed

In this challenge we will use `sed` command because sometimes the garbage and the required data is in the same line and `grep` will not be able to filter in those situations. 
`sed "s/<oldword>/<newword>/g"`

- `s/` - substitute  
- `oldword` - the word to replace  
- `newword` - the replacement for `oldword`  
- `/g` - global (search for all occurrences of the pattern)

```bash
$ /challenge/run | sed "s/FAKEFLAG//g"
pwn.college{redacted}
```

## Duplicating piped data with tee

In piping data cannot be seen traversing so if we need to see what data is flowing we can use `tee` command and specify any number of files where we want to store the data.

```bash
$ /challenge/pwn | tee data | /challenge/data
bash: /challenge/data: No such file or directory
Processing...
^C
$ /challenge/pwn | tee data | /challenge/college
Processing...
The input to 'college' does not contain the correct secret code! This code 
should be provided by the 'pwn' command. HINT: use 'tee' to intercept the 
output of 'pwn' and figure out what the code needs to be.
hacker@piping~duplicating-piped-data-with-tee:~$ cat data
Usage: /challenge/pwn --secret [SECRET_ARG]

SECRET_ARG should be "ogwJG1TC"
$ /challenge/pwn --secret ogwJG1TC | /challenge/college 
Processing...
Correct! Passing secret value to /challenge/college...
Great job! Here is your flag:
pwn.college{redacted}
```

## Process substitution for input

When you write `<(command)`, bash will run the command and hook up its output to a temporary file that it will create. This isn't a _real_ file, of course, it's what's called a **_named pipe_**. 

- output of `/challenge/print_decoys_and_flag` goes to named_pipe1 for example.
- output of `/challenge/print_decoys` goes to named_pipe2 for example.
- now in process substitution `<(command)` both the outputs of named_pipe1 and named_pipe2 are transferred to `diff` which finds the real and fake flag difference.

```bash
$ diff <(/challenge/print_decoys_and_flag) <(/challenge/print_decoys)
61d60
< pwn.college{redacted}
```

## Writing into multiple programs

Output of `/challenge/hack` taken in `hack_output` file using `tee` and then the data stored in `hack_output` is sent as input for `/challenge/the` and `/challenge/planet`

```bash
$ /hack
bash: /hack: No such file or directory
$ /challenge/hack
You must redirect my output into another command!
$ /challenge/hack | tee hack
This secret data must directly and simultaneously make it to /challenge/the and 
/challenge/planet. Don't try to copy-paste it; it changes too fast.
11591194322821128172
$ /challenge/hack | tee hack_output > >(/challenge/the) >(/challenge/planet)
Congratulations, you have duplicated data into the input of two programs! Here 
is your flag:
pwn.college{redacted}
```

## Split-piping stderr and stdout

In this challenge, you have:

- `/challenge/hack`: this produces data on _stdout_ and _stderr_
- `/challenge/the`: you must redirect `hack`'s _stderr_ to this program
- `/challenge/planet`: you must redirect `hack`'s _stdout_ to this program

```bash
$ /challenge/hack 2> >(/challenge/the) > >(/challenge/planet)
Congratulations, you have learned a redirection technique that even experts 
struggle with! Here is your flag:
pwn.college{redacted}
```

## Named pipes

In this challenge we will learn about `FIFO` which is a named pipe but this is created by us and it persists in the Linux file system until we delete it. `FIFO` files are created using `mkfifo` command and if we write data into `FIFO` file, it will stay hanged until another program tries to read the file.

#### Tab 1

Open a tab and enter the below commands. We create a `FIFO` file using `mkfifo` and then redirect the output of `/challenge/run` to `/tmp/flag_fifo`.

```bash
$ mkfifo /tmp/flag_fifo
$ /challenge/run > /tmp/flag_fifo 
You're successfully redirecting /challenge/run to a FIFO at /tmp/flag_fifo! 
Bash will now try to open the FIFO for writing, to pass it as the stdout of 
/challenge/run. Recall that operations on FIFOs will *block* until both the 
read side and the write side is open, so /challenge/run will not actually be 
launched until you start reading from the FIFO!
```

### Tab 2

In this tab we read the `FIFO` file to get the flag.

```bash
$ cat /tmp/flag_fifo 
You've correctly redirected /challenge/run's stdout to a FIFO at 
/tmp/flag_fifo! Here is your flag:
pwn.college{redacted}
```

