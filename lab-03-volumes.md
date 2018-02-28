### Lab 3: Set up a docker volume plugin:

#### Requirements:

Lab VM with:
* Docker (version 1.8+)

> Note: This lab should be run as the **root** user. This can be accomplished with the following command:
```
sudo -i
```
#### Preparation:

Prepare directory for persistent data storage:

Input:
```bash
cd ~

mkdir vol-persist
```

Setup plugin and docker volume (for lots of good info about this plugin see [here](https://hub.docker.com/r/cwspear/docker-local-persist-volume-plugin/)):

Input:
```bash
docker run -d -v /run/docker/plugins/:/run/docker/plugins/ \
-v `pwd`/vol-persist:/vol-persist/ \
cwspear/docker-local-persist-volume-plugin

docker volume create -d local-persist -o mountpoint=/root/vol-persist --name=images
```

#### Test persistent volume mount:

Launch interactive container and test mount:

_Terminal 1_:
Input:
```bash
docker run -it -v images:/tmp ubuntu

echo $(date) > /tmp/test
```

_Terminal 2_:
Input:
```bash
cd ~
cat vol-persist/test

### the file should contain the date and time stamp as inputted within the interactive container
```

### See you in lab four!
