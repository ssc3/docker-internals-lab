#### Obtain files from link

link to lab files:
provided in email

#### Requirements

* this lab must be run as root
* to get root access run `sudo su -` from the command line

#### Transfer file to lab vm

`scp Downloads/lab-05-IaC.zip docker@<LAB_VM_IP>:/tmp`

#### Unzip in your home directory

input:

```bash
sudo su -
cp /tmp/lab-05-IaC.zip .
unzip lab-05-IaC.zip

cd lab-05-IaC/
```

output:

```
root@dockerhost1 ~: unzip lab-05-IaC.zip
Archive:  lab-05-IaC.zip
   creating: lab-05-IaC/
  inflating: lab-05-IaC/.cluster-deploy.md.swp
   creating: lab-05-IaC/.terraform.d/
  inflating: lab-05-IaC/.terraform.d/checkpoint_cache
  inflating: lab-05-IaC/.terraform.d/checkpoint_signature
  inflating: lab-05-IaC/.terraform.tfstate.lock.info
   creating: lab-05-IaC/client-bundle/
  inflating: lab-05-IaC/client-bundle/client-bundle.sh
  inflating: lab-05-IaC/client-bundle/Dockerfile
  inflating: lab-05-IaC/cluster-deploy.md
  inflating: lab-05-IaC/cluster-deploy.pdf
  inflating: lab-05-IaC/ddc-install.sh
  inflating: lab-05-IaC/Dockerfile
  inflating: lab-05-IaC/dtr-join.sh
  inflating: lab-05-IaC/guide.pdf
  inflating: lab-05-IaC/main.tf
  inflating: lab-05-IaC/terraform.tfvars
  inflating: lab-05-IaC/training.key
  inflating: lab-05-IaC/training.key.pub
  inflating: lab-05-IaC/variables.tf
  inflating: lab-05-IaC/worker-join.sh
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

edit `terraform.tfvars`

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

see the **guide.pdf**

#### Cleanup cluster

```
docker run --rm -it -v $(pwd):/root/ terraform destroy
```
