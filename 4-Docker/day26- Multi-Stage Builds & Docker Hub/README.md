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

#### 4. Run the container-

       docker run --rm node-single
       o/p:
       > hello-node@1.0.0 start
       > node app.js
       Hello from Docker!

#### 5. check image size

      docker images
      o/p:
      node-single:latest        f868aa39afef       1.63GB          409MB

#### why is it so large?

The final image contains: Base Node image, npm, npm cache, package manager, development files, source code, build layers.
