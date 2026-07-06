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





