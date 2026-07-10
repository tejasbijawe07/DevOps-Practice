## YAML Basics

- YAML — the language every pipeline is written in.
- YAML uses spaces only — never tabs
- Indentation is everything — 2 spaces is standard
- Strings don't need quotes unless they contain special characters (:, #, etc.)
- true/false are booleans, "true" is a string


#### Task 1: Key-Value Pairs
- Create person.yaml that describes yourself with:
- name, role, experience_years, learning (a boolean)
- Verify: Run cat person.yaml — does it look clean? No tabs?


person.yaml

    name: Tejas Bijawe
    role: DevOps Engineer (Learning)
    experience_years: 2
    learning: true

---

#### Task 2: Lists
- Add to person.yaml:
- tools — a list of 5 DevOps tools you know or are learning
- hobbies — a list using the inline format [item1, item2]


person.yaml

    name: Tejas Bijawe
    role: DevOps Engineer (Learning)
    experience_years: 2
    learning: true

    tools:
      - Docker
      - Git
      - Jenkins
      - Linux
      - CI/CD

    hobbies: [Traveling, Photography]


#### What are the two ways to write a list in YAML?

#### 1. Block style- Each item starts with a hyphen (-).

    tools:
      - Docker
      - Kubernetes
      - Git
      - Jenkins
      - Linux

#### 2. Inline style- Everything is written on a single line inside square brackets.

    hobbies: [Traveling, Photography, Coding]


---


#### Task 3: Nested Objects
- Create server.yaml that describes a server:
- server with nested keys: name, ip, port
- database with nested keys: host, name, credentials (nested further: user, password)
- Verify: Try adding a tab instead of spaces — what happens when you validate it?


server.yaml:

    server:
      name: dev-server
      ip: 192.168.1.100
      port: 8080

    database:
      host: db-server
      name: employee_db
      credentials:
        user: admin
        password: admin123

- Top-level keys- `server:`, `database:`
- Nested keys under server- `name`, `ip`, `port` belong to the server object because they are indented by 2 spaces.
- if used a tab instead of spaces- found character '\t' that cannot start any token.
- validate file: `yamllint server.yaml`


---

#### Task 4: Multi-line Strings
- In `server.yaml`, add a `startup_script` field using:
- The | block style (preserves newlines)
- The > fold style (folds into one line)
- Write in your notes: When would you use | vs >?


server.yaml:

    server:
      name: dev-server
      ip: 192.168.1.100
      port: 8080

    database:
      host: db-server
      name: employee_db
      credentials:
        user: admin
        password: admin123

    startup_script_preserve: |
      #!/bin/bash
      echo "Starting application..."
      sudo systemctl start nginx
      echo "Application started."

    startup_script_fold: >
      This server is configured
      to start automatically
      after every reboot
      using a systemd service.


#### 1. `|` Literal block style: The | preserves line breaks exactly as written.

     o/p:
     #!/bin/bash
     echo "Starting application..."
     sudo systemctl start nginx


- Every newline is preserved.
- This is ideal for:
- Shell scripts
- SQL queries
- Configuration files
- Certificates
- Code snippets


#### 2. `>` Folded Block Style: The > replaces line breaks with spaces, producing one continuous line (except for blank lines).

     o/p:
     This server is configured to start automatically after every reboot.


- All lines are folded into a single sentence.
- This is ideal for:
- Long descriptions
- Documentation
- Messages
- Comments
- Release notes


Summary:
- `|` (literal block) → preserves every newline. Use it for code, scripts, and formatted text.
- `>` (folded block) → folds multiple lines into a single line separated by spaces. Use it for long descriptions or documentation.
Both styles improve readability of YAML files without changing the meaning of your data structure.


---

#### Task 5: Validate Your YAML
- Install yamllint or use an online validator
- Validate both your YAML files
- Intentionally break the indentation — what error do you get?
- Fix it and validate again

      yamllint --version

  validate:

      yamllint server.yaml

common yamllint errors:

| Error                                              | Cause                                           |
| -------------------------------------------------- | ----------------------------------------------- |
| `found character '\t' that cannot start any token` | Used a tab instead of spaces                    |
| `mapping values are not allowed here`              | Incorrect indentation or misplaced `:`          |
| `expected <block end>, but found...`               | Inconsistent indentation or missing indentation |
| `too many spaces inside braces`                    | Incorrect inline formatting                     |


---


