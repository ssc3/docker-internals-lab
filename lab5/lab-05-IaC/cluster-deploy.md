#### obtain files from link

link to lab files:
provided in email

#### requirements

> this lab must be run as root
> to get root access run `sudo su -` from the command line

#### transfer file to lab vm

`scp Downloads/lab-05-IaC.zip docker@<LAB_VM_IP>:/tmp`

#### unzip in your home directory

input:

```bash
sudo su -
apt-get install -y unzip
cp /tmp/lab-05-IaC.zip .
unzip lab-05-IaC.zip

#######

cd lab-05-IaC/
```

output:

```
docker@159.203.219.157 ~: unzip lab-05-IaC.zip
Archive:  lab-05-IaC.zip
   creating: lab-05-IaC/
  inflating: lab-05-IaC/compose.txt
  inflating: lab-05-IaC/ddc-install.sh
   creating: __MACOSX/
   creating: __MACOSX/lab-05-IaC/
  inflating: __MACOSX/lab-05-IaC/._ddc-install.sh
  inflating: lab-05-IaC/ddc-join.sh
  inflating: __MACOSX/lab-05-IaC/._ddc-join.sh
  inflating: lab-05-IaC/ddc.tf
  inflating: __MACOSX/lab-05-IaC/._ddc.tf
  inflating: lab-05-IaC/Dockerfile.txt
  inflating: lab-05-IaC/guide.pdf
  inflating: __MACOSX/lab-05-IaC/._guide.pdf
  inflating: lab-05-IaC/terraform.tfvars
  inflating: __MACOSX/lab-05-IaC/._terraform.tfvars
  inflating: lab-05-IaC/training.key
  inflating: lab-05-IaC/training.key.pub
  inflating: lab-05-IaC/variables.tf
  inflating: __MACOSX/lab-05-IaC/._variables.tf
docker@159.203.219.157 ~: ls
lab-05-IaC  lab-05-IaC.zip  __MACOSX
docker@159.203.219.157 ~: cd lab-05-IaC/
docker@159.203.219.157 ~/lab-05-IaC:
```

#### build terraform tool

review the Dockerfile

```bash
input:
cat Dockerfile
```

build terraform tool

```bash
docker build -t terraform .
```

#### Deploy UCP

edit `terraform.tfvars`

##### at line 1 of terraform.tfvars

change `name = "training"`
alter name value with `<your_name>`

##### Use terraform to stand up your new infrastructure

```
docker run --rm -it -v $(pwd):/root/ terraform apply

# when complete run the following to grab IP addresses of UCP and DTR to use with the guide.pdf
cat ips.txt

#### output example


```

#### work with the UCP cluster

see the **guide.pdf**

#### cleanup cluster

```
docker run --rm -it -v `pwd`:/root/ terraform destroy
```
