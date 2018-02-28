## Lab 6 – enable user namespace

> Requirements <br>
> Lab VM with docker version 1.8+ <br>

> Note: This lab should be run as the **root** user

```
sudo -i
```

#### Preparation:

View current container user >>>

input:
```bash
cd ~

docker rm -f `docker ps -qa`

CID=$(docker run -d nginx) && echo $CID

docker ps

ps -p $(docker inspect --format='{{ .State.Pid }}' $CID) -o pid,user
```

#### reconfigure docker engine:

reconfigure the docker engine to use the user namespace re-map (you must be root) >>>

input:
```bash
service docker stop

### create a docker engine configuration file to enable the use of the user namespace

cat > /etc/docker/daemon.json << EOF
{
  "userns-remap": "default"
}
EOF

service docker start
```

#### test reconfigured engine:

View re-configured container user >>>

input:
```bash
### Verify the newly created user docker engine will use to map container users

id dockremap

cd ~

CID=$(docker run -d nginx) && echo $CID

docker ps

ps -p $(docker inspect --format='{{ .State.Pid }}' $CID) -o pid,user
```

view user re-map config files >>>

```bash
grep dockremap /etc/subuid

grep dockremap /etc/subgid
```

checkout to the newly created docker graph directory >>>

```bash
ls -l /var/lib/docker/<user-id>.<group-id>
```

#### docker engine reset:

reconfigure the docker engine to return it to its orginal state (you must be root) >>>

input:
```bash
service docker stop

rm /etc/docker/daemon.json

service docker start
```
