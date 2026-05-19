
## Learning from Documentation

We need to pass an argument with the `/challenge/challenge` program to get the flag.

```bash
$ /challenge/challenge --giveflag
Correct argument! Here is your flag:
pwn.college{redacted}
```

## Learning Complex Usage

The `/challenge/challenge` allows us to print arbitrary files to the terminal using `--printfile` argument. We also need to mention the file we want to read with the `--printfile` argument.

```bash
$ /challenge/challenge --printfile /flag
Correct argument! Here is the /flag file:
pwn.college{redacted}
```

## Reading Manuals

For this challenge I read the manual for the `challenge` file and there a switch is mentioned which helped me to read the flag.

```bash
$ /challenge/challenge --bzozgc 442
Correct usage! Your flag: 
pwn.college{redacted}
```

## Searching Manuals

I solved this level by using a different approach. I used `grep` to look for `flag` keyword because I knew the read flag switch will be associated with the correct keyword.

```bash
$ man challenge | grep "flag"
       /challenge/challenge - print the flag!
       Output the flag when called with the right argument.
       --qme  This argument will give you the flag!
$ /challenge/challenge --qme
Initializing...
Correct usage! Your flag: pwn.college{w7GwmcH3IkobPKY9ebN_CWLgfZs.dVTM4QDLzcTO5UzW}
```

## Searching the Manuals

I used the `man -k` to look for a keyword and get an argument. I used the argument with`man` command to read about the `/challege/challenge` file and get the flag. 

```bash
$ man -k challenge
wcvkuhiyld (1)       - print the flag!
$ man wcvkuhiyld
$ /challenge/challenge --wcvkuh 101
Correct usage! Your flag: 
pwn.college{redacted}
```

## Helpful Programs

We need to use the `--help` switch with the `/challenge/challenge` file to understand which switch to use to get the flag.

```bash
$ /challenge/challenge --help
usage: a challenge to make you ask for help [-h] [--fortune] [-v] [-g GIVE_THE_FLAG] [-p]

optional arguments:
  -h, --help            show this help message and exit
  --fortune             read your fortune
  -v, --version         get the version number
  -g GIVE_THE_FLAG, --give-the-flag GIVE_THE_FLAG
                        get the flag, if given the correct value
  -p, --print-value     print the value that will cause the -g option to give you the flag
$ /challenge/challenge -p
The secret value is: 470
$ /challenge/challenge -g 470
Correct usage! Your flag: pwn.college{redacted}
```

## Help for Builtins

We need to use `help` command to look for builtins and this `challenge` is a shell builtin rather than a program. We nee `help` to find the correct argument to use with `challenge` and get the flag.

```bash
$ help challenge
challenge: challenge [--fortune] [--version] [--secret SECRET]
    This builtin command will read you the flag, given the right arguments!
    
    Options:
      --fortune         display a fortune
      --version         display the version
      --secret VALUE    prints the flag, if VALUE is correct

    You must be sure to provide the right value to --secret. That value
    is "wh2OgJ2M".
$ challenge --secret wh2OgJ2M
Correct! Here is your flag!
pwn.college{redacted}
```

	