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
          SQLAlchemy Database Driver
                   │
                   ▼
            PostgreSQL Database


---

#### Task 2: Dockerfile

- Create a Dockerfile for your application
- Use a multi-stage build if applicable
- Use a non-root user
- Keep the image small — use alpine or slim base images
- Add a .dockerignore file
Build and test it locally.



