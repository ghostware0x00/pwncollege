
## The Root

The filesystem inside the Linux starts with the `/` directory. All the files, folders, directories, binaries and other special files come under the `/` directory. In this challenge we need to invoke the `pwn` program using its absolute path. **Absolute Paths start with `/`**.

```bash
$ /pwn
BOOM!!!
Here is your flag:
pwn.college{redacted}
```

## Program and absolute Paths

Here we need to again invoke a program using its absolute path.

```bash
$ /challenge/run
Correct!!!
/challenge/run is an absolute path! Here is your flag:
pwn.college{redacted}
```

## Position thy self

We need to use the `cd` command to position our working directory and then invoke the `run` file in the `/challenge` directory.

```bash
$ cd /proc/1775
$ /challenge/run 
Correct!!!
/challenge/run is an absolute path, invoked from the right directory!
Here is your flag:
pwn.college{redacted}
```

## Position elsewhere

We need to position ourselves 5 times and then finally invoke the `run` file in `/challenge` to get the flag. I executed `run` file after positioning my working directory and each time it will ask you to position to a new working directory for 5 times in total and after that when you finally invoke it you get the flag.

```bash
$ cd /
$ cd /usr/share/zoneinfo/posix/Asia
$ cd /usr/aarch64-linux-gnu/include/gnu
$ cd /usr/include
$ cd /usr/bin
$ /challenge/run
Correct!!!
/challenge/run is an absolute path, invoked from the right directory!
Here is your flag:
pwn.college{redacted}
```


## implicit relative paths, from /

We need to use relative path in this challenge. Relative path is basically a path which doesn't start with `/` or with a letter.

```bash
$ cd /
$ challenge/run
Correct!!!
challenge/run is a relative path, invoked from the right directory!
Here is your flag:
pwn.college{redacted}
```

## explicit relative paths, from /

We need to use the `./` for relative path and `./` means working directory.

```bash
$ cd /
$ ./challenge/run
Correct!!!
./challenge/run is a relative path, invoked from the right directory!
Here is your flag:
pwn.college{redacted}
```

## implicit relative path

Almost same as the previous challenge.

```bash
$ cd /challenge
$ ./run
Correct!!!
./run is a relative path, invoked from the right directory!
Here is your flag:
pwn.college{redacted}
```

## home sweet home

`/challenge/run` will write a copy of the flag to any file you specify as an argument on the commandline, with these constraints:

1. Your argument must be an absolute path.
2. The path must be inside your home directory.
3. Before expansion, your argument must be three characters or less.

```bash
$ pwd
/home/hacker
hacker@paths~home-sweet-home:~$ touch f
hacker@paths~home-sweet-home:~$ /challenge/run ~/f
Writing the file to /home/hacker/f!
... and reading it back to you:
pwn.college{redacted}
```