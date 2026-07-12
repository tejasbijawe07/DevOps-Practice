## Dockerfile: Build Your Own Images

- A Dockerfile is a text file that contains instructions for building a Docker image automatically.
- Without a dockerfile:

      Start container
             ↓
      Install software manually
             ↓
      Configure things manually
             ↓
      Repeat again for every system

- With a dockerfile:

       Write steps once
             ↓
        Build image
             ↓
       Run anywhere consistently

- Uses:
    - Automation → no manual setup every time
    - Consistency → same environment everywhere
    - Version control → store setup in Git
    - Easy sharing → teammates can build the same image
    - Reproducibility → recreate environments anytime

- Docker performs following steps:
     - Reads Dockerfile: Docker starts reading instructions from top to bottom.
     - Pulls Base Image: Downloads Ubuntu image if not already available.
     - Executes Instructions: Creates a temporary container, runs commands, saves changes.
     - Creates Layers: Each instruction creates a layer
     - Produces an Image
     - Run Container from Image

- Real DevOps usecase:
     - A team wants an app with:
     - Ubuntu, Java, Maven, Application files
     - Instead of manually setting up every server:

           FROM ubuntu
           RUN install java
           RUN install maven
           COPY app.jar .
           CMD run app

     - build and run

           docker build -t app .
           docker run app

---

### Task 1: Your First Dockerfile
 - Create a folder called my-first-image
 - Inside it, create a Dockerfile that:
      - Uses ubuntu as the base image
      - Installs curl
 - Sets a default command to print "Hello from my custom image!"
 - Build the image and tag it my-ubuntu:v1
 - Run a container from your image


#### 1. Creation of folder

        mkdir my-first-image
        cd my-first-image

#### 2. Ceate Dockerfile

       FROM ubuntu:latest
       RUN apt-get update && apt-get install -y curl
       CMD ["echo", "Hello from my custom image!"]

Understanding the Dockerfile:

a. `FROM ubuntu:latest` :
    
  - Tells Docker which base image to start with.
  - downloads and uses latest version of OS image from Docker hub
  - Start building my image on top of Ubuntu.

b. `RUN apt-get update && apt-get install -y curl` :
   
  - apt-get update: Updates Ubuntu package lists.
  - &&: Runs second command only if first succeeds.
  - apt-get install -y curl: Installs curl
  - This custom image contains curl and any container crated from this image can use `curl --version`

c. `CMD ["echo", "Hello from my custom image!"]` :
  
  - Sets the default command when a container starts.
  - Since echo finishes immediately, the container exits.


#### 3. Build the docker image

       docker build -t my-ubuntu:v1 .

Explanation:
 - -t : adds a tag to the image
 - my-ubuntu:v1 : image name and version
 - . : current directory contains Dockerfile

#### 4. Verify image creation

     docker images
     
     o/p:
     IMAGE          ID             DISK USAGE   CONTENT SIZE  
     my-ubuntu:v1   43a4a4c3781c        254MB           77MB

#### 5. Running container from image

      docker run my-ubuntu:v1

      o/p:
      Hello from my custom image!

#### 6. container execution history

      docker ps -a

      o/p:
      CONTAINER ID   IMAGE          COMMAND                  CREATED          STATUS       
      46ec93929bba   my-ubuntu:v1   "echo 'Hello from my…"   11 seconds ago   Exited (0) 10 seconds ago    

---

### Task 2: Dockerfile Instructions
 - Create a new Dockerfile that uses all of these instructions:
 - FROM — base image
 - RUN — execute commands during build
 - COPY — copy files from host to image
 - WORKDIR — set working directory
 - EXPOSE — document the port
 - CMD — default command

#### 1. Create project folder

     mkdir dockerfile-demo
     cd dockerfile-demo

#### 2. create a sample file - message.txt

     echo "Docker learning is fun!" > message.txt

#### 3. create Dockerfile

     FROM ubuntu:latest
     RUN apt-get update && apt-get install -y curl
     WORKDIR /app
     COPY message.txt /app/
     EXPOSE 8080
     CMD ["cat", "/app/message.txt"]

Understanding each instructions:

a. `FROM ubuntu:latest` :
 - Selects Ubuntu as the base image.
 - Docker starts building from this image.

b. `RUN apt-get update && apt-get install -y curl` :
 - Executes commands during image build.
 - Updates package lists.
 - Installs curl inside image.

c. `WORKDIR /app` :
  - Creates /app directory if needed.
  - Sets it as current working directory.
  - Future commands run inside /app.

d. `COPY message.txt /app/` :
  - Copies file from your computer → image filesystem.
  - Host machine -> message.txt -> Docker image -> /app/message.txt

e. `EXPOSE 8080` :
  - Documents that container intends to use port 8080.
  - Does not actually open port.
  - Mainly helps documentation and networking.

f. `CMD ["cat", "/app/message.txt"]` :
  - default command when container starts.
  - Prints contents of copied file.


#### 4. Build Image

      docker build -t docker-demo:v1 .

#### 5. Run container

      docker run docker-demo:v1

#### 6. Image layers: shows how each instruction created a separate image layer.

      docker history docker-demo:v1

---
### Task 3: CMD vs ENTRYPOINT
- Create an image with `CMD ["echo", "hello"]` — run it, then run it with a custom command. What happens?
- Create an image with `ENTRYPOINT ["echo"]` — run it, then run it with additional arguments. What happens?
- Write in your notes: When would you use CMD vs ENTRYPOINT?


#### 1. Using CMD

       FROM ubuntu:latest
       CMD ["echo", "hello"]

       docker build -t cmd-demo:v1 .
       docker run cmd-demo:v1

       o/p:
       hello

Run with custom command:

       docker run cmd-demo:v1 ls

       o/p:
       bin
       boot
       dev
       etc

The custom command (ls) replaced the CMD instruction.

     CMD = default command
    docker run <image> <command>
            ↓
      overrides CMD

#### 2. Using ENTRYPOINT

       FROM ubuntu:latest
       ENTRYPOINT ["echo"]

       docker build -t entrypoint-demo:v1 .
       docker run entrypoint-demo:v1

       o/p:
       blank line because echo runs without arguments

   Run with additional arguments

       docker run entrypoint-demo:v1 hello world

       o/p:
       hello world

    - The arguments were appended to ENTRYPOINT.
    - ENTRYPOINT = fixed executable
    - Arguments passed to docker run are added to it

#### 3. CMD + ENTRYPOINT Together

       FROM ubuntu:latest
       ENTRYPOINT ["echo"]
       CMD ["hello"]

       docker build -t combined-demo:v1 .

       docker run combined-demo:v1
       o/p:
       hello

Run with arguments

       docker run combined-demo:v1 docker
       o/p:
       docker


| Feature                          | CMD                    | ENTRYPOINT                      |
| -------------------------------- | ---------------------- | ------------------------------- |
| Purpose                          | Default command        | Main executable                 |
| Can be overridden?               | Yes                    | No (unless `--entrypoint` used) |
| Arguments passed to `docker run` | Replace CMD            | Append to ENTRYPOINT            |
| Typical use                      | Defaults/configuration | Fixed application               |

- CMD provides a default command that can be easily overridden when starting a container.
- ENTRYPOINT defines the main executable that always runs; arguments supplied during docker run are appended to it.
- Use CMD when:
   - You want a default command.
   - Users may run different commands.
- Use ENTRYPOINT when
   - Container should always run a specific application.
   - You want extra arguments passed to that application.


#### 4. Real-world Nginx example:

Example Dockerfile:

       FROM nginx:latest

       # ENTRYPOINT ensures nginx always runs
       ENTRYPOINT ["nginx"]

       # CMD provides default arguments
       CMD ["-g", "daemon off;"]

 - ENTRYPOINT ["nginx"] : Locks the container to always run the nginx binary.
 - CMD ["-g", "daemon off;"] : Supplies default arguments telling Nginx to run in the foreground.

Run without arguments

        docker run nginx-demo:v1

- Executes: nginx -g 'daemon off;'
- Result: Nginx starts and serves content, staying alive in the foreground


Run with custom arguments

      docker run nginx-demo:v1 -t

- Executes: nginx -t
- Result: Nginx runs its configuration test instead of starting the server.

- Summary:
     - ENTRYPOINT guarantees the container always runs Nginx.
     - CMD provides sensible defaults (daemon off;), but lets you override them at runtime.

---

### Task 4: Build a Simple Web App Image
 - Create a small static HTML file (index.html) with any content
 - Write a Dockerfile that:
      - Uses nginx:alpine as base
      - Copies your index.html to the Nginx web directory
 - Build and tag it my-website:v1
 - Run it with port mapping and access it in your browser


#### 1. Project directory:

     mkdir my-website
     cd my-website

#### 2. Create index.html

      <!DOCTYPE html>
      <html>
      <head>
         <title>My First Docker Website</title>
      </head>
      <body>
         <h1>Hello from Docker and Nginx!</h1>
         <p>This is my first containerized website.</p>
      </body>
      </html>

#### 3. Dockerfile

       FROM nginx:alpine
       COPY index.html /usr/share/nginx/html/index.html

Understanding dockerfile:

 - `FROM nginx:alpine` :
   
     - Uses the official Nginx image.
     - alpine is a lightweight Linux distribution, making the image smaller.
       
 - `COPY` : COPY index.html /usr/share/nginx/html/index.html

     - Copies your local index.html
     - Places it in Nginx's default web root directory

           Host Machine
             index.html
                ↓
           Container
           /usr/share/nginx/html/index.html

#### 4. Build image

         docker build -t my-website:v1 .

#### 5. Run container

        docker run -d -p 8080:80 --name website my-website:v1

  
  - -d - Run in background
  - -p 8080:80 - Host Port : Container Port
  - --name -    Container name(website)

#### 6. verify container

      docker ps

      o/p:
      CONTAINER ID   IMAGE           CREATED          STATUS          PORT                                      NAME
      a78dd1154c69   my-website:v1   22 seconds ago   Up 20 seconds   0.0.0.0:8080->80/tcp, [::]:8080->80/tcp   website

       http://localhost:8080
       Hello from Docker and Nginx!
       This is my first containerized website.

Useful commands:

      docker logs website         (view logs)
      docker stop website         (stop container)
      docker rm website           (remove container)
      docker rmi my-website:v1    (remove image)

---

### Task 5: .dockerignore
 - Create a .dockerignore file in one of your project folders
 - Add entries for: node_modules, .git, *.md, .env
 - Build the image — verify that ignored files are not included


#### What is .dockerignore?
  - A .dockerignore file works like a .gitignore file.
  - It tells Docker: not to send these files/folders to the Docker build context."
  - This:
     - Makes builds faster
     - Reduces image size
     - Prevents secrets from being copied accidentally


#### 1. Create .dockerignore

Inside your project folder:

      touch .dockerignore

Add:

    node_modules
    .git
    *.md
    .env


| Pattern        | Ignored                    |
| -------------- | -------------------------- |
| `node_modules` | Dependency folder          |
| `.git`         | Git repository data        |
| `*.md`         | All Markdown files         |
| `.env`         | Environment variable files |

#### 2. Creating test files

     mkdir node_modules         
     touch README.md
     touch .env
     mkdir .git
     touch app.txt

     Project Structure:
     project/
     ├── Dockerfile
     ├── .dockerignore
     ├── app.txt
     ├── README.md
     ├── .env
     ├── .git/
     └── node_modules/

#### 3. create Dockerfile

     FROM ubuntu:latest
     WORKDIR /app
     COPY . .      (This copies the entire build context except ignored files.)
     CMD ["ls", "-la", "/app"]

#### 4. Build Image and run container

      docker build -t ignore-demo:v1 .
      o/p:
      Sending build context to Docker daemon  3.5kB
      
      docker run --rm ignore-demo:v1
                                               (README.md
      o/p:                                     .env
      total 8                                  .git
      drwxr-xr-x 2 root root 4096 ...          .node_modules   .dockerignore excluded these)
      -rw-r--r-- 1 root root    0 app.txt      

---

### Optimized Dockerfile:

       FROM ubuntu:latest
       RUN apt-get update && apt-get install -y curl
       WORKDIR /app
       COPY app.txt .
       CMD ["cat", "app.txt"]

   - Move frequently changing files to the bottom
   - If app.txt changes, and we build again:

           Step 1/5 : FROM ubuntu
            ---> Using cache

           Step 2/5 : RUN apt-get update
           ---> Using cache

           Step 3/5 : RUN apt-get install -y curl
           ---> Using cache

           Step 4/5 : COPY app.txt
           ---> Rebuilding
   
   - then docker reuses the unchanged layers:
       - FROM          Cached
       - RUN           Cached
       - WORKDIR       Cached
       - COPY          Rebuild
       - CMD           Rebuild


#### 1.Why does layer order matter for build speed?
   - Docker builds images in layers and caches each layer.
   - If a layer changes, Docker must rebuild that layer and all subsequent layers.
   - Therefore:
       - Put rarely changing instructions first.
       - Put expensive operations (apt-get install, npm install, pip install) early.
       - Put frequently changing files (COPY . ., source code) near the end.
   - Layer order matters because Docker reuses cached layers. When a layer changes, all layers after it are rebuilt.
   - Placing stable instructions first and frequently changing files last maximizes cache reuse and significantly improves build performance.

---
