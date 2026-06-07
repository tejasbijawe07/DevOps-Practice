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
Run docker image history nginx — what do you see?
Each line is a layer. Note how some layers show sizes and some show 0B
What are layers and why does Docker use them?

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


   
