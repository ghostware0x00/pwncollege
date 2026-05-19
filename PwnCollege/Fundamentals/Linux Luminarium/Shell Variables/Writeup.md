
## Printing Variables

The `/challenge/run` will not be able to give us the flag but there is a variable present in the shell called `FLAG` which has the flag value.

```bash
$ echo $FLAG
pwn.college{redacted}
```

## Setting Variables

```bash
$ PWN=COLLEGE
You've set the PWN variable properly! As promised, here is the flag:
pwn.college{redacted}
```

## Multi-word Variables

```bash
$ PWN="COLLEGE YEAH"
You've set the PWN variable properly! As promised, here is the flag:
pwn.college{redacted}
```

## Exporting Variables

When you create a shell variable and then open another shell you will not be able to access variables you declared in one shell. To make sure you can access shell variables throughout other shells we use `export` of variables. When variables created in parent process, they cannot be accessed in child process, so `export` is done to make child process inherit those variables and be able to access them.

**Scope Management:** It controls the scope of a variable. Local variables (not exported) are private to the current shell instance and are automatically removed when that shell session ends. Exported variables (environment variables) persist across the session's lifespan and its descendants

```bash
$ PWN=COLLEGE
You've set the PWN variable to the proper value!
$ export PWN
You've set the PWN variable to the proper value!
$ COLLEGE=PWN
You've set the PWN variable to the proper value!
You've set the COLLEGE variable to the proper value!
$ /challenge/run
CORRECT!
You have exported PWN=COLLEGE and set, but not exported, COLLEGE=PWN. Great 
job! Here is your flag:
pwn.college{redacted}
You've set the PWN variable to the proper value!
You've set the COLLEGE variable to the proper value!
```

## Printing exported variables

`env` command prints all the exported variables of in our shell.

```bash
$ env | grep -i "flag"
FLAG=pwn.college{redacted}
```

## Storing Command Output

```bash
$ PWN=$(/challenge/run)
Congratulations! You have read the flag into the PWN variable. Now print it out 
and submit it!
hacker@variables~storing-command-output:~$ echo $PWN
pwn.college{redacted}
```

## Reading Input

In this challenge we need to `read` the `PWN` variable and set it to `COLLEGE`. We read a variable using the `read` command.

```bash
$ read PWN
COLLEGE
You've set the PWN variable properly! As promised, here is the flag:
pwn.college{redacted}
```

## Reading Files

We need to read the value of `PWN` from the `/challenge/read_me` program.

```bash
$ read PWN < /challenge/read_me
You've set the PWN variable properly! As promised, here is the flag:
pwn.college{redacted}
```

