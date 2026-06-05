## Introduction to Docker


### Task 1: What is Docker?
- What is a container and why do we need them?
- Containers vs Virtual Machines — what's the difference?
- What is the Docker architecture? (daemon, client, images, containers, registry)
- Describe the Docker architecture.


## 1. What is Docker?

Docker is an open-source platform used to build, package, ship, and run applications inside containers.

It helps developers:
- Build once, run anywhere
- Maintain consistent environments
- Deploy applications faster
- Reduce dependency issues


## 2. What is a Container and Why Do We Need Them?

A container is a lightweight package that includes:

- Application code
- Runtime
- Libraries
- Dependencies
- Configuration files

Why containers are needed:

- Consistent environments across systems
- Faster deployment
- Lightweight compared to VMs
- Easy scaling and portability
- Eliminates "works on my machine" problems


## 3. Containers vs Virtual Machines

| Feature | Containers | Virtual Machines |
|--------|--------|--------|
| Virtualization Type | OS-level | Hardware-level |
| Startup Time | Seconds | Minutes |
| Size | Lightweight (MBs) | Heavy (GBs) |
| Resource Usage | Low | High |
| OS Included | Shares host OS kernel | Includes full guest OS |
| Performance | Near native | More overhead |
| Isolation | Process-level | Full OS isolation |

### Real Difference:
- Containers share the host operating system kernel, making them faster and lighter,
- while VMs run complete operating systems, on top of hypervisor making them heavier but more isolated.


## 4. Docker Architecture

Docker follows a client-server architecture consisting of multiple components working together.


### 1. Docker Client
- The interface users interact with.
- Commands like `docker build`, `docker run`, and `docker pull` are executed from here.
- Sends requests to Docker Daemon.

Example:

     docker run nginx
     
### 2. Docker Daemon (dockerd)
- Background service running on the host machine.
- Responsible for:
     - Building images
     - Creating and managing containers
     - Managing networks and volumes
     - Communicating with registries

### 3. Docker Images
- Read-only templates used to create containers
- Contain application code, dependencies, and instructions.

Example:

      docker pull ubuntu
      
### 4. Docker Containers
- Running instances of images
- Isolated processes sharing the host OS kernel.

Example:

     docker run -it ubuntu bash
     
### 5. Docker Registry
- Stores Docker images
- Can be public or private.

Common registries:
- Public: Docker Hub
- Private: Organization-hosted registries

Flow:

      Developer
          ↓
     Docker Client
          ↓
     Docker Daemon
          ↓
     Build/Pull Images
          ↓
     Create Containers
          ↓
     Run Applications


## 5. Docker Architecture Diagram

             +-------------------+
             |   Docker Client   |
             | docker commands   |
             +---------+---------+
                       |
                       v
             +-------------------+
             |  Docker Daemon    |
             |   (dockerd)       |
             +----+---------+----+
                  |         |
          builds images   runs containers
                  |         |
                  v         v
           +----------+  +----------+
           | Images   |  |Containers|
           +----------+  +----------+
                  |
                  v
           +---------------+
           | Docker Hub /  |
           | Registry      |
           +---------------+

---

### Task 2: Install Docker
 - Install Docker on your machine
 - Verify the installation
 - Run the hello-world container
 - Read the output carefully — it explains what just happened

1. check docker version

       docker --version

       o/p:
       Docker version 29.4.0, build 9d7ad9f

2. verify docker

       docker info

       o/p:
       Client:
       Server:
       Containers:
       Images:
   
       This checks:
       Docker daemon is running
       Client and server communication works
       System resources available for Docker

3. Run container

       docker run hello-world

       o/p:
       Unable to find image 'hello-world:latest' locally
       latest: Pulling from library/hello-world
       ...
       Hello from Docker!
       This message shows that your installation appears to be working correctly.

4. Understanding the o/p

    When we run `docker run hello-world` :

    - 1: Docker client sent request to Docker daemon
    - 2: Docker checked if hello-world image exists locally
    - 3: Since image was absent, Docker pulled it from Docker Hub
    - 4: Docker created a new container from that image
    - 5: Container executed its program and printed the message
    - 6: Container stopped after completing execution

5. Verify container creation

       docker ps -a

       o/p:
       CONTAINER ID    IMAGE          STATUS
       8d9d6b8486c1    hello-world    Exited (0)

---

### Task 3: Run Containers
 - Run an Nginx container and access it in your browser
 - Run an Ubuntu container in interactive mode — explore it like a mini Linux machine
 - List all running containers
 - List all containers (including stopped ones)
 - Stop and remove a container


1. Run an Nginx container

 - Start an Nginx container and map port 80 inside container to port 8080:

       docker run -d --name my-nginx -p 8080:80 nginx

   Explanation:
      - -d → Run in detached/background mode
      - --name my-nginx → Give container a custom name
      - -p 8080:80 → Maps host port 8080 → container port 80
      - nginx → Image name

 - Verify container is running:

        docker ps
        http://localhost:8080   (on browser)

2. Run an Ubuntu Container in Interactive Mode

 - Start Ubuntu container

        docker run -it --name my-ubuntu ubuntu bash

   Explaination:
     - -i → Interactive mode
     - -t → Terminal access
     - bash → Opens bash shell inside container

 - we can run linux commands and `exit` will stop the container.

3. List all running containers

       docker ps

       o/p:
       CONTAINER ID    IMAGE    STATUS
       1bcba682e7df    nginx    Up 2 mins

   - Shows only active containers
  
4. List All Containers (Including Stopped)

       docker ps -a

       o/p:
       CONTAINER ID      IMAGE      STATUS
       13564c452417      ubuntu     Exited (0)
       1bcba682e7df      nginx      Up 5 mins

   - Shows both running and stopped containers.
  
5. Stop a container

       docker stop my-nginx

6. Remove a container

       docker rm my-nginx

---
