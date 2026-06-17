## Docker Volumes & Networking


#### Task 1: The Problem
- Run a Postgres or MySQL container
- Create some data inside it (a table, a few rows)
- Stop and remove the container
- Run a new one — is your data still there?

#### 1. Run a PostgreSQL container

    docker run -d --name postgres-demo -e POSTGRES_PASSWORD=password postgres

Understanding the command:

| Option                          | Meaning                                          |
| ------------------------------- | ------------------------------------------------ |
| `docker run`                    | Creates and starts a new container               |
| `-d`                            | Runs container in background (detached mode)     |
| `--name postgres-demo`          | Gives container a custom name                    |
| `-e POSTGRES_PASSWORD=password` | Sets environment variable required by PostgreSQL |
| `postgres`                      | Uses the official PostgreSQL image               |


#### 2. Connect to PostgreSQL

    docker exec -it postgres-demo psql -U postgres

Understanding the command:

| Option          | Meaning                                  |
| --------------- | ---------------------------------------- |
| `docker exec`   | Run a command inside a running container |
| `-it`           | Interactive terminal                     |
| `postgres-demo` | Container name                           |
| `psql`          | PostgreSQL command-line client           |
| `-U postgres`   | Login as postgres user                   |


#### 3. Creating sql data

Inside PostgreSQL:

     CREATE TABLE employees (
       id SERIAL PRIMARY KEY,
       name VARCHAR(50)
     );

     INSERT INTO employees (name)
     VALUES ('Volumes');

     SELECT * FROM employees;

     o/p:
      id | name
     ----+-------
      1  | Volumes

Useful sql commands inside container:
- `\dt` - Show all tables
- `\d employees` - Describe a table
- `\q` - Exit PostgreSQL
-  `docker exec -it postgres-demo psql -U postgres -c "CREATE TABLE employees (id SERIAL PRIMARY KEY, name VARCHAR(50));"` - Execute sql directly from linux terminal.
-  `\r` - remove previous command -- o/p: Query buffer reset (cleared).

| Prompt       | Meaning                                   |
| ------------ | ----------------------------------------- |
| `postgres=#` | Ready for a new command                   |
| `postgres(#` | Waiting for closing `)`                   |
| `postgres-#` | Waiting for a semicolon `;` or more input |
| `postgres'>` | Waiting for closing quote `'`             |


#### 4. Stop Container

     docker stop postgres-demo

#### 5. Remove container

     docker rm postgres-demo

- Container filesystem is deleted.
- Any data stored inside the container is deleted.

#### 6. Start new PostgrSQL Container

       docker run -d \
       --name postgres-demo-new \
       -e POSTGRES_PASSWORD=password \
       postgres

#### 7. Check for table

       docker exec -it postgres-demo-new psql -U postgres

       \dt
       SELECT * FROM employees;

       o/p:
       ERROR: relation "employees" does not exist

- The sql data is gone.
- The PostgreSQL database files were stored inside the container's writable layer.
- When container was removed, docker deleted container, its filesystem and all databse files.
- Containers are Ephemeral(temporary); when container deleted, data is also deleted.
- Containers should not be used for permanent storage. Use Docker Volumes to persist data beyond the life of a container.


#### 8. Verify where PostgreSQL stores its data:

       docker inspect postgres-demo
       
       docker exec -it postgres-demo bash ...(inside container)

 - PostgreSQL stores its database files in:
      - "PGDATA=/var/lib/postgresql/18/docker"
 - Without a volume: deleting the container deletes the data.
 - With a volume mounted to PGDATA: data survives container deletion.

---

#### Task 2: Named Volumes
 - Create a named volume
 - Run the same database container, but this time attach the volume to it
 - Add some data, stop and remove the container
 - Run a brand new container with the same volume
 - Is the data still there?

- Docker Volumes persist data even when containers are deleted.

#### 1. Create a named Volume

       docker volume create pgdata

Understanding the command:

 - `docker volume` - Manage Docker volumes
 - `create` - Create a new volume
 - `pgdata` - Name of the volume

Verify: 

      docker volume ls
      o/p:
      DRIVER    VOLUME NAME
      local     pgdata

#### 2. Run PostgreSQL with Volume attached

       docker run -d --name postgres-volume -e POSTGRES_PASSWORD=password -v pgdata:/var/lib/postgresql/18/docker postgres

Understanding command:

| Option                                    | Meaning                     |
| ----------------------------------------- | --------------------------- |
| `docker run`                              | Create and start container  |
| `-d`                                      | Run in background           |
| `--name postgres-volume`                  | Container name              |
| `-e POSTGRES_PASSWORD=password`           | Set postgres password       |
| `-v pgdata:/var/lib/postgresql/18/docker` | Mount volume into container |
| `postgres`                                | PostgreSQL image            |


Understanding the volume mapping:

pgdata:/var/lib/postgresql/18/docker

 - pgdata - Docker volume stored on host.
 - /var/lib/postgresql/18/docker - Database directory inside container (PGDATA).

#### 3. Create data

     docker exec -it postgres-volume psql -U postgres

| Part              | Meaning                      |
| ----------------- | ---------------------------- |
| `docker exec`     | Run command inside container |
| `-it`             | Interactive terminal         |
| `postgres-volume` | Container name               |
| `psql`            | PostgreSQL client            |
| `-U postgres`     | Login as postgres user       |


      CREATE TABLE employees (
      id SERIAL PRIMARY KEY,
      name VARCHAR(50)
      );
      INSERT INTO employees(name)
      VALUES ('Tejas');
      SELECT * FROM employees;

#### 4. Stop and remove the container

     docker stop postgres-volume

     docker rm postgres-volume

#### 5. Creating a new Container

    docker run -d --name postgres-volume-new -e POSTGRES_PASSWORD=password -v pgdata:/var/lib/postgresql/18/docker postgres


- Data is still present
- `docker volume inspect pgdata`

      [
         {
          "Name": "pgdata",
          "Driver": "local",
          "Mountpoint": "/var/lib/docker/volumes/pgdata/_data"
         }
      ]

| Field      | Meaning                 |
| ---------- | ----------------------- |
| Name       | Volume name             |
| Driver     | Storage driver          |
| Mountpoint | Actual location on host |


- The PostgreSQL database files were stored in the Docker volume (pgdata) instead of the container filesystem.
- Docker Volumes provide persistent storage. Containers can be removed and recreated without losing data, as long as the same volume is attached.

---

#### Task 3: Bind Mounts
- Create a folder on your host machine with an index.html file
- Run an Nginx container and bind mount your folder to the Nginx web directory
- Access the page in your browser
- Edit the index.html on your host — refresh the browser


#### a. What is a Bind Mount?

- A bind mount is a Docker storage mechanism that connects a specific file or directory on the host machine to a directory or file inside a container.
- Any change made on the host are immediately visible inside the container.
- Syntax: `docker run -v <host-path>:<container-path> <image>`
- `$(pwd)` = current directory on the host machine.
- `/usr/share/nginx/html` = Nginx web directory inside the container.
- Bind Mount flow:

         Host Machine
         ┌─────────────────────┐
         │ index.html          │
         │ style.css           │
         └─────────┬───────────┘
                   │ Bind Mount
                   ▼
         Container
         ┌─────────────────────┐
         │ /usr/share/nginx/html
         │ index.html          │
         │ style.css           │
         └─────────────────────┘

#### b. Why Do We Use Bind Mounts?

- Live Code Development: Developers can edit source code on the host and immediately see changes inside the container.
- Example: `docker run -v $(pwd):/app node-app`
  
- Share Configuration Files: Mount configuration files from the host.
- Example: `docker run -v /home/user/nginx.conf:/etc/nginx/nginx.conf nginx`

- Persistent data: Files remain on the host even if the container is deleted.

- Log Collection: Store application logs directly on the host.
- `docker run -v /var/log/myapp:/logs myapp`




#### 1. Creating folder and index.html file


       mkdir nginx-site
       cd nginx-site

       echo "<h1>Hello from Bind Mount</h1>" > index.html

#### 2. Run Nginx container with a bind mount


      docker run -d --name nginx-bind -p 8080:80 -v $(pwd):/usr/share/nginx/html nginx

Understanding the command:

| Option                            | Meaning                                               |
| --------------------------------- | ----------------------------------------------------- |
| `docker run`                      | Create and start a container                          |
| `-d`                              | Run in background (detached mode)                     |
| `--name nginx-bind`               | Container name                                        |
| `-p 8080:80`                      | Map host port 8080 to container port 80               |
| `-v $(pwd):/usr/share/nginx/html` | Bind mount current host directory into Nginx web root |
| `nginx`                           | Nginx image                                           |

#### 3. Access the page

    http://localhost:8080

#### 4. Modify the file on the host

      echo "<h1>Updated from Host Machine</h1>" > index.html

- The changes appear immediately.
- Reason: The container is directly reading files from the host directory through the bind mount.

#### 5. Verify mounts

     docker inspect nginx-bind

     o/p:
     "Mounts": [
            {
                "Type": "bind",
                "Source": "/home/dell/nginx-site",
                "Destination": "/usr/share/nginx/html",
                "Mode": "",
                "RW": true,
                "Propagation": "rprivate"
            }
        ]

### Bind Mounts vs Named Volumes:

| Feature               | Named Volume                      | Bind Mount                      |
| --------------------- | --------------------------------- | ------------------------------- |
| Storage Location      | Managed by Docker                 | Specific host directory         |
| Created By            | Docker                            | User                            |
| Host Path Required    | No                                | Yes                             |
| Easy Backup/Migration | Yes                               | Manual                          |
| Performance           | Usually better                    | Depends on host filesystem      |
| Access from Host      | Harder                            | Direct access                   |
| Typical Use           | Database data, persistent storage | Source code, configs, web files |
| Managed Using         | `docker volume` commands          | Normal filesystem tools         |


- Example:

   1. Named Volume- Docker manages where the data is stored.

          docker volume create mydata

          docker run -v mydata:/var/lib/postgresql/data postgres

   2. Bind Mount- The container directly uses files from your current host directory.

           docker run -v $(pwd):/app nginx

- Named Volume: Docker-managed storage used mainly for persistent application data.
- Bind Mount: Maps a specific host directory/file into a container, allowing real-time access and modification from the host system.

---

#### Task 4: Docker Networking Basics
 - List all Docker networks on your machine
 - Inspect the default bridge network
 - Run two containers on the default bridge — can they ping each other by name?
 - Run two containers on the default bridge — can they ping each other by IP?


#### 1. What is Docker Networking?

- Docker networking allows containers to communicate:
    - With each other
    - With the Docker host
    - With external networks (Internet)

- Every container gets its own:
    - Network namespace
    - IP address
    - Network interfaces
    - Routing table


#### 2. Why docker networking is needed?

        Container A (Web App)
                |
                |
        Container B (Database)

  - The web application must connect to the database.
  - Docker networking provides the communication channel between them.


#### 3. Types of docker Networks

`docker network ls`:

     NETWORK ID     NAME      DRIVER
     xxxxxx         bridge    bridge
     xxxxxx         host      host
     xxxxxx         none      null


A. Bridge Network: Default network for containers.

       Container A ----+
                       |
                  Docker Bridge
                       |
       Container B ----+

Features:
  - Containers get private IP addresses.
  - Containers can communicate with each other.
  - Internet access is available through NAT.
  - Host can access containers through published ports.

Example:
 
     docker run -d --name web nginx
     docker run -d --name db postgres

     Both are attached to the default bridge network.


B. Host Network: Container uses the host's network stack directly.

   - No separate container IP.
   - Example: `docker run --network host nginx`
   - Benefits: Better performance, No port mapping required.


C. None Network: No networking.

   - Example: `docker run --network none ubuntu`
   - Used for: Security, Offline processing.


#### 4. What is a Bridge?

  - A bridge is a virtual network switch created by Docker.

          Docker Bridge (docker0)
                  |
          -------------------------
          |           |           |
         Container1 Container2 Container3

 - The bridge forwards traffic between connected containers.


#### 5. Default Bridge Network?
- Docker automatically creates: bridge.
- `docker network inspect bridge`
- Subnet: 172.17.0.0/16 ; Gateway: 172.17.0.1
- Example: Container1 → 172.17.0.2 ; Container2 → 172.17.0.3


#### 6. How communication works?

 - Container1 → 172.17.0.2
 - Container2 → 172.17.0.3
 - Container1 sends traffic: ping 172.17.0.3

        Container1
           |
        Virtual Ethernet (veth)
           |
        Docker Bridge (docker0)
           |
        Virtual Ethernet (veth)
           |
        Container2

---

#### TASK:

#### 1. List docker networks

    docker network ls

    o/p:
    NETWORK ID     NAME      DRIVER    SCOPE
    a1b2c3d4e5f6   bridge    bridge    local
    b2c3d4e5f6g7   host      host      local
    c3d4e5f6g7h8   none      null      local

| Network | Purpose                        |
| ------- | ------------------------------ |
| bridge  | Default network for containers |
| host    | Container shares host network  |
| none    | No networking                  |


#### 2. Inspect the default bridge network

    docker network inspect bridge

    Information Displayed
    Network subnet
    Gateway IP
    Connected containers
    Driver type
    Network settings


#### 3. Run two containers on default bridge

     docker run -dit --name container1 ubuntu bash

     docker run -dit --name container2 ubuntu bash


#### 4. Can they ping each other by name

  - Enter Container1:

        docker exec -it container1 bash

  - Install ping:

        apt update && apt install -y iputils-ping
        ping container2

        o/p:
        ping: container2: Name or service not known

  - The default bridge network does NOT provide automatic DNS name resolution between containers. Only IP communication works.


#### 5. Can they ping each other by IP

  - Find Container2 IP:

        docker inspect container2

        docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' container2

        o/p:
        "Gateway": "172.17.0.3"


   - From Container1:

         ping 172.17.0.3
         o/p:
         64 bytes from 172.17.0.3: icmp_seq=1 ttl=64 time=0.1 ms

   - Containers on the same bridge network can communicate using IP addresses.


 #### Why does ping by name fail on the default bridge network?

Because the default bridge network does not provide Docker DNS-based service discovery. Containers can communicate only through IP addresses unless a user-defined bridge network is created.

---


#### Task 5: Custom Networks
- Create a custom bridge network called my-app-net
- Run two containers on my-app-net
- Can they ping each other by name now?
- Write in your notes: Why does custom networking allow name-based communication but the default bridge doesn't?


#### 1. Create a Custom Bridge network


     docker network create my-app-net

Understanding the command:
- `docker network` → Manage Docker networks.
- `create` → Create a new network.
- `my-app-net` → Name of the network.

Verify:

    docker network ls

    o/p:
    NETWORK ID     NAME         DRIVER    SCOPE
    0b8e2afe687f   bridge       bridge    local
    55450bf756f9   host         host      local
    6102a4dc21b7   my-app-net   bridge    local
    3015c371336c   none         null      local


#### 2. Run two Containers on custom network

    docker run -dit --name app1 --network my-app-net ubuntu bash
    docker run -dit --name app2 --network my-app-net ubuntu bash

Understanding the command:
- `-d` → Detached mode.
- `-i` → Interactive.
- `-t` → Terminal.
- `--name` → Assign container name.
- `--network my-app-net` → Connect container to custom network.


#### 3. Install Ping

Inside app1:

    docker exec -it app1 bash

Install ping:

    apt update && apt install -y iputils-ping


#### 4. Ping by container name

Inside container1:

    ping app2
    o/p:
    PING app2 (172.18.0.3) 56(84) bytes of data.
    64 bytes from app2.my-app-net: icmp_seq=1 ttl=64 time=0.1 ms
    64 bytes from app2.my-app-net: icmp_seq=2 ttl=64 time=0.1 ms


- When we create a user-defined bridge network, Docker automatically enables an internal DNS server.

        app1  ---> Docker DNS ---> app2 IP
  
- So containers can find each other using names.

- Default bridge is created automatically by Docker for backward compatibility which:
     - Assigns IP addresses
     - Allows IP-based communication
     - Does NOT provide automatic DNS-based name resolution
     - so `ping app2` fails on default bridge, but `ping 172.17.0.3` works.

---


- Why does custom networking allow name-based communication but the default bridge doesn't?

User-defined bridge networks include Docker's built-in DNS service, which automatically resolves container names to IP addresses. The default bridge network does not provide this DNS-based service discovery, so containers can communicate only through IP addresses unless a custom bridge network is used.

