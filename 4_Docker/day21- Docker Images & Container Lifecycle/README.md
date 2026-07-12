## Docker Images & Container Lifecycle

### Task 1: Docker Images
- Pull the nginx, ubuntu, and alpine images from Docker Hub
- List all images on your machine — note the sizes
- Compare ubuntu vs alpine — why is one much smaller?
- Inspect an image — what information can you see?
- Remove an image you no longer need


1. Pull images from docker hub

       docker pull nginx
       docker pull ubuntu
       docker pull alpine

2. List all images and check sizes

       docker images

       o/p:
       IMAGE               ID              DISK USAGE   CONTENT SIZE
       alpine:latest       5b10f432ef3d    13.1MB         3.95MB
       nginx:latest        5aca99593157    241MB           66MB
       ubuntu:latest       f3d28607ddd7    160MB         45.3MB

3. Ubuntu vs Alpine

| Ubuntu                             | Alpine                           |
| ---------------------------------- | -------------------------------- |
| General-purpose Linux distribution | Minimal Linux distribution       |
| Includes many packages/tools       | Includes only essential packages |
| Larger filesystem                  | Very small filesystem            |
| Easier for beginners               | Optimized for containers         |
| ~80MB+ image size                  | ~5–10MB image size               |


4. Inspect an image

       docker inspect nginx

5. Remove an Image

       docker rmi ubuntu

 If image is used by a container:
   - Error response from daemon:
   - image is being used by stopped container

   - Remove container first:

         docker ps -a
         docker rm <container_id>
         docker rmi alpine

---

### Task 2: Image Layers
 - Run docker image history nginx — what do you see?
 - Each line is a layer. Note how some layers show sizes and some show 0B
 - What are layers and why does Docker use them?

1. view image history

       docker image history nginx

    - Layer ids
    - Commands used to create layers
    - Layer sizes
    - Creation timestamps
  
    - Layers showing 0B usually come from instructions that change metadata rather than filesystem contents.

2. What are docker layers

  - Layers are read-only filesystem changes stacked on top of each other to create a complete Docker image.
  - Each Docker instruction usually creates a new layer.

        Dockerfile:
    
        FROM ubuntu
        RUN apt update
        RUN apt install nginx
        COPY app /
        CMD ["nginx"]


3. Why docker uses Layers?

 a) Faster Builds - Docker reuses unchanged layers.

 b) Saves Storage - Multiple images share common layers.

 c) Faster Downloads - Only missing layers are downloaded.

 d) Better Caching - Build process skips unchanged layers.

Layers Summary:
 - Docker images are built from multiple layers
 - Each instruction often creates a new layer
 - 0B layers usually represent metadata changes
 - Layers improve speed, caching, storage efficiency, and reusability
 - Containers add a writable layer above image layers

---

### Task 3: Container Lifecycle
 
 Practice the full lifecycle on one container:
 - Create a container (without starting it)
 - Start the container
 - Pause it and check status
 - Stop it, Restart it, Kill it, Remove it.


1. Create a container: creates but does not start it.

       docker create --name lifecycle-demo ubuntu

       Verify:
       docker ps -a

       o/p:
       CONTAINER ID   IMAGE     COMMAND       CREATED         STATUS    NAMES
       10f56425fd1e   ubuntu    "/bin/bash"   9 seconds ago   Created   lifecycle-demo


2. Start the container: Container runs while its main process runs; Main process exits → Container exits

       docker start lifecycle-demo

       Verify:
       docker ps

       o/p:
       CONTAINER ID   IMAGE     COMMAND       CREATED          STATUS                      NAMES
       10f56425fd1e   ubuntu    "/bin/bash"   48 seconds ago   Exited (0) 19 seconds ago   lifecycle-demo

- After using above command to start container the status still shows as Exited(0).
- This happens because container was created from Ubuntu image with default command:  /bin/bash
- Docker starts /bin/bash, but since there is no interactive terminal attached, bash immediately exits.
- Once the main process exits, the container stops too.
- `Exited (0)` means:
      - Process finished normally (0 = success)
      - Container stopped because its main process ended

- To start container interactively:

        docker create -it --name lifecycle-demo ubuntu
        docker start -ai lifecycle-demo

       [-a → attach output
       -i → interactive input
       This attaches to bash].

       docker start lifecycle-demo

       Verify:
       docker ps -a ... (Now it will start container)

3. Pause the container: Freezes container processes without stopping the container.

       docker pause lifecycle-demo

       o/p:
       CONTAINER ID   IMAGE     COMMAND       CREATED         STATUS                         NAMES
       07eb37cf654e   ubuntu    "/bin/bash"   2 minutes ago   Up About a minute (Paused)     lifecycle-demo


4. Unpause the container

       docker unpause lifecycle-demo

       o/p:
       Up about a minute

5. Stop the container: Gracefully shutdown

       docker stop lifecycle-demo

       o/p:
       Exited(137)

6. Restart the container

       docker restart lifecycle-demo

       o/p:
        Up 2 seconds

7. Kill the container: immediate termination

       docker kill lifecycle-demo

8. Remove the container

       docker rm lifecycle-demo

---

### Task 4: Working with Running Containers
- Run an Nginx container in detached mode and view its logs
- View real-time logs (follow mode)
- Exec into the container and look around the filesystem
- Run a single command inside the container without entering it
- Inspect the container — find its IP address, port mappings, and mounts


1. Run Nginx Container in Detached Mode

Start container in background:

    docker run -d --name nginx-demo -p 8080:80 nginx

    docker ps -a
    Status: Up
    Ports: 0.0.0.0:8080->80/tcp

- -d → Detached Mode : Runs the container in the background.
- -p → Port Mapping : -p 8080:80
- Maps - Host Port : Container Port
    - Meaning:
    - 80 → Nginx listens inside container
    - 8080 → Port exposed on your machine


2. View container logs

       docker logs nginx-demo

Logs shows:
   - Nginx startup messages
   - Access logs
   - Error logs

3. View real-time logs

       docker logs -f nginx-demo

4. Exec Into Container and Explore Filesystem

   Open shell inside running container:

       docker exec -it nginx-demo sh

    can run commands like:

        pwd
        ls
       cd /usr
       cat index.html

5. Run a single command without entering container

       docker exec nginx-demo ls /usr

6. Inspect container

       docker inspect nginx-demo

   Find IP address:

       docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' nginx-demo

   Find port mappings:

       docker port nginx-demo

   Find Mounts:

       docker inspect -f '{{json .Mounts}}' nginx-demo

---

Task 5: Cleanup
 - Stop all running containers in one command
 - Remove all stopped containers in one command
 - Remove unused images
 - Check how much disk space Docker is using


1. Stop all containers

       docker stop $(docker ps -q)

2.Remove all stopped containers

      docker container prune

3. Remove unused images

       docker image prune -a

4. Check disk space usage by docker

       docker system df

       o/p:
       TYPE            TOTAL   ACTIVE   SIZE
       Images          3       2        1.2GB
       Containers      3       1        200MB
       Volumes         2       1        500MB
       Build Cache              300MB


| Command                       | Result                         |
| ----------------------------- | ------------------------------ |
| `docker ps`                   | No running containers          |
| `docker ps -a`                | Shows stopped nginx container  |
| `docker stop $(docker ps -q)` | Successfully stopped container |
