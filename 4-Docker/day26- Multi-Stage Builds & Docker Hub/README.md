## Multi-Stage Builds & Docker Hub
- Today's goal is to build optimized images.
- Multi-stage builds are how real teams ship small, secure images. Docker Hub is how we distribute them.



Task 1: The Problem with Large Images
- Write a simple Go, Java, or Node.js app (even a "Hello World" is fine)
- Create a Dockerfile that builds and runs it in a single stage
- Build the image and check its size.


#### 1. create a project and app.js

      mkdir single-stage
      cd single-stage

create app.js-

    console.log("Hello from Docker!");

create package.json-

    {
     "name": "hello-node",
     "version": "1.0.0",
     "main": "app.js",
     "scripts": {
      "start": "node app.js"
     }
    }

#### 2. create a single stage dockerfile-

     FROM node:22
     WORKDIR /app
     COPY package*.json ./
     RUN npm install
     COPY . .
     CMD ["npm", "start"]


Understading Dockerfile:

- `FROM node:22` - Starts the image using the official Node.js image.
        - This image already has: Linux OS, Node.js runtime, npm installed.
        - Instead of installing Node.js manually every time, Docker starts from a prebuilt base image.


- `WORKDIR /app` - Creates the /app directory inside the container (if it doesn't exist) and makes it the current working directory.


- `COPY package*.json ./` - Copies files matching: package.json, package-lock.json from your computer into /app inside the image.


- Why we copy these first?
     - Docker caches layers.
     - If only app.js changes, Docker can reuse the cached dependency installation layer instead of reinstalling packages.
     - This makes rebuilds much faster.

- `CMD ["npm", "start"]` - Defines the default command that runs when a container starts, which executes the "start" script from package.json.


#### 3. Build the image-

      docker build -t node-single .


- `docker build` - tells docker to create an image from Dockerfile.
- `-t` - adds a tag(name) to image. 
- `.` - use the current directory as build context.


#### 4. Run the container-

       docker run --rm node-single
       o/p:
       > hello-node@1.0.0 start
       > node app.js
       Hello from Docker!

- `--rm` - automatically removes the container after it stops.


#### 5. check image size

      docker images
      o/p:
      node-single:latest        f868aa39afef       1.63GB          409MB

#### why is it so large?

The final image contains: Base Node image, npm, npm cache, package manager, development files, source code, build layers.


---

#### Task 2: Multi-Stage Build
 - Rewrite the Dockerfile using multi-stage build:
 - Stage 1: Build the app (install dependencies, compile)
 - Stage 2: Copy only the built artifact into a minimal base image (alpine, distroless, or scratch)
 - Build the image and check its size again
 - Compare the two sizes


#### 1. app.json

    console.log("Hello from Docker Multi-Stage Build!");

#### 2. package.json

    {
    "name": "hello-node",
    "version": "1.0.0",
    "main": "app.js",
    "scripts": {
      "start": "node app.js"
     }
    }


#### 3. Multi-Stage Dockerfile

     # ---------- Stage 1 : Build ----------
     FROM node:22 AS builder
     WORKDIR /app
     COPY package*.json ./
     RUN npm install
     COPY . .

     # ---------- Stage 2 : Runtime ----------
     FROM node:22-alpine
     WORKDIR /app
     COPY --from=builder /app .
     CMD ["npm", "start"]


Understanding Dockerfile:

- `FROM node:22 AS builder` :
       - Starts the first build stage using the full Node.js image.
       - The name builder is just a label.
       - Install packages
       - Compile code (if needed)
       - Perform build tasks
       - This stage is not included in the final image.

- `WORKDIR /app` : Creates and switches to /app.
- `COPY . .` : copies remaining file to /app.


- `FROM node:22-alpine` :
        - This starts a new image.
        - Everything from Stage 1 is discarded unless you explicitly copy it.
        - `node:22-alpine` is much smaller because it is based on Alpine Linux.
- `WORKDIR /app` : Creates the working directory inside the new image. This is a completely fresh image. Nothing from Stage 1 exists yet.
- `COPY --from=builder /app .` : Copy files from the stage named builder into this image.

          Source
             Builder Stage
             /app

          Destination
             Runtime Stage
             /app

          Without this line, the runtime image would be empty.

- `CMD ["npm", "start"]` : when container runs, docker automatically executes `npm start`, which runs `node app.js`.



#### Build the image:

      docker build -t hello-node-multi .

      docker images
      o/p:
      IMAGE                          ID             DISK USAGE   CONTENT SIZE
      hello-node-multi:latest        e524556525d6        230MB         57.4MB
      node-single:latest             f868aa39afef       1.63GB          409MB


#### run the container:


     docker run --rm hello-node-multi
     
     o/p:
     > hello-node@1.0.0 start
     > node app.js

     Hello from Docker Multi-Stage Build!


#### Why is multi-stageimage smaller?
- There are two reasons:
        - Only the runtime environment is kept. The build stage is temporary and is discarded after the build completes.
        - The runtime uses a minimal base image (`node:22-alpine`) instead of the larger full Linux-based Node.js image.


---

#### Task 3: Push to Docker Hub
- Create a free account on DockerHub
- Log in from your terminal
- Tag your image properly: yourusername/image-name:tag
- Push it to Docker Hub
- Pull it on a different machine (or after removing locally) to verify.


#### 1. Login from Terminal

    docker login

    verify login
    docker info

    
#### 2. local image

    docker images

    REPOSITORY          TAG       IMAGE ID 
    hello-node-multi    latest    abc12345       


#### 3. Tag the image

- dockerhub expects image name in format:

       dockerhub-username/repository:tag

- Syntax:

      docker tag <local-image> <dockerhub-username>/<repository>:<tag>
      docker tag hello-node-multi tejas123/hello-node-multi:1.0

- verify:

      docker images

      o/p:
      REPOSITORY                           TAG                 IMAGE ID
      hello-node-multi:latest              e524556525d6        230MB
      tejasdevops07/hello-node-multi:1.0   e524556525d6        230MB

Both entries have the same IMAGE ID. Tagging doesn't create another image.

  
#### 4. Push the image

    docker push tejasdevops07/hello-node-multi:1.0

    Docker uploads each image layer.
    The push refers to repository [docker.io/tejasdevops07/hello-node-multi]
    d10ff586f6bd: Pushed
    84f3f648e286: Pushed
    55afa1ecc21d: Pushed


#### 5. verify by pulling image

- Remove local image:

      docker rmi tejasdevops07/hello-node-multi:1.0

- Pull the image:

      docker pull tejasdevops07/hello-node-multi:1.0
      o/p:
      1.0: Pulling from tejas123/hello-node
      Downloaded newer image


---

    
