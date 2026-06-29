## Docker Compose: Real-World Multi-Container App


#### Task 1: Build Your Own App Stack
- Create a docker-compose.yml for a 3-service stack:
- A web app (use Python Flask, Node.js, or any language you know)
- A database (Postgres or MySQL)
- A cache (Redis)
- Write a simple Dockerfile for the web app.


#### 1. Flask Application:

- app.py

        from flask import Flask
        import os

        app = Flask(__name__)

        @app.route("/")
        def home():
            return f"""
            Docker Compose Demo

            Database Host : {os.getenv('DB_HOST')}

            Redis Host : {os.getenv('REDIS_HOST')}
            """

         if __name__ == "__main__":
             app.run(host="0.0.0.0", port=5000)


This application simply prints database and Redis host names that Docker Compose provides through environment variables.


- requirements.txt

       flask            ...         Web framework
       psycopg2-binary	...         PostgreSQL client
       redis	          ...         Redis client


#### 2. Dockerfile

     FROM python:3.12-slim
     WORKDIR /app
     COPY requirements.txt .
     RUN pip install --no-cache-dir -r requirements.txt
     COPY . .
     EXPOSE 5000
     CMD ["python","app.py"]

Understanding the dockerfile-

- `FROM python:3.12-slim` - Instead of installing Python manually, Docker downloads a lightweight Linux image with Python already installed.
- `WORKDIR /app` - Creates the directory /app.
- `COPY requirements.txt .` - Copies only requirements.txt first.
- `RUN pip install ` - Installs flask, postgreSQL client, Redis client.
- `COPY ..` - copies remaining application files.
- `EXPOSE 5000` - documents that container listens on port 5000.


#### 3. docker-compose.yml

    version: "3.9"

    services:

      app:
         build: ./app
         container_name: flask-app

         ports:
           - "5000:5000"

         environment:
           DB_HOST: postgres
           REDIS_HOST: redis

         depends_on:
           - postgres
           - redis

      postgres:
           image: postgres:17

           container_name: postgres-db

           environment:
             POSTGRES_USER: admin
             POSTGRES_PASSWORD: password
             POSTGRES_DB: mydb

      redis:
           image: redis:8
           container_name: redis-cache

Understanding compose file-

- `services` - Everything under services becomes a container. app, postgres, redis.
- `build: ./app` - Instead of pulling an image, Docker builds it using: app/Dockerfile.
- `ports` - 5000:5000 ; host -> container.  (flask inside container).
- `environment` - DB_HOST=postgres.  (Docker automatically creates DNS entries.)
- `depends_on:` - Compose starts these containers before the app. It only waits until containers start—not until PostgreSQL is ready.


#### 4. Run containers

     docker compose up -d

     docker ps -a

     http://localhost:5000
     o/p:
     Docker Compose Demo
     Database Host : postgres
     Redis Host : redis

---

#### Task2: depends_on & Healthchecks
- Add depends_on to your compose file so the app starts after the database
- Add a healthcheck on the database service
- Use depends_on with condition: service_healthy so the app waits for the database to be truly ready, not just started
- Test: Bring everything down and up — does the app wait for the DB?


The problem with normal depends_on is that it waits only until the database container starts, not until PostgreSQL is actually ready to accept connections.

