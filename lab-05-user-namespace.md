### Lab 5: Enable user namespace:

Lab VM with:
* Docker (version 1.8+)

> Note: This lab should be run as the **root** user. This can be accomplished with the following command:
```
sudo -i
```

#### Preparation:

View current container user:

Input:
```bash
cd ~

docker rm -f `docker ps -qa`

CID=$(docker run -d nginx) && echo $CID

docker ps

ps -p $(docker inspect --format='{{ .State.Pid }}' $CID) -o pid,user
```

#### Reconfigure docker engine:

Reconfigure the docker engine to use the user namespace re-map (you must be root):

Input:
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

#### Test reconfigured engine:

View re-configured container user:

Input:
```bash
### Verify the newly created user docker engine will use to map container users

id dockremap

cd ~

CID=$(docker run -d nginx) && echo $CID

docker ps

ps -p $(docker inspect --format='{{ .State.Pid }}' $CID) -o pid,user
```

View user re-map config files:

```bash
grep dockremap /etc/subuid

grep dockremap /etc/subgid
```

Checkout to the newly created docker graph directory:

```bash
ls -l /var/lib/docker/<user-id>.<group-id>
```

#### Docker engine reset:

Reconfigure the docker engine to return it to its orginal state (you must be root):

Input:
```bash
service docker stop

rm /etc/docker/daemon.json

service docker start
```

### See you in lab six!

