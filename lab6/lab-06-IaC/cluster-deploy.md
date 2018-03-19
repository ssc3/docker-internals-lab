# Cluster Deploy Guide

## Requirements

* Lab files: Provided in repository
* Login to the lab repository

> Note: This lab should be run as the **root** user. This can be accomplished with the following command:
```bash
$ sudo su -
```

## Obtain files from repository

Input:

```bash
$ sudo su -
$ git clone https://ghe.nebulaworks.com/nebulaworks/docker-internals-lab.git
$ cd docker-internals-lab/lab6/lab-06-IaC/
```

Output:

```
root@ip-172-31-23-34:~# git clone https://ghe.nebulaworks.com/nebulaworks/docker-internals-lab.git
Cloning into 'docker-internals-lab'...
Username for 'https://ghe.nebulaworks.com': training
Password for 'https://training@ghe.nebulaworks.com':
remote: Counting objects: 357, done.
remote: Compressing objects: 100% (19/19), done.
remote: Total 357 (delta 10), reused 18 (delta 5), pack-reused 333
Receiving objects: 100% (357/357), 8.06 MiB | 0 bytes/s, done.
Resolving deltas: 100% (170/170), done.
Checking connectivity... done.
root@ip-172-31-23-34:~# cd docker-internals-lab/lab6/lab-06-IaC/
```

## Build terraform tool

Review the Dockerfile:

```bash
$ cat Dockerfile
```

Build the terraform Docker image:

```bash
$ docker image build -t terraform .
```

## Deploy UCP

`vim terraform.tfvars # Or use the text editor of your choice.`

At line 1 of terraform.tfvars:

Change `name = "training"`, to `name = "<your-name>"`.

## Use terraform to stand up your DDC infrastructure

```
$ docker run --rm -it -v $(pwd):/root/ terraform apply
# When complete run the following to grab IP addresses of UCP and DTR to use
# with the guide.md

$ cat ips.txt
## output example
UCP URL: https://104.236.156.152
DTR URL: https://192.241.223.231
```

## Work with the UCP cluster

See [**guide.md**](./guide.md).

## Cleanup cluster

```
$ docker run --rm -it -v $(pwd):/root/ terraform destroy
```
