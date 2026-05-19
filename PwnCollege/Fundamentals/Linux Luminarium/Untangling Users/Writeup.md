
## Becoming root with su

We need to run the `/challenge/bin/su` to become `root` user and then read the `/flag` file. The password for the `root` user is `hack-the-planet`.

```bash
$ /challenge/bin/su
Password: 
root@users~becoming-root-with-su:/home/hacker# cat /flag
pwn.college{redacted}
```

## Other users with su

To become another user we use the `su` command. The password for `zardus` user is `dont-hack-me`. After becoming `zardus` we need to run `/challenge/run` to get the `/flag` .

```bash
$ su zardus
Password: 
zardus@users~other-users-with-su:/home/hacker$ /challenge/run
Congratulations, you have become Zardus! Here is your flag:
pwn.college{redacted}
```

## Cracking Passwords

`/challenge/shadwow-leak` file contains the password hashes for `zardus` user and we need to use `john` to crack it and then login as `zardus` to run the `/challenge/run` file to get the flag.

```bash
$ john /challenge/shadow-leak 
Loaded 1 password hash (crypt, generic crypt(3) [?/64])
Press 'q' or Ctrl-C to abort, almost any other key for status
aardvark         (zardus)
1g 0:00:00:20 100% 2/3 0.04812g/s 280.2p/s 280.2c/s 280.2C/s Johnson..buzz
Use the "--show" option to display all of the cracked passwords reliably
Session completed
$ su zardus
Password: 
zardus@users~cracking-passwords:/home/hacker$ cat /flag
cat: /flag: Permission denied
zardus@users~cracking-passwords:/home/hacker$ /challenge/run
Congratulations, you have become Zardus! Here is your flag:
pwn.college{redacted}
```

## Using sudo

We use the `sudo su` command to become `root` user and then read `/flag` file.

```bash
$ sudo su
root@users~using-sudo:/home/hacker# ls
Desktop  Downloads  core  public_html  readFlag.c
root@users~using-sudo:/home/hacker# cat /flag
pwn.college{redacted}
```


