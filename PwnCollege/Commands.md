
## Create Keys for PwnCollege

### 1. Create SSH Key

- The below commands will generate `public` keys with `.pub` and `private` keys.

```bash
ssh-keygen -f key -N ''
```

### 2. Adding Keys

- Add the `.pub` or public key to pwncollege account.

### 3. Login to PwnCollege from own VM

```bash
ssh -i <pwncollege private_key> hacker@dojo.pwn.college
```

---
## Copy files from PwnCollege

```bash
scp -i <pwncollege private_key> hacker@dojo.pwn.college:<challenge file_path>
```


