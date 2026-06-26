## Docker Compose: Multi-Container Basics

- Today's goal is to run multi-container applications with a single command.
- Previously we manually created networks and volumes and ran containers one by one. Docker Compose does all of that in one YAML file.


#### Task 1: Install & Verify
- Check if Docker Compose is available on your machine
- Verify the version

1. Verify docker compose installed:

       docker compose version
       o/p:
       Docker Compose version v5.1.2

2. Verify docker engine and compose:

       docker --version

       docker compose

---

#### Task 2: Your First Compose File
- Create a folder compose-basics
- Write a docker-compose.yml that runs a single Nginx container with port mapping
- Start it with docker compose up
- Access it in your browser
- Stop it with docker compose down


#### 1. Create a project folder

        mkdir compose-basics
        cd compose-basics


#### 2. Create `docker-compose.yml`

      nano docker-compose.yml

      services:
        nginx:
          image: nginx:latest
          container_name: nginx-compose
          ports:
            - "8080:80"


Understanding YAML file:

 - `services`: Defines the containers managed by Compose.
 - `nginx` : Service name.
 - `image: nginx:latest` : Pull and run the latest Nginx image.
 - `container_name: nginx-compose` : Assign a custom container name.
 - `8080` = Host machine port ; `80` = Container port


#### 3. Validate compose file - checks YAML syntax.

        docker compose config


#### 4. Start container

        docker compose up

        o/p:
        [+] Running 1/1
         ✔ Container nginx-compose Started


#### 5. Access Nginx in Browser

       http://localhost:8080


#### 6. Check running containers

       docker ps
       CONTAINER ID   IMAGE          PORTS
       xxxxx          nginx:latest   0.0.0.0:8080->80/tcp


#### 7. Stop the compose application

       docker compose down
       [+] Running 1/1
        ✔ Container nginx-compose Removed


Summary:

- `docker compose up` → Create and start containers.
- `docker compose up -d` → Run in background (detached mode).
- `docker compose down` → Stop and remove containers, networks created by Compose.
- Compose reads the `docker-compose.yml` file automatically from the current directory.

---

#### Task 3: Two-Container Setup
- Write a docker-compose.yml that runs:
     - A WordPress container
     - A MySQL container
- They should:
     - Be on the same network (Compose does this automatically)
     - MySQL should have a named volume for data persistence
     - WordPress should connect to MySQL using the service name


#### 1. Create a project folder

        mkdir wordpress-compose
        cd wordpress-compose
