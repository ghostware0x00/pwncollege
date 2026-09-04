
## Installing Docker

### 1. Install Docker

```bash
sudo pacman -S docker docker-buildx docker-compose
```

### 2. Start Docker Service

```bash
sudo systemctl start docker.service
```

### 3. Enable Docker Service at Startup

```bash
sudo systemctl enable docker.service
```

### 4. Add Current User to Docker Group

- This lets the current user use the docker with the `sudo` command.

```bash
sudo usermod -aG docker $(whoami)
```

- Type `groups` command and check whether `docker` is showing in the command output. If not showing then type `newgrp docker` and press enter and then type `groups` command again to recheck.

---
## Starting Container

### 1. `git clone` 

- `git clone` pwnlab container from my github

### 2. Build Docker Image

- `cd` into the directory of the cloned repo where the `Dockerfile` is present and then execute the below command.

```bash
docker compose build --no-cache
```

### 3. Run the Docker Container

- The below command starts the container.
- Also the `--rm` switch means when you `exit` the container, the container and the stuff inside it will be destroyed too.

```bash
docker compose run --rm <container_name> # pwnlab probably in your scenario but check the config file dockerfile zshrc or p10ksh
```

---
## Other Docker Commands
### Remove unused Docker build cache

```bash
docker builder prune -a
```

### Remove any stopped/created PwnLab container

```bash
docker ps -a
```


### Wipe the Docker Cache & Unused Data

```bash
docker system prune -a --volumes --force
```

