## Docker Compose: Multi-Container Basics

- Today's goal is to run multi-container applications with a single command.
- Previously we manually created networks and volumes and ran containers one by one. Docker Compose does all of that in one YAML file.


Task 1: Install & Verify
- Check if Docker Compose is available on your machine
- Verify the version

1. Verify docker compose installed:

       docker compose version
       o/p:
       Docker Compose version v5.1.2

2. Verify docker engine and compose:

       docker --version

       docker compose

---

Task 2: Your First Compose File
- Create a folder compose-basics
- Write a docker-compose.yml that runs a single Nginx container with port mapping
- Start it with docker compose up
- Access it in your browser
- Stop it with docker compose down


