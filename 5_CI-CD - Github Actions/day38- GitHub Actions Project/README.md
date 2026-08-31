## GitHub Actions Project: End-to-End CI/CD Pipeline

- We've learned workflows, triggers, secrets, Docker builds, reusable workflows, and advanced events.
- Now we put it all together in one project — a complete, production-style CI/CD pipeline that builds, tests, and deploys.


### Task 1: Set Up the Project Repo
- Create a new repo called github-actions-capstone (or use your existing github-actions-practice)
- Add a simple app:
- A Node.js Express app with one endpoint
- Add a Dockerfile and a basic test
- Add a README.md with a project description



#### 1. Github repo and clone:

- create `github-actions-capstone`
- `git clone https://github.com/<your-username>/github-actions-capstone.git`



#### 2. Initialize node.js application:

- `npm init -y`
- `npm install express`
- `mkdir -p src test`


src/server.js:


         const express = require("express");

         const app = express();
         const PORT = process.env.PORT || 3000;

         app.get("/", (req, res) => {
            res.json({
                 message: "GitHub Actions Capstone App",
                 status: "running"
            });
         });

         app.get("/health", (req, res) => {
            res.status(200).json({
                status: "healthy"
            });
         });

         app.listen(PORT, "0.0.0.0", () => {
            console.log(`Server running on port ${PORT}`);
         });


- `const express = require("express"); const app = express();` : This loads Express and creates the web application.
- `app.get("/", (req, res)` : we define two endpoints.
- `app.get("/health", (req, res)` : creates a health-check endpoint.
- `app.listen(PORT, "0.0.0.0",()` :  starts the web server on port 3000.



package.json:


      {
          "name": "github-actions-capstone",
          "version": "1.0.0",
          "description": "End-to-end CI/CD pipeline using GitHub Actions",
          "main": "src/server.js",
          "scripts": {
             "start": "node src/server.js",
             "test": "bash test/health-check.sh"
         },
         "dependencies": {
         "express": "^5.0.0"
         }
      }


#### 3. Test script:

health-check.sh:

         #!/bin/bash

         set -e

         echo "Starting application..."

         node src/server.js &
         APP_PID=$!

         cleanup() {
             kill $APP_PID 2>/dev/null || true
         }

         trap cleanup EXIT

         sleep 2

         echo "Checking health endpoint..."

         response=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3000/health)

         if [ "$response" -eq 200 ]; then
             echo "Health check passed!"
         else
             echo "Health check failed! HTTP status: $response"
             exit 1
         fi


- `response=$(curl -s -o /dev/null` : calls: http://localhost:3000/health; using curl and captures only the HTTP status code.
- `if [ "$response" -eq 200 ];` : checks whether the application returned 200.
- `set -e` : Exit the script immediately if a command fails.
- `$!` is a special Bash variable, PID of the most recently started background process.
- `2>/dev/null` : /dev/null is basically a black hole for output.\

- 1. Stop immediately if an important command fails.
- 2. Start the Node application in the background.
- 3. Remember the Node process ID.
- 4. Define a cleanup function that stops that process.
- 5. Make sure cleanup runs when the script exits.
- 6. Wait for the application to start.
- 7. Call `/health` and check whether it responds successfully.



Run: `npm` test

       Starting application...
       Server running on port 3000
       Checking health endpoint...
       Health check passed!



#### 4. Create Dockerfile:


        FROM node:22-alpine

        WORKDIR /app

        COPY package*.json ./

        RUN npm ci --omit=dev

        COPY src ./src

        EXPOSE 3000

        CMD ["npm", "start"]


- `FROM node:22-alpine`: lightweight Linux image.
- `WORKDIR /app` : creates/sets the working directory.



 .dockerignore:

        node_modules
        npm-debug.log
        .git
        .github
        .env



.gitignore:

       node_modules/
       .env
       npm-debug.log



#### 5. Test the application:

       npm start
       o/p:
       Server running on port 3000
       
       curl http://localhost:3000/
       o/p:
       {
          "message": "GitHub Actions Capstone App",
           "status": "running"
       }


#### 6. Test the Docker image:

      docker build -t github-actions-capstone .
      docker images
      docker run -d -p 3000:3000 --name capstone-app github-actions-capstone
      curl http://localhost:3000/health



---


### Task 2: Reusable Workflow — Build & Test

Create .github/workflows/reusable-build-test.yml:

- Trigger: workflow_call
- Inputs: `node_version`, `run_tests` (boolean, default: true)
- Steps:
   - Check out code
   - Set up the language runtime
   - Install dependencies
   - Run tests (only if `run_tests` is true)
   - Set output: `test_result` with value `passed` or `failed`



         Caller Workflow
              |
              | passes node_version + run_tests
              ↓
         reusable-build-test.yml
              |
              ├── Checkout
              ├── Setup Node.js
              ├── npm install
              └── npm test
