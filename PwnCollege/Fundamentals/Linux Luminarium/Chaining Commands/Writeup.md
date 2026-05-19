
## Chaining with Semicolons

We can chain multiple commands using `;` (**semicolon**). `/challenge/pwn` and `/challenge/college` programs' execution are separated by `;`.

```bash
$ /challenge/pwn; /challenge/college
Yes! You chained /challenge/pwn and /challenge/college! Here is your flag:
pwn.college{redacted}
```

## Building on Success

We will use `&&` operator in this challenge for chaining commands. If the first command succeeds, only then the command associated with `&&` next will be executed. To check whether a program is successfully run or not we can check the program exit status codes using `$?`.

```bash
$ /challenge/first-success && /challenge/second
Nice chaining! Flag: pwn.college{redacted}
```

## Handling Failure

In this challenge we will use `||` operator to chain commands. If one command fails, the other command chained using `||` will still execute. 

```bash
$ /challenge/first-failure || /challenge/second
Nice chaining! Flag: pwn.college{redacted}
```

## Your First Shell Script

We need to write a shell script to run `/challenge/pwn` and `/challenge/college` files and then run our script using `bash` command.

```bash
$ vim x.sh
$ cat x.sh
/challenge/pwn && /challenge/college
$ bash x.sh
Great job, you've written your first shell script! Here is the flag:
pwn.college{redacted}
```

## Redirecting Script Output

We wrote our shell script in `x.sh` and piped(`|`) the stdout of our script as stdin for the `/challenge/solve` to get the flag.

```bash
$ vim x.sh
$ cat x.sh
/challenge/pwn && /challenge/college
$ bash x.sh | /challenge/solve
Correct! Here is your flag:
pwn.college{redacted}
```

## Executable Shell Scripts

We need to make our `script.sh` executable and include the **Shebang**(`/usr/bin/bash`) line so that we don't need to explicitly call the `bash` command to execute the shell file and also we added `executable(x)` permissions to `script.sh` using `chmod` to avoid file permission issues.

```bash
$ vim script.sh
$ cat script.sh
#/usr/bin/bash
/challenge/solve
$ chmod +x script.sh
$ ls -l script.sh
-rwxr-xr-x 1 hacker hacker 32 Dec 31 07:24 script.sh
$ ./script.sh
Congratulations on your shell script execution! Your flag:
pwn.college{redacted}
```

## Understanding Shebangs

Common shebangs you might see:

- `#!/bin/bash` for bash scripts
- `#!/usr/bin/python3` for Python scripts
- `#!/bin/sh` for POSIX shell scripts --- this is a more primitive predecessor to `bash` with fewer features, but more compatibility to non-Linux systems.

For this challenge, create a script at `/home/hacker/solve.sh` that has a proper shebang and outputs "hack the planet". Remember to make it executable, then run `/challenge/run` to verify your script works correctly

```bash
$ vim solve.sh
$ cat solve.sh
#!/bin/bash
echo "hack the planet"

$ chmod +x solve.sh
$ ls -l solve.sh
-rwxr-xr-x 1 hacker hacker 36 Dec 31 07:53 solve.sh
$ /challenge/run
Testing your script...
Perfect! Your flag:
Flag: pwn.college{redacted}
```

## Scripting with Arguments

Arguments in scripts are accepted using `$1`(argument1) `$2`(argument2)...
For this challenge, you need to write a script at `/home/hacker/solve.sh` that:

1. Takes two arguments
2. Outputs them in REVERSE order (second argument first, then the first argument)

```bash
$ vim solve.sh
$ chmod +x solve.sh
$ cat solve.sh
#!/bin/bash
echo "$2 $1"
$ /challenge/run
Correct! Your script properly reversed the arguments.
Here's your flag:
pwn.college{redacted}
```

## Scripting with Conditionals

**SYNTAX** 

```bash
if [condition]
then
	..........
	something
	..........
else
	..........
	something
	..........
fi
```

For this challenge, write a script at `/home/hacker/solve.sh` that:

- Takes one argument
- If the argument is "pwn", output "college"
- For any other input, output nothing

```bash
$ vim solve.sh
$ chmod +x solve.sh
$ cat solve.sh
#!/bin/bash
if [ $1 == "pwn" ]
then
        echo "college"
fi
$ /challenge/run
Correct! Your script properly handles all the conditions.
Here's your flag:
pwn.college{redacted}
```

## Scripting with Default Cases

For this challenge, write a script at `/home/hacker/solve.sh` that:

- Takes one argument
- If the argument is "pwn", output "college"
- For any other input, output "nope"

```bash
$ vim solve.sh
$ chmod +x solve.sh
$ cat solve.sh
#!/bin/bash
if [ $1 == "pwn" ]
then
        echo "college"
else
        echo "nope"
fi
$ /challenge/run
Correct! Your script properly handles the if/else conditions.
Here's your flag:
pwn.college{redacted}
```

## Scripting with Multiple Conditions

For this challenge, write a script at `/home/hacker/solve.sh` that:

- Takes one argument
- If the argument is "hack", output "the planet"
- If the argument is "pwn", output "college"
- If the argument is "learn", output "linux"
- For any other input, output "unknown"

```bash
$ vim solve.sh
$ chmod +x solve.sh
$ cat solve.sh
#!/bin/bash
if [ $1 == "hack" ]
then
        echo "the planet"
elif [ $1 == "pwn" ]
then
        echo "college"
elif [ $1 == "learn" ]
then
        echo "linux"
else
        echo "unknown"
fi
$ /challenge/run
Correct! Your script properly handles all the conditions with elif.
Here's your flag:
pwn.college{redacted}
```

## Reading Shell Scripts

In this challenge we need to read the `/challenge/run` file and understand what is the password we need to supply to this file to get the flag. We can read the script using `cat` command and figure out the password ourselves.

```bash
$ cat /challenge/run
#!/opt/pwn.college/bash

read GUESS
if [ "$GUESS" == "hack the PLANET" ]
then
        echo "CORRECT! Your flag:"
        cat /flag
else
        echo "Read the /challenge/run file to figure out the correct password!"
fi
$ /challenge/run
hack the PLANET
CORRECT! Your flag:
pwn.college{redacted}
```

