>  please run this exercise as root <br>
>  run `sudo su -` to obtain root access with the class vm

#### check rkt installation 1.17.0
```bash
rkt help
rkt version
```

#### check lxc configuration
```bash
lxc-checkconfig
```

getting Ubuntu images for testing >>>

#### rkt runtime

```bash
rkt --insecure-options=image fetch docker://ubuntu:14.04
```

#### lxc runtime

```bash
lxc-create -n myubuntu -t ubuntu
```

#### docker runtime

```shell
docker pull ubuntu:14.04
```

testing containers >>>>>

```shell
mkdir /usr/bin/c-bin
cp /usr/bin/stress-ng /usr/bin/c-bin/
```

#### rkt runtime

```shell
rkt run --interactive=true --net=host --volume stress,kind=host,source=/usr/bin/c-bin/ \
--mount volume=stress,target=/tmp --insecure-options=image docker://ubuntu:14.04

cd /tmp

./stress-ng --cpu 8 --io 4 --vm 2 --vm-bytes 256M --fork 4 --timeout 10s --metrics

#
```


#### lxc runtime

```bash
lxc-start -n myubuntu -d

lxc-console -n myubuntu

(user name: ubuntu pass: ubuntu)

apt-get update

apt-get install -y stress

stress --cpu 8 --io 4 --vm 2 --vm-bytes 256M --timeout 10s

```

> to exit the lxc container <br>
> press the following key sequence `ctrl-a + q`

#### docker runtime

```bash
docker run -it ubuntu /bin/bash

apt-get update

apt-get install -y stress-ng

stress-ng --cpu 8 --io 4 --vm 2 --vm-bytes 256M --fork 4 --timeout 10s --metrics
```
