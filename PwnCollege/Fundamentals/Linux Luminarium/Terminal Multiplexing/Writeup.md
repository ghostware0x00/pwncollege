
## Launching Screen

`screen` is a program that creates virtual terminals inside your terminal. It's somewhat like having multiple browser tabs, but for your command line. Enter the `screen` command in terminal and after that type `exit` or `CTRL+D` to get the flag.

```bash
$ screen # launching the screen
# type exit/CTRL+D
Congratulations! You're inside a screen session!
Here's your flag:
pwn.college{redacted}
```

## Detaching and Attaching

- You detach by pressing `Ctrl-A`, followed by `d` (for **d**etach). This leaves your session running in the background while you return to your normal terminal.
- `screen -r` command can be used to reattach.

For this challenge, you'll need to:

1. Launch screen
2. Detach from it.
3. Run `/challenge/run` (this will secretly send the flag to your detached session!)
4. Reattach to see your prize

```bash
$ screen # launching screen
# CTRL + D followed by d for detaching
$ screen
[detached from 1111.pts-0.terminal-multiplexing~detaching-and-attaching]
$ /challenge/run
Found detached screen session: 1111.pts-0.terminal-multiplexing~detaching-and-attaching
Sending flag to your screen session...

Flag sent! Now reattach to your screen session with:

  screen -r

You'll find the flag waiting for you there
$ echo Yes! Flag is: pwn.college{redacted}
Yes! Flag is: pwn.college{redacted}
```

## Finding Sessions

-  If you become an avid screen user, you will inevitably end up with multiple sessions running. To list the sessions of screen we can use `screen -ls` command.
- After finding the session name we can attach ourselves to that particular session using `screen -r <session_name>` command.
- Detaching a session can be done by `CTRL+A` followed by `d`. This should be done if we are joining a different session from the one we are already in.

```bash
$ screen -ls
There are screens on:
        368.pts-0.terminal-multiplexing~launching-screen        (Remote or dead)
        1111.pts-0.terminal-multiplexing~detaching-and-attaching        (Remote or dead)
        295.pts-0.terminal-multiplexing~detaching-and-attaching (Remote or dead)
        146.session_412426aad2effe68    (Detached)
        149.session_bffcc4a9b531be0e    (Detached)
        152.session_3adcda93f411179a    (Detached)
6 Sockets in /home/hacker/.screen.
$ screen -r 149.session_bffcc4a9b531be0e # the correct session
```

If you get the correct session the `pwn{redacted}` flag will be displayed on a new terminal screen.

## Switching Windows

These windows are handled with different keyboard shortcuts, all starting with `Ctrl-A`:

- `Ctrl-A c` - Create a new window
- `Ctrl-A n` - Next window
- `Ctrl-A p` - Previous window
- `Ctrl-A 0` through `Ctrl-A 9` - Jump directly to window 0-9
- `Ctrl-A "` - bring up a selection menu of all of the windows

For this challenge, we've set up a screen session with two windows:

- Window 0 has... well, you'll have to switch there to find out!
- Window 1 has a welcome message

```bash
$ screen -ls
There are screens on:
        368.pts-0.terminal-multiplexing~launching-screen        (Remote or dead)
        1111.pts-0.terminal-multiplexing~detaching-and-attaching        (Remote or dead)
        295.pts-0.terminal-multiplexing~detaching-and-attaching (Remote or dead)
        152.session_3adcda93f411179a    (Remote or dead)
        138.challenge_session   (Detached)
5 Sockets in /home/hacker/.screen.
```

Our session is the `138.challenge_session` in which we can join using `screen -r 138.challenge_session` command. Below is the message we get after joining.

```bash
cat <<MSG
Welcome to the window switching challenge!
You are currently in window 1.
The flag is hidden in window 0.
Use Ctrl-A 0 to switch to window 0!
MSG
$  cat <<MSG
> Welcome to the window switching challenge!
> You are currently in window 1.
> The flag is hidden in window 0.
> Use Ctrl-A 0 to switch to window 0!
> MSG
Welcome to the window switching challenge!
You are currently in window 1.
The flag is hidden in window 0.
Use Ctrl-A 0 to switch to window 0!
```

I typed `CTRL+A` and I got the flag.

```bash
$  cat <<MSG
> Excellent work! You found window 0!
> Here is your flag: 
> pwn.college{redacted}> MSG
Excellent work! You found window 0!
Here is your flag: pwn.college{redacted}
```

## Detaching and Attaching (tmux)

`tmux` (terminal multiplexer) is screen's younger, more modern cousin. It does all the same things but with some different key bindings. The biggest difference? Instead of `Ctrl-A`, tmux uses `Ctrl-B` as its command prefix

The commands also differ:

- `tmux ls` - List sessions
- `tmux attach` or `tmux a` - Reattach to session

For this challenge:

1. Launch tmux
2. Detach from it.
3. Run `/challenge/run` (this will send the flag to your detached session!)
4. Reattach to see your prize

```bash
$ tmux # start tmux
# CTRL+B to detach
$ /challenge/run
Found detached tmux session: 0
Sending flag to your tmux session...

Flag sent! Now reattach to your tmux session with:
  tmux attach

You'll find the flag waiting for you there!
$ tmux attach
[detached (from session 0)]
```

After attaching you will get the `pwn{redacted}` flag in the `tmux` terminal.

## Switching Windows (tmux)

Just like screen, tmux has windows. The key combos are different, but the concept is the same:

- `Ctrl-B c` - Create a new window
- `Ctrl-B n` - Next window
- `Ctrl-B p` - Previous window
- `Ctrl-B 0` through `Ctrl-B 9` - Jump to window 0-9
- `Ctrl-B w` - See a nice window picker

```bash
$ tmux attach -t challenge_session # attaching to specific session
```

Below is the output message we get in the `tmux` terminal session screen

```bash
~$  cat <<MSG
> Welcome to the tmux window switching challenge!
> You are currently in window 1.
> The flag is hidden in window 0.
> Use Ctrl-B 0 to switch to window 0!
> MSG
Welcome to the tmux window switching challenge!
You are currently in window 1.
The flag is hidden in window 0.
Use Ctrl-B 0 to switch to window 0!
```

I used `CTRL+B w` to switch to window 0 and get the flag.