## Introduction to Docker


Task 1: What is Docker?
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
