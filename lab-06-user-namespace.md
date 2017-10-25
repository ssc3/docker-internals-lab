## Lab 6 – enable user namespace

> Requirements <br>
> Lab VM with docker version 1.8+ <br>

#### Preparation:

View current container user >>>

input:
```bash
cd ~

docker rm -f `docker ps -qa`

docker run -d nginx

docker ps

ps -p $(docker inspect --format='{{ .State.Pid }}' <CONTAINER ID>) -o pid,user
```

#### reconfigure docker engine:

reconfigure the docker engine to use the user namespace re-map (you must be root) >>>

input:
```bash
service docker stop

vim /etc/default/docker

### inside the docker config file replace the following line as shown below

before:
DOCKER_OPTS="-H unix:///var/run/docker.sock -H tcp://127.0.0.1:2375"

after:
DOCKER_OPTS="-H unix:///var/run/docker.sock -H tcp://127.0.0.1:2375 --userns-remap=default"

### (end of edits)

service docker start
```

#### test reconfigured engine:

View re-configured container user >>>

input:
```bash
cd ~

docker rm -f `docker ps -qa`

docker run -d nginx

docker ps

ps -p $(docker inspect --format='{{ .State.Pid }}' <CONTAINER ID>) -o pid,user
```

view user re-map config files >>>

```bash
cat /etc/subuid

cat /etc/subgid
```

#### docker engine reset:

reconfigure the docker engine to return it to its orginal state (you must be root) >>>

input:
```bash
service docker stop

vim /etc/default/docker

### inside the docker config file replace the following line as shown below

before:
DOCKER_OPTS="-H unix:///var/run/docker.sock -H tcp://127.0.0.1:2375 --userns-remap=default"

after:
DOCKER_OPTS="-H unix:///var/run/docker.sock -H tcp://127.0.0.1:2375"

### (end of edits)

service docker start
```
