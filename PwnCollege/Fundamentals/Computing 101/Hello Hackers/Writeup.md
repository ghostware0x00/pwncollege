
## Writing Output

We need to use the `write` syscall for this. `write` syscall number is '1' and uses the below 3 arguments. They are:-
- **fd** (file descriptor) = **1** for stdout
- **buff memory address**
- **number of characters to write**

In the above challenge the **buff variable** is located at memory `1337000`.

```bash
$ cat assembly.s
.global _start
mov rax, 1
mov rdi, 1
mov rsi, 1337000
mov rdx, 1
syscall
$ /challenge/check assembly.s
pwn.college{redacted}
```

## Chaining Syscalls

In this challenge we need to edit our previous challenge assembly code and add the `exit` syscall.

```bash
$ cat assembly.s
.global _start
mov rax, 1
mov rdi, 1
mov rsi, 1337000
mov rdx, 1
syscall

mov rax, 60
mov rdi, 42
syscall
$ /challenge/check assembly.s
pwn.college{redacted}
```

## Writing Strings

A 14-character secret string at memory location `1337000`.  Compared to the previous solution we only need to change the `rdx` register value for this challenge.

```bash
$ cat assembly.s
.global _start
mov rax, 1
mov rdi, 1
mov rsi, 1337000
mov rdx, 14
syscall

mov rax, 60
mov rdi, 42
syscall
$ /challenge/check assembly.s
pwn.college{redacted}
```

## Reading Data

In this challenge we need to `read` the input and then `write` it. So basically taking `stdin` and `stdout`. `read` syscall arguments are :-

- **fd** (file descriptor) =**0** `stdin`
- **read bytes from a memory** (here its `1337000`)
- **read number of bytes** (here its `8` bytes)

We have to `read` `8` bytes and `write` `8` bytes.

```bash
$ cat assembly.s
.global _start

mov rax, 0
mov rdi, 0
mov rsi, 1337000
mov rdx, 8
syscall

mov rax, 1
mov rdi, 1
mov rsi, 1337000
mov rdx, 8
syscall

mov rax, 60
mov rdi, 42
syscall
$ /challenge/check assembly.s
pwn.college{redacted}
```
