
## Changing File Ownership

So basically in this challenge the `/flag` file is only accessible to `root` user because of `root` is the owner of the file and group privileges so we need to use `chown` command to change the file ownership permissions and assign them to user `hacker`. **Usage -> `chown [user] [file/directory]**

```bash
$ /challenge/run
I have given you access to use the 'chown' command. Use it to enable the flag 
to be read!
$ chown hacker /flag
$ cat /flag
pwn.college{redacted}
```

## Groups and Files

The `/flag` file is assigned to `root` group and to read the `/flag` file we need to use `chgrp` command to change file group permissions. The challenge says we can assign `/flag` file to any group to be able to read it. I used `chgrp` to assign `/flag` to `hacker` group.                               **Usage -> `chgrp [group] [file/directory]`**

```bash
$ /challenge/run
I have given you access to use the 'chgrp' command. Use it to enable the flag 
to be read!
$ chgrp hacker /flag
$ cat /flag
pwn.college{redacted}
```

## Fun with Group Names

This challenge adds a twist on top of the previous challenge. We cannot assign `hacker` group to the `/flag` file so instead we use `id` command to check the groups `hacker` is associated with and then use that `chgrp` to assign that group to the `/flag` user and only then we are able to read the `/flag` file.

```bash
$ /challenge/run
I have given you access to use the 'chgrp' command. Use it to enable the flag 
to be read, but first use 'id' to figure out the group name!
$ id
uid=1000(hacker) gid=1000(grp22844) groups=1000(grp22844)
$ chgrp grp22844 /flag
$ cat /flag
pwn.college{redacted}
```

## Changing Permissions

In this challenge we need to use `chmod` to change file's `read(r)`, `write(w)`, and `executable(x)` permissions. There are 2 ways we change customize the file permissions using `chmod`. They are :-
- SYMBOLIC WAY
- OCTAL WAY -> (**more preferred**)

The OCTAL WAY has set values for **read, write, executable** permissions.
- `r` = 4 **(read)**
- `w` = 2 **(write)**
- `x` = 1 **(executable)**

Since the `/flag` file owner is `root` and `others` doesn't have `read` permissions I used `chmod` to add `read` permissions to `others`.

```bash
$ /challenge/run
I have given you access to use the 'chmod' command. Use it to enable the flag 
to be read!
$ ls -l /flag
-r-------- 1 root root 58 Dec 30 16:12 /flag
$ chmod o+r /flag
$ cat /flag
pwn.college{redacted}
```

## Executable Files

`/challenge/run` will give us the flag but we need to assign `executable(x)` permissions to it using `chmod` command. Since the owner of `/challenge/run` is `hacker` I added `executable(x)` permissions to owner of the file.

```bash
$ ls -l /challenge/run
-r--r--r-- 1 hacker hacker 32 Jan 14  2025 /challenge/run
$ chmod u+x /challenge/run
$ /challenge/run
Successful execution! Here is your flag:
pwn.college{redacted}
```

## Permission Tweaking Practice

In this challenge there are 8 rounds and we need to modify the file permissions in the requested order. If we are able to set the file permissions correctly, we are allowed to change file permissions for `/flag` file. To start the game run `/challenge/run` file.

```bash
$ chmod 044 /challenge/pwn # ROUND 1
$ chmod 264 /challenge/pwn # ROUND 2
$ chmod 765 /challenge/pwn # ROUND 3
$ chmod 260 /challenge/pwn # ROUND 4
$ chmod 040 /challenge/pwn # ROUND 5
$ chmod 062 /challenge/pwn # ROUND 6
$ chmod 022 /challenge/pwn # ROUND 7
$ chmod 077 /challenge/pwn # ROUND 8
```

After passing all the rounds we are able to modify permissions for `/flag` file.

```bash
$ chmod u+r /flag
$ cat /flag
pwn.college{redacted}
```

## Permissions Setting Practice

Same procedure as the previous challenge. 8 rounds of modification of permissions of `/challenge/pwn`, which if done successfully will allow us to modify permissions of `/flag` file.  So as usual start the game by running `/challenge/run` file.

```bash
$ chmod 717 /challenge/pwn # ROUND 1
$ chmod 620 /challenge/pwn # ROUND 2
$ chmod 614 /challenge/pwn # ROUND 3
$ chmod 535 /challenge/pwn # ROUND 4
$ chmod 472 /challenge/pwn # ROUND 5
$ chmod 217 /challenge/pwn # ROUND 6
$ chmod 154 /challenge/pwn # ROUND 7
$ chmod 732 /challenge/pwn # ROUND 8
```

After passing all the rounds we are able to modify permissions for `/flag` file.

```bash
$ chmod u+r /flag
$ cat /flag
pwn.college{redacted}
```

## The SUID Bit

`SUID` bit is denoted using `s` sign in the file permissions which we can see using `ls -l` command. The `SUID` bit lets us execute that file on the privileges of the file owner.

```bash
$ ls -l /challenge/getroot
-rwxr-xr-x 1 root root 155 Jan 14  2025 /challenge/getroot
$ chmod u+s /challenge/getroot
$ ls -l /challenge/getroot
-rwsr-xr-x 1 root root 155 Jan 14  2025 /challenge/getroot
$ sudo /challenge/getroot
sudo: workspace is not privileged
$ /challenge/getroot
SUCCESS! You have set the suid bit on this program, and it is running as root! 
Here is your shell...
root@permissions~the-suid-bit:~# cat /flag
pwn.college{redacted}
```


