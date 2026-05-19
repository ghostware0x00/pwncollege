
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

## Exit

In this challenge we need to create the `exit` syscall. This syscall is used to exit a program and returns a status code which is usually `0`.

```nasm
global _start

section .text

_start:
    mov rax, 0x3c   ; exit syscall
    mov rdi, 0  ; status code
    syscall
```

## Socket

In this challenge we will create a `socket` syscall. A `socket` is basically the building block of network communication. A `socket` typically requires the following 3 arguments. They are :-

- `AF_INET` for IPV4 for example
- `SOCK_STREAM` for TCP
- protocol (usually set to `0`) by default

We need to find the integer which corresponds to `AF_INET`. These numbers are not even found in the man pages, but these numbers do exist on our machine. Check out the `/usr/include` directory. All the system's general-use include files for C programming are placed here.

Read the below header files to get the numbers required to make the arguments necessary for `socket` syscall :-
- `/usr/include/x86_64-linux-gnu/bits/socket.h`
	- `AF_INET -> 2 `
- `/usr/include/x86_64-linux-gnu/bits/socket_type.h`
	- `SOCK_STREAM -> 1`
- `/usr/include/netinet/in.h`
	- `IPPROTO_TCP = 6`

So the above header files gave us our 3 necessary values for the 3 arguments required to make the `socket` syscall. Below is the assembly code required to get the flag. According to the Linux Syscall Table `socket` syscall number is `0x29` or `41`.

```nasm
global _start

section .text

_start:
    mov rax, 0x29   ; socket syscall number
    mov rdi, 2  ; AF_INET for IPV4 addresses
    mov rsi, 1  ; SOCK_STREAM for connection
    mov rdx, 0  ; default TCP protocol
    syscall     ; socket(AF_INET, SOCK_STREAM, 0)

    mov rax, 0x3c   ; exit syscall
    mov rdi, 0  ; status code
    syscall
```

## Bind

We created a `socket` previously for communication in the network and we need the `bind` to assign the `socket` to a specific IP address and port. In this challenge we need to create the `bind` syscall. We need to the following arguments for making the `bind` syscall :-

- **socket file descriptor** -> value returned in `rax` by the `socket` syscall in our previous `socket` creation.
- **a pointer to a `struct sockaddr` (specifically a `struct sockaddr_in` for IPv4 that holds fields like the address family, port, and IP address)** -> we must create the below structure in memory.

```
struct sockaddr sturcure below
	struct sockaddr_in {
    sa_family_t    sin_family;   // 2 bytes //AF_INET
    in_port_t      sin_port;     // 2 bytes //PORT NUMBER 80
    struct in_addr sin_addr;     // 4 bytes //IPv4 0.0.0.0 all networkinterfaces
};
```

- **size of that structure** -> the size of the `struct sockaddr`

```nasm
global _start

section .text

_start:
    

socket_syscall:    
    mov rax, 0x29   ; socket syscall number
    mov rdi, 2  ; AF_INET for IPV4 addresses
    mov rsi, 1  ; SOCK_STREAM for connection
    mov rdx, 0  ; default TCP protocol
    syscall     ; socket(AF_INET, SOCK_STREAM, 0)

; struct sockaddr sturcure below
;    struct sockaddr_in {
;        sa_family_t    sin_family;   // 2 bytes // AF_INET
;        in_port_t      sin_port;     // 2 bytes // PORT NUMBER 80
;        struct in_addr sin_addr;     // 4 bytes // IPv4 -> 0.0.0.0 for all network interfaces
;    };


bind_syscall:
    mov rdi, rax    ; socket file descriptor returned by socket syscall (arg1)
    sub rsp, 0x10   ; reserving 16 bytes of memory
    mov word[rsp], 2    ; sin_family AF_INET
    mov word[rsp+2], 0x5000 ; Little Endian for 0x80 or port 80 sin_port
    mov dword[rsp+4], 0x0   ; sin_addr 0.0.0.0 equivalent and dword cuz IPv4 32 bits/4 bytes
    lea rsi, [rsp]    ; pointer to struct_addr (arg2)
    mov rdx, 0x10   ; 16 bytes address length cuz struct_addr is 16 bytes (2+2+4+8)
    mov rax, 0x31   ; bind syscall number
    syscall         ; bind(sockfd, (struct sockaddr*)&sockaddr_in, 16)


exit_syscall:
    mov rax, 0x3c   ; exit syscall
    mov rdi, 0  ; status code
    syscall
```

## Listen

We have created a `socket` and bounded it to an IP address and port using our own `bind`. In this challenge we need to prepare our socket to accept incoming connections. This introduces us to `listen` syscall which we need to create in this level. The `listen` syscall requires the following arguments. They are:-

- **socket file descriptor**  ->  value returned in `rax` by the `socket` syscall in our previous `socket` creation.
- **backlog parameter** -> number of pending connections that can be kept in queue by the `kernel`.

```nasm
global _start

section .text

_start:
    

socket_syscall:    
    mov rax, 0x29   ; socket syscall number
    mov rdi, 2  ; AF_INET for IPV4 addresses
    mov rsi, 1  ; SOCK_STREAM for connection
    mov rdx, 0  ; default TCP protocol
    syscall     ; socket(AF_INET, SOCK_STREAM, 0)

    mov r8, rax ; storing socket file descriptor for later use

; struct sockaddr sturcure below
;    struct sockaddr_in {
;        sa_family_t    sin_family;   // 2 bytes // AF_INET
;        in_port_t      sin_port;     // 2 bytes // PORT NUMBER 80
;        struct in_addr sin_addr;     // 4 bytes // IPv4 -> 0.0.0.0 for all network interfaces
;    };


bind_syscall:
    mov rdi, rax    ; socket file descriptor returned by socket syscall (arg1)
    sub rsp, 0x10   ; reserving 16 bytes of memory
    mov word[rsp], 2    ; sin_family AF_INET
    mov word[rsp+2], 0x5000 ; Little Endian for 0x80 or port 80 sin_port
    mov dword[rsp+4], 0x0   ; sin_addr 0.0.0.0 equivalent and dword cuz IPv4 32 bits/4 bytes
    lea rsi, [rsp]    ; pointer to struct_addr (arg2)
    mov rdx, 0x10   ; 16 bytes address length cuz struct_addr is 16 bytes (2+2+4+8)
    mov rax, 0x31   ; bind syscall number
    syscall         ; bind(sockfd, (struct sockaddr*)&sockaddr_in, 16)


listen_syscall:
    mov rdi, r8 ; socket file descriptor (arg1)
    mov rsi, 0  ; backlog i.e. number of pending connections allowed (arg2)
    mov rax, 0x32  ; listen syscall number
    syscall        ; listen(sockfd, 0)


exit_syscall:
    mov rax, 0x3c   ; exit syscall
    mov rdi, 0  ; status code
    syscall
```

## Accept

We need to implement the `accept` syscall so that we can actively accept the incoming connections. In this challenge we will setup our `accept` syscall which waits for the client to connect. When connection is established it returns a new **socket file descriptor** dedicated for communication with that client and fills in a provided address structure (such as `struct sockaddr_in)` with the client's details. The arguments required by the `accept` syscall are :-

- **socket file descriptor**
- Rest 2 arguments mentioned in the code are **NULL**

```nasm
global _start

section .text

_start:
    

socket_syscall:    
    mov rax, 0x29   ; socket syscall number
    mov rdi, 2  ; AF_INET for IPV4 addresses
    mov rsi, 1  ; SOCK_STREAM for connection
    mov rdx, 0  ; default TCP protocol
    syscall     ; socket(AF_INET, SOCK_STREAM, 0)

    mov r8, rax ; storing socket file descriptor for later use

; struct sockaddr sturcure below
;    struct sockaddr_in {
;        sa_family_t    sin_family;   // 2 bytes // AF_INET
;        in_port_t      sin_port;     // 2 bytes // PORT NUMBER 80
;        struct in_addr sin_addr;     // 4 bytes // IPv4 -> 0.0.0.0 for all network interfaces
;    };


bind_syscall:
    mov rdi, rax    ; socket file descriptor returned by socket syscall (arg1)
    sub rsp, 0x10   ; reserving 16 bytes of memory
    mov word[rsp], 2    ; sin_family AF_INET
    mov word[rsp+2], 0x5000 ; Little Endian for 0x80 or port 80 sin_port
    mov dword[rsp+4], 0x0   ; sin_addr 0.0.0.0 equivalent and dword cuz IPv4 32 bits/4 bytes
    lea rsi, [rsp]    ; pointer to struct_addr (arg2)
    mov rdx, 0x10   ; 16 bytes address length cuz struct_addr is 16 bytes (2+2+4+8)
    mov rax, 0x31   ; bind syscall number
    syscall         ; bind(sockfd, (struct sockaddr*)&sockaddr_in, 16)


listen_syscall:
    mov rdi, r8 ; socket file descriptor (arg1)
    mov rsi, 0  ; backlog i.e. number of pending connections allowed (arg2)
    mov rax, 0x32  ; listen syscall number
    syscall        ; listen(sockfd, 0)


accept_syscall:
    mov rdi, r8 ; socket file descriptor (arg1)
    xor rsi, rsi    ; struct sockaddr *_Nullable restrict addr (arg2)
    xor rdx, rdx    ; socklen_t *_Nullable restrict addrlen (arg3)
    mov rax, 0x2b   ; accept syscall number
    syscall         ; accept(sockfd, NULL, NULL)


exit_syscall:
    mov rax, 0x3c   ; exit syscall
    mov rdi, 0  ; status code
    syscall
```

## Static Response

Now that the server can accept connections from clients we need to send a HTTP response to any client that connects. We need to use the `write` syscall for this challenge and implement it. The `write` syscall uses the following arguments :-

- **file descriptor** -> returned by the `accept`
- **buffer variable** 
- **length of the message**

We must `write` to the accepted socket. After the `accept` the program returns a value in the `rax` register so we need to `read` from it and `write` our response in that `socket`. After `read` ing from the `accept`ed `socket` connection we need to `close` the connection using `close` syscall as well.

```nasm
global _start

section .data

    response: db "HTTP/1.0 200 OK", 13, 10, 13, 10  ; \r\n\r\n in ascii values cuz assembly don't interpret \ sign
    responseLen: equ $ - response

section .text

_start:
    

socket_syscall:    
    mov rax, 0x29   ; socket syscall number
    mov rdi, 2  ; AF_INET for IPV4 addresses
    mov rsi, 1  ; SOCK_STREAM for connection
    mov rdx, 0  ; default TCP protocol
    syscall     ; socket(AF_INET, SOCK_STREAM, 0)

    mov r8, rax ; storing socket file descriptor for later use

; struct sockaddr sturcure below
;    struct sockaddr_in {
;        sa_family_t    sin_family;   // 2 bytes // AF_INET
;        in_port_t      sin_port;     // 2 bytes // PORT NUMBER 80
;        struct in_addr sin_addr;     // 4 bytes // IPv4 -> 0.0.0.0 for all network interfaces
;    };


bind_syscall:
    mov rdi, rax    ; socket file descriptor returned by socket syscall (arg1)
    sub rsp, 0x10   ; reserving 16 bytes of memory
    mov word[rsp], 2    ; sin_family AF_INET
    mov word[rsp+2], 0x5000 ; Little Endian for 0x80 or port 80 sin_port
    mov dword[rsp+4], 0x0   ; sin_addr 0.0.0.0 equivalent and dword cuz IPv4 32 bits/4 bytes
    lea rsi, [rsp]    ; pointer to struct_addr (arg2)
    mov rdx, 0x10   ; 16 bytes address length cuz struct_addr is 16 bytes (2+2+4+8)
    mov rax, 0x31   ; bind syscall number
    syscall         ; bind(sockfd, (struct sockaddr*)&sockaddr_in, 16)


listen_syscall:
    mov rdi, r8 ; socket file descriptor (arg1)
    mov rsi, 0  ; backlog i.e. number of pending connections allowed (arg2)
    mov rax, 0x32  ; listen syscall number
    syscall        ; listen(sockfd, 0)


accept_syscall:
    mov rdi, r8 ; socket file descriptor (arg1)
    xor rsi, rsi    ; struct sockaddr *_Nullable restrict addr (arg2)
    xor rdx, rdx    ; socklen_t *_Nullable restrict addrlen (arg3)
    mov rax, 0x2b   ; accept syscall number
    syscall         ; accept(sockfd, NULL, NULL)
    mov r9, rax     ; storing for later use


read_syscall:
    sub rsp, 0x400  ; buffer 1024 bytes temporarily created
    mov rdi, r9 ; file descriptor by accept_syscall (arg1)
    mov rsi, rsp    ; buffer (arg2)
    mov rdx, 0x400  ; buffer length or size (arg3)
    mov rax, 0  ; read syscall
    syscall ; read(conn, *buf, 1024)


write_syscall:
    mov rdi, r9 ; file descriptor by accept_syscall (arg1)
    mov rsi, response   ; buffer variable (arg2)
    mov rdx, responseLen    ; buffer length or size (arg3)
    mov rax, 0x1  ; write syscall number
    syscall ; write(conn, "HTTP/1.0 200 OK\r\n\r\n", 19)


close_syscall:
    mov rdi, r9  ; closes file descriptor or connection to client (arg1)
    mov rax, 0x3    ; close syscall number
    syscall ; close(conn)


exit_syscall:
    mov rax, 0x3c   ; exit syscall
    mov rdi, 0  ; status code
    syscall
```


---
```
THE BELOW SOLUTIONS AREN'T MINE SO I HAVE PROVIDED GITHUB REPO LINKS TO EACH ONE OF THEM SO PLEASE CHECK THEM OUT. THEY ABOVE ONES ARE MINE.
```

## Dynamic Response

In this challenge we need to provide the client with a dynamic response. This response will be based on the client's request. So we need to `read` the HTTP request and parse the `GET` part and then `open` the requested file and `read` its contents and `write` them. The `open` syscall requires the below arguments. They are :-

- `pathname` -> filename and including the entire path of the file.
- `flags` -> O_RDONLY for reading only operation.
- `mode` -> file permission bit.

- The below code is in `GAS syntax`. So compile use `as` assembler. The below code is taken from a **Github Repository** -> [Link](https://github.com/thesrikarpaida/Web-Server-In-Assembly)

```nasm
.intel_syntax noprefix
.global _start

.section .text

_start:
    mov rdi, 0x2 # AF_INET - Internet IP Protocol
    mov rsi, 0x1 # SOCK_STREAM - stream (connection) socket
    xor rdx, rdx # 0
    mov rax, 0x29 # 0x29 or 41 is the syscall value for socket()
    syscall # socket(AF_INET, SOCK_STREAM, 0)
    mov r15, rax # storing the socket file descriptor in a separate register for later use.

    # struct sockaddr_in {
    #        sa_family_t     sin_family;     /* AF_INET */
    #        in_port_t       sin_port;       /* Port 80 */
    #        struct in_addr  sin_addr;       /* IPv4 address - 0.0.0.0 */
    #    };

    mov rdi, r15 # socket file descriptor to rdi, the first parameter of bind()
    xor rax, rax
    push rax
    mov rbx, 0x0 # equivalent to 0.0.0.0
    push rbx
    movw [rsp-2], 0x5000 # Little endian for 0x0050, or 80
    movw [rsp-4], 0x2 # AF_INET = 0x2
    sub rsp, 4
    lea rsi, [rsp]
    mov rdx, 0x10 # address length
    mov rax, 0x31 # 0x31 or 49 is the syscall value for bind()
    syscall # bind(sockfd, (struct sockaddr*)&sockaddr_in, 16)

    mov rdi, r15 # socket file descriptor
    xor rsi, rsi # 0
    mov rax, 0x32 # 0x32 or 50 is the syscall value for listen()
    syscall # listen(sockfd, 0)

    mov rdi, r15 # socket file descriptor
    xor rsi, rsi # NULL
    xor rdx, rdx # NULL
    mov rax, 0x2b # 0x2b or 43 is the syscall value for accept()
    syscall # accept(sockfd, NULL, NULL)
    mov r14, rax # file descriptor for accepted connection is stored in a register for later use

    mov rdi, r14 # we read from the accepted connection, so we use that file descriptor
    sub rsp, 0x400 # setting up the stack as the buffer variable
    mov rsi, rsp
    mov rdx, 0x400 # upto how many bytes can be read
    xor rax, rax # 0 is the syscall value for read()
    syscall # read(conn, *buf, 1024)

    lea rdi, [rsi+4] # rsi has the address of the stack, where the response started.
    # rsi+4 is where we skip "GET " in the response, where the file name starts.
    # the file name should end with a NULL terminator, so we loop through till we find a space " ", and add a NULL at that location in rdi
    xor rax, rax # using rax as a counter
    # mov rdx, 0x400
.file_name_loop:
    cmpb [rdi+rax], 0x20 # 0x20 is the hex value for " " (space)
    je .end_file_name_loop
    inc rax
    loop .file_name_loop
.end_file_name_loop:
    movb [rdi+rax], 0x0 # we add the NULL terminator where we find a space
    xor rsi, rsi # 0
    # xor rdx, rdx # 0
    mov rax, 0x2 # 0x2 or 2 is the syscall value for open()
    syscall # open(file_name, O_RDONLY)

    mov rdi, rax # we read from the file descriptor that is opened
    sub rsp, 0x1000 # clearing 4096 bytes on the stack buffer, which is how much we allow to read from the file.
    mov rsi, rsp # we read on to the stack
    mov rdx, 0x1000 # we give a buffer to read up to 4096 bytes
    xor rax, rax # syscall value for read()
    syscall # read(file_fd, *stack, 4096)
    mov r13, rax # we will save the number of bytes read to the r13 register

    # rdi already has the file descriptor, since we're closing it immediately after reading from the file.
    mov rax, 0x3 # 0x3 or 3 is the syscall value for close()
    syscall # close(file_fd)

    # Response string: "HTTP/1.0 200 OK\r\n\r\n" followed by NULL terminator "\0"
    # 0x48 0x54 0x54 0x50 | 0x2f 0x31 0x2e 0x30 0x20 0x32 0x30 0x30 | 0x20 0x4f 0x4b 0x0d 0x0a 0x0d 0x0a 0x00
    mov rdi, r14 # we write to the accepted connection, so we use that file descriptor
    mov rax, 0x000a0d0a0d4b4f20
    push rax
    mov rax, 0x30303220302e312f
    push rax
    mov eax, 0x50545448
    mov [rsp-4], eax
    sub rsp, 4
    lea rsi, [rsp] # pushed the response string on to the stack and set the address of the stack for the response parameter
    mov rdx, 0x13 # the response string is 19 (0x13) bytes
    mov rax, 0x1 # 0x1 or 1 is the syscall value for write()
    syscall # write(conn, "HTTP/1.0 200 OK\r\n\r\n", 19)

    mov rdi, r14 # we write to the accepted connection, so we use that file descriptor
    lea rsi, [rsp+0x14] # the size of response written is 0x13 bytes, and the extra 1 byte is the ending NULL byte we added into the response
    # the response was on the stack after the file contents were added on to it. We just got the address from where the file contents started, so we skip writing the response part
    mov rdx, r13 # number of bytes read from the file
    mov rax, 0x1 # syscall value for write()
    syscall # write(conn, file_content, file_content_size)

    mov rdi, r14 # we close the connection
    mov rax, 0x3 # syscall value for close()
    syscall # close(conn)

    xor rdi, rdi # 0
    mov rax, 0x3c # 0x3c or 60 is the syscall value for exit()
    syscall # exit(0)

.section .data
```

## Iterative GET Server

Previously, your server served just one GET request before terminating. Now, you will modify it so that it can handle multiple GET requests sequentially. This involves wrapping the accept-read-write-close sequence in a loop. Each time a client connects, your server will accept the connection, process the GET request, and then cleanly close the client session while remaining active for the next request. This iterative approach is essential for building a persistent server.

- The below code is in `GAS syntax`. So compile use `as` assembler. The below code is taken from a **Github Repository** -> [Link](https://github.com/thesrikarpaida/Web-Server-In-Assembly)

```nasm
.intel_syntax noprefix
.global _start

.section .text

_start:
    mov rdi, 0x2 # AF_INET - Internet IP Protocol
    mov rsi, 0x1 # SOCK_STREAM - stream (connection) socket
    xor rdx, rdx # 0
    mov rax, 0x29 # 0x29 or 41 is the syscall value for socket()
    syscall # socket(AF_INET, SOCK_STREAM, 0)
    mov r15, rax # storing the socket file descriptor in a separate register for later use.

    # struct sockaddr_in {
    #        sa_family_t     sin_family;     /* AF_INET */
    #        in_port_t       sin_port;       /* Port 80 */
    #        struct in_addr  sin_addr;       /* IPv4 address - 0.0.0.0 */
    #    };

    mov rdi, r15 # socket file descriptor to rdi, the first parameter of bind()
    xor rax, rax
    push rax
    mov rbx, 0x0 # equivalent to 0.0.0.0
    push rbx
    movw [rsp-2], 0x5000 # Little endian for 0x0050, or 80
    movw [rsp-4], 0x2 # AF_INET = 0x2
    sub rsp, 4
    lea rsi, [rsp]
    mov rdx, 0x10 # address length
    mov rax, 0x31 # 0x31 or 49 is the syscall value for bind()
    syscall # bind(sockfd, (struct sockaddr*)&sockaddr_in, 16)

    mov rdi, r15 # socket file descriptor
    xor rsi, rsi # 0
    mov rax, 0x32 # 0x32 or 50 is the syscall value for listen()
    syscall # listen(sockfd, 0)

.request_loop:
    mov rdi, r15 # socket file descriptor
    xor rsi, rsi # NULL
    xor rdx, rdx # NULL
    mov rax, 0x2b # 0x2b or 43 is the syscall value for accept()
    syscall # accept(sockfd, NULL, NULL)
    mov r14, rax # file descriptor for accepted connection is stored in a register for later use

    mov rdi, r14 # we read from the accepted connection, so we use that file descriptor
    sub rsp, 0x400 # setting up the stack as the buffer variable
    mov rsi, rsp
    mov rdx, 0x400 # upto how many bytes can be read
    xor rax, rax # 0 is the syscall value for read()
    syscall # read(conn, *buf, 1024)

    lea rdi, [rsi+4] # rsi has the address of the stack, where the response started.
    # rsi+4 is where we skip "GET " in the response, where the file name starts.
    # the file name should end with a NULL terminator, so we loop through till we find a space " ", and add a NULL at that location in rdi
    xor rax, rax # using rax as a counter
    # mov rdx, 0x400
.file_name_loop:
    cmpb [rdi+rax], 0x20 # 0x20 is the hex value for " " (space)
    je .end_file_name_loop
    inc rax
    loop .file_name_loop
.end_file_name_loop:
    movb [rdi+rax], 0x0 # we add the NULL terminator where we find a space
    xor rsi, rsi # 0
    # xor rdx, rdx # 0
    mov rax, 0x2 # 0x2 or 2 is the syscall value for open()
    syscall # open(file_name, O_RDONLY)

    mov rdi, rax # we read from the file descriptor that is opened
    sub rsp, 0x1000 # clearing 4096 bytes on the stack buffer, which is how much we allow to read from the file.
    mov rsi, rsp # we read on to the stack
    mov rdx, 0x1000 # we give a buffer to read up to 4096 bytes
    xor rax, rax # syscall value for read()
    syscall # read(file_fd, *stack, 4096)
    mov r13, rax # we will save the number of bytes read to the r13 register

    # rdi already has the file descriptor, since we're closing it immediately after reading from the file.
    mov rax, 0x3 # 0x3 or 3 is the syscall value for close()
    syscall # close(file_fd)

    # Response string: "HTTP/1.0 200 OK\r\n\r\n" followed by NULL terminator "\0"
    # 0x48 0x54 0x54 0x50 | 0x2f 0x31 0x2e 0x30 0x20 0x32 0x30 0x30 | 0x20 0x4f 0x4b 0x0d 0x0a 0x0d 0x0a 0x00
    mov rdi, r14 # we write to the accepted connection, so we use that file descriptor
    mov rax, 0x000a0d0a0d4b4f20
    push rax
    mov rax, 0x30303220302e312f
    push rax
    mov eax, 0x50545448
    mov [rsp-4], eax
    sub rsp, 4
    lea rsi, [rsp] # pushed the response string on to the stack and set the address of the stack for the response parameter
    mov rdx, 0x13 # the response string is 19 (0x13) bytes
    mov rax, 0x1 # 0x1 or 1 is the syscall value for write()
    syscall # write(conn, "HTTP/1.0 200 OK\r\n\r\n", 19)

    mov rdi, r14 # we write to the accepted connection, so we use that file descriptor
    lea rsi, [rsp+0x14] # the size of response written is 0x13 bytes, and the extra 1 byte is the ending NULL byte we added into the response
    # the response was on the stack after the file contents were added on to it. We just got the address from where the file contents started, so we skip writing the response part
    mov rdx, r13 # number of bytes read from the file
    mov rax, 0x1 # syscall value for write()
    syscall # write(conn, file_content, file_content_size)

    mov rdi, r14 # we close the connection
    mov rax, 0x3 # syscall value for close()
    syscall # close(conn)

    # We're responding to multiple requests, so we jump back to accepting new connections
    jmp .request_loop

    xor rdi, rdi # 0
    mov rax, 0x3c # 0x3c or 60 is the syscall value for exit()
    syscall # exit(0)

.section .data
```

## Concurrent GET Server

To enable your server to handle several clients at once, you will introduce concurrency using the [fork](https://man7.org/linux/man-pages/man2/fork.2.html) syscall. When a client connects, [fork](https://man7.org/linux/man-pages/man2/fork.2.html) creates a child process dedicated to handling that connection. Meanwhile, the parent process immediately returns to accept additional connections. With this design, the child uses [read](https://man7.org/linux/man-pages/man2/read.2.html) and [write](https://man7.org/linux/man-pages/man2/write.2.html) to interact with the client, while the parent continues to listen. This concurrent model is a key concept in building scalable, real-world servers.

- The below code is in `GAS syntax`. So compile use `as` assembler. The below code is taken from a **Github Repository** -> [Link](https://github.com/thesrikarpaida/Web-Server-In-Assembly)

```nasm
.intel_syntax noprefix
.global _start

.section .text

_start:
    mov rdi, 0x2 # AF_INET - Internet IP Protocol
    mov rsi, 0x1 # SOCK_STREAM - stream (connection) socket
    xor rdx, rdx # 0
    mov rax, 0x29 # 0x29 or 41 is the syscall value for socket()
    syscall # socket(AF_INET, SOCK_STREAM, 0)
    mov r15, rax # storing the socket file descriptor in a separate register for later use.

    # struct sockaddr_in {
    #        sa_family_t     sin_family;     /* AF_INET */
    #        in_port_t       sin_port;       /* Port 80 */
    #        struct in_addr  sin_addr;       /* IPv4 address - 0.0.0.0 */
    #    };

    mov rdi, r15 # socket file descriptor to rdi, the first parameter of bind()
    xor rax, rax
    push rax
    mov rbx, 0x0 # equivalent to 0.0.0.0
    push rbx
    movw [rsp-2], 0x5000 # Little endian for 0x0050, or 80
    movw [rsp-4], 0x2 # AF_INET = 0x2
    sub rsp, 4
    lea rsi, [rsp]
    mov rdx, 0x10 # address length
    mov rax, 0x31 # 0x31 or 49 is the syscall value for bind()
    syscall # bind(sockfd, (struct sockaddr*)&sockaddr_in, 16)

    mov rdi, r15 # socket file descriptor
    xor rsi, rsi # 0
    mov rax, 0x32 # 0x32 or 50 is the syscall value for listen()
    syscall # listen(sockfd, 0)

.request_loop:
    mov rdi, r15 # socket file descriptor
    xor rsi, rsi # NULL
    xor rdx, rdx # NULL
    mov rax, 0x2b # 0x2b or 43 is the syscall value for accept()
    syscall # accept(sockfd, NULL, NULL)
    mov r14, rax # file descriptor for accepted connection is stored in a register for later use

    # We will fork the process since we need multiple handlers that deal with multiple requests
    mov rax, 0x39 # 0x39 or 57 is the syscall value for fork()
    syscall # fork()
    # the result of running fork() leads to 2 outputs: 0 for child process and >0 for parent process
    cmp rax, 0x0
    je .child_process

    mov rdi, r14 # we close the connection in the parent process for every program run
    mov rax, 0x3 # syscall value for close()
    syscall # close(conn)
    jmp .request_loop # jump to the request loop to accept a new connection

.child_process:
    mov rdi, r15 # socket descriptor
    mov rax, 0x3 # syscall value for close()
    syscall # close(sockfd)
    
    mov rdi, r14 # we read from the accepted connection, so we use that file descriptor
    sub rsp, 0x400 # setting up the stack as the buffer variable
    mov rsi, rsp
    mov rdx, 0x400 # upto how many bytes can be read
    xor rax, rax # 0 is the syscall value for read()
    syscall # read(conn, *buf, 1024)

    lea rdi, [rsi+4] # rsi has the address of the stack, where the response started.
    # rsi+4 is where we skip "GET " in the response, where the file name starts.
    # the file name should end with a NULL terminator, so we loop through till we find a space " ", and add a NULL at that location in rdi
    xor rax, rax # using rax as a counter
    # mov rdx, 0x400
.file_name_loop:
    cmpb [rdi+rax], 0x20 # 0x20 is the hex value for " " (space)
    je .end_file_name_loop
    inc rax
    loop .file_name_loop
.end_file_name_loop:
    movb [rdi+rax], 0x0 # we add the NULL terminator where we find a space
    xor rsi, rsi # 0
    # xor rdx, rdx # 0
    mov rax, 0x2 # 0x2 or 2 is the syscall value for open()
    syscall # open(file_name, O_RDONLY)

    mov rdi, rax # we read from the file descriptor that is opened
    sub rsp, 0x1000 # clearing 4096 bytes on the stack buffer, which is how much we allow to read from the file.
    mov rsi, rsp # we read on to the stack
    mov rdx, 0x1000 # we give a buffer to read up to 4096 bytes
    xor rax, rax # syscall value for read()
    syscall # read(file_fd, *stack, 4096)
    mov r13, rax # we will save the number of bytes read to the r13 register

    # rdi already has the file descriptor, since we're closing it immediately after reading from the file.
    mov rax, 0x3 # 0x3 or 3 is the syscall value for close()
    syscall # close(file_fd)

    # Response string: "HTTP/1.0 200 OK\r\n\r\n" followed by NULL terminator "\0"
    # 0x48 0x54 0x54 0x50 | 0x2f 0x31 0x2e 0x30 0x20 0x32 0x30 0x30 | 0x20 0x4f 0x4b 0x0d 0x0a 0x0d 0x0a 0x00
    mov rdi, r14 # we write to the accepted connection, so we use that file descriptor
    mov rax, 0x000a0d0a0d4b4f20
    push rax
    mov rax, 0x30303220302e312f
    push rax
    mov eax, 0x50545448
    mov [rsp-4], eax
    sub rsp, 4
    lea rsi, [rsp] # pushed the response string on to the stack and set the address of the stack for the response parameter
    mov rdx, 0x13 # the response string is 19 (0x13) bytes
    mov rax, 0x1 # 0x1 or 1 is the syscall value for write()
    syscall # write(conn, "HTTP/1.0 200 OK\r\n\r\n", 19)

    mov rdi, r14 # we write to the accepted connection, so we use that file descriptor
    lea rsi, [rsp+0x14] # the size of response written is 0x13 bytes, and the extra 1 byte is the ending NULL byte we added into the response
    # the response was on the stack after the file contents were added on to it. We just got the address from where the file contents started, so we skip writing the response part
    mov rdx, r13 # number of bytes read from the file
    mov rax, 0x1 # syscall value for write()
    syscall # write(conn, file_content, file_content_size)

    xor rdi, rdi # 0
    mov rax, 0x3c # 0x3c or 60 is the syscall value for exit()
    syscall # exit(0)

.section .data
```

## Concurrent POST Server & Web Server

Expanding your server’s capabilities further, this challenge focuses on handling HTTP POST requests concurrently. POST requests are more complex because they include both headers and a message body. You will once again use [fork](https://man7.org/linux/man-pages/man2/fork.2.html) to manage multiple connections, while using [read](https://man7.org/linux/man-pages/man2/read.2.html) to capture the entire request. Again, you will parse the URL path to determine the specified file, but this time instead of reading from that file, you will instead write to it with the incoming POST data. In order to do so, you must determine the length of the incoming POST data. The _obvious_ way to do this is to parse the `Content-Length` header, which specifies exactly that. Alternatively, consider using the return value of [read](https://man7.org/linux/man-pages/man2/read.2.html) to determine the total length of the request, parsing the request to find the total length of the headers (which end with `\r\n\r\n`), and using that difference to determine the length of the body--this seemingly more complicated algorithm may actually be easier to implement. Finally, return just a `200 OK` response to the client to indicate that the POST request was successful.

**Github Link** -> [Link](https://gist.github.com/Elijah-Bodden/88416ba6671bae09a467b10ab208499c)

```nasm
.intel_syntax noprefix
.globl _start

.section .text

_start:
    # Open socket
    mov rdi, 2
    mov rsi, 1
    mov rdx, 0
    mov rax, 41
    syscall
    # Store socket fd in rbx
    mov rbx, rax

    # Bind socket to address
    mov rdi, rbx
    lea rsi, sa_family_t
    mov rdx, 16
    mov rax, 49
    syscall

    # Listen on socket
    mov rdi, rbx
    mov rsi, 0
    mov rax, 50
    syscall

    accept_jump:
    # Accept a connection
    mov rdi, rbx
    mov rsi, 0
    mov rdx, 0
    mov rax, 43
    syscall
    # Save new fd for bound connection in r12
    mov r12, rax

    # Fork the process and let the child do the serving
    mov rax, 57
    syscall
    cmp rax, 0
    je serve_connection
    # Close the connection if parent
    mov rdi, r12
    mov rax, 3
    syscall
    # Then go back to listening
    jmp accept_jump

    serve_connection:
    # Close listening socket
    mov rdi, rbx
    mov rax, 3
    syscall

    # Read from the connection
    mov rdi, r12
    lea rsi, read_buffer
    mov rdx, [read_packet_length]
    mov rax, 0
    syscall

    # Figure out what file was requested
    lea rdi, read_buffer
    mov rsi, 1
    lea rdx, space
    call get_nth_substr
    mov r13, rax
    lea rdi, read_buffer
    mov rsi, 2
    call get_nth_substr
    mov r14, rax
    sub r14, 1
    # r13 = start (exclusive), r14 = end (inclusive)
    mov rdi, r13
    mov rsi, r14
    lea rdx, file_name_buffer
    call write_to_buf
    # Filename is now stored in file_name_buffer

    # Check request type
    mov dil, [read_buffer]
    # Compare to "G"
    cmp dil, 0x47
    # Continue (GET process) if G, otherwise do POST
    jne POST

    GET:
        # Open that file
        lea rdi, file_name_buffer
        mov rsi, 0
        mov rdx, 0
        mov rax, 2
        syscall
        mov r13, rax

        # Read file contents
        mov rdi, r13
        lea rsi, file_read_buffer
        mov rdx, 1024
        mov rax, 0
        syscall

        # Close the file
        mov rdi, r13
        mov rax, 3
        syscall

        # Write status to connection
        mov rdi, r12
        lea rsi, write_static
        mov rdx, 19
        mov rax, 1
        syscall

        # Write file contents to connection
        lea rdi, file_read_buffer
        call get_len
        mov rdx, rax
        sub rdx, 1
        mov rdi, r12
        lea rsi, file_read_buffer
        mov rax, 1
        syscall

        jmp exit

    POST:
        # Open that file
        lea rdi, file_name_buffer
        mov rsi, 0x41 # O_CREAT, O_WRONLY
        mov rdx, 0777
        mov rax, 2
        syscall
        mov r13, rax

        # Get the POST content
        lea rdi, read_buffer
        mov rsi, 1
        lea rdx, double_cr_lf
        call get_nth_substr
        mov rsi, rax
        add rsi, 1

        # Get write length
        mov rdi, rsi
        call get_len
        mov rdx, rax
        # Get rid of the pesky null byte
        sub rdx, 1
        # Write to file
        mov rdi, r13
        mov rax, 1
        syscall

        # Close the file
        mov rdi, r13
        mov rax, 3
        syscall

        # Write status to connection
        mov rdi, r12
        lea rsi, write_static
        mov rdx, 19
        mov rax, 1
        syscall

    exit:
    # Close the connection
    mov rdi, r12
    mov rax, 3
    syscall

    # Sys exit
    mov rdi, 0
    mov rax, 60
    syscall

    # Get the length of a null-terminated string (including the first null byte)
    # Args:
    # rdi - buffer we're checking the length of
    # rax - length
    get_len:
        mov rax, 0
        get_len_loop:
            # See if rdi + rax-th byte is null
            mov r10, rdi
            add r10, rax
            mov r10, [r10]
            add rax, 1
            cmp r10, 0x00
            jne get_len_loop
        ret

    # Copy the bytes spanning rdi to rsi to the buffer rdx
    # rdx MUST BE LONGER THAN rsi - rdi BYTES, rdi MUST BE LESS THAN rsi
    # Args:
    # rdi - start (exclusive) of the string we're copying
    # rsi - end (inclusive) of the string we're copying
    # rdx - buffer we're copying to
    # rax - unchanged
    write_to_buf:
        write_to_buf_loop:
            add rdi, 1
            mov r9, [rdi]
            mov [rdx], r9
            add rdx, 1
            cmp rdi, rsi
            jne write_to_buf_loop
        mov byte ptr [rdx], 0x00
        ret

    # Get address of the (last byte of) the nth occurence of substring in string (occurences must be non-overlapping)
    # ONLY GUARANTEED TO WORK ON NULL-TERMINATED STRINGS
    # Args:
    # rdi - target string address
    # rsi - n
    # rdx - substring

    # rax - address of nth character
    get_nth_substr:
        # Set rcx (ocurrence counter)
        mov rcx, 0
        # Set r10 (to traverse substring)
        mov r10, rdx
        check_character_loop:
            # r9b = character at position
            mov r9b, [rdi]
            # If string's terminated, obviously the substring doesn't occur enough times
            cmp r9b, 0x00
            je not_enough_occurrences
            # Step through substring iff r9b = current byte
            cmp r9b, byte ptr [r10]
            jne character_not_equal
                add r10, 1
                # If we've reached the end of the substring, increment counter and reset r10
                cmp byte ptr [r10], 0x00
                jne after_comparison
                    mov r10, rdx
                    add rcx, 1
                    jmp after_comparison
            character_not_equal:
                # Reset r10 without adding to count
                mov r10, rdx
            after_comparison:
            # Return address if we've got the nth ocurrence
            cmp rcx, rsi
            je match
            # Otherwise increment and continue
            add rdi, 1
            jmp check_character_loop
        match:
        mov rax, rdi
        ret
        not_enough_occurrences:
        mov rax, -1
        ret

.section .data
    # sockaddr_in struct
    sa_family_t: .word 2
    bind_port: .word 0x5000
    bind_address: .double 0x00000000
    pad: .byte 0,0,0,0,0,0,0,0
    # Make empty buffers to read to
    read_buffer: .space 1024
    file_name_buffer: .space 1024
    file_read_buffer: .space 1024
    # Constants
    # Yes it's dumb to use a quad word for this, but it simplifies copying it to the register
    read_packet_length: .quad 0x0000000000000400
    write_static: .string "HTTP/1.0 200 OK\r\n\r\n"
    space: .string " "
    double_cr_lf: .string "\r\n\r\n"
```

