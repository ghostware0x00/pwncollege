
## cat, not the pet, but the command!

```bash
$ cat /flag
pwn.college{redacted}
```

## catting absolute paths

Basically this is the same as the last we but it explicitly specifies using absolute paths(`/`).

```bash
$ cat /flag
pwn.college{redacted}
```

## more catting practice

I tried to change the directory but I am forbidden to change directory on this level. I need to use absolute paths (`/`) to get the flag. I get the location of the flag revealed to me after I tried to change directory.

```bash
$ cd /
You used 'cd'! In this level, I don't allow you to change the working directory 
--- you MUST chase pass 'cat' the absolute path of where I put it on the 
filesystem (which is /lib/environment.d/flag).
$ cat /lib/environment.d/flag
pwn.college{redacted}
```

## grepping for a needle in a haystack

In this challenge we need to use the `grep` command to read contents of `data.txt` file in `/challenge` directory. We all know the flag will have `pwn.college` string so I used  it in `grep`.

```bash
$ cat /challenge/data.txt | grep 'pwn.college'
pwn.college{redacted}
```

## comparing files

There are multiple fake flags, each having `fake` work inside them so I used `-v` switch in `grep` which does invert matching and looks for everything other than the string mentioned in `-v`.

```bash
$ cat /challenge/decoys_and_real.txt | grep -v 'fake'
pwn.college{redacted}
```

## listing files

In this challenge we need to list files present inside directory using `ls` command.

```bash
$ ls /challenge/
29788-renamed-run-1249  DESCRIPTION.md
$ /challenge/29788-renamed-run-1249 
Yahaha, you found me! Here is your flag:
pwn.college{redacted}
```

## touching files

In this challenge we need to create 2 files `/tmp/pwn` and `/tmp/college` and run the `/challenge/run` file. We can create files using `touch` command.

```bash
$ touch /tmp/pwn
$ touch /tmp/college
$ /challenge/run
Success! Here is your flag:
pwn.college{redacted}
```

## removing files

In this challenge a `delete_me` file will be created in our home directory and we need to delete it and then run the `/challenge/check` program which will make sure we have deleted the file and then give us the flag if we deleted the necessary file.

```bash
$ rm delete_me
$ /challenge/check
Excellent removal. Here is your reward:
pwn.college{redacted}
```

## moving files

We need to move the `/flag` file to the directory mentioned in the question and then run `/challenge/check` file for verification to get the flag value.

```bash
$ mv /flag /tmp/hack-the-planet
Correct! Performing 'mv /flag /tmp/hack-the-planet'.
$ /challenge/check
Congrats! You successfully moved the flag to /tmp/hack-the-planet! Here it is:
pwn.college{redacted}
```

## copying files

We need to copy the `/flag` file to the directory mentioned in the question and then run the `/challenge/check` file for verification to get the flag value.

```bash
$ cp /flag /tmp/hack-the-planet
Correct! Performing 'cp /flag /tmp/hack-the-planet'.
$ /challenge/check
Congrats! You successfully copied the flag to /tmp/hack-the-planet! Here it is:
pwn.college{redacted}
```

## hidden files

`ls` was used previously to view files and directories but `-a` switch of `ls` can be used to view hidden files in Linux.

```bash
$ ls -a /
.   .dockerenv            bin   challenge  etc   lib    lib64   media  nix  proc  run   srv  tmp  var
..  .flag-23505759612133  boot  dev        home  lib32  libx32  mnt    opt  root  sbin  sys  usr
$ cat /.flag-23505759612133 
pwn.college{redacted}
```

## An Epic Filesystem Quest

Won't say much but by this time you should have a pretty good idea what to do and always read the instructions before throwing random commands. Analyze the clues and head or don't! to the directories.

```bash
$ cd /
$ ls -a
.   .dockerenv  bin   challenge  etc   home  lib32  libx32  mnt  opt   root  sbin  sys  usr
..  INSIGHT     boot  dev        flag  lib   lib64  media   nix  proc  run   srv   tmp  var
$ cat INSIGHT
Lucky listing!
The next clue is in: /usr/share/javascript/mathjax/unpacked/jax/output/SVG/fonts/Neo-Euler/Size4

The next clue is **hidden** --- its filename starts with a '.' character. You'll need to look for it using special options to 'ls'.
$ cd /usr/share/javascript/mathjax/unpacked/jax/output/SVG/fonts/Neo-Euler/Size4
$ ls -a
.  ..  .SECRET  Regular
$ cat .SECRET 
Lucky listing!
The next clue is in: /opt/linux/linux-5.4/tools/nfsd

The next clue is **delayed** --- it will not become readable until you enter the directory with 'cd'.
$ cd /opt/linux/linux-5.4/tools/nfsd
hacker@commands~an-epic-filesystem-quest:/opt/linux/linux-5.4/tools/nfsd$ ls -a
.  ..  MEMO  inject_fault.sh
$ cat MEMO 
Great sleuthing!
The next clue is in: /usr/share/javascript/mathjax/unpacked/jax/output/HTML-CSS/fonts/Asana-Math/Variants/Regular

Watch out! The next clue is **trapped**. You'll need to read it out without 'cd'ing into the directory; otherwise, the clue will self destruct!
$ ls -a /usr/share/javascript/mathjax/unpacked/jax/output/HTML-CSS/fonts/Asana-Math/Variants/Regular
.  ..  Main.js  NUGGET-TRAPPED
$ cat /usr/share/javascript/mathjax/unpacked/jax/output/HTML-CSS/fonts/Asana-Math/Variants/Regular/NUGGET-TRAPPED 
Tubular find!
The next clue is in: /usr/lib/python3/dist-packages/IPython/lib/tests

The next clue is **delayed** --- it will not become readable until you enter the directory with 'cd'.
$ cd /usr/lib/python3/dist-packages/IPython/lib/tests
$ ls -a
.          __init__.py  test_backgroundjobs.py  test_display.py      test_latextools.py  test_security.py
..         __pycache__  test_clipboard.py       test_editorhooks.py  test_lexers.py
BLUEPRINT  test.wav     test_deepreload.py      test_imports.py      test_pretty.py
$ cat BLUEPRINT 
Yahaha, you found me!
The next clue is in: /usr/local/lib/python3.8/dist-packages/defusedxml-0.7.1.dist-info
$ ls -a
.  ..  DOSSIER  INSTALLER  LICENSE  METADATA  RECORD  WHEEL  top_level.txt
$ cat DOSSIER 
Tubular find!
The next clue is in: /usr/lib/python3/dist-packages/prompt_toolkit/eventloop/__pycache__

The next clue is **delayed** --- it will not become readable until you enter the directory with 'cd'.
$ cd /usr/lib/python3/dist-packages/prompt_toolkit/eventloop/__pycache__
$ ls -a
.                               asyncio_posix.cpython-38.pyc  defaults.cpython-38.pyc   select.cpython-38.pyc
..                              asyncio_win32.cpython-38.pyc  event.cpython-38.pyc      utils.cpython-38.pyc
EVIDENCE                        base.cpython-38.pyc           future.cpython-38.pyc     win32.cpython-38.pyc
__init__.cpython-38.pyc         context.cpython-38.pyc        inputhook.cpython-38.pyc
async_generator.cpython-38.pyc  coroutine.cpython-38.pyc      posix.cpython-38.pyc
$ cat EVIDENCE 
Tubular find!
The next clue is in: /usr/local/lib/python3.8/dist-packages/nbformat/corpus/tests/__pycache__

The next clue is **hidden** --- its filename starts with a '.' character. You'll need to look for it using special options to 'ls'.
$ cd /usr/local/lib/python3.8/dist-packages/nbformat/corpus/tests/__pycache__
$ ls -a
.  ..  .BRIEF  __init__.cpython-38.pyc  test_words.cpython-38.pyc
$ cat .BRIEF 
Tubular find!
The next clue is in: /opt/linux/linux-5.4/arch/sh/cchips

The next clue is **delayed** --- it will not become readable until you enter the directory with 'cd'.
$ cd /opt/linux/linux-5.4/arch/sh/cchips
$ ls -a
.  ..  HINT  Kconfig  hd6446x
$ cat HINT
CONGRATULATIONS! Your perserverence has paid off, and you have found the flag!
It is: pwn.college{redacted}
```

## making directories

We need to create a directory `/tmp/pwn` and inside that directory create a file named `college` and then run `/challenge/run` to get our flag.

```bash
$ mkdir /tmp/pwn
$ touch /tmp/pwn/college
$ /challenge/run
Success! Here is your flag:
pwn.college{redacted}
```

## finding files

We need to find the `/flag` using the `find` command. This will generate a lot of errors due to insufficient permissions because I am not a super user and I am searching the entire Linux file system and to prevent the screen from flooding with permission denied errors `2>/dev/null` is used.

```bash
$ find / -type f -iname "flag" 2>/dev/null
/opt/linux/linux-5.4/include/config/vm/event/flag
$ cat /opt/linux/linux-5.4/include/config/vm/event/flag
pwn.college{redacted}
```

## linking files

In this challenge we need to create a symbolic using `ln -s` command and use it to read the flag. This symbolic link of `/flag` -> to -> `/home/hacker/not-the-flag` file fools the `/challenge/catflag` file into giving us the flag.

```bash
$ ln -s /flag ~/not-the-flag
$ /challenge/catflag
About to read out the /home/hacker/not-the-flag file!
pwn.college{redacted}
```




