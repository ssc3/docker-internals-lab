## Lab 3 – set up a docker volume plugin

> Requirements <br>
> Lab VM with docker version 1.8+ <br>
> Run lab as root <br>

#### Preparation:

Prepare directory for persistent data storage>>>

input:
```bash
cd ~

mkdir vol-persist
```

Setup plugin and docker volume >>>

(For lots of good info about this plugin, see:   https://hub.docker.com/r/cwspear/docker-local-persist-volume-plugin/)

input:
```bash
docker run -d -v /run/docker/plugins/:/run/docker/plugins/ \
-v `pwd`/vol-persist:/vol-persist/ \
cwspear/docker-local-persist-volume-plugin

docker volume create -d local-persist -o mountpoint=/root/vol-persist --name=images
```

#### Test persistent volume mount:

Launch interactive container and test mount >>>

Terminal (1)
input:
```bash
docker run -it -v images:/tmp ubuntu

echo $(date) > /tmp/test
```

Terminal (2)
input:
```bash
cd ~
cat vol-persist/test

### the file should contain the date and time stamp as inputted within the interactive container
```
