
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

---
## HOW TO CLONE A PRIVATE REPOSITORY

- get the github classic token 
- open settings
- scroll down and select developer options
- then select classic tokens
- click only the repo option and the rest should remain as it is
- copy the token and then use it to clone a private repository as shown below.


```bash
git clone https://<token>@github.com/<github username>/<repo.git>
```
