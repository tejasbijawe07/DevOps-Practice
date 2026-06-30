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

#### 1. updating `postgres` service in `docker-compose.yml`:

       postgres:
          image: postgres:17
          container_name: postgres-db

          environment:
            POSTGRES_USER: admin
            POSTGRES_PASSWORD: password
            POSTGRES_DB: mydb

          healthcheck:
            test: ["CMD-SHELL", "pg_isready -U admin -d mydb"]
            interval: 10s
            timeout: 5s
            retries: 5
            start_period: 10s

          restart: always


Understanding healthcheck command:

- `pg_isready` : A PostgreSQL utility that returns success only when the database is ready.
- `interval: 10s` : Check every 10 seconds.
- `timeout: 5s` : wait up to 5 seconds for each check.
- `start_period: 10s` : Mark the container as unhealthy after 5 failed checks.
- `start_period: 10s` : Allow PostgreSQL 10 seconds to initialize before failures count.


#### 2. updating the `app` service:

       depends_on:
         postgres:
            condition: service_healthy
         redis:
            condition: service_started


#### Observe the logs:
- PostgreSQL starts first.
- Docker waits until the healthcheck passes.
- Only then does the Flask app start.


---

#### Task 3: Restart Policies
- Add restart: always to your database service
- Manually kill the database container — does it come back?
- Try restart: on-failure — how is it different?


- `restart: always` : If the container stops for any reason (including Docker daemon restart or host reboot), Docker attempts to start it again.
- `restart: on-failure` : Docker restarts the container only if it exits with a non-zero exit code (indicating an error).



| Policy           | Restarts after crash | Restarts after `docker stop`                                 | Restarts after Docker daemon reboot |
| ---------------- | -------------------- | ------------------------------------------------------------ | ----------------------------------- |
| `no` (default)   | ❌                    | ❌                                                            | ❌                                   |
| `on-failure`     | ✅                    | ❌                                                            | ❌                                   |
| `always`         | ✅                    | ✅ (unless explicitly stopped and daemon behavior intervenes) | ✅                                   |
| `unless-stopped` | ✅                    | ❌ (stays stopped until manually started)                     | ✅                                   |


#### When to use each
- always: Databases, message brokers, and production services that should stay available.
- on-failure: Batch jobs or applications where you want retries only after unexpected crashes.
- unless-stopped: Long-running services that should survive reboots but respect an administrator's manual stop.

---


#### Task 4: Custom Dockerfiles in Compose

    app:
     build: ./app

This instructs Docker Compose to build the image from app/Dockerfile instead of pulling a pre-built image.

---

#### Task 5: Named Networks & Volumes

- Define explicit networks in your compose file instead of relying on the default.
- Define named volumes for database data.
- Add labels to your services for better organization.


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
            postgres:
              condition: service_healthy
            redis:
              condition: service_started

         networks:
           - backend

         labels:
           project: docker-compose-demo
           tier: frontend

      postgres:
        image: postgres:17

        container_name: postgres-db

         restart: always

        environment:
          POSTGRES_USER: admin
          POSTGRES_PASSWORD: password
          POSTGRES_DB: mydb

      volumes:
        - postgres_data:/var/lib/postgresql/data

      networks:
        - backend

      labels:
        project: docker-compose-demo
        tier: database

      healthcheck:
        test: ["CMD-SHELL","pg_isready -U admin -d mydb"]
        interval: 10s
        timeout: 5s
        retries: 5

      redis:
        image: redis:8

        container_name: redis-cache

      networks:
        - backend

      labels:
        project: docker-compose-demo
        tier: cache

      networks:
       backend:

      volumes:
        postgres_data:


- Named Network:

      networks:
        backend:


Creates a custom bridge network named backend. All services attached to it can communicate using their service names (postgres, redis, app). Using explicit networks improves organization and allows you to connect or isolate services intentionally.


- Named Volume:

      volumes:
        postgres_data:

Stores PostgreSQL data outside the container. If you remove and recreate the database container, the data remains in the named volume.


Summary:

- Building custom images with a `Dockerfile`
- Managing multiple services with `docker-compose.yml`
- Using `depends_on` with health checks for reliable startup sequencing.
- Applying restart policies.
- Rebuilding images efficiently with `build:`
- Creating custom networks for service communication.
- Persisting database data with named volumes.

---

#### Task 6: Scaling (Bonus)
- Try scaling your web app to 3 replicas using docker compose up --scale
- What happens? What breaks?
- Write in your notes: Why doesn't simple scaling work with port mapping?


#### Scale application:

       docker compose up -d --scale app=3

- Docker tries to create:
     
      app-1
      app-2
      app-3

- #### Limitations:

 #### 1. docker-compose.yml likely contains:

         services:
           app:
             build: ./app
             container_name: flask-app

   - Every app container is named flask-app.
   - Docker tries to create containers with same name.
   - Remove container name and docker will automatically generate unique names.


#### 2. compose file contains ports: - "5000:5000"

     ports:
       - "5000:5000"

      o/p:
      Bind for 0.0.0.0:5000 failed:
      port is already allocated

 - This is because all three containers are trying to publish host port 5000.
 - The host machine has only one port 5000.
 - only one container can bind to it.
 - second and third container fails.


#### How to scale?

1. Reverse proxy:
   - Nginx
   - HAProxy
   - Architecture:

                Browser
                   │
                   ▼
                  Nginx
                    │
          ┌─────────┼─────────┐
          ▼         ▼         ▼
         App-1     App-2     App-3

   - only nginx exposes: `localhost:80`
   - Internally it distributes traffic to: app-1, app-2, app-3, which is called load balancing.


#### 1. What is scaling?

Scaling means running multiple instances (replicas) of the same application to handle more traffic, improve availability, or increase fault tolerance.


#### 2. Why doesn't simple scaling work with port mapping?

- When a service publishes a host port using:

      ports:
       - "5000:5000"

- every replica tries to bind the same host port (5000). Since a host port can be owned by only one process or container at a time, additional replicas fail with a port already allocated error.


#### 3. How is scaling usually done?

- In production, application containers typically do not publish ports directly. Instead:
     - Multiple application replicas run on an internal Docker network.
     - A reverse proxy or load balancer (such as Nginx) exposes a single public port (for example, 80 or 443).
     - The proxy distributes incoming requests across the replicas.

- This avoids host port conflicts and allows the application to scale horizontally

---
