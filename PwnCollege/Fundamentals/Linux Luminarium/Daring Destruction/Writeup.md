
## The Fork Bomb

We need to create a shell script which will create a copy of itself and then that copy will create two copies of itself and repeat. In another tab we need to run `/challenge/check`. So basically the parent process i.e. the shell will launch the child process i.e. shell script and the script will keep making copies of itself and thus the forking will start.

### tab1

We need to run the below script a couple of times.

```bash
$ vim script.sh
$ cat script.sh
#!/bin/bash
./script.sh &
./script.sh &
$ ./script.sh # run this a couple of times 
./script.sh: fork: Resource temporarily unavailable
./script.sh: fork: Resource temporarily unavailable
./script.sh: fork: Resource temporarily unavailable
./script.sh: fork: Resource temporarily unavailable
...(SNIP)...
```

### tab2

Keep the below script running and if the forking bomb works then we will get the flag.

```bash
$ /challenge/check
 /challenge/check
It looks like the system can still spawn processes. We'll check again in 5 seconds...
It looks like the system can still spawn processes. We'll check again in 5 seconds...
It looks like the system can still spawn processes. We'll check again in 5 seconds...
It looks like the system can still spawn processes. We'll check again in 5 seconds...
...(SNIP)...
You successfully saturated the process table.  Here is your hard-earned flag:
pwn.college{redacted}
```

## Disk-Space Doomsday

In this challenge we need to fill our home directory (`/home/hacker`) with the `yes` command and then run `/challenge/check` to verify whether the home directory is filled or not and again run it to get the flag.

### tab1

Running the `yes` command and storing inside a file to fill up the home directory.

```bash
$ yes > file
yes: standard output: Disk quota exceeded
```

### tab2

Running the `/challenge/check` to verify the filling up.

```bash
$ /challenge/check
Well done, you clogged the disk. Now free that space (remove the file you created) and run /challenge/check again to prove you cleaned up!
```

After verification is successfully done we need to `rm` or delete the `file` and rerun the `/challenge/check` file to get the flag.

```bash
$ /challenge/check
Disk space restored. Here is your flag:
pwn.college{redacted}
```

## rm -rf /

We need to use the `rm -rf /` which is basically a full wipe out of everything of the Linux system but for security purposes not everything can be deleted but it will do enough damage. Before execution of the mentioned command we need to start the `/challenge/check` file.

### tab1

Below is the output we get after running the command.

```bash
$ rm -rf / --no-preserve-root
/bin/rm: cannot remove '/etc/hosts': Device or resource busy
/bin/rm: cannot remove '/etc/resolv.conf': Device or resource busy
/bin/rm: cannot remove '/etc/hostname': Device or resource busy
/bin/rm: cannot remove '/usr/sbin/docker-init': Device or resource busy
/bin/rm: skipping '/sys', since it's on a different device
/bin/rm: skipping '/home/hacker', since it's on a different device
/bin/rm: skipping '/run/dojo/sys', since it's on a different device
/bin/rm: skipping '/proc', since it's on a different device
/bin/rm: skipping '/dev', since it's on a different device
/bin/rm: skipping '/nix', since it's on a different device
```

### tab2

The output we receive in the terminal window where we ran the `/challenge/check` file.

```bash
$ /challenge/check
Looks like you haven't wiped the system! We'll check again in 5 seconds...
Looks like you haven't wiped the system! We'll check again in 5 seconds...
Looks like you haven't wiped the system! We'll check again in 5 seconds...
Looks like you haven't wiped the system! We'll check again in 5 seconds...
...(SNIP)...
YES! You wiped it, you wild hacker! The flag is yours:
pwn.college{redacted}
```


## Life after rm -rf /

This challenge is almost like the previous one but this time `/challenge/check` will not print the flag so we need to use shell variables to `read` the flag.

### tab1

As usual running the `rm` command.

```bash
$ rm -rf / --no-preserve-root
/bin/rm: cannot remove '/etc/hosts': Device or resource busy
/bin/rm: cannot remove '/etc/resolv.conf': Device or resource busy
/bin/rm: cannot remove '/etc/hostname': Device or resource busy
/bin/rm: cannot remove '/usr/sbin/docker-init': Device or resource busy
/bin/rm: skipping '/sys', since it's on a different device
/bin/rm: skipping '/home/hacker', since it's on a different device
/bin/rm: skipping '/run/dojo/sys', since it's on a different device
/bin/rm: skipping '/proc', since it's on a different device
/bin/rm: skipping '/dev', since it's on a different device
/bin/rm: skipping '/nix', since it's on a different device
```

### tab2

Before `rm`-ing  everything start the `/challenge/check`.

```bash
$ /challenge/check
Looks like you haven't wiped the system! We'll check again in 5 seconds...
Looks like you haven't wiped the system! We'll check again in 5 seconds...
Looks like you haven't wiped the system! We'll check again in 5 seconds...
Looks like you haven't wiped the system! We'll check again in 5 seconds...
...(SNIP)...
YES! You did it again! Go read the flag!
```

Now lets `read` the flag.

```bash
$ flag=$(<"/flag")
$ echo $flag
pwn.college{redacted}
```

## Finding meaning after rm -rf /

This challenge is almost like the previous one but this time we will not be allowed to use `ls` command and the flag file will be renamed differently.

### tab1

```bash
$ rm -rf / --no-preserve-root
/bin/rm: cannot remove '/etc/hosts': Device or resource busy
/bin/rm: cannot remove '/etc/resolv.conf': Device or resource busy
/bin/rm: cannot remove '/etc/hostname': Device or resource busy
/bin/rm: cannot remove '/usr/sbin/docker-init': Device or resource busy
/bin/rm: skipping '/sys', since it's on a different device
/bin/rm: skipping '/home/hacker', since it's on a different device
/bin/rm: skipping '/run/dojo/sys', since it's on a different device
/bin/rm: skipping '/proc', since it's on a different device
/bin/rm: skipping '/dev', since it's on a different device
/bin/rm: skipping '/nix', since it's on a different device
```

### tab2

```bash
$ /challenge/check
Looks like you haven't wiped the system! We'll check again in 5 seconds...
Looks like you haven't wiped the system! We'll check again in 5 seconds...
Looks like you haven't wiped the system! We'll check again in 5 seconds...
...(SNIP)...
YES! You did it again! Go read the flag!
```

We can use the `echo *` command to list files and we are told the flag file will be at the `/` directory after `rm`-ing it and the file name will be different.

```bash
$ cd / && echo *
7c5114bc dev etc home nix proc run sys usr
$ echo "$(<7c5114bc)"
pwn.college{redacted}
```