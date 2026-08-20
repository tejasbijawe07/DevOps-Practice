## Docker Build & Push in GitHub Actions

Today we build a complete CI/CD pipeline — code pushed to GitHub automatically builds a Docker image and ships it to Docker Hub.

### Task 1: Prepare
- Use the app you Dockerized on Day 36 (or any simple Dockerfile)
- Add the Dockerfile to your github-actions-practice repo
- Make sure DOCKER_USERNAME and DOCKER_TOKEN secrets are set.


#### 1. Create a simple Flask application 

- app.py:

      from flask import Flask
      app = Flask(__name__)

      @app.route("/")
      def home():
         return "Hello from Flask Docker CI/CD!"

      @app.route("/health")
      def health():
         return "OK"

      if __name__ == "__main__":
         app.run(host="0.0.0.0", port=5000)


- requirements.txt:

      Flask==3.1.2


 #### 2. Dockerfile


         FROM python:3.12-slim

         WORKDIR /app

         COPY requirements.txt .

         RUN pip install --no-cache-dir -r requirements.txt

         COPY app.py .

         EXPOSE 5000

         CMD ["python", "app.py"]


#### Understanding the Dockerfile:

- `FROM python:3.12-slim` :
     - Start with an existing image that already has Python 3.12 installed.
     - slim is a smaller version of the Python image, which helps keep the final Docker image smaller.

- `WORKDIR /app` : Creates/uses `/app` inside the container as the working directory. container looks like:

      /
      └── app/
          ├── app.py
          └── requirements.txt

- `COPY requirements.txt .` : Copies the `requirements.txt` file from GitHub repository into `/app` inside the Docker image.

- `RUN pip install --no-cache-dir -r requirements.txt` :
     - This runs during the Docker image build.
     - It installs Flask and its dependencies.

              requirements.txt
                   ↓
               pip install
                   ↓
              Flask installed inside Docker image
     - --no-cache-dir prevents pip from keeping its download cache, helping reduce image size.

- `COPY app.py .` : Copies your Flask application into the container.

- `EXPOSE 5000` : Documents that the Flask application listens on port 5000. EXPOSE does not publish the port to host machine.

             docker run
                ↓
            python app.py
                ↓
            Flask starts
                ↓
            Application listens on port 5000


---

### Task 2: Build the Docker Image in CI
- Create .github/workflows/docker-publish.yml that:
- Triggers on push to main
- Checks out the code
- Builds the Docker image and tags it
- Verify: Check the build step logs — does the image build successfully?


#### 1. docker-publish.yml:

    name: Docker Build
    on:
      push:
        branches:
          - main

     jobs:
       docker-build:
         runs-on: ubuntu-latest

         steps:
           - name: Checkout repository
             uses: actions/checkout@v4

           - name: Build Docker image
             run: docker build -t flask-app:latest .


#### Understanding the workflow:

      Git push to main
           ↓
     GitHub Actions starts
           ↓
     Ubuntu runner starts
           ↓
     Checkout repository
           ↓
     docker build
           ↓
     Docker image created

- `uses: actions/checkout@v4` :
      - The GitHub-hosted runner initially doesn't have repository files.
      - actions/checkout downloads your repository into the runner.
      - After this step, the runner has:

           app.py
           requirements.txt
           Dockerfile
           .github/

- `run: docker build -t flask-app:latest .` :
      - Build a Docker image.
      - Give the image a name: `flask-app`, and tag: `latest`.


#### 2. Test locally before pushing: 

          docker build -t flask-app:latest .
          docker images
          
          o/p:
          REPOSITORY    TAG       IMAGE ID 
          flask-app     latest    abc123...
          
          docker run -p 5000:5000 flask-app:latest

          http://localhost:5000
          o/p:
          Hello from Flask Docker CI/CD!
          
          http://localhost:5000/health
          o/p:
          OK


#### 3. Push files to github:

         git add app.py requirements.txt Dockerfile .github/workflows/docker-publish.yml
         git commit -m "Add Docker build CI workflow"
         git push origin main


- Docker Build: ✓ Checkout repository ✓ Build Docker image
- CI/CD pipeline:

         Developer
           │
           │ git push
           ▼
         GitHub
           │
           ▼
        GitHub Actions
           │
           ├── Checkout code
           │
           ├── Build Docker image
           │
           ▼
        Docker image
        flask-app:latest


---

### Task 3: Push to Docker Hub
- Add steps to:
- Log in to Docker Hub using your secrets
- Tag the image as username/repo:latest and also username/repo:sha-<short-commit-hash>
- Push both tags
- Verify: Go to Docker Hub — is your image there with both tags?


#### 1. Create Docker hub secrets in Github:
DOCKER_USERNAME and DOCKER_TOKEN.


#### 2. Update docker-publish.yml:

      name: Docker Build and Push

      on:
        push:
          branches:
            - main

      jobs:
        docker-build-push:
           runs-on: ubuntu-latest

           steps:
             - name: Checkout repository
               uses: actions/checkout@v4

             - name: Log in to Docker Hub
               uses: docker/login-action@v3
               with:
                 username: ${{ secrets.DOCKER_USERNAME }}
                 password: ${{ secrets.DOCKER_TOKEN }}

             - name: Build Docker image
               run: docker build -t flask-app:latest .

             - name: Create Docker tags
               run: |
                 SHORT_SHA=$(git rev-parse --short HEAD)

                 docker tag flask-app:latest \
                   ${{ secrets.DOCKER_USERNAME }}/flask-app:latest

                 docker tag flask-app:latest \
                   ${{ secrets.DOCKER_USERNAME }}/flask-app:sha-$SHORT_SHA

            - name: Push Docker images
              run: |
                SHORT_SHA=$(git rev-parse --short HEAD)

                docker push ${{ secrets.DOCKER_USERNAME }}/flask-app:latest
                docker push ${{ secrets.DOCKER_USERNAME }}/flask-app:sha-$SHORT_SHA


#### Understanding the yaml file:

-  `SHORT_SHA=$(git rev-parse --short HEAD)` :
       - gets the short Git commit SHA.
       - For example, commit might have:

              a1b2c3d4e5f67890...
              The short version becomes:
              a1b2c3d

- `docker tag flask-app:latest \
  ${{ secrets.DOCKER_USERNAME }}/flask-app:sha-$SHORT_SHA` :
      - tejas123/flask-app:sha-a1b2c3d
      - username/flask-app:latest ; username/flask-app:sha-a1b2c3d


#### Why use both tags?
- latest: This is convenient for users who simply want the newest version:

        docker pull username/flask-app:latest

- sha-a1b2c3d: This gives you an immutable reference to a particular Git commit.

        sha-a1b2c3d

- This is better for deployments because we know exactly which source code produced the image.


---

### Automated CI/CD pipeline:

          GitHub
           │
           │ push to main
           ▼
          GitHub Actions
           │
           ├── Checkout
           ├── Docker login
           ├── Docker build
           ├── Tag :latest
           ├── Tag :sha-xxxxxxx
           ├── Push :latest
           └── Push :sha-xxxxxxx
                     │
                     ▼
                  Docker Hub


- When code is pushed to the main branch, GitHub Actions checks out the source code and builds a Docker image using the Dockerfile.
- The workflow authenticates with Docker Hub using GitHub Secrets, tags the image with both latest and a commit-specific SHA tag, and pushes both tags to Docker Hub.
- A deployment machine can then pull the required image and run it as a container. The commit SHA tag provides traceability because we can identify exactly which Git commit produced the running image.

---
