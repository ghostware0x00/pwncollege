## DOCKER CONTAINER SETUP

- First check the `DOCKER_COMMANDS.md` to setup the user and groups and permissions before applying the below changes.
- Run the below command to give `pwn` user the appropriate privileges.

```bash
sudo chown -R "$(id -u):$(id -g)" ~/pwn
```

- Create Docker Image and Run the Container
```bash
# give executable permissions
chmod +x entrypoint.sh 
chmod +x pwnlab.sh
```
