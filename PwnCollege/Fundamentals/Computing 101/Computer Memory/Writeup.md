
## Loading From Memory

In this challenge we need to retrieve a value from a memory given to use i.e. `133700` using the `[]` symbol which is used for dereferencing like we do in C programming using `*` in **pointers.** We also need to `mov` this secret value to `rdi` like we did in `exit` syscall.

**NOTE: To solve this challenge, you must pass either the output executable binary or the assembly code `.s` file to `/challenge/check`.**

```bash
$ cat assembly.s
.global _start
mov rax, 60
mov rdi, [133700]
syscall
$ /challenge/check assembly.s
pwn.college{redacted}
```

## More Loading Practice

Same as the previous challenge but a different memory this time.

```bash
$ cat assembly.s
.global _start
mov rax, 60
mov rdi, [123400]
syscall
$ /challenge/check assembly.s
pwn.college{redacted}
```

## Dereferencing Pointers

In this challenge we need to load the memory address of the `rax` register and dereference `[]`. Dereferencing basically tells that "go to that memory address and fetch the value from there".

```bash
$ cat assembly.s
.global _start
mov rdi, [rax]
mov rax, 60
syscall
$ /challenge/check assembly.s
pwn.college{redacted}
```

## Dereferencing Yourself

Same as the previous challenge but this time load the value inside the register by dereferencing the register itself.

```bash
$ cat assembly.s 
.global _start
mov rax, 60
mov rdi, [rdi]
syscall
$ /challenge/check assembly.s
pwn.college{redacted}
```

## Dereferencing with Offsets

In this challenge we need to use `rdi` register and deference a memory using its offset value. The distance between that point and `rdi` is 8 bytes so the offset is 8 bytes i.e. `[rdi+8]`.

```bash
$ cat assembly.s
.global _start
mov rax, 60
mov rdi, [rdi+8]
syscall
$ /challenge/check assembly.s
pwn.college{redacted}
```

## Stored Addresses

In this challenge `secret value => secret address => address 567800` So we need to `[567800] => secret addr. [secret addr.] => secret value`.

```bash
$ cat assembly.s
.global _start
mov rax, 60
mov rdi, [567800]
mov rdi, [rdi]
syscall
$ /challenge/check assembly.s
pwn.college{redacted}
```

## Double Dereference

In this challenge, we stored our `SECRET_VALUE` in memory at the address `SECRET_LOCATION_1`, then stored `SECRET_LOCATION_1` in memory at the address `SECRET_LOCATION_2`.

```bash
$ cat assembly.s
.global _start
mov rax, [rax] 
mov rdi, [rax] 
mov rax, 60 
syscall
$ /challenge/check assembly.s
pwn.college{redacted}
```

## Triple Dereference

We need to perform triple dereferencing because another layer of dereferencing is added in this challenge. You need to dereference the `rdi` register.

```bash
$ cat assembly.s 
.global _start
mov rdi, [rdi] 
mov rdi, [rdi]
mov rdi, [rdi] 
mov rax, 60
syscall
$ /challenge/check assembly.s
pwn.college{redacted}
```