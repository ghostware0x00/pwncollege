
## Translating characters

We need to use `tr` command to replace **UpperCase** characters to **LowerCase** characters and vice versa. `[A-Z]` **UpperCase** replaced with `[a-z]` **LowerCase** and `[a-z]` **LowerCase** replaced with `[A-Z]` **UpperCase**.

```bash
$ /challenge/run | tr [A-Z][a-z] [a-z][A-Z]
yOUR CASE-SWAPPED FLAG:
pwn.college{redacted}
```

## Deleting characters

`tr -d` is used to delete the specified characters i.e. `^` and `%` from the output of `/challenge/run`.

```bash
$ /challenge/run | tr -d ^%
Your character-stuffed flag:
pwn.college{redacted}
```

## Deleting newlines

Each character in our flag is in a newline but we have to store them in a single line so we used `tr -d` to delete the newline. Newline is denoted as `\n` and should be in double quotes to prevent the shell from misinterpreting the character.

```bash
$ /challenge/run | tr -d "\n"
Your line-split flag: pwn.college{redacted}
```

## Extracting the first lines with head

`head` command is used to display desired number of lines from the top/head of the file. Using the `-n` switch we can specify the number of lines from the top/head of the file we want to see. Below we take the output of `/challenge/pwn` and take only first 7 lines, which is then piped to `/challenge/college` to get the flag.

```bash
$ /challenge/pwn | head -n 7 | /challenge/college
Congratulations, you piped the right codes!
pwn.college{redacted}
```

## Extracting specific sections of text

- ` cut-d " "` specifies the delimiter. When `" "` or space is hit the command will treat it as a separate column.
- `cut -f 2` specifies we are only taking characters from column 2.
- `tr -d "\n"` is basically to remove newlines.

```bash
$ /challenge/run | cut -d " " -f 2 | tr -d "\n"
pwn.college{redacted}
```

## Sorting data

In this challenge we are told that if we `sort` the `/challenge/flags.txt` file alphabetically, the flag is going to be in the last line so I used `sort` command to `sort` the `/challenge/flags.txt` file alphabetically and then used `tail` command to extract the last line to get the flag.

```bash
$ cat /challenge/flags.txt | sort | tail -n 1
pwn.college{redacted}
```



