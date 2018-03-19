### Lab 2: Container runtimes:

> Note: This lab should be run as the **root** user. This can be accomplished with the following command:
```
sudo su - 
```

#### Check rkt installation 1.29.0:
```bash
rkt help
rkt version
```

#### Check lxc configuration:
```bash
lxc-checkconfig
```

Getting Ubuntu images for testing:

#### rkt runtime:

```bash
rkt --insecure-options=image fetch docker://ubuntu:16.04
```

#### lxc runtime:

```bash
lxc-create -n myubuntu -t ubuntu
```

#### Docker runtime:

```shell
docker pull ubuntu:16.04
```

Testing containers:

```shell
mkdir /usr/bin/c-bin
cp /usr/bin/stress-ng /usr/bin/c-bin/
```

#### rkt runtime:

```shell
rkt run --interactive=true --net=host --volume stress,kind=host,source=/usr/bin/c-bin/ \
--mount volume=stress,target=/tmp --volume lib,kind=host,source=/lib/x86_64-linux-gnu/ \
--mount volume=lib,target=/lib/x86_64-linux-gnu --insecure-options=image docker://ubuntu:16.04

cd /tmp

./stress-ng --cpu 8 --io 4 --vm 2 --vm-bytes 256M --fork 4 --timeout 10s --metrics

# to exit rkt

exit
```


#### lxc runtime:

```bash
lxc-start -n myubuntu -d

lxc-console -n myubuntu

(user name: ubuntu pass: ubuntu)

sudo apt-get update

sudo apt-get install -y stress-ng

stress-ng --cpu 8 --io 4 --vm 2 --vm-bytes 256M --fork 4 --timeout 10s --metrics

```

> Note: To exit the lxc container press the following key sequence `ctrl-a + q`.

#### Docker runtime:

```bash
docker run -it ubuntu /bin/bash

apt-get update

apt-get install -y stress-ng

stress-ng --cpu 8 --io 4 --vm 2 --vm-bytes 256M --fork 4 --timeout 10s --metrics
```

### See you in lab three!
