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


 
