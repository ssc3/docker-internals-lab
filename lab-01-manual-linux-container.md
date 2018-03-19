### Lab 1: Manually creating a linux container:

#### Requirements:

Lab VM with:
* unshare tools
* cgroup tools
* stress-ng tools
* btrfs tools
* Docker
* 32 GB space

A recommended option is a Linux VM that is provisioned via AWS EC2 (directions can be found [here](https://ghe.nebulaworks.com/nebulaworks/docker-internals-lab/blob/master/lab-01-setup-vm.md)).

> Note: This lab should be run as the **root** user. This can be accomplished with the following command:
```
sudo -i
```
#### Preparation of the file system:

Prepare copy-on-write filesystem for container and image storage (_Terminal 1_):

Create a file device for our CoW fs to user:

Input:
```
mkdir /cowfs
dd if=/dev/zero of=/cowfs/btrfs.img bs=1024 count=10000000 status=progress
```
Output:
```
10000000+0 records in
10000000+0 records out
40000000 bytes (10 GB) copied, 53.4925 s, 191 MB/s
```

Create a new CoW fs:

Input:
```
mkfs.btrfs /cowfs/btrfs.img
```
Output:
```
btrfs-progs v4.4
See http://btrfs.wiki.kernel.org for more information.

Label:              (null)
UUID:               0d6f310e-1735-427a-a0c7-93b8b2d00ca1
Node size:          16384
Sector size:        4096
Filesystem size:    9.54GiB
Block group profiles:
  Data:             single            8.00MiB
  Metadata:         DUP             496.25MiB
  System:           DUP              12.00MiB
SSD detected:       no
Incompat features:  extref, skinny-metadata
Number of devices:  1
Devices:
   ID        SIZE  PATH
    1     9.54GiB  /cowfs/btrfs.img
```

Now, let's configure the CoW fs for use as a mount with our container:

Input:
```
mount -o loop /cowfs/btrfs.img /cowfs/
mount --make-private /
```

#### Creating a container image:

Create image root file system (borrow from docker) aka your container (read-only) image (_Terminal 1_):

Let's prep the storage location:

Input:
```
cd /cowfs
mkdir -p images containers
btrfs subvol create images/alpine
```
Output:
```
Create subvolume 'images/alpine'
```

Now to borrow an image from Docker:

Input:
```
CID=$(docker run -d alpine true) && echo $CID
docker export $CID | tar -C images/alpine -xf-
ls images/alpine/
```

Output:
```
bin  dev  etc  home  lib  media  mnt  proc  root  run  sbin  srv  sys  tmp  usr  var
```

#### Time to create a place for the container to store stuff:

Create the container's writeable filesystem (_Terminal 1_):

Input:
```
btrfs subvol snapshot images/alpine containers/dolly
```
Output:
```
Create a snapshot of 'images/alpine' in 'containers/dolly'
```

Let's add something new to the container's filesystem:

Input:
```
touch containers/dolly/I_AM_A_CONTAINER
ls containers/dolly/
```
Output:
```
bin  dev  etc  home  I_AM_A_CONTAINER  lib  media  mnt  proc  root  run  sbin  srv  sys  tmp  usr  var
```

#### Give the new file system a test drive:

Test container file system (_Terminal 1_):

Input:
```
chroot containers/dolly/ sh
ls
apk
exit
```
Output:
```
# ls
I_AM_A_CONTAINER  home              proc              srv               var
bin               lib               root              sys
dev               media             run               tmp
etc               mnt               sbin              usr

...

# apk
apk-tools 2.7.2, compiled for x86_64.

usage: apk COMMAND [-h|--help] [-p|--root DIR] [-X|--repository REPO] [-q|--quiet] [-v|--verbose]
           [-i|--interactive] [-V|--version] [-f|--force] [-U|--update-cache] [--progress]
           [--progress-fd FD] [--no-progress] [--purge] [--allow-untrusted] [--wait TIME]
           [--keys-dir KEYSDIR] [--repositories-file REPOFILE] [--no-network] [--no-cache]
           [--cache-dir CACHEDIR] [--arch ARCH] [--print-arch] [ARGS]...

The following commands are available:
  add       Add PACKAGEs to 'world' and install (or upgrade) them, while ensuring that all
            dependencies are met
...
```

#### Let's create the “container”:

First create an isolated processing environment and enable process controls (_Terminal 1_):

Input:
```
# create the cgroups to setup resource controls
cgcreate -g cpu,memory,blkio,devices,freezer:/dolly

# set limits on the cpu and memory resources
cgset -r cpu.cfs_period_us=100000 dolly
cgset -r cpu.cfs_quota_us=1000 dolly
cgset -r memory.limit_in_bytes=512M dolly

# start a process container
cgexec -g cpu,memory,blkio,devices,freezer:/dolly \
prlimit --nofile=256 --nproc=512 --locks=32 \
unshare --mount --uts --ipc --net --pid --fork --mount-proc=/proc bash

# the preceding commands do not generate Output
# instead run the following list command to verify cgroup creation
ls /sys/fs/cgroup/cpu/dolly/
```

Output:
```
# ls /sys/fs/cgroup/cpu/dolly/
cgroup.clone_children  cpuacct.usage         cpu.cfs_quota_us  notify_on_release
cgroup.procs           cpuacct.usage_percpu  cpu.shares        tasks
cpuacct.stat           cpu.cfs_period_us     cpu.stat
```

Time to mount and switch over to the container's file system:

> Note: from this point forward _Terminal 1_ will be operating inside the container:

Changing the identity to the container hostname and pstree:

Input:
```
hostname dolly
exec bash
ps
```

Output:
```
# after running exec bash note the change in the prompt
root@dolly /cowfs:

# ps
  PID TTY          TIME CMD
    1 pts/0    00:00:00 bash
   22 pts/0    00:00:00 ps
```

Mounting the rest of the container filesystem:

Input:
```
cd containers/dolly
mkdir oldroot
cd /
mount --bind /cowfs/containers/dolly/ /cowfs/containers/dolly/
mount --move /cowfs/containers/dolly/ /cowfs/
cd /cowfs
pivot_root . oldroot/
cd ~
cd /
ls
```

Output:
```
I_AM_A_CONTAINER  home              oldroot           sbin              usr
bin               lib               proc              srv               var
dev               media             root              sys
etc               mnt               run               tmp
```

Finally let's fix the process filesystem:

Input:
```
mount -t proc none /proc
umount -l /oldroot/
mount
```

Output:
```
/dev/loop0 on / type btrfs (rw,relatime,space_cache,subvolid=258,subvol=/containers/dolly)
none on /proc type proc (rw,relatime)
```

#### Connecting your container to the world:

> Note: you now need to open a second terminal session to carry out the operations designated for all commands under _Terminal 2_:

Create a container network (_Terminal 2_):

Input:
```
# use root user
sudo -i

# CPID will contain the process ID of your “container” process; copy the id down you'll need it for later

CPID=$(pidof unshare) && echo $CPID
ip link add name h$CPID type veth peer name c$CPID
ip link set c$CPID netns $CPID

# Let's borrow the docker bridge so we don't need to master name space networking
ip link set h$CPID master docker0 up
```

Time to switch back to _Terminal 1_ and configure the network adapter we just connected:

Input:
```
# remember that you are inside the container in this terminal session

ip link set lo up

# {CPID} should be replaced with the CPID number from the previous section

ip link set c{CPID} name eth0 up
ip addr add 172.17.0.128/16 dev eth0
ip route add default via 172.17.0.1
echo nameserver 8.8.8.8 > etc/resolv.conf
ping -c 4 google.com
```

Output:
```
PING google.com (216.58.195.238): 56 data bytes
64 bytes from 216.58.195.238: seq=0 ttl=58 time=2.561 ms
64 bytes from 216.58.195.238: seq=1 ttl=58 time=99.331 ms
64 bytes from 216.58.195.238: seq=2 ttl=58 time=2.439 ms
64 bytes from 216.58.195.238: seq=3 ttl=58 time=2.421 ms

--- google.com ping statistics ---
4 packets transmitted, 4 packets received, 0% packet loss
round-trip min/avg/max = 2.421/26.688/99.331 ms
```

#### Last step: Time to switch over to the alpine shell:

Now that the container has been assembled it's time to interact with it (_Terminal 1_):

Input:
```
exec chroot / sh
ps
```

Output:
```
PID   USER     TIME   COMMAND
    1 root       0:00 sh
   36 root       0:00 ps
```

**SUCCESS!!!**

#### Time to cleanup our manual "container":

Exit and clean up “container” (_Terminal 1_):

Input:
```
exit
cgdelete -g cpu,memory,blkio,devices,freezer:/dolly
ls /sys/fs/cgroup/cpu/dolly
```

Output:
```
ls: cannot access /sys/fs/cgroup/cpu/dolly: No such file or directory
```

### See you in lab two!
