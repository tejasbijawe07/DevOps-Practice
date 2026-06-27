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


#### 2. Create docker-compose.yml

        nano docker-compose.yml


       services:
          db:
            image: mysql:8.0
            container_name: wordpress-db
            restart: always
            environment:
               MYSQL_ROOT_PASSWORD: rootpassword
               MYSQL_DATABASE: wordpress
               MYSQL_USER: wpuser
               MYSQL_PASSWORD: wppassword
            volumes:
              - db_data:/var/lib/mysql

          wordpress:
             image: wordpress:latest
             container_name: wordpress-app
             restart: always
             depends_on:
               - db
             ports:
               - "8080:80"
             environment:
               WORDPRESS_DB_HOST: db:3306
               WORDPRESS_DB_NAME: wordpress
               WORDPRESS_DB_USER: wpuser
               WORDPRESS_DB_PASSWORD: wppassword

       volumes:
         db_data:


Understanding the yaml file:

- #### MySQL Service - 
     - `db:` : Service name used by WordPress to connect.
     - `image: mysql:8.0` :  Runs the MySQL image.
     - `environment:` : Creates:
                 - Root password
                 - Database
                 - User
                 - Password
     - `volumes: - db_data:/var/lib/mysql` : Stores MySQL database files in a named volume.

- #### WordPress Service -
     - `depends_on: - db` : Starts MySQL before WordPress.
     - `WORDPRESS_DB_HOST: db:3306` : db is the service name, which Compose automatically resolves to the MySQL container.
     - `ports: - "8080:80"` : Maps:
                  - Host port 8080
                  - Container port 80.
     
- #### Named Volume -
     - `volumes: db_data:` : Creates a Docker-managed named volume.


#### 3. Validate compose file

      docker compose config

#### 4. start the application

     docker compose up -d

     o/p:
     Creating network "wordpress-compose_default"
     Creating volume "wordpress-compose_db_data"
     Creating wordpress-db
     Creating wordpress-app


#### 5. verify network

    docker network ls
    docker network inspect wordpress-compose_default

#### 6. verify volume

    docker volume ls
    docker volume inspect wordpress-compose_db_data

#### 7. open wordpress

    http://localhost:8080

#### 8. verify container communication

    docker exec -it wordpress-app bash

    ping:
    ping db

- This works because Compose automatically creates a DNS entry for each service name.


#### 9. stop container

    docker compose down

- If we restart this container again and open wordpress site, the installation wizard for wordpress won't appear again as it was configured previously and the MySQL database data is stored in named volume.


#### verify persistence

    docker volume ls

    docker volume inspect wordpress-compose_db_data ... (volume still exists)

- How Compose connects container

                  Docker Compose

      +-----------------------------+
      |     Default Network         |
      |                             |
      |   wordpress -----> db       |
      |      |             |        |
      +-----------------------------+

      Service Name = db
      Hostname     = db
      Port         = 3306

  - WordPress connects to MySQL using the hostname db, without needing to know the container's IP address.

---

#### Task 4: Compose Commands

#### 1. Start service in detached mode

       docker compose up -d

- Starts all services defined in `docker-compose.yml`.
- `-d` (detached mode) runs containers in the background.
- terminal is free to use for other commands.


#### 2. view running services

      docker compose ps

- Shows only the services in the current Compose project.
- Displays:
     - Container name
     - Status
     - Ports
 

#### 3. view logs of all services

    docker compose logs

Displays logs from every service in the Compose application.


#### 4. view logs of specific service

    docker compose logs wordpress

    docker compose logs -f wordpress ... (follow live logs)


#### 5. stop/restart services without removing containers

    docker compose stop

    docker compose start ...(restart)

#### 6. Remove containers and networks

    docker compose down

- Removes:
   - Containers
   - Default network

- Keeps:
   - Named volumes
   - Images

 - To remove name volumes:

       docker compose down -v

#### 7. Rebuild images after making changes

       docker compose build
       docker compose up -d ...(restart)

- build rebuilds the image from the Dockerfile.
- Note: In the WordPress + MySQL example, we are using prebuilt images (`image:`), so `docker compose build` has no effect. It becomes useful when Compose file contains something like:

       services:
         web:
           build: .

---

#### Task 5: Environment Variables
- Add environment variables directly in your docker-compose.yml
- Create a .env file and reference variables from it in your compose file
- Verify the variables are being picked up


