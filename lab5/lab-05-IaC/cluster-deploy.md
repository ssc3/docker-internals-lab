lab files:
provided in repository

#### Requirements

* this lab must be run as root
* to get root access run `sudo su -` from the command line
* must have login to repository

#### Obtain files from repository

input:

```bash
sudo su -
git -c http.sslVerify=false clone https://git.nebulaworks.com/nebulaworks/docker-internals-lab.git

cd lab-05-IaC/
```

output:

```
root@165.227.13.80 ~: sudo su -
root@165.227.13.80 ~: git -c http.sslVerify=false clone
https://git.nebulaworks.com/nebulaworks/docker-internals-lab.git
Cloning into 'docker-internals-lab'...
Username for 'https://git.nebulaworks.com': training
Password for 'https://training@git.nebulaworks.com':
remote: Counting objects: 132, done.
remote: Compressing objects: 100% (3/3), done.
remote: Total 132 (delta 0), reused 0 (delta 0), pack-reused 129
Receiving objects: 100% (132/132), 1.90 MiB | 0 bytes/s, done.
Resolving deltas: 100% (56/56), done.
Checking connectivity... done.
root@165.227.13.80 ~: cd docker-internals-lab/lab5/lab-05-IaC/
```

#### Build terraform tool

Review the Dockerfile

```bash
input:
cat Dockerfile
```

build terraform tool

```bash
docker build -t terraform .
```

#### Deploy UCP

`vi terraform.tfvars`

##### At line 1 of terraform.tfvars

change `name = "training"`
alter name value with `<your_name>`

##### Use terraform to stand up your new infrastructure

```
docker run --rm -it -v $(pwd):/root/ terraform apply

# when complete run the following to grab IP addresses of UCP and DTR to use 
# with the guide.pdf
cat ips.txt

#### output example
UCP URL: https://104.236.156.152
DTR URL: https://192.241.223.231
```

#### Work with the UCP cluster

see the [**guide.pdf**](./guide.pdf)

#### Cleanup cluster

```
docker run --rm -it -v $(pwd):/root/ terraform destroy
```
