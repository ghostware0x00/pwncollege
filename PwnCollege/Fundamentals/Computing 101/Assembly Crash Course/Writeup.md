
## Forming Executable and Running Challenge File

After you form your assembly code use the below commands to create binary file or executable of the assembly code. Your assembly code file name might be different so change the name. After forming the executable we need to use the executable as command line argument for the `/challenge/run` file. This will give us our `pwn.college{FLAG}` if our assembly code is correct. Its better you create a `.sh` or shell script and run it after finishing your code instead of manually typing it every time.

### Automation Script

The below script is for removing the headache of assembling the assembly code and then forming the executable file and running it again and again with the `/challenge/run` file. Make sure to add executable permissions to it using `chmod +x <script_name.sh>` command.

```bash
#!/bin/bash
nasm -f elf64 assembly.s -o assembly.o # forming object code file using nasm
ld -f assembly.o -o assembly # creating executable using linker
/challenge/run assembly # run the challenge file
```

---
## set-register

In this challenge we need to set  `rdi = 0x1337` . We also need to compile the assembly code and create an executable from it using `nasm` and `ld` command.

```nasm
mov rdi, 0x1337
```

## set-multiple-registers

In this level, we need to work with multiple registers. We need to set the following:-
- `rax = 0x1337`
- `r12 = 0xCAFED00D1337BEEF`
- `rsp = 0x31337`

```nasm
mov rax, 0x1337
mov r12, 0xCAFED00D1337BEEF
mov rsp, 0x31337
```

## add-to-register

In this challenge we need to add `0x331337` to `rdi` register

```nasm
add rdi, 0x331337
```

## linear-equation-registers

In this challenge we need to computer the expression `f(x) = mx + b` where :-

- `m = rdi`
- `x = rsi`
- `b = rdx`

We need to place the result in `rax` register and also we need to use `imul` instead `mul`. `imul` for signed multiplication and `mul` for unsigned multiplication.

```nasm
imul rdi, rsi
add rdi, rdx
mov rax, rdi
```

## integer-division

In this challenge we need to compute `speed = distance/time` where :-
- `distance = rdi`
- `time = rsi`
- `speed = rax`
We need to use the `div` instruction for performing division. Make sure to set `rdx = 0` because during division the numerator becomes `rax + rdx` (concatenates and forms numerator). The quotient in the below code will be stored in `rax` register.

```nasm
mov rdx, 0
mov rax, rdi
div rsi
```

## modulo-operation

In this challenge we need to perform the modulo operation(`%`) which basically gives us the remainder when division is performed. We need to compute `rdi % rsi` and place the value in `rax` register. The remainder will stored in `rdx` register after division.

```nasm
mov rdx, 0
mov rax, rdi
div rsi
mov rax, rdx
```

## set-upper-byte

Using only one move instruction, set the upper 8 bits of `ax` register to `0x42`

```nasm
mov ah, 0x42
```

## efficient-modulo

We need to compute the following :-
- `rax = rdi % 256`
- `rbx = rsi % 65536`

If we have `x % y`, and `y` is a power of 2, such as `2^n`, the result will be the lower `n` bits of `x`.

```nasm
mov al, dil
mov bx, si
```

## byte-extraction

In this challenge we need to perform bitwise shift left and right operations using `shr` and `shl` instructions. We need to set `rax` to the 5th least significant byte of `rdi` register. To calculate the number of shits the formula is :-

- consider the byte you want to extract and subtract minus 1 from it.
- multiply the result with 8 to get the number of shits you require.

```nasm
shr rdi, 32
mov al, dil
```

## bitwise-and

Set `rax` to the value of `(rdi AND rsi)`. `rax` will have all bits set to `1`

```nasm
and rdi, rsi
and rax, rdi
```

## check-even

Using `and` `or` `xor` we need to implement the below logic where `x = rdi` and `y = rax` 

```
if x is even then
  y = 1
else
  y = 0
```

So to check whether `rdi` or **x** is even or not we need to check the last bit is `0` or `1`. If `0` then **even** else **odd**.

- `and` operation checks whether `rdi` is even or odd.
- `xor` operation makes `rax` value `0`.
- `xor` operation makes `rdi` last bit value flip.
- `or` operation copies flipped value of `rdi` last bit to `rax`.

```nasm
and rdi, 1  
xor rax, rax  
xor rdi, 1  
or rax, rdi
```

## memory-read

We need to dereference the address `0x404000` i.e. get the value stored at the address and copy it to `rax` register.

```nasm
mov rax, [0x404000]
```

## memory-write

This time the opposite of the previous challenge. We need to dereference a memory itself and store a value there which is present in `rax` register.

```nasm
mov [0x404000], rax
```

## memory-increment

- we need to place the value stored at `0x404000` into `rax`.
- After that we need to increment the value stored at the address `0x404000` by `0x1337`.

Without a size specifier(`word, dword, qword`), the assembler will not know how many bytes of memory we want to modify or add in this case.

```nasm
mov rax, [0x404000]
add word [0x404000], 0x1337
```

## byte-access

In this challenge we need to set `rax` to the byte of `0x404000`.

```nasm
mov al, byte [0x404000]
```

## memory-size-access

```nasm
mov al, byte [0x404000]
mov bx, word [0x404000]
mov ecx, dword [0x404000]
mov rdx, qword [0x404000]
```

## little-endian-write

In this challenge we need to store the value in reverse. As an example, say:

```
[0x1330] = 0x00000000deadc0de
```

If you examined how it actually looked in memory, you would see:

```
[0x1330] = 0xde
[0x1331] = 0xc0
[0x1332] = 0xad
[0x1333] = 0xde
[0x1334] = 0x00
[0x1335] = 0x00
[0x1336] = 0x00
[0x1337] = 0x00
```

In **little endian** the LSB bit is stored in lower address and MSB to high address.
We need to set the following :-
- Set `[rdi] = 0xdeadbeef00001337`
- Set `[rsi] = 0xc0ffee0000`

We are moving a single byte in each location so `mov byte` is used and in the `rsi` register the value we need to assign is of 5 bytes so we need to specify the rest 3 bytes as well otherwise will get error.

```nasm
mov byte[rdi+0], 0x37
mov byte[rdi+1], 0x13
mov byte[rdi+2], 0x00
mov byte[rdi+3], 0x00
mov byte[rdi+4], 0xef
mov byte[rdi+5], 0xbe
mov byte[rdi+6], 0xad
mov byte[rdi+7], 0xde

mov byte[rsi+0], 0x00
mov byte[rsi+1], 0x00
mov byte[rsi+2], 0xee
mov byte[rsi+3], 0xff
mov byte[rsi+4], 0xc0
mov byte[rsi+5], 0x00
mov byte[rsi+6], 0x00
mov byte[rsi+7], 0x00
```

## memory-sum

Perform the following:

- Load two consecutive quad words from the address stored in `rdi`.
- Calculate the sum of the previous steps' quad words.
- Store the sum at the address in `rsi`.

We loaded `qword 1` using `[rdi+0]` and then loaded `qword 2` using `[rdi+8]` The 

```nasm
mov rax, qword[rdi+0]    
mov rdx, qword[rdi+8]    
add rax, rdx
mov [rsi], rax
```

## stack-subtraction

- `push` instruction decrements the `sp` or stack pointer and stores the value being pushed into the stack.
- `pop` instruction increments the `sp` or stack pointer and pops the value at the top of the stack and copies it to the register which is being popped.

Using these instructions, we need to take the top value of the stack and subtract `rdi` from it and then put it back.

```nasm
pop rax
sub rax, rdi
push rax
```

## swap-stack-values

In this challenge we need to use only `push` and `pop` instructions to swap values of `rdi` and `rsi` register.

```nasm
push rdi
push rsi
pop rdi
pop rsi
```

## average-stack-values

We need to basically find our the average of 4 consecutive `qword` present in the stack by using the `rsp` register or stack pointer register. The `0` `8` `16` `24` are the summation of consecutive 8 bytes. After finding the average we need to push the value into the stack.

```nasm
mov r8, qword[rsp+0]
mov r9, qword[rsp+8]
mov r10, qword[rsp+16]
mov r11, qword[rsp+24]
add r8, r9
add r8, r10
add r8, r11
mov rdx, 0
mov rax, r8
mov rbx, 4
div rbx
push rax
```

## absolute-jump

We need to perform **absolute jump** or jump at a location without any condition. This sort of jump can also be called as unconditional jump and is done using the `jmp` instruction. In `x86` architecture such jumps can be performed but we need to load the address into a register first.

```nasm
mov rax, 0x403000
jmp rax
```

## relative-jump

We need to perform the following :-

- Make the first instruction in your code a `jmp`.
- Make that `jmp` a relative jump of exactly 0x51 bytes from the current instruction.
- Fill the space between the jump and the destination with `nop` instructions using `.rept`.
- At the label where the relative jump lands, set `rax` to 0x1.

```nasm
jmp location
times 0x51 nop
location:
    mov rax, 0x1
```

## jump-trampoline

Create a two jump trampoline:

- Make the first instruction in your code a `jmp`.
- Make that `jmp` a relative jump to 0x51 bytes from its current position.
- At 0x51, write the following code:
    - Place the top value on the stack into register `rdi`.
    - `jmp` to the absolute address 0x403000.

```nasm
jmp location
times 0x51 nop
location:
	pop rdi
	mov rax, 0x403000
	jmp rax
```

## conditional-jump

Assume each dereferenced value is a signed `dword`. This means the values can start as a negative value at each memory position. `x = rdi`, `y = rax`. In this challenge we will use `call` `jmp` and `cmp` instructions to do implement the following :-

- `[x+4] [x+8] [x+12]` are 3 consecutive `dwords` which we need to use during our computation of `y = rax` but first we need to check whether `x = rdi` is `0x7f454c46` or `0x00005A4D` or something else...

```
if [x] is 0x7f454c46:
    y = [x+4] + [x+8] + [x+12]
else if [x] is 0x00005A4D:
    y = [x+4] - [x+8] - [x+12]
else:
    y = [x+4] * [x+8] * [x+12]
```

```nasm
mov r8d, dword[rdi+4]
mov r9d, dword[rdi+8]
mov r10d, dword[rdi+12]
mov edx, [rdi]
cmp edx, 0x7f454c46
je do_add
cmp edx, 0x00005A4D
je do_sub
jmp do_mul

do_add:
	add r8d, r9d
	add r8d, r10d
	jmp done

do_sub:
	sub r8d, r9d
	sub r8d, r10d
	jmp done

do_mul:
	imul r8d, r9d
	imul r8d, r10d

done:
	mov eax, r8d
```

## indirect-jump

Using the above knowledge, implement the following logic:

```
if rdi is 0:
  jmp 0x40301e
else if rdi is 1:
  jmp 0x4030da
else if rdi is 2:
  jmp 0x4031d5
else if rdi is 3:
  jmp 0x403268
else:
  jmp 0x40332c
```

- Assume `rdi` will NOT be negative.
- Use no more than 1 `cmp` instruction.
- Use no more than 3 jumps (of any variant).
- We will provide you with the number to 'switch' on in `rdi`.
- We will provide you with a jump table base address in `rsi`.

```nasm
cmp rdi, 3
ja switch_case
jmp [rsi+rdi*8]
switch_case:
	jmp [rsi+4*8]
```

## average-loop

Compute the average of `n` consecutive quad words, where:

- `rdi` = memory address of the 1st quad word
- `rsi` = `n` (amount to loop for)
- `rax` = average computed

```nasm
mov rax, 0
mov rcx, 0
mov rbx, rsi
checking:
	cmp rsi, 0
	jne looping
	jmp average

looping:
	add rax, qword[rdi+rcx]
	add rcx, 8
	dec rsi
	jmp checking

average:
	mov rdx, 0
	div rbx
```

## count-not-zero

Count the consecutive non-zero bytes in a contiguous region of memory, where:

- `rdi` = memory address of the 1st byte
- `rax` = number of consecutive non-zero bytes
- Additionally, if `rdi = 0`, then set `rax = 0`

```nasm
mov rcx, -1
xor rax, rax
xor rbx, rbx
cmp rdi, 0
je done

count_non_zeros:
	inc rcx
	mov bl, byte[rdi+rcx]
	cmp bl, 0
	jne count_non_zeros
	mov rax, rcx

done:
```

## string lower

We need to implement the following logic:

```
str_lower(src_addr):
  i = 0
  if src_addr != 0:
    while [src_addr] != 0x00:
      if [src_addr] <= 0x5a:
        [src_addr] = foo([src_addr])
        i += 1
      src_addr += 1
  return i
```

`foo` is provided at `0x403000`. `foo` takes a single argument as a value and returns a value. An important note is that `src_addr` is an address in memory (where the string is located) and `[src_addr]` refers to the byte that exists at `src_addr`. Therefore, the function `foo` accepts a byte as its first argument and returns a byte. Also after a function or `call` instruction is used the return value is stored in `rax` register.

```nasm
mov r8, 0x403000

str_lower:
    xor     rcx, rcx
    cmp     rdi, 0x0
    je      done

loop:
    mov     rbx, rdi
    xor     rdi, rdi
    mov     dil, byte[rbx]
    cmp     dil, 0x0
    je      done
    cmp     dil, 0x5a
    jg      greater
    inc     rcx
    call    r8
    mov     byte[rbx], al

greater:
    mov     rdi, rbx
    inc     rdi
    jmp     loop

done:
    mov     rax, rcx
    ret
```

## most-common-byte

We need to implement the following :-

```
most_common_byte(src_addr, size):
  i = 0
  while i <= size-1:
    curr_byte = [src_addr + i]
    [stack_base - curr_byte * 2] += 1
    i += 1

  b = 0
  max_freq = 0
  max_freq_byte = 0
  while b <= 0xff:
    if [stack_base - b * 2] > max_freq:
      max_freq = [stack_base - b * 2]
      max_freq_byte = b
    b += 1

  return max_freq_byte
```

**Assumptions:**

- There will never be more than `0xffff` of any byte
- The size will never be longer than `0xffff`
- The list will have at least one element

**Constraints:**

- You must put the "counting list" on the stack
- You must restore the stack like in a normal function
- You cannot modify the data at `src_addr`

```nasm
mov     rbp, rsp
sub     rsp, 0x100
xor     r8, r8

most_common_byte:
loop1:
    cmp     r8, rsi
    jg      next
    mov     dl, byte [rdi + r8]
    add     byte [rsp + rdx], 1
    inc     r8
    jmp     loop1

next:
    xor     rcx, rcx
    xor     rbx, rbx
    xor     rax, rax

loop2:
    cmp     rcx, 0xff
    jg      done
    cmp     [rsp + rcx], bl
    jg      updateFreq
    jmp     increment

updateFreq:
    mov     bl, byte [rsp + rcx]
    mov     rax, rcx
    jmp     increment

increment:
    inc     rcx
    jmp     loop2

done:
    mov     rsp, rbp
    ret
```