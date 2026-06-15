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
