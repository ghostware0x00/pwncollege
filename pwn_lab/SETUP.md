## DOCKER CONTAINER SETUP

1. build docker image
```bash
docker compose build
```

2. give +x permissions
```bash
chmod +x pwnlab.sh
chmod +x entrypoint.sh
```

3. run script pwnlab
```bash
./pwnlab.sh
```

4. set workspace permissions
```bash
sudo chown -R "$(id -u):$(id -g)" workspace
```