# Docker Datacenter Guide

This walkthrough demonstrates the basic use of Docker Datacenter.

**Applies to:** The information in this topic applies to DDC.

## Content

This welcome guide illustrates the following tasks:

1. Logging into DDC.
1. Creating a new user.
1. Logging into DTR.
1. Deploying an application.
1. Deploying a WP site

## Prerequisites

You need the following components to complete this walkthrough:

* Browser (screenshots show Chrome)
* Three node Docker Datacenter (DDC) Sandbox in DigitalOcean.

Note: All nodes have the Docker Engine, Universal Control Plane (UCP) and
Docker Trusted Registry (DTR) installed.

### Accessing Universal Control Plane

Universal Control Plane can be accessed at `https://<your-ucp-ip>` in your
browser. Login with the following credentials:

Username: admin

Password: orcaorca

### Accessing Docker Trusted Registry

Docker Trusted Registry can be accessed at `https://<your-dtr-ip>` in your
browser.

## 1. Logging into UCP

Use a browser to open `https://<your-ucp-ip>`

### Log into UCP

1. Open `https://<your-ucp-ip>` in a browser.
1. Click "Advanced" and Proceed to bypass the certificate error page
  ![UCP Login on Chrome](../assets/advanced.png)
  ![Proceed to UCP](../assets/proceed.png)
1. Use the default admin credentials to login, UN:admin/PW:orcaorca
  ![UCP login](../assets/ucp-login.png)
1. Select the "admin" drop down box > Profile to change the default admin
   password upon initial login

  ![Setting admin password](../assets/admin-password.png)

## 2. Creating a new user

Use a browser to open `https://<your-ucp-ip>`

### Create a new user

1. Select "User Management" from the UCP dashboard top menu bar:
  ![User Management](../assets/user-management.png)
1. Select the "Create User" button
1. Enter new user information and select "Create User" button to save:
  ![Create User](../assets/create-user.png)

## 3. Logging into DTR

Use a browser to open `https://<your-dtr-ip>`

### Log into DTR and Create a new repository

1. Open `https://<your-dtr-ip>` in a browser.
1. Use the default admin credentials to login, UN:admin/PW:orcaorca.
1. Select "New Repository" to create a new repository.

![Docker Trusted Registry](../assets/dtr.png)

## 4. Deploying an application

The voting application to be deployed is composed of five(5) services:

* Redis
* Postgres (PostgreSQL)
* Worker containers
* Results containers
* Web services

### Deploy an application

1. On your browser, log in to UCP `https://<your-ucp-ip>`
1. Navigate to the Resources page
1. Click the "Deploy" button
1. Copy-paste the application definition below into the "APPLICATION DEFINITION"
   section of the form, and name it 'vote-app'.

  ```yaml
  ---
  version: "3"

  services:
    voting-app:
      image: ehazlett/dockercon-voting-app
      ports:
        - "8000:80"
      networks:
        - voteapp
    result-app:
      image: ehazlett/dockercon-result-app
      ports:
        - "5000:80"
      networks:
        - voteapp
    worker:
      image: ehazlett/dockercon-worker
      networks:
        - voteapp
    redis:
      image: redis
      ports:
        - "6379"
      networks:
        - voteapp
    db:
      image: postgres:9.4
      volumes:
        - "db-data:/var/lib/postgresql/data"
      networks:
        - voteapp
  volumes:
    db-data:

  networks:
    voteapp:
  ```

  ![Deploy](../assets/deploy.png)
1. Click the "Create" button to create the vote-app application
1. Once UCP deploys the vote-app application, you can click on the stack,
   to see its details.
1. Access the vote-app site:
   To vote: `http://<your-ucp-ip>:8000/`
   To view results: `http://<your-ucp-ip>:5000`

## 5. Deploying a WP site

The WordPress application to be deployed is composed of two services:

* WordPress: The container that runs Apache, PHP, and WordPress
* DB: A MySQL database used for data persistence.

### Deploy a WP site

1. On your browser, log in to UCP `https://<your-ucp-ip>`
1. Navigate to the "Stacks & Applications" page
1. Click the "Deploy" button
1. Copy-paste the application definition below into the "APPLICATION DEFINITION"
   section of the form, and name it "wordpress".

  ```yaml
  ---
  version: '3'

  services:
    db:
      image: mysql:5.7
      volumes:
        - db_data:/var/lib/mysql
      environment:
        MYSQL_ROOT_PASSWORD: wordpress
        MYSQL_DATABASE: wordpress
        MYSQL_USER: wordpress
        MYSQL_PASSWORD: wordpress

    wordpress:
      depends_on:
        - db
      image: wordpress:latest
      ports:
        - "8080:80"
      environment:
        WORDPRESS_DB_HOST: db:3306
        WORDPRESS_DB_PASSWORD: wordpress
  volumes:
    db_data:
  ```

1. Click the "Create" button, to create the WordPress application
1. Once UCP deploys the WordPress application, you can click on the wordpress
   stack to see its details.
1. Access the WordPress site: `http://<your-ucp-ip>:8080/`
1. Finish initial configuration by entering the site title, admin UN, admin PW
   and admin email address.
1. Click the "Install WordPress" button to finish

## Next Steps

This walkthrough shows the basics of using DDC. Here are some tasks that might
come next:

* Deploy an application from the CLI.

## See also

[https://docs.docker.com/datacenter/ucp/2.1/guides/user/services/deploy-app-cli/](https://docs.docker.com/datacenter/ucp/2.1/guides/user/services/deploy-app-cli/)
