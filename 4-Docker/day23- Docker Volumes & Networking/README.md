## Docker Volumes & Networking


#### Task 1: The Problem
- Run a Postgres or MySQL container
- Create some data inside it (a table, a few rows)
- Stop and remove the container
- Run a new one — is your data still there?

#### 1. Run a PostgreSQL container

    docker run -d --name postgres-demo -e POSTGRES_PASSWORD=password postgres

Understanding the command:

| Option                          | Meaning                                          |
| ------------------------------- | ------------------------------------------------ |
| `docker run`                    | Creates and starts a new container               |
| `-d`                            | Runs container in background (detached mode)     |
| `--name postgres-demo`          | Gives container a custom name                    |
| `-e POSTGRES_PASSWORD=password` | Sets environment variable required by PostgreSQL |
| `postgres`                      | Uses the official PostgreSQL image               |


#### 2. Connect to PostgreSQL

    docker exec -it postgres-demo psql -U postgres

Understanding the command:

| Option          | Meaning                                  |
| --------------- | ---------------------------------------- |
| `docker exec`   | Run a command inside a running container |
| `-it`           | Interactive terminal                     |
| `postgres-demo` | Container name                           |
| `psql`          | PostgreSQL command-line client           |
| `-U postgres`   | Login as postgres user                   |


#### 3. Creating sql data

Inside PostgreSQL:

     CREATE TABLE employees (
       id SERIAL PRIMARY KEY,
       name VARCHAR(50)
     );

     INSERT INTO employees (name)
     VALUES ('Volumes');

     SELECT * FROM employees;

     o/p:
      id | name
     ----+-------
      1  | Volumes

Useful sql commands inside container:
- `\dt` - Show all tables
- `\d employees` - Describe a table
- `\q` - Exit PostgreSQL
-  `docker exec -it postgres-demo psql -U postgres -c "CREATE TABLE employees (id SERIAL PRIMARY KEY, name VARCHAR(50));"` - Execute sql directly from linux terminal.
-  `\r` - remove previous command -- o/p: Query buffer reset (cleared).

| Prompt       | Meaning                                   |
| ------------ | ----------------------------------------- |
| `postgres=#` | Ready for a new command                   |
| `postgres(#` | Waiting for closing `)`                   |
| `postgres-#` | Waiting for a semicolon `;` or more input |
| `postgres'>` | Waiting for closing quote `'`             |


#### 4. Stop Container

     docker stop postgres-demo

#### 5. Remove container

     docker rm postgres-demo

- Container filesystem is deleted.
- Any data stored inside the container is deleted.

#### 6. Start new PostgrSQL Container

       docker run -d \
       --name postgres-demo-new \
       -e POSTGRES_PASSWORD=password \
       postgres

#### 7. Check for table

       docker exec -it postgres-demo-new psql -U postgres

       \dt
       SELECT * FROM employees;

       o/p:
       ERROR: relation "employees" does not exist

