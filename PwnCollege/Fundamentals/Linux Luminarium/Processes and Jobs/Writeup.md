
## Listing Processes

Once again renamed `/challenge/run` to a random filename, and this time made it so that you cannot `ls` the `/challenge` directory but its also launched so we can use `ps` command to find the process and run it to get the flag.

```bash
$ ps aux | grep -i 'challenge'
root         134  0.0  0.0   4132  2560 ?        S    07:14   0:00 /challenge/21715-run-5706
hacker      2319  0.0  0.0 230696  2560 pts/0    S+   07:25   0:00 grep --color=auto -i challenge
$ /challenge/21715-run-5706
Yahaha, you found me! Here is your flag:
pwn.college{redacted}
Now I will sleep for a while (so that you could find me with 'ps').

```

## Killing Processes

We need to run `/challenge/run` to get the flag but it will not run if `/challenge/dont_run` is running. So we need to kill the `dont_run` process. To eliminate the process we need to get the process PID and then use `kill` command to kill/terminate the process.

```bash
$ ps aux | grep -i 'dont_run'
hacker       138  0.0  0.0 231576  3520 ?        Ss   07:28   0:00 /challenge/dont_run
hacker       926  0.0  0.0 230696  2560 pts/0    S+   07:34   0:00 grep --color=auto -i dont_run
$ kill 138
$ /challenge/run
Great job! Here is your payment:
pwn.college{redacted}
```

## Interrupting Processes

Sometimes we need to eliminate a running process that's clogging up the terminal but not will `kill` command so we can use `CTRL+C` hotkey.

```bash
$ /challenge/run
I could give you the flag... but I won't, until this process exits. Remember, 
you can force me to exit with Ctrl-C. Try it now!
^C
Good job! You have used Ctrl-C to interrupt this process! Here is your flag:
pwn.college{redacted}
```

## Killing Misbehaving Processes

We need to kill the `/challenge/decoy` so that `/challenge/run` can write the flag in `/tmp/flag_fifo`. `/tmp/flag_fifo` is a named pipe so we need to `kill` the `decoy` first and then run `/challenge/run` and open another tab where we can `cat` the contents of `flag_fifo` but we might see several decoy or fake flags and that's because `decoy` file data has already piped into the `flag_info` so you can run the `cat flag_info` file and simultaneously run the   `/challenge/run` file to get the true flag at the last line of `/tmp/flag_fifo` file.

### tab 1

Before running `/challenge/run` we need to run the `cat` command in **tab 2** first.

```bash
$ ps aux | grep -i 'decoy'
root         141  0.0  0.0   5204  3520 ?        S    07:45   0:00 su -c exec /challenge/decoy > /tmp/flag_fifo hacker
hacker       144  0.0  0.0  13516  9280 ?        Ss   07:45   0:00 /usr/bin/python /challenge/decoy
hacker       829  0.0  0.0 230696  2560 pts/0    S+   07:49   0:00 grep --color=auto -i decoy
$ kill 144
$ /challenge/run
Sending the flag to /tmp/flag_fifo!
```

### tab 2

```bash
$ cat /tmp/flag_fifo
pwn.college{smEPURR64ltTAUtzZ6A699-wRbTtRJ0eQHpBHeQkSSfiNK}
pwn.college{5QLi8N4-Eb5lMAi1XZa01zGqI1b610sm1KGKvd.6r79AgV}
pwn.college{QSl5-fSjAi.PfwmYrH902c4.PwwI3dVUDad2w5tJDbLuoA}
pwn.college{LE4uXRfhaN8c4mYAXSSJjWZ6juv4kQGvCT3an4UKItPneB}
....(SNIP)....
pwn.college{redacted}
```

## Suspending Processes

We can suspend a process using `CTRL+Z` hotkey. In this challenge we need to run `/challenge/run` and then suspend it and run it again to get the flag. **Suspending a process basically stores the current state of the process to the hard drive and shuts down.**

```bash
$ /challenge/run
I'll only give you the flag if there's already another copy of me running in 
this terminal... Let's check!

UID          PID    PPID  C STIME TTY          TIME CMD
root        1399     277  0 07:57 pts/0    00:00:00 bash /challenge/run
root        1401    1399  0 07:57 pts/0    00:00:00 ps -f

I don't see a second me!

To pass this level, you need to suspend me and launch me again! You can 
background me with Ctrl-Z or, if you're not ready to do that for whatever 
reason, just hit Enter and I'll exit!
^Z
[1]+  Stopped                 /challenge/run
$ /challenge/run
I'll only give you the flag if there's already another copy of me running in 
this terminal... Let's check!

UID          PID    PPID  C STIME TTY          TIME CMD
root        1399     277  0 07:57 pts/0    00:00:00 bash /challenge/run
root        1423     277  0 07:57 pts/0    00:00:00 bash /challenge/run
root        1425    1423  0 07:57 pts/0    00:00:00 ps -f

Yay, I found another version of me! Here is the flag:
pwn.college{redacted}
```

## Resuming Processes

The only reason we would suspend a process instead or terminating/killing must be because we can later on resume it. To resume a process after `CTRL+Z`(suspending) is using `fg` command.

```bash
$ /challenge/run
Let's practice resuming processes! Suspend me with Ctrl-Z, then resume me with 
the 'fg' command! Or just press Enter to quit me!
^Z
[1]+  Stopped                 /challenge/run
$ fg
/challenge/run
I'm back! Here's your flag:
pwn.college{redacted}
Don't forget to press Enter to quit me!
```

## Backgrounding Process

We can also resume processes using `bg` command. This allows the process to keep running while giving our shell back to invoke commands in the meantime.

- `S` => sleeping 
- `R` => actively running
- `+` => running in foreground

**Sleeping process requires user input or interaction otherwise it will not "wake up" until it gets the resources or user input it needs.**

```bash
$ /challenge/run
I'll only give you the flag if there's already another copy of me running *and 
not suspended* in this terminal... Let's check!

UID          PID STAT CMD
root        1210 S+   bash /challenge/run
root        1212 R+   ps -o user=UID,pid,stat,cmd

I don't see a second me!

To pass this level, you need to suspend me, resume the suspended process in the 
background, and then launch a new version of me! You can background me with 
Ctrl-Z (and resume me in the background with 'bg') or, if you're not ready to 
do that for whatever reason, just hit Enter and I'll exit!
^Z
[1]+  Stopped                 /challenge/run
$ bg
[1]+ /challenge/run &
$ 


Yay, I'm now running the background! Because of that, this text will probably 
overlap weirdly with the shell prompt. Don't panic; just hit Enter a few times 
to scroll this text out.

$ /challenge/run
I'll only give you the flag if there's already another copy of me running *and 
not suspended* in this terminal... Let's check!

UID          PID STAT CMD
root        1210 S    bash /challenge/run
root        1244 S    sleep 6h
root        1308 S+   bash /challenge/run
root        1310 R+   ps -o user=UID,pid,stat,cmd

Yay, I found another version of me running in the background! Here is the flag:
pwn.college{redacted}
```

## Foregrounding Processes

**Foregrounding processes are processes which are actively running in the user's terminal screen and require user interaction as well.** To foreground a process we can use the `fg` command.

```bash
$ /challenge/run
To pass this level, you need to suspend me, resume the suspended process in the 
background, and *then* foreground it without re-suspending it! You can 
background me with Ctrl-Z (and resume me in the background with 'bg') or, if 
you're not ready to do that for whatever reason, just hit Enter and I'll exit!
^Z
[1]+  Stopped                 /challenge/run
hacker@processes~foregrounding-processes:~$ bg
[1]+ /challenge/run &
$ 


Yay, I'm now running the background! Because of that, this text will probably 
overlap weirdly with the shell prompt. Don't panic; just hit Enter a few times 
to scroll this text out. After that, resume me into the foreground with 'fg'; 
I'll wait.

$ fg
/challenge/run
YES! Great job! I'm now running in the foreground. Hit Enter for your flag!

pwn.college{redacted}
```

## Starting Backgrounded Process

To background a process we don't need to suspend them first using `CTRL+Z`. We can directly background a process using `&`.

```bash
$ /challenge/run &
[1] 1816
$ 


Yay, you started me in the background! Because of that, this text will probably 
overlap weirdly with the shell prompt, but you're used to that by now...

Anyways! Here is your flag!
pwn.college{redacted}
```

## Process Exit Codes

In this challenge, we must retrieve the exit code returned by `/challenge/get-code` and then run `/challenge/submit-code` with that error code as an argument. To get the status code of a process after running it we need to use the `echo $?` command.

```bash
$ /challenge/get-code
Exiting with an error code!
hacker@processes~process-exit-codes:~$ echo $?
233
$ /challenge/submit-code 233
CORRECT! Here is your flag:
pwn.college{redacted}
```

