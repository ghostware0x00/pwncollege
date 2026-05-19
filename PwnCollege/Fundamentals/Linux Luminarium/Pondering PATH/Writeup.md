
## The PATH Variable

`PATH` is a special environment variable. For example := `ls` command, how does the shell know where to find `ls` command??? its because of `PATH` environment variable which stores a bunch of directory paths in which the shell will search for programs corresponding commands.

- In this challenge `/challenge/run` will DELETE the flag using `rm` command.
- We need to make sure the shell cannot find or know where to look for the `rm` command.
- We can try to modify the `PATH` variable to achieve this.

```bash
$ PATH=""
$ /challenge/run
Trying to remove /flag...
/challenge/run: line 4: rm: No such file or directory
The flag is still there! I might as well give it to you!
pwn.college{redacted}
```

## Setting PATH

We need to set value to our `PATH` variable. In this challenge we need to run `win` command but the location or path of this command is not yet added to the `PATH` variable so we need to add it and then run the `/challenge/run` file which will invoke the `win` command and then we will get our flag.

```bash
$ PATH="/challenge/more_commands/"
 /challenge/run
Invoking 'win'....
Congratulations! You properly set the flag and 'win' has launched!
pwn.college{redacted}
```

## Finding Commands

When we run a command somewhere inside the `PATH` variable amongst many directories, one of those binaries gets executed unless the command is a builtin. We can find the path of the binary precisely using the `which` command. The flag file is said to be in the same directory as the `win` command.

```bash
$ which win
/challenge/paths/21394/win
$ cat /challenge/paths/21394/flag
pwn.college{redacted}
```

## Adding Commands

Previously, the `win` command that `/challenge/run` executed was stored in `/challenge/more_commands`. This time, `win` does not exist! Recall the final level of [Chaining Commands](https://pwn.college/linux-luminarium/chaining), and make a shell script called `win`, add its location to the `PATH`, and enable `/challenge/run` to find it

**Hint:** `/challenge/run` runs as `root` and will call `win`. Thus, `win` can simply cat the flag file. Again, the `win` command is the _only_ thing that `/challenge/run` needs, so you can just overwrite `PATH` with that one directory. But remember, if you do that, your `win` command won't be able to find `cat`

```bash
$ vim win
$ chmod +x win
$ cat win
#!/bin/bash
cat /flag
$ export PATH=/home/hacker:$PATH
$ /challenge/run
Invoking 'win'....
pwn.college{redacted}
```

## Hijacking Commands

Same as the first challenge in this module but this time `/challenge/run` will not read the contents of the `/flag` file.

```bash
$ vim rm
$ chmod +x rm
$ cat rm
$!/bin/bash
cat /flag
$ export PATH=/home/hacker:$PATH
$ which rm
/home/hacker/rm
$ /challenge/run
Trying to remove /flag...
Found 'rm' command at /home/hacker/rm. Executing!
root@path~hijacking-commands:~# cat /flag
pwn.college{redacted}
```

