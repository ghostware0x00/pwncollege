


## UID

- UID -> User Identifier. 
- UID is a unique number assigned to each user account in the Linux system.
- Used to distinguish between other users in the Linux.
- The `root` user is a superuser so has a UID of `0`.


## GUID

- GUID = Group Identifier.
- GUID is a collection of other users combined to form and group and a unique number provided to this group for distinguishing between other groups(GUIDs).
- Unique number to identify a group.


**Every file is owned by a user and a group in Linux.**

## Get RUID Program

```c
#include<stdio.h>
int main(){
	printf("RUID : %d\n",getuid());
	return 0;
}
```

- **getuid()** -> returns the **RealUserID(RUID)** i.e. the UID of the who initiated or started the process or program. This **RUID** doesn't change.

## GET EUID Program

```c
#include<stdio.h>
int main(){
	printf("EUID : %d\n",geteuid());
	return 0;
}
```

- **geteuid()** -> returns the **EffectiveUserID(EUID)** i.e. the UID kernel uses to check permissions like `root` user. For example: Let's say if a non root user is trying to access a file where `root` permissions are set normally that user will not be able to access it but if `setuid` binary is set then the file will execute and it will have `RUID of that user` and `EUID of root`. 

[RUID and EUID Explanation (Stack Overflow)](https://unix.stackexchange.com/questions/191940/difference-between-owner-root-and-ruid-euid)

## Privilege Escalation

- There are various ways to elevate privileges. They are :-
	- `SUID` => executes the program at the user's privilege that owns the file, regardless of the user passing the command or not.
	- `SGID` => executes the program at the group's privilege that owns the file.
	- `Sticky`



### SUID(SetUserID)  (u+s)

```bash
sudo chmod u+s <filename>
```


- executes the program at the user's privilege that owns the file, regardless of the user passing the command or not.
- Note the **s** where **x** would usually indicate execute permissions for the user (file owner).


### SGID(SetGroupID) (g+s)

```bash
sudo chmod g+s <filename>
```

- executes the program at the group's privilege that owns the file.
- As noted previously for **SUID**, if the owning group does not have execute permissions, then an uppercase **S** is used.


### Sticky Bit

```bash
sudo chmod t+s <filename>
```

- Only the **owner** (and **root**) of a file can remove the file within that directory. A common example of this is the `/tmp` directory:
- The permission set is noted by the lowercase **t**, where the **x** would normally indicate the execute privilege.