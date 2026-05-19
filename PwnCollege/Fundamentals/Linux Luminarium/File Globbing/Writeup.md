

## Matching with *

The `*` is treated as a wildcard and tries to match all files matching that pattern.

```bash
$ cd /ch*
$ /challenge/run
You ran me with the working directory of /challenge! Here is your flag:
pwn.college{redacted}
```

## Matching with ?

Works like `*` but one matches a single character. Also we are not allowed to use `c`, `l` or `*` characters.

```bash
$ cd /?ha??enge
$ ./run
You ran me with the working directory of /challenge! Here is your flag:
pwn.college{redacted}
```

## Matching with []

Unlike `?` which matches any character, inside `[]`  we need to specify the characters that matches our criteria. We need to be in the working directory of `/challenge/files` for this challenge.

```bash
$ cd /challenge/files
$ ls file_[a-z]
file_a  file_c  file_e  file_g  file_i  file_k  file_m  file_o  file_q  file_s  file_u  file_w  file_y
file_b  file_d  file_f  file_h  file_j  file_l  file_n  file_p  file_r  file_t  file_v  file_x  file_z
$ /challenge/run file_[a-z]
Your expansion did not expand to the requested files (file_a, file_b, file_h, 
and file_s). Instead, it expanded to:
file_a file_b file_c file_d file_e file_f file_g file_h file_i file_j file_k file_l file_m file_n file_o file_p file_q file_r file_s file_t file_u file_v file_w file_x file_y file_z
$ /challenge/run file_[abhs]
You got it! Here is your flag!
pwn.college{redacted}
```

## Matching paths with []

```bash
$ cd /challenge/files
$ /challenge/run file_[abhs]
Error: please run with a working directory of /home/hacker!
$ cd ~
$ /challenge/run /challenge/files/file_[abhs]
You got it! Here is your flag!
pwn.college{redacted}
```

## Multiple globs

Trying multiple `*` this time to solve the challenge. We also need to include the letter `p` remember that.

```bash
$ cd ~
hacker@globbing~multiple-globs:~$ cd /challenge/files
hacker@globbing~multiple-globs:/challenge/files$ /challenge/run *p*
You got it! Here is your flag!
pwn.college{redacted}
```

## Mixing globs

We need to use `[]` and `*` to solve this challenge. It says we need to include the words `challenging`, `educational`, `pwning`. 

```bash
$ cd /challenge/files
$ /challenge/run [cep]*
You got it! Here is your flag!
pwn.college{redacted}
```


## Exclusionary globbing

We need to invert match pattern in this challenge using `^` (new bash versions) or `!` (old bash versions) to get the flag.

```bash
$ cd /challenge/files
$ /challenge/run [^pwn]*
You got it! Here is your flag!
pwn.college{redacted}
```

## Tab completion

We need to use `TAB` key to autocomplete possible patterns of files or directories. When you see the `TAB` its basically where I am pressed `TAB` key. I have added the keyword for better understanding.

```bash
$ cat /challenge<TAB>
.bashrc         .init           DESCRIPTION.md  pwncollege​      
hacker@globbing~tab-completion:~$ cat /challenge/pwncollege​ 
pwn.college{redacted}
```

## Multiple options for tab completion

```bash
$ cat /challenge/<TAB>
.bashrc         .init           DESCRIPTION.md  bin/            files/          
$ cat /challenge/files/<TAB>
hack-the-planet        pwn-college            pwncollege-family      pwncollege-flamingo    pwncollege-hacking
pwn                    pwn-the-planet         pwncollege-flag        pwncollege-flyswatter  
$ cat /challenge/files/pwncollege-flag
pwn.college{redacted}
```

## Tab completion on commands

Type `pwncollege` and hit the tab key to auto-complete it

```bash
$ pwn<TAB>
pwn               pwncollege-23174  pwndbg            pwnstrip          pwntools-gdb      
$ pwncollege-23174 
Correct! Here is your flag:
pwn.college{redacted}
```