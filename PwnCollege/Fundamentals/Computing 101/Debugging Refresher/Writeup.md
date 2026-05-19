
**NOTE : you need to start `/challenge/XYZ` file present in each challenge level first before doing anything.**

## Debugging Programs

We need run the `/challenge/embryogdb_level1` file and then we will get inside `gdb` where we will use the `r` command to run the program and hit a **breakpoint** . To move past it we can use the `c` or **continue** command.

```bash
$ /challenge/embryogdb_level1
(gdb) r
(gdb) c
pwn.college{redacted}
```

## Inspecting Registers

In order to solve this challenge we need to find the random value of `r12` register. We can find the value of the register by printing it using `p` command. Also the value they want should be in **hex** format so use the `p/x` command. Of course the value of `r12` is random in each scenario so your value might be different.

```bash
$ /challenge/embryogdb_level2
(gdb) p/x $r12
$1 = 0xc53f86a3b3c1753a
(gdb) c
Continuing.
Random value: 0xc53f86a3b3c1753a
You input: c53f86a3b3c1753a
The correct answer is: c53f86a3b3c1753a
You win! Here is your flag:
pwn.college{redacted}


[Inferior 1 (process 2020) exited normally]
```

## Examining Memory

In order to solve this level, we must figure out the random value on the stack (the value read in from `/dev/urandom`). Think about what the arguments to the read system call are. We need to use the `x` command for examining the memory in this challenge.

```bash
$ /challenge/embryogdb_level3
(gdb) r
Program received signal SIGTRAP, Trace/breakpoint trap.
0x000063a6629dec1f in main ()
(gdb) x/16gx $rsp
0x7ffea95699b0: 0x0000000000000002      0x00007ffea9569af8
0x7ffea95699c0: 0x00007ffea9569ae8      0x00000001629ded10
0x7ffea95699d0: 0x0000000000000000      0x000063a6629de2a0
0x7ffea95699e0: 0x00007ffea9569ae0      0x3072bb12f09e8400
0x7ffea95699f0: 0x0000000000000000      0x00007ae3b6ece083
0x7ffea9569a00: 0x00007ae3b70d9620      0x00007ffea9569ae8
0x7ffea9569a10: 0x0000000100000000      0x000063a6629deaa6
0x7ffea9569a20: 0x000063a6629ded10      0x370777c12624452c
(gdb) c
Continuing.
The random value has been set!


Program received signal SIGTRAP, Trace/breakpoint trap.
0x000063a6629dec64 in main ()
(gdb) x/16gx $rsp
0x7ffea95699b0: 0x0000000000000002      0x00007ffea9569af8
0x7ffea95699c0: 0x00007ffea9569ae8      0x00000001629ded10
0x7ffea95699d0: 0x0000000000000000      0x972f12a808cfac33
0x7ffea95699e0: 0x00007ffea9569ae0      0x3072bb12f09e8400
0x7ffea95699f0: 0x0000000000000000      0x00007ae3b6ece083
0x7ffea9569a00: 0x00007ae3b70d9620      0x00007ffea9569ae8
0x7ffea9569a10: 0x0000000100000000      0x000063a6629deaa6
0x7ffea9569a20: 0x000063a6629ded10      0x370777c12624452c
(gdb) c
Continuing.
Random value: 0x972f12a808cfac33
You input: 972f12a808cfac33
The correct answer is: 972f12a808cfac33
You win! Here is your flag:
pwn.college{redacted}


[Inferior 1 (process 4669) exited normally]
```

So the random value is `0x972f12a808cfac33`  and we get our flag.

## Setting Breakpoints

In order to solve this level, we must figure out a series of random values which will be placed on the stack. As before, `run` will start us out, but it will interrupt the program and we must, carefully, continue its execution. Below is the disassembly of `main`.

```bash
(gdb) set disassembly-flavor intel
(gdb) disass main
Dump of assembler code for function main:
   0x00005a5a214deaa6 <+0>:     endbr64 
   0x00005a5a214deaaa <+4>:     push   rbp
   0x00005a5a214deaab <+5>:     mov    rbp,rsp
   0x00005a5a214deaae <+8>:     sub    rsp,0x40
   0x00005a5a214deab2 <+12>:    mov    DWORD PTR [rbp-0x24],edi
   0x00005a5a214deab5 <+15>:    mov    QWORD PTR [rbp-0x30],rsi
   0x00005a5a214deab9 <+19>:    mov    QWORD PTR [rbp-0x38],rdx
   0x00005a5a214deabd <+23>:    mov    rax,QWORD PTR fs:0x28
   0x00005a5a214deac6 <+32>:    mov    QWORD PTR [rbp-0x8],rax
   0x00005a5a214deaca <+36>:    xor    eax,eax
   0x00005a5a214deacc <+38>:    cmp    DWORD PTR [rbp-0x24],0x0
   0x00005a5a214dead0 <+42>:    jg     0x5a5a214deaf1 <main+75>
   0x00005a5a214dead2 <+44>:    lea    rcx,[rip+0x1070]        # 0x5a5a214dfb49 <__PRETTY_FUNCTION__.5345>
   0x00005a5a214dead9 <+51>:    mov    edx,0x51
   0x00005a5a214deade <+56>:    lea    rsi,[rip+0x54c]        # 0x5a5a214df031
   0x00005a5a214deae5 <+63>:    lea    rdi,[rip+0x6d0]        # 0x5a5a214df1bc
   0x00005a5a214deaec <+70>:    call   0x5a5a214de1f0 <__assert_fail@plt>
   0x00005a5a214deaf1 <+75>:    lea    rdi,[rip+0x6cd]        # 0x5a5a214df1c5
   0x00005a5a214deaf8 <+82>:    call   0x5a5a214de190 <puts@plt>
   0x00005a5a214deafd <+87>:    mov    rax,QWORD PTR [rbp-0x30]
   0x00005a5a214deb01 <+91>:    mov    rax,QWORD PTR [rax]
   0x00005a5a214deb04 <+94>:    mov    rsi,rax
   0x00005a5a214deb07 <+97>:    lea    rdi,[rip+0x6bb]        # 0x5a5a214df1c9
   0x00005a5a214deb0e <+104>:   mov    eax,0x0
   0x00005a5a214deb13 <+109>:   call   0x5a5a214de1d0 <printf@plt>
   0x00005a5a214deb18 <+114>:   lea    rdi,[rip+0x6a6]        # 0x5a5a214df1c5
   0x00005a5a214deb1f <+121>:   call   0x5a5a214de190 <puts@plt>
--Type <RET> for more, q to quit, c to continue without paging--
   0x00005a5a214deb24 <+126>:   mov    edi,0xa
   0x00005a5a214deb29 <+131>:   call   0x5a5a214de170 <putchar@plt>
   0x00005a5a214deb2e <+136>:   mov    rax,QWORD PTR [rip+0x24eb]        # 0x5a5a214e1020 <stdin@@GLIBC_2.2.5>
   0x00005a5a214deb35 <+143>:   mov    ecx,0x0
   0x00005a5a214deb3a <+148>:   mov    edx,0x2
   0x00005a5a214deb3f <+153>:   mov    esi,0x0
   0x00005a5a214deb44 <+158>:   mov    rdi,rax
   0x00005a5a214deb47 <+161>:   call   0x5a5a214de240 <setvbuf@plt>
   0x00005a5a214deb4c <+166>:   mov    rax,QWORD PTR [rip+0x24bd]        # 0x5a5a214e1010 <stdout@@GLIBC_2.2.5>
   0x00005a5a214deb53 <+173>:   mov    ecx,0x1
   0x00005a5a214deb58 <+178>:   mov    edx,0x2
   0x00005a5a214deb5d <+183>:   mov    esi,0x0
   0x00005a5a214deb62 <+188>:   mov    rdi,rax
   0x00005a5a214deb65 <+191>:   call   0x5a5a214de240 <setvbuf@plt>
   0x00005a5a214deb6a <+196>:   lea    rdi,[rip+0x66f]        # 0x5a5a214df1e0
   0x00005a5a214deb71 <+203>:   call   0x5a5a214de190 <puts@plt>
   0x00005a5a214deb76 <+208>:   lea    rdi,[rip+0x6db]        # 0x5a5a214df258
   0x00005a5a214deb7d <+215>:   call   0x5a5a214de190 <puts@plt>
   0x00005a5a214deb82 <+220>:   lea    rdi,[rip+0x72f]        # 0x5a5a214df2b8
   0x00005a5a214deb89 <+227>:   call   0x5a5a214de190 <puts@plt>
   0x00005a5a214deb8e <+232>:   lea    rdi,[rip+0x79b]        # 0x5a5a214df330
   0x00005a5a214deb95 <+239>:   call   0x5a5a214de190 <puts@plt>
   0x00005a5a214deb9a <+244>:   lea    rdi,[rip+0x807]        # 0x5a5a214df3a8
   0x00005a5a214deba1 <+251>:   call   0x5a5a214de190 <puts@plt>
   0x00005a5a214deba6 <+256>:   lea    rdi,[rip+0x833]        # 0x5a5a214df3e0
   0x00005a5a214debad <+263>:   call   0x5a5a214de190 <puts@plt>
   0x00005a5a214debb2 <+268>:   lea    rdi,[rip+0x89f]        # 0x5a5a214df458
--Type <RET> for more, q to quit, c to continue without paging--
   0x00005a5a214debb9 <+275>:   call   0x5a5a214de190 <puts@plt>
   0x00005a5a214debbe <+280>:   lea    rdi,[rip+0x90b]        # 0x5a5a214df4d0
   0x00005a5a214debc5 <+287>:   call   0x5a5a214de190 <puts@plt>
   0x00005a5a214debca <+292>:   lea    rdi,[rip+0x977]        # 0x5a5a214df548
   0x00005a5a214debd1 <+299>:   call   0x5a5a214de190 <puts@plt>
   0x00005a5a214debd6 <+304>:   lea    rdi,[rip+0x9db]        # 0x5a5a214df5b8
   0x00005a5a214debdd <+311>:   call   0x5a5a214de190 <puts@plt>
   0x00005a5a214debe2 <+316>:   lea    rdi,[rip+0xa47]        # 0x5a5a214df630
   0x00005a5a214debe9 <+323>:   call   0x5a5a214de190 <puts@plt>
   0x00005a5a214debee <+328>:   lea    rdi,[rip+0xab3]        # 0x5a5a214df6a8
   0x00005a5a214debf5 <+335>:   call   0x5a5a214de190 <puts@plt>
   0x00005a5a214debfa <+340>:   lea    rdi,[rip+0xab7]        # 0x5a5a214df6b8
   0x00005a5a214dec01 <+347>:   call   0x5a5a214de190 <puts@plt>
   0x00005a5a214dec06 <+352>:   lea    rdi,[rip+0xb23]        # 0x5a5a214df730
   0x00005a5a214dec0d <+359>:   call   0x5a5a214de190 <puts@plt>
   0x00005a5a214dec12 <+364>:   lea    rdi,[rip+0xb8f]        # 0x5a5a214df7a8
   0x00005a5a214dec19 <+371>:   call   0x5a5a214de190 <puts@plt>
   0x00005a5a214dec1e <+376>:   lea    rdi,[rip+0xbfb]        # 0x5a5a214df820
   0x00005a5a214dec25 <+383>:   call   0x5a5a214de190 <puts@plt>
   0x00005a5a214dec2a <+388>:   lea    rdi,[rip+0xc67]        # 0x5a5a214df898
   0x00005a5a214dec31 <+395>:   call   0x5a5a214de190 <puts@plt>
   0x00005a5a214dec36 <+400>:   lea    rdi,[rip+0xcdb]        # 0x5a5a214df918
   0x00005a5a214dec3d <+407>:   call   0x5a5a214de190 <puts@plt>
   0x00005a5a214dec42 <+412>:   lea    rdi,[rip+0xd07]        # 0x5a5a214df950
   0x00005a5a214dec49 <+419>:   call   0x5a5a214de190 <puts@plt>
   0x00005a5a214dec4e <+424>:   lea    rdi,[rip+0xd73]        # 0x5a5a214df9c8
   0x00005a5a214dec55 <+431>:   call   0x5a5a214de190 <puts@plt>
   0x00005a5a214dec5a <+436>:   lea    rdi,[rip+0xde7]        # 0x5a5a214dfa48
   0x00005a5a214dec61 <+443>:   call   0x5a5a214de190 <puts@plt>
--Type <RET> for more, q to quit, c to continue without paging--
   0x00005a5a214dec66 <+448>:   lea    rdi,[rip+0xe4f]        # 0x5a5a214dfabc
   0x00005a5a214dec6d <+455>:   call   0x5a5a214de190 <puts@plt>
   0x00005a5a214dec72 <+460>:   int3   
=> 0x00005a5a214dec73 <+461>:   nop
   0x00005a5a214dec74 <+462>:   mov    DWORD PTR [rbp-0x1c],0x0
   0x00005a5a214dec7b <+469>:   jmp    0x5a5a214ded2b <main+645>
   0x00005a5a214dec80 <+474>:   mov    esi,0x0
   0x00005a5a214dec85 <+479>:   lea    rdi,[rip+0xe3c]        # 0x5a5a214dfac8
   0x00005a5a214dec8c <+486>:   mov    eax,0x0
   0x00005a5a214dec91 <+491>:   call   0x5a5a214de250 <open@plt>
   0x00005a5a214dec96 <+496>:   mov    ecx,eax
   0x00005a5a214dec98 <+498>:   lea    rax,[rbp-0x18]
   0x00005a5a214dec9c <+502>:   mov    edx,0x8
   0x00005a5a214deca1 <+507>:   mov    rsi,rax
   0x00005a5a214deca4 <+510>:   mov    edi,ecx
   0x00005a5a214deca6 <+512>:   call   0x5a5a214de210 <read@plt>
   0x00005a5a214decab <+517>:   lea    rdi,[rip+0xe26]        # 0x5a5a214dfad8
   0x00005a5a214decb2 <+524>:   call   0x5a5a214de190 <puts@plt>
   0x00005a5a214decb7 <+529>:   lea    rdi,[rip+0xe3a]        # 0x5a5a214dfaf8
   0x00005a5a214decbe <+536>:   mov    eax,0x0
   0x00005a5a214decc3 <+541>:   call   0x5a5a214de1d0 <printf@plt>
   0x00005a5a214decc8 <+546>:   lea    rax,[rbp-0x10]
   0x00005a5a214deccc <+550>:   mov    rsi,rax
   0x00005a5a214deccf <+553>:   lea    rdi,[rip+0xe31]        # 0x5a5a214dfb07
   0x00005a5a214decd6 <+560>:   mov    eax,0x0
   0x00005a5a214decdb <+565>:   call   0x5a5a214de260 <__isoc99_scanf@plt>
   0x00005a5a214dece0 <+570>:   mov    rax,QWORD PTR [rbp-0x10]
   0x00005a5a214dece4 <+574>:   mov    rsi,rax
   0x00005a5a214dece7 <+577>:   lea    rdi,[rip+0xe1e]        # 0x5a5a214dfb0c
--Type <RET> for more, q to quit, c to continue without paging--
   0x00005a5a214decee <+584>:   mov    eax,0x0
   0x00005a5a214decf3 <+589>:   call   0x5a5a214de1d0 <printf@plt>
   0x00005a5a214decf8 <+594>:   mov    rax,QWORD PTR [rbp-0x18]
   0x00005a5a214decfc <+598>:   mov    rsi,rax
   0x00005a5a214decff <+601>:   lea    rdi,[rip+0xe17]        # 0x5a5a214dfb1d
   0x00005a5a214ded06 <+608>:   mov    eax,0x0
   0x00005a5a214ded0b <+613>:   call   0x5a5a214de1d0 <printf@plt>
   0x00005a5a214ded10 <+618>:   mov    rdx,QWORD PTR [rbp-0x10]
   0x00005a5a214ded14 <+622>:   mov    rax,QWORD PTR [rbp-0x18]
   0x00005a5a214ded18 <+626>:   cmp    rdx,rax
   0x00005a5a214ded1b <+629>:   je     0x5a5a214ded27 <main+641>
   0x00005a5a214ded1d <+631>:   mov    edi,0x1
   0x00005a5a214ded22 <+636>:   call   0x5a5a214de280 <exit@plt>
   0x00005a5a214ded27 <+641>:   add    DWORD PTR [rbp-0x1c],0x1
   0x00005a5a214ded2b <+645>:   cmp    DWORD PTR [rbp-0x1c],0x3
   0x00005a5a214ded2f <+649>:   jle    0x5a5a214dec80 <main+474>
   0x00005a5a214ded35 <+655>:   mov    eax,0x0
   0x00005a5a214ded3a <+660>:   call   0x5a5a214de97d <win>
   0x00005a5a214ded3f <+665>:   mov    eax,0x0
   0x00005a5a214ded44 <+670>:   mov    rcx,QWORD PTR [rbp-0x8]
   0x00005a5a214ded48 <+674>:   xor    rcx,QWORD PTR fs:0x28
   0x00005a5a214ded51 <+683>:   je     0x5a5a214ded58 <main+690>
   0x00005a5a214ded53 <+685>:   call   0x5a5a214de1c0 <__stack_chk_fail@plt>
   0x00005a5a214ded58 <+690>:   leave  
   0x00005a5a214ded59 <+691>:   ret    
End of assembler dump.
```

There is part when random value is set so we need to check the stack condition before and after that so we will set breakpoints before and after and examine the stack.

```bash
(gdb) x/s 0x5a5a214dfad8
0x5a5a214dfad8: "The random value has been set!\n"
(gdb) b *0x00005a5a214decb2
Breakpoint 1 at 0x5a5a214decb2
(gdb) b *0x00005a5a214deca6
Breakpoint 2 at 0x5a5a214deca6
```

Running the program again and checking comparing stack values to the desired input for flag.

```bash
(gdb) c
Continuing.

Breakpoint 2, 0x00005a5a214deca6 in main ()
(gdb) x/16gx $rsp
0x7ffea0cd8dc0: 0x0000000000000002      0x00007ffea0cd8f08
0x7ffea0cd8dd0: 0x00007ffea0cd8ef8      0x00000001214ded60
0x7ffea0cd8de0: 0x0000000000000000      0x00005a5a214de2a0
0x7ffea0cd8df0: 0x00007ffea0cd8ef0      0xbf7aecb59d4edb00
0x7ffea0cd8e00: 0x0000000000000000      0x000073fb7f3f5083
0x7ffea0cd8e10: 0x000073fb7f600620      0x00007ffea0cd8ef8
0x7ffea0cd8e20: 0x0000000100000000      0x00005a5a214deaa6
0x7ffea0cd8e30: 0x00005a5a214ded60      0xb7b74b5bedda8e8b
(gdb) c
Continuing.

Breakpoint 1, 0x00005a5a214decb2 in main ()
(gdb) ni
The random value has been set!

0x00005a5a214decb7 in main ()
(gdb) x/16gx $rsp
0x7ffea0cd8dc0: 0x0000000000000002      0x00007ffea0cd8f08
0x7ffea0cd8dd0: 0x00007ffea0cd8ef8      0x00000001214ded60
0x7ffea0cd8de0: 0x0000000000000000      0xa12ffef81bac1991
0x7ffea0cd8df0: 0x00007ffea0cd8ef0      0xbf7aecb59d4edb00
0x7ffea0cd8e00: 0x0000000000000000      0x000073fb7f3f5083
0x7ffea0cd8e10: 0x000073fb7f600620      0x00007ffea0cd8ef8
0x7ffea0cd8e20: 0x0000000100000000      0x00005a5a214deaa6
0x7ffea0cd8e30: 0x00005a5a214ded60      0xb7b74b5bedda8e8b
(gdb) c
Continuing.
Random value: 0xa12ffef81bac1991
You input: a12ffef81bac1991
The correct answer is: a12ffef81bac1991

Breakpoint 2, 0x00005a5a214deca6 in main ()
(gdb) c
Continuing.

Breakpoint 1, 0x00005a5a214decb2 in main ()
(gdb) x/16gx $rsp
0x7ffea0cd8dc0: 0x0000000000000002      0x00007ffea0cd8f08
0x7ffea0cd8dd0: 0x00007ffea0cd8ef8      0x00000001214ded60
0x7ffea0cd8de0: 0x0000000100000000      0x7df93478fe80b308
0x7ffea0cd8df0: 0xa12ffef81bac1991      0xbf7aecb59d4edb00
0x7ffea0cd8e00: 0x0000000000000000      0x000073fb7f3f5083
0x7ffea0cd8e10: 0x000073fb7f600620      0x00007ffea0cd8ef8
0x7ffea0cd8e20: 0x0000000100000000      0x00005a5a214deaa6
0x7ffea0cd8e30: 0x00005a5a214ded60      0xb7b74b5bedda8e8b
(gdb) c
Continuing.
The random value has been set!

Random value: 0x7df93478fe80b308
You input: 7df93478fe80b308
The correct answer is: 7df93478fe80b308

Breakpoint 2, 0x00005a5a214deca6 in main ()
(gdb) c
Continuing.

Breakpoint 1, 0x00005a5a214decb2 in main ()
(gdb) x/16gx $rsp
0x7ffea0cd8dc0: 0x0000000000000002      0x00007ffea0cd8f08
0x7ffea0cd8dd0: 0x00007ffea0cd8ef8      0x00000001214ded60
0x7ffea0cd8de0: 0x0000000200000000      0x0853c24795d16a88
0x7ffea0cd8df0: 0x7df93478fe80b308      0xbf7aecb59d4edb00
0x7ffea0cd8e00: 0x0000000000000000      0x000073fb7f3f5083
0x7ffea0cd8e10: 0x000073fb7f600620      0x00007ffea0cd8ef8
0x7ffea0cd8e20: 0x0000000100000000      0x00005a5a214deaa6
0x7ffea0cd8e30: 0x00005a5a214ded60      0xb7b74b5bedda8e8b
(gdb) c
Continuing.
The random value has been set!

Random value: 0x0853c24795d16a88
You input: 853c24795d16a88
The correct answer is: 853c24795d16a88

Breakpoint 2, 0x00005a5a214deca6 in main ()
(gdb) c
Continuing.

Breakpoint 1, 0x00005a5a214decb2 in main ()
(gdb) x/16gx $rsp
0x7ffea0cd8dc0: 0x0000000000000002      0x00007ffea0cd8f08
0x7ffea0cd8dd0: 0x00007ffea0cd8ef8      0x00000001214ded60
0x7ffea0cd8de0: 0x0000000300000000      0x8dee3cbeda3a4159
0x7ffea0cd8df0: 0x0853c24795d16a88      0xbf7aecb59d4edb00
0x7ffea0cd8e00: 0x0000000000000000      0x000073fb7f3f5083
0x7ffea0cd8e10: 0x000073fb7f600620      0x00007ffea0cd8ef8
0x7ffea0cd8e20: 0x0000000100000000      0x00005a5a214deaa6
0x7ffea0cd8e30: 0x00005a5a214ded60      0xb7b74b5bedda8e8b
(gdb) c
Continuing.
The random value has been set!

Random value: 0x8dee3cbeda3a4159
You input: 8dee3cbeda3a4159
The correct answer is: 8dee3cbeda3a4159
You win! Here is your flag:
pwn.college{redacted}
```

## GDB Scripting

This is same as the previous challenge but we need to answer more questions. Below is disassembly of `main`.

```bash
(gdb) disass main
Dump of assembler code for function main:
   0x000062a2d5c2daa6 <+0>:     endbr64 
   0x000062a2d5c2daaa <+4>:     push   rbp
   0x000062a2d5c2daab <+5>:     mov    rbp,rsp
   0x000062a2d5c2daae <+8>:     sub    rsp,0x40
   0x000062a2d5c2dab2 <+12>:    mov    DWORD PTR [rbp-0x24],edi
   0x000062a2d5c2dab5 <+15>:    mov    QWORD PTR [rbp-0x30],rsi
   0x000062a2d5c2dab9 <+19>:    mov    QWORD PTR [rbp-0x38],rdx
   0x000062a2d5c2dabd <+23>:    mov    rax,QWORD PTR fs:0x28
   0x000062a2d5c2dac6 <+32>:    mov    QWORD PTR [rbp-0x8],rax
   0x000062a2d5c2daca <+36>:    xor    eax,eax
   0x000062a2d5c2dacc <+38>:    cmp    DWORD PTR [rbp-0x24],0x0
   0x000062a2d5c2dad0 <+42>:    jg     0x62a2d5c2daf1 <main+75>
   0x000062a2d5c2dad2 <+44>:    lea    rcx,[rip+0x1050]        # 0x62a2d5c2eb29 <__PRETTY_FUNCTION__.5345>
   0x000062a2d5c2dad9 <+51>:    mov    edx,0x51
   0x000062a2d5c2dade <+56>:    lea    rsi,[rip+0x54c]        # 0x62a2d5c2e031
   0x000062a2d5c2dae5 <+63>:    lea    rdi,[rip+0x6d0]        # 0x62a2d5c2e1bc
   0x000062a2d5c2daec <+70>:    call   0x62a2d5c2d1f0 <__assert_fail@plt>
   0x000062a2d5c2daf1 <+75>:    lea    rdi,[rip+0x6cd]        # 0x62a2d5c2e1c5
   0x000062a2d5c2daf8 <+82>:    call   0x62a2d5c2d190 <puts@plt>
   0x000062a2d5c2dafd <+87>:    mov    rax,QWORD PTR [rbp-0x30]
   0x000062a2d5c2db01 <+91>:    mov    rax,QWORD PTR [rax]
   0x000062a2d5c2db04 <+94>:    mov    rsi,rax
--Type <RET> for more, q to quit, c to continue without paging--
   0x000062a2d5c2db07 <+97>:    lea    rdi,[rip+0x6bb]        # 0x62a2d5c2e1c9
   0x000062a2d5c2db0e <+104>:   mov    eax,0x0
   0x000062a2d5c2db13 <+109>:   call   0x62a2d5c2d1d0 <printf@plt>
   0x000062a2d5c2db18 <+114>:   lea    rdi,[rip+0x6a6]        # 0x62a2d5c2e1c5
   0x000062a2d5c2db1f <+121>:   call   0x62a2d5c2d190 <puts@plt>
   0x000062a2d5c2db24 <+126>:   mov    edi,0xa
   0x000062a2d5c2db29 <+131>:   call   0x62a2d5c2d170 <putchar@plt>
   0x000062a2d5c2db2e <+136>:   mov    rax,QWORD PTR [rip+0x24eb]        # 0x62a2d5c30020 <stdin@@GLIBC_2.2.5>
   0x000062a2d5c2db35 <+143>:   mov    ecx,0x0
   0x000062a2d5c2db3a <+148>:   mov    edx,0x2
   0x000062a2d5c2db3f <+153>:   mov    esi,0x0
   0x000062a2d5c2db44 <+158>:   mov    rdi,rax
   0x000062a2d5c2db47 <+161>:   call   0x62a2d5c2d240 <setvbuf@plt>
   0x000062a2d5c2db4c <+166>:   mov    rax,QWORD PTR [rip+0x24bd]        # 0x62a2d5c30010 <stdout@@GLIBC_2.2.5>
   0x000062a2d5c2db53 <+173>:   mov    ecx,0x1
   0x000062a2d5c2db58 <+178>:   mov    edx,0x2
   0x000062a2d5c2db5d <+183>:   mov    esi,0x0
   0x000062a2d5c2db62 <+188>:   mov    rdi,rax
   0x000062a2d5c2db65 <+191>:   call   0x62a2d5c2d240 <setvbuf@plt>
   0x000062a2d5c2db6a <+196>:   lea    rdi,[rip+0x66f]        # 0x62a2d5c2e1e0
   0x000062a2d5c2db71 <+203>:   call   0x62a2d5c2d190 <puts@plt>
   0x000062a2d5c2db76 <+208>:   lea    rdi,[rip+0x6db]        # 0x62a2d5c2e258
--Type <RET> for more, q to quit, c to continue without paging--
   0x000062a2d5c2db7d <+215>:   call   0x62a2d5c2d190 <puts@plt>
   0x000062a2d5c2db82 <+220>:   lea    rdi,[rip+0x72f]        # 0x62a2d5c2e2b8
   0x000062a2d5c2db89 <+227>:   call   0x62a2d5c2d190 <puts@plt>
   0x000062a2d5c2db8e <+232>:   lea    rdi,[rip+0x7a3]        # 0x62a2d5c2e338
   0x000062a2d5c2db95 <+239>:   call   0x62a2d5c2d190 <puts@plt>
   0x000062a2d5c2db9a <+244>:   lea    rdi,[rip+0x7ff]        # 0x62a2d5c2e3a0
   0x000062a2d5c2dba1 <+251>:   call   0x62a2d5c2d190 <puts@plt>
   0x000062a2d5c2dba6 <+256>:   lea    rdi,[rip+0x86b]        # 0x62a2d5c2e418
   0x000062a2d5c2dbad <+263>:   call   0x62a2d5c2d190 <puts@plt>
   0x000062a2d5c2dbb2 <+268>:   lea    rdi,[rip+0x8d7]        # 0x62a2d5c2e490
   0x000062a2d5c2dbb9 <+275>:   call   0x62a2d5c2d190 <puts@plt>
   0x000062a2d5c2dbbe <+280>:   lea    rdi,[rip+0x943]        # 0x62a2d5c2e508
   0x000062a2d5c2dbc5 <+287>:   call   0x62a2d5c2d190 <puts@plt>
   0x000062a2d5c2dbca <+292>:   lea    rdi,[rip+0x9af]        # 0x62a2d5c2e580
   0x000062a2d5c2dbd1 <+299>:   call   0x62a2d5c2d190 <puts@plt>
   0x000062a2d5c2dbd6 <+304>:   lea    rdi,[rip+0xa1b]        # 0x62a2d5c2e5f8
   0x000062a2d5c2dbdd <+311>:   call   0x62a2d5c2d190 <puts@plt>
   0x000062a2d5c2dbe2 <+316>:   lea    rdi,[rip+0xa87]        # 0x62a2d5c2e670
   0x000062a2d5c2dbe9 <+323>:   call   0x62a2d5c2d190 <puts@plt>
   0x000062a2d5c2dbee <+328>:   lea    rdi,[rip+0xaf1]        # 0x62a2d5c2e6e6
   0x000062a2d5c2dbf5 <+335>:   call   0x62a2d5c2d190 <puts@plt>
   0x000062a2d5c2dbfa <+340>:   lea    rdi,[rip+0xaf7]        # 0x62a2d5c2e6f8
   0x000062a2d5c2dc01 <+347>:   call   0x62a2d5c2d190 <puts@plt>
   0x000062a2d5c2dc06 <+352>:   lea    rdi,[rip+0xb57]        # 0x62a2d5c2e764
--Type <RET> for more, q to quit, c to continue without paging--
   0x000062a2d5c2dc0d <+359>:   call   0x62a2d5c2d190 <puts@plt>
   0x000062a2d5c2dc12 <+364>:   lea    rdi,[rip+0xb53]        # 0x62a2d5c2e76c
   0x000062a2d5c2dc19 <+371>:   call   0x62a2d5c2d190 <puts@plt>
   0x000062a2d5c2dc1e <+376>:   lea    rdi,[rip+0xb58]        # 0x62a2d5c2e77d
   0x000062a2d5c2dc25 <+383>:   call   0x62a2d5c2d190 <puts@plt>
   0x000062a2d5c2dc2a <+388>:   lea    rdi,[rip+0xb57]        # 0x62a2d5c2e788
   0x000062a2d5c2dc31 <+395>:   call   0x62a2d5c2d190 <puts@plt>
   0x000062a2d5c2dc36 <+400>:   lea    rdi,[rip+0xb5e]        # 0x62a2d5c2e79b
   0x000062a2d5c2dc3d <+407>:   call   0x62a2d5c2d190 <puts@plt>
   0x000062a2d5c2dc42 <+412>:   lea    rdi,[rip+0xb5f]        # 0x62a2d5c2e7a8
   0x000062a2d5c2dc49 <+419>:   call   0x62a2d5c2d190 <puts@plt>
   0x000062a2d5c2dc4e <+424>:   lea    rdi,[rip+0xb59]        # 0x62a2d5c2e7ae
   0x000062a2d5c2dc55 <+431>:   call   0x62a2d5c2d190 <puts@plt>
   0x000062a2d5c2dc5a <+436>:   lea    rdi,[rip+0xb58]        # 0x62a2d5c2e7b9
   0x000062a2d5c2dc61 <+443>:   call   0x62a2d5c2d190 <puts@plt>
   0x000062a2d5c2dc66 <+448>:   lea    rdi,[rip+0xb53]        # 0x62a2d5c2e7c0
   0x000062a2d5c2dc6d <+455>:   call   0x62a2d5c2d190 <puts@plt>
   0x000062a2d5c2dc72 <+460>:   lea    rdi,[rip+0xbc0]        # 0x62a2d5c2e839
   0x000062a2d5c2dc79 <+467>:   call   0x62a2d5c2d190 <puts@plt>
   0x000062a2d5c2dc7e <+472>:   lea    rdi,[rip+0xbc3]        # 0x62a2d5c2e848
   0x000062a2d5c2dc85 <+479>:   call   0x62a2d5c2d190 <puts@plt>
   0x000062a2d5c2dc8a <+484>:   lea    rdi,[rip+0xad3]        # 0x62a2d5c2e764
   0x000062a2d5c2dc91 <+491>:   call   0x62a2d5c2d190 <puts@plt>
   0x000062a2d5c2dc96 <+496>:   lea    rdi,[rip+0xacf]        # 0x62a2d5c2e76c
--Type <RET> for more, q to quit, c to continue without paging--
   0x000062a2d5c2dc9d <+503>:   call   0x62a2d5c2d190 <puts@plt>
   0x000062a2d5c2dca2 <+508>:   lea    rdi,[rip+0xad4]        # 0x62a2d5c2e77d
   0x000062a2d5c2dca9 <+515>:   call   0x62a2d5c2d190 <puts@plt>
   0x000062a2d5c2dcae <+520>:   lea    rdi,[rip+0xbf8]        # 0x62a2d5c2e8ad
   0x000062a2d5c2dcb5 <+527>:   call   0x62a2d5c2d190 <puts@plt>
   0x000062a2d5c2dcba <+532>:   lea    rdi,[rip+0xbf7]        # 0x62a2d5c2e8b8
   0x000062a2d5c2dcc1 <+539>:   call   0x62a2d5c2d190 <puts@plt>
   0x000062a2d5c2dcc6 <+544>:   lea    rdi,[rip+0xc2b]        # 0x62a2d5c2e8f8
   0x000062a2d5c2dccd <+551>:   call   0x62a2d5c2d190 <puts@plt>
   0x000062a2d5c2dcd2 <+556>:   lea    rdi,[rip+0xac2]        # 0x62a2d5c2e79b
   0x000062a2d5c2dcd9 <+563>:   call   0x62a2d5c2d190 <puts@plt>
   0x000062a2d5c2dcde <+568>:   lea    rdi,[rip+0xac3]        # 0x62a2d5c2e7a8
   0x000062a2d5c2dce5 <+575>:   call   0x62a2d5c2d190 <puts@plt>
   0x000062a2d5c2dcea <+580>:   lea    rdi,[rip+0xabd]        # 0x62a2d5c2e7ae
   0x000062a2d5c2dcf1 <+587>:   call   0x62a2d5c2d190 <puts@plt>
   0x000062a2d5c2dcf6 <+592>:   lea    rdi,[rip+0xabc]        # 0x62a2d5c2e7b9
   0x000062a2d5c2dcfd <+599>:   call   0x62a2d5c2d190 <puts@plt>
   0x000062a2d5c2dd02 <+604>:   lea    rdi,[rip+0xc27]        # 0x62a2d5c2e930
   0x000062a2d5c2dd09 <+611>:   call   0x62a2d5c2d190 <puts@plt>
   0x000062a2d5c2dd0e <+616>:   lea    rdi,[rip+0xc93]        # 0x62a2d5c2e9a8
   0x000062a2d5c2dd15 <+623>:   call   0x62a2d5c2d190 <puts@plt>
   0x000062a2d5c2dd1a <+628>:   lea    rdi,[rip+0xcff]        # 0x62a2d5c2ea20
   0x000062a2d5c2dd21 <+635>:   call   0x62a2d5c2d190 <puts@plt>
   0x000062a2d5c2dd26 <+640>:   lea    rdi,[rip+0xd43]        # 0x62a2d5c2ea70
--Type <RET> for more, q to quit, c to continue without paging--
   0x000062a2d5c2dd2d <+647>:   call   0x62a2d5c2d190 <puts@plt>
   0x000062a2d5c2dd32 <+652>:   int3   
=> 0x000062a2d5c2dd33 <+653>:   nop
   0x000062a2d5c2dd34 <+654>:   mov    DWORD PTR [rbp-0x1c],0x0
   0x000062a2d5c2dd3b <+661>:   jmp    0x62a2d5c2ddeb <main+837>
   0x000062a2d5c2dd40 <+666>:   mov    esi,0x0
   0x000062a2d5c2dd45 <+671>:   lea    rdi,[rip+0xd5e]        # 0x62a2d5c2eaaa
   0x000062a2d5c2dd4c <+678>:   mov    eax,0x0
   0x000062a2d5c2dd51 <+683>:   call   0x62a2d5c2d250 <open@plt>
   0x000062a2d5c2dd56 <+688>:   mov    ecx,eax
   0x000062a2d5c2dd58 <+690>:   lea    rax,[rbp-0x18]
   0x000062a2d5c2dd5c <+694>:   mov    edx,0x8
   0x000062a2d5c2dd61 <+699>:   mov    rsi,rax
   0x000062a2d5c2dd64 <+702>:   mov    edi,ecx
   0x000062a2d5c2dd66 <+704>:   call   0x62a2d5c2d210 <read@plt>
   0x000062a2d5c2dd6b <+709>:   lea    rdi,[rip+0xd46]        # 0x62a2d5c2eab8
   0x000062a2d5c2dd72 <+716>:   call   0x62a2d5c2d190 <puts@plt>
   0x000062a2d5c2dd77 <+721>:   lea    rdi,[rip+0xd5a]        # 0x62a2d5c2ead8
   0x000062a2d5c2dd7e <+728>:   mov    eax,0x0
   0x000062a2d5c2dd83 <+733>:   call   0x62a2d5c2d1d0 <printf@plt>
   0x000062a2d5c2dd88 <+738>:   lea    rax,[rbp-0x10]
   0x000062a2d5c2dd8c <+742>:   mov    rsi,rax
   0x000062a2d5c2dd8f <+745>:   lea    rdi,[rip+0xd51]        # 0x62a2d5c2eae7
   0x000062a2d5c2dd96 <+752>:   mov    eax,0x0
--Type <RET> for more, q to quit, c to continue without paging--
   0x000062a2d5c2dd9b <+757>:   call   0x62a2d5c2d260 <__isoc99_scanf@plt>
   0x000062a2d5c2dda0 <+762>:   mov    rax,QWORD PTR [rbp-0x10]
   0x000062a2d5c2dda4 <+766>:   mov    rsi,rax
   0x000062a2d5c2dda7 <+769>:   lea    rdi,[rip+0xd3e]        # 0x62a2d5c2eaec
   0x000062a2d5c2ddae <+776>:   mov    eax,0x0
   0x000062a2d5c2ddb3 <+781>:   call   0x62a2d5c2d1d0 <printf@plt>
   0x000062a2d5c2ddb8 <+786>:   mov    rax,QWORD PTR [rbp-0x18]
   0x000062a2d5c2ddbc <+790>:   mov    rsi,rax
   0x000062a2d5c2ddbf <+793>:   lea    rdi,[rip+0xd37]        # 0x62a2d5c2eafd
   0x000062a2d5c2ddc6 <+800>:   mov    eax,0x0
   0x000062a2d5c2ddcb <+805>:   call   0x62a2d5c2d1d0 <printf@plt>
   0x000062a2d5c2ddd0 <+810>:   mov    rdx,QWORD PTR [rbp-0x10]
   0x000062a2d5c2ddd4 <+814>:   mov    rax,QWORD PTR [rbp-0x18]
   0x000062a2d5c2ddd8 <+818>:   cmp    rdx,rax
   0x000062a2d5c2dddb <+821>:   je     0x62a2d5c2dde7 <main+833>
   0x000062a2d5c2dddd <+823>:   mov    edi,0x1
   0x000062a2d5c2dde2 <+828>:   call   0x62a2d5c2d280 <exit@plt>
   0x000062a2d5c2dde7 <+833>:   add    DWORD PTR [rbp-0x1c],0x1
   0x000062a2d5c2ddeb <+837>:   cmp    DWORD PTR [rbp-0x1c],0x7
   0x000062a2d5c2ddef <+841>:   jle    0x62a2d5c2dd40 <main+666>
   0x000062a2d5c2ddf5 <+847>:   mov    eax,0x0
   0x000062a2d5c2ddfa <+852>:   call   0x62a2d5c2d97d <win>
   0x000062a2d5c2ddff <+857>:   mov    eax,0x0
   0x000062a2d5c2de04 <+862>:   mov    rcx,QWORD PTR [rbp-0x8]
--Type <RET> for more, q to quit, c to continue without paging--
   0x000062a2d5c2de08 <+866>:   xor    rcx,QWORD PTR fs:0x28
   0x000062a2d5c2de11 <+875>:   je     0x62a2d5c2de18 <main+882>
   0x000062a2d5c2de13 <+877>:   call   0x62a2d5c2d1c0 <__stack_chk_fail@plt>
   0x000062a2d5c2de18 <+882>:   leave  
   0x000062a2d5c2de19 <+883>:   ret    
End of assembler dump.
```


Setting breakpoints just like before to analyze the stack values.

```bash
(gdb) b *0x000062a2d5c2dd66
Breakpoint 1 at 0x62a2d5c2dd66
(gdb) b *0x000062a2d5c2dd72
Breakpoint 2 at 0x62a2d5c2dd72
```

Running `gdb` to compare the stack values.

```bash
(gdb) c
Continuing.

Breakpoint 1, 0x000062a2d5c2dd66 in main ()
(gdb) x/16gx $rsp
0x7ffc6f05ab30: 0x0000000000000002      0x00007ffc6f05ac78
0x7ffc6f05ab40: 0x00007ffc6f05ac68      0x00000001d5c2de20
0x7ffc6f05ab50: 0x0000000000000000      0x000062a2d5c2d2a0
0x7ffc6f05ab60: 0x00007ffc6f05ac60      0x012c53bea0101a00
0x7ffc6f05ab70: 0x0000000000000000      0x00007f8ad4df2083
0x7ffc6f05ab80: 0x00007f8ad4ffd620      0x00007ffc6f05ac68
0x7ffc6f05ab90: 0x0000000100000000      0x000062a2d5c2daa6
0x7ffc6f05aba0: 0x000062a2d5c2de20      0x62fffacf948c07c9
(gdb) c
Continuing.

Breakpoint 2, 0x000062a2d5c2dd72 in main ()
(gdb) ni
The random value has been set!

0x000062a2d5c2dd77 in main ()
(gdb) x/16gx $rsp
0x7ffc6f05ab30: 0x0000000000000002      0x00007ffc6f05ac78
0x7ffc6f05ab40: 0x00007ffc6f05ac68      0x00000001d5c2de20
0x7ffc6f05ab50: 0x0000000000000000      0xc54081b0eab812f6
0x7ffc6f05ab60: 0x00007ffc6f05ac60      0x012c53bea0101a00
0x7ffc6f05ab70: 0x0000000000000000      0x00007f8ad4df2083
0x7ffc6f05ab80: 0x00007f8ad4ffd620      0x00007ffc6f05ac68
0x7ffc6f05ab90: 0x0000000100000000      0x000062a2d5c2daa6
0x7ffc6f05aba0: 0x000062a2d5c2de20      0x62fffacf948c07c9
(gdb) c
Continuing.
Random value: 0xc54081b0eab812f6
You input: c54081b0eab812f6
The correct answer is: c54081b0eab812f6

Breakpoint 1, 0x000062a2d5c2dd66 in main ()
(gdb) x/16gx $rsp
0x7ffc6f05ab30: 0x0000000000000002      0x00007ffc6f05ac78
0x7ffc6f05ab40: 0x00007ffc6f05ac68      0x00000001d5c2de20
0x7ffc6f05ab50: 0x0000000100000000      0xc54081b0eab812f6
0x7ffc6f05ab60: 0xc54081b0eab812f6      0x012c53bea0101a00
0x7ffc6f05ab70: 0x0000000000000000      0x00007f8ad4df2083
0x7ffc6f05ab80: 0x00007f8ad4ffd620      0x00007ffc6f05ac68
0x7ffc6f05ab90: 0x0000000100000000      0x000062a2d5c2daa6
0x7ffc6f05aba0: 0x000062a2d5c2de20      0x62fffacf948c07c9
(gdb) c
Continuing.

Breakpoint 2, 0x000062a2d5c2dd72 in main ()
(gdb) ni
The random value has been set!

0x000062a2d5c2dd77 in main ()
(gdb) x/16gx $rsp
0x7ffc6f05ab30: 0x0000000000000002      0x00007ffc6f05ac78
0x7ffc6f05ab40: 0x00007ffc6f05ac68      0x00000001d5c2de20
0x7ffc6f05ab50: 0x0000000100000000      0x00cd7a40c7b95a15
0x7ffc6f05ab60: 0xc54081b0eab812f6      0x012c53bea0101a00
0x7ffc6f05ab70: 0x0000000000000000      0x00007f8ad4df2083
0x7ffc6f05ab80: 0x00007f8ad4ffd620      0x00007ffc6f05ac68
0x7ffc6f05ab90: 0x0000000100000000      0x000062a2d5c2daa6
0x7ffc6f05aba0: 0x000062a2d5c2de20      0x62fffacf948c07c9
(gdb) c
Continuing.
Random value: 0x00cd7a40c7b95a15
You input: cd7a40c7b95a15
The correct answer is: cd7a40c7b95a15

Breakpoint 1, 0x000062a2d5c2dd66 in main ()
...(SNIP)...
```

Basically after seeing the `random value has been set!` string check the stack and the random value will always be in the same position as the previous ones. You need to repeat it a couple of times and then you will get the flag.

## Modifying Data

This challenge is same as the previous challenge but we need to do it 64 times so the below python script will help us automate the task.

```python
from pwn import *
import binascii
p = process("/challenge/embryogdb_level6")
p.recvuntil(b"(gdb) ")
p.sendline(b"run")
p.recvuntil(b"(gdb) ")
p.sendline(b"b *main+625")
p.recvuntil(b"(gdb) ")
p.sendline(b"c")
for i in range(64):
        p.recvuntil(b"(gdb) ")
        p.sendline(b"x/16gx $rbp-0x18")
        output = str(p.recvline())
        output1 = str(output[1:])
        output2 = output1.split("\\t")
        p.recvuntil(b"(gdb) ")
        p.sendline(b"c")
        p.recvuntil(b"Continuing.\n")
        p.sendline(str(output2[1]).encode())
p.interactive()
```

```bash
$ python3 solve.py 
[+] Starting local process '/challenge/embryogdb_level6': pid 1268
[*] Switching to interactive mode
You input: 79f1768367e774df
The correct answer is: 79f1768367e774df
You win! Here is your flag:
pwn.college{redacted}
```

## Modifying Execution

Run the `/challenge/e`

```
$ /challenge/embryogdb_level7
(gdb) r
(gdb) c
(gdb) call (void)win()
You win! Here is your flag:
pwn.college{redacted}
```

## Broken Functions

```bash
0x00005bc77b85cb99 in main ()
(gdb) disass main
Dump of assembler code for function main:
   0x00005bc77b85ca75 <+0>:     endbr64 
   0x00005bc77b85ca79 <+4>:     push   rbp
   0x00005bc77b85ca7a <+5>:     mov    rbp,rsp
   0x00005bc77b85ca7d <+8>:     sub    rsp,0x30
   0x00005bc77b85ca81 <+12>:    mov    DWORD PTR [rbp-0x14],edi
   0x00005bc77b85ca84 <+15>:    mov    QWORD PTR [rbp-0x20],rsi
   0x00005bc77b85ca88 <+19>:    mov    QWORD PTR [rbp-0x28],rdx
   0x00005bc77b85ca8c <+23>:    mov    rax,QWORD PTR fs:0x28
   0x00005bc77b85ca95 <+32>:    mov    QWORD PTR [rbp-0x8],rax
   0x00005bc77b85ca99 <+36>:    xor    eax,eax
   0x00005bc77b85ca9b <+38>:    mov    rax,QWORD PTR [rip+0x258e]        # 0x5bc77b85f030 <stdin@@GLIBC_2.2.5>
   0x00005bc77b85caa2 <+45>:    mov    ecx,0x0
   0x00005bc77b85caa7 <+50>:    mov    edx,0x2
   0x00005bc77b85caac <+55>:    mov    esi,0x0
   0x00005bc77b85cab1 <+60>:    mov    rdi,rax
   0x00005bc77b85cab4 <+63>:    call   0x5bc77b85c230 <setvbuf@plt>
   0x00005bc77b85cab9 <+68>:    mov    rax,QWORD PTR [rip+0x2560]        # 0x5bc77b85f020 <stdout@@GLIBC_2.2.5>
   0x00005bc77b85cac0 <+75>:    mov    ecx,0x0
   0x00005bc77b85cac5 <+80>:    mov    edx,0x2
   0x00005bc77b85caca <+85>:    mov    esi,0x0
   0x00005bc77b85cacf <+90>:    mov    rdi,rax
   0x00005bc77b85cad2 <+93>:    call   0x5bc77b85c230 <setvbuf@plt>
--Type <RET> for more, q to quit, c to continue without paging--
   0x00005bc77b85cad7 <+98>:    lea    rdi,[rip+0x6de]        # 0x5bc77b85d1bc
   0x00005bc77b85cade <+105>:   call   0x5bc77b85c180 <puts@plt>
   0x00005bc77b85cae3 <+110>:   mov    rax,QWORD PTR [rbp-0x20]
   0x00005bc77b85cae7 <+114>:   mov    rax,QWORD PTR [rax]
   0x00005bc77b85caea <+117>:   mov    rsi,rax
   0x00005bc77b85caed <+120>:   lea    rdi,[rip+0x6cc]        # 0x5bc77b85d1c0
   0x00005bc77b85caf4 <+127>:   mov    eax,0x0
   0x00005bc77b85caf9 <+132>:   call   0x5bc77b85c1c0 <printf@plt>
   0x00005bc77b85cafe <+137>:   lea    rdi,[rip+0x6b7]        # 0x5bc77b85d1bc
   0x00005bc77b85cb05 <+144>:   call   0x5bc77b85c180 <puts@plt>
   0x00005bc77b85cb0a <+149>:   mov    edi,0xa
   0x00005bc77b85cb0f <+154>:   call   0x5bc77b85c160 <putchar@plt>
   0x00005bc77b85cb14 <+159>:   lea    rdi,[rip+0x6bd]        # 0x5bc77b85d1d8
   0x00005bc77b85cb1b <+166>:   call   0x5bc77b85c180 <puts@plt>
   0x00005bc77b85cb20 <+171>:   lea    rdi,[rip+0x729]        # 0x5bc77b85d250
   0x00005bc77b85cb27 <+178>:   call   0x5bc77b85c180 <puts@plt>
   0x00005bc77b85cb2c <+183>:   lea    rdi,[rip+0x77d]        # 0x5bc77b85d2b0
   0x00005bc77b85cb33 <+190>:   call   0x5bc77b85c180 <puts@plt>
   0x00005bc77b85cb38 <+195>:   lea    rdi,[rip+0x7e9]        # 0x5bc77b85d328
   0x00005bc77b85cb3f <+202>:   call   0x5bc77b85c180 <puts@plt>
   0x00005bc77b85cb44 <+207>:   lea    rdi,[rip+0x85d]        # 0x5bc77b85d3a8
   0x00005bc77b85cb4b <+214>:   call   0x5bc77b85c180 <puts@plt>
   0x00005bc77b85cb50 <+219>:   lea    rdi,[rip+0x8c9]        # 0x5bc77b85d420
   0x00005bc77b85cb57 <+226>:   call   0x5bc77b85c180 <puts@plt>
   0x00005bc77b85cb5c <+231>:   lea    rdi,[rip+0x935]        # 0x5bc77b85d498
--Type <RET> for more, q to quit, c to continue without paging--
   0x00005bc77b85cb63 <+238>:   call   0x5bc77b85c180 <puts@plt>
   0x00005bc77b85cb68 <+243>:   lea    rdi,[rip+0x971]        # 0x5bc77b85d4e0
   0x00005bc77b85cb6f <+250>:   call   0x5bc77b85c180 <puts@plt>
   0x00005bc77b85cb74 <+255>:   lea    rdi,[rip+0x9d9]        # 0x5bc77b85d554
   0x00005bc77b85cb7b <+262>:   call   0x5bc77b85c180 <puts@plt>
   0x00005bc77b85cb80 <+267>:   lea    rdi,[rip+0x9e9]        # 0x5bc77b85d570
   0x00005bc77b85cb87 <+274>:   call   0x5bc77b85c180 <puts@plt>
   0x00005bc77b85cb8c <+279>:   lea    rdi,[rip+0xa35]        # 0x5bc77b85d5c8
   0x00005bc77b85cb93 <+286>:   call   0x5bc77b85c180 <puts@plt>
   0x00005bc77b85cb98 <+291>:   int3   
=> 0x00005bc77b85cb99 <+292>:   nop
   0x00005bc77b85cb9a <+293>:   mov    edi,0x2a
   0x00005bc77b85cb9f <+298>:   call   0x5bc77b85c260 <exit@plt>
End of assembler dump.
(gdb) 
(gdb) disass win
Dump of assembler code for function win:
   0x00005bc77b85c951 <+0>:     endbr64 
   0x00005bc77b85c955 <+4>:     push   rbp
   0x00005bc77b85c956 <+5>:     mov    rbp,rsp
   0x00005bc77b85c959 <+8>:     sub    rsp,0x10
   0x00005bc77b85c95d <+12>:    mov    QWORD PTR [rbp-0x8],0x0
   0x00005bc77b85c965 <+20>:    mov    rax,QWORD PTR [rbp-0x8]
   0x00005bc77b85c969 <+24>:    mov    eax,DWORD PTR [rax]
   0x00005bc77b85c96b <+26>:    lea    edx,[rax+0x1]
   0x00005bc77b85c96e <+29>:    mov    rax,QWORD PTR [rbp-0x8]
   0x00005bc77b85c972 <+33>:    mov    DWORD PTR [rax],edx
   0x00005bc77b85c974 <+35>:    lea    rdi,[rip+0x73e]        # 0x5bc77b85d0b9
   0x00005bc77b85c97b <+42>:    call   0x5bc77b85c180 <puts@plt>
   0x00005bc77b85c980 <+47>:    mov    esi,0x0
   0x00005bc77b85c985 <+52>:    lea    rdi,[rip+0x749]        # 0x5bc77b85d0d5
   0x00005bc77b85c98c <+59>:    mov    eax,0x0
   0x00005bc77b85c991 <+64>:    call   0x5bc77b85c240 <open@plt>
   0x00005bc77b85c996 <+69>:    mov    DWORD PTR [rip+0x26a4],eax        # 0x5bc77b85f040 <flag_fd.5712>
   0x00005bc77b85c99c <+75>:    mov    eax,DWORD PTR [rip+0x269e]        # 0x5bc77b85f040 <flag_fd.5712>
   0x00005bc77b85c9a2 <+81>:    test   eax,eax
   0x00005bc77b85c9a4 <+83>:    jns    0x5bc77b85c9ef <win+158>
   0x00005bc77b85c9a6 <+85>:    call   0x5bc77b85c170 <__errno_location@plt>
   0x00005bc77b85c9ab <+90>:    mov    eax,DWORD PTR [rax]
--Type <RET> for more, q to quit, c to continue without paging--
   0x00005bc77b85c9ad <+92>:    mov    edi,eax
   0x00005bc77b85c9af <+94>:    call   0x5bc77b85c270 <strerror@plt>
   0x00005bc77b85c9b4 <+99>:    mov    rsi,rax
   0x00005bc77b85c9b7 <+102>:   lea    rdi,[rip+0x722]        # 0x5bc77b85d0e0
   0x00005bc77b85c9be <+109>:   mov    eax,0x0
   0x00005bc77b85c9c3 <+114>:   call   0x5bc77b85c1c0 <printf@plt>
   0x00005bc77b85c9c8 <+119>:   call   0x5bc77b85c1f0 <geteuid@plt>
   0x00005bc77b85c9cd <+124>:   test   eax,eax
   0x00005bc77b85c9cf <+126>:   je     0x5bc77b85ca66 <win+277>
   0x00005bc77b85c9d5 <+132>:   lea    rdi,[rip+0x734]        # 0x5bc77b85d110
   0x00005bc77b85c9dc <+139>:   call   0x5bc77b85c180 <puts@plt>
   0x00005bc77b85c9e1 <+144>:   lea    rdi,[rip+0x750]        # 0x5bc77b85d138
   0x00005bc77b85c9e8 <+151>:   call   0x5bc77b85c180 <puts@plt>
   0x00005bc77b85c9ed <+156>:   jmp    0x5bc77b85ca66 <win+277>
   0x00005bc77b85c9ef <+158>:   mov    eax,DWORD PTR [rip+0x264b]        # 0x5bc77b85f040 <flag_fd.5712>
   0x00005bc77b85c9f5 <+164>:   mov    edx,0x100
   0x00005bc77b85c9fa <+169>:   lea    rsi,[rip+0x265f]        # 0x5bc77b85f060 <flag.5711>
   0x00005bc77b85ca01 <+176>:   mov    edi,eax
   0x00005bc77b85ca03 <+178>:   call   0x5bc77b85c200 <read@plt>
   0x00005bc77b85ca08 <+183>:   mov    DWORD PTR [rip+0x2752],eax        # 0x5bc77b85f160 <flag_length.5713>
   0x00005bc77b85ca0e <+189>:   mov    eax,DWORD PTR [rip+0x274c]        # 0x5bc77b85f160 <flag_length.5713>
   0x00005bc77b85ca14 <+195>:   test   eax,eax
--Type <RET> for more, q to quit, c to continue without paging--
   0x00005bc77b85ca16 <+197>:   jg     0x5bc77b85ca3c <win+235>
   0x00005bc77b85ca18 <+199>:   call   0x5bc77b85c170 <__errno_location@plt>
   0x00005bc77b85ca1d <+204>:   mov    eax,DWORD PTR [rax]
   0x00005bc77b85ca1f <+206>:   mov    edi,eax
   0x00005bc77b85ca21 <+208>:   call   0x5bc77b85c270 <strerror@plt>
   0x00005bc77b85ca26 <+213>:   mov    rsi,rax
   0x00005bc77b85ca29 <+216>:   lea    rdi,[rip+0x760]        # 0x5bc77b85d190
   0x00005bc77b85ca30 <+223>:   mov    eax,0x0
   0x00005bc77b85ca35 <+228>:   call   0x5bc77b85c1c0 <printf@plt>
   0x00005bc77b85ca3a <+233>:   jmp    0x5bc77b85ca67 <win+278>
   0x00005bc77b85ca3c <+235>:   mov    eax,DWORD PTR [rip+0x271e]        # 0x5bc77b85f160 <flag_length.5713>
   0x00005bc77b85ca42 <+241>:   cdqe   
   0x00005bc77b85ca44 <+243>:   mov    rdx,rax
   0x00005bc77b85ca47 <+246>:   lea    rsi,[rip+0x2612]        # 0x5bc77b85f060 <flag.5711>
   0x00005bc77b85ca4e <+253>:   mov    edi,0x1
   0x00005bc77b85ca53 <+258>:   call   0x5bc77b85c1a0 <write@plt>
   0x00005bc77b85ca58 <+263>:   lea    rdi,[rip+0x75b]        # 0x5bc77b85d1ba
   0x00005bc77b85ca5f <+270>:   call   0x5bc77b85c180 <puts@plt>
   0x00005bc77b85ca64 <+275>:   jmp    0x5bc77b85ca67 <win+278>
   0x00005bc77b85ca66 <+277>:   nop
   0x00005bc77b85ca67 <+278>:   leave  
   0x00005bc77b85ca68 <+279>:   ret  
(gdb) x/s 0x5bc77b85d0d5
0x5bc77b85d0d5: "/flag"
```

We can use the `set` command in `gdb` to change the `rip` value so that we can point into that address and maneuver the instruction pointer to the our desired location and get the flag.

```bash
(gdb) c
Continuing.
pwn.college{redacted}


[Inferior 1 (process 6553) exited with code 02]
```

