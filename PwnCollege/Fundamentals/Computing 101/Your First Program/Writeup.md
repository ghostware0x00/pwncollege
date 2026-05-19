
## Your First Register

In this challenge we need to move `60` to `rax` register. We need to write assembly code to perform this and the extension should be `.s` . Also remember that after writing the assembly code we need to invoke the `/challenge/check` file and add a command line argument with it, the argument being our assembly code filename.

```bash
$ echo 'mov rax, 60' > assembly.s
$ /challenge/check assembly.s
pwn.college{redacted}
```

## Your First Syscall

In this challenge we need to make the `exit` syscall. Your can refer the link which states Linux Syscall number and their necessary arguments. [Linux Syscall Table](https://chromium.googlesource.com/chromiumos/docs/+/master/constants/syscalls.md) . `exit` syscall is present in number `60`.

```bash
$ cat assembly.s
mov rax, 60
syscall
$ /challenge/check assembly.s
pwn.college{redacted}
```

## Exit Codes

Previously we only used the syscall number of `exit` but it also requires an argument which returns the status code. So in this challenge we need to return the `exit` syscall status code. Since `exit` syscall only requires one argument so we will use `rdi` register for the first and only argument and the status code needs to be `42` for this challenge.

```bash
$ cat assembly.s 
mov rax, 60
mov rdi, 42
syscall
$ /challenge/check assembly.s
pwn.college{redacted}
```

## Building Executables

We need to build our own executable from the `.s` file in this challenge. We also need to include 2 directives in this file i.e. `global _start` and `.intel_syntax noprefix` We need to form the object file from the `.s` file using `as` command and then link the object code file using a linker `ld`.

```bash
$ cat assembly.s 
.intel_syntax noprefix
.global _start

mov rax, 60
mov rdi, 42
syscall
$ as assembly.s -o assembly.o
$ ld assembly.o -o assembly
/nix/store/v9zpzmigqkcjrw1jpf0zjc49y47cm55s-binutils-2.44/bin/ld: warning: cannot find entry symbol _start; defaulting to 0000000000401000
$ /challenge/check assembly
pwn.college{redacted}
```

## Moving Between Registers

In this challenge, we will store a secret value in the `rsi` register, and your program must exit with that value as the return code.

```bash
$ cat assembly.s
.intel_syntax noprefix
.global _start

mov rax, 60
mov rdi, rsi
syscall
$ /challenge/check assembly.s
pwn.college{redacted}
```

