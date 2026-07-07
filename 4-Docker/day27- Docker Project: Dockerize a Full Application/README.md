## Docker Project: Dockerize a Full Application

- A capstone project which combines below topics about Docker:

Dockerfiles, Multi-stage builds, Non-root users, .dockerignore, Docker Compose, Networks, Volumes, Environment variables, Healthchecks, Docker Hub.


#### Task 1: Pick Your App
 - Choose one of these:
 - A Python Flask/Django app with a database
 - A Node.js Express app with MongoDB
 - A static website served by Nginx with a backend API
 - Any app from your GitHub that doesn't have Docker yet


#### python application

- Employee Management System - Python Flask + PostgreSQL
- A Flask web application where users can add employees, view all employees, store employee data in PostgreSQL.
- Docker will create separate containers for: Flask App, PostgreSQL Database.
- Both Containers communicate over a custom Docker network.

                Browser
                   │
                   │ HTTP Request
                   ▼
           Flask Web Application
                   │
                   │
                   ▼
            PostgreSQL Database


- Application flow:

When the application starts-

       Browser
         |
       GET /
         |
       Flask
         |
       SELECT * FROM employees
         |
       PostgreSQL
         |
       Return employee list


When user adds employee-

      Browser
        |
      POST /add
        |
      Flask
        |
      INSERT INTO employees
        |
      PostgreSQL


#### Flask Application: app.py


     from flask import Flask, request, render_template, redirect
     import psycopg2
     import os

     app = Flask(__name__)

     conn = psycopg2.connect(
         host=os.getenv("DB_HOST"),
         database=os.getenv("DB_NAME"),
         user=os.getenv("DB_USER"),
         password=os.getenv("DB_PASSWORD")
     )

     cur = conn.cursor()

     cur.execute("""
     CREATE TABLE IF NOT EXISTS employees(
     id SERIAL PRIMARY KEY,
     name TEXT,
     department TEXT
     )
     """)

    conn.commit()


    @app.route("/")
    def index():
        cur.execute("SELECT * FROM employees")
        employees = cur.fetchall()
        return render_template("index.html", employees=employees)


    @app.route("/add", methods=["POST"])
    def add():
        name = request.form["name"]
        department = request.form["department"]

        cur.execute(
            "INSERT INTO employees(name,department) VALUES(%s,%s)",
        (name, department)
        )
        conn.commit()

        return redirect("/")

     app.run(host="0.0.0.0", port=5000)


requirements.txt:

     Flask
     psycopg2-binary
    
---


#### Task 2: Dockerfile

- Create a Dockerfile for your application
- Use a multi-stage build if applicable
- Use a non-root user
- Keep the image small — use alpine or slim base images
- Add a .dockerignore file.


#### 1. Dockerfile:

      # ---------- Stage 1 : Builder ----------
      FROM python:3.12-slim AS builder

      # Create application directory
      WORKDIR /app

      # Copy dependency file
      COPY requirements.txt .

      # Install dependencies into a separate directory
      RUN pip install --no-cache-dir --prefix=/install -r requirements.txt


      # ---------- Stage 2 : Runtime ----------
      FROM python:3.12-slim

      # Create a non-root user
      RUN useradd -m appuser

      # Set working directory
      WORKDIR /app

     # Copy installed packages from builder stage
     COPY --from=builder /install /usr/local

     # Copy application source code
     COPY . .

     # Change ownership of application files
     RUN chown -R appuser:appuser /app

     # Switch to non-root user
     USER appuser

     # Application port
     EXPOSE 5000

     # Start Flask application
     CMD ["python", "app.py"]


Understanding the dockerfile:
- `FROM python:3.12-slim AS builder` - Uses a lightweight Python image.
- `FROM python:3.12-slim` - Starts with a clean image. Builder tools aren't copied.
- `RUN useradd -m appuser` - Creates a non-root Linux user. More secure than running as root.
- `USER appuser` - Application runs without root privileges.


#### 2. .dockerignore: Prevents unnecessary files from entering the image.

    __pycache__
    *.pyc
    .git
    .env
    README.md


#### 3. Build image:

    docker build -t employee-app:v1 .

#### 4. Test image:

    docker run -p 5000:5000 employee-app:v1
    
    o/p:
    psycopg2.OperationalError: connection to server on socket "/var/run/postgresql/.s.PGSQL.5432" failed: No such file or directory Is the server running locally and accepting connections on that socket?


Understanding the error: Flask application depends on a separate PostgreSQL container.
- This error is expected when we run only the Flask container. Only one container is being started and there is no PostgreSQL container running.
- Since `DB_HOST` is not set, `os.getenv("DB_HOST")` returns `None`. When host is omitted, `psycopg2` tries to connect to a local PostgreSQL Unix socket inside the Flask container; But there is no PostgreSQL server installed or running inside that container so we get operational error.
- code connects to PostgreSQL immediately when the application starts: `conn = psycopg2.connect(...)`. If PostgreSQL takes a few seconds to initialize, Flask will crash before the database is ready.


----


#### Task 3: Add Docker Compose
- Write a docker-compose.yml that includes:
- Your app service (built from Dockerfile)
- A database service (Postgres, MySQL, MongoDB — whatever your app needs)
- Volumes for database persistence
- A custom network
- Environment variables for configuration (use .env file)
- Healthchecks on the database




    


