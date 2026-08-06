## Jobs, Steps, Env Vars & Conditionals

- How to control the flow of pipeline: 
- multi-job workflows, passing data between jobs, environment variables, and running steps only when certain conditions are met.



### Task 1: Multi-Job Workflow
- Create .github/workflows/multi-job.yml with 3 jobs:
- build — prints "Building the app"
- test — prints "Running tests"
- deploy — prints "Deploying"
- Make test run only after build succeeds. Make deploy run only after test succeeds.
- Verify: Check the workflow graph in the Actions tab — does it show the dependency chain?


multi-job.yml:

      name: Multi Job Workflow

      on:
        push:

      jobs:
        build:
          runs-on: ubuntu-latest

          steps:
            - name: Build the application
              run: echo "Building the app"

         test:
           runs-on: ubuntu-latest
           needs: build

           steps:
            - name: Run tests
              run: echo "Running tests"

         deploy:
          runs-on: ubuntu-latest
          needs: test

          steps:
           - name: Deploy the application
             run: echo "Deploying"


- workflow graph:

      git add .github/workflows/multi-job.yml
      git commit -m "Add multi-job workflow with dependencies"
      git push origin main
    
      build
       │
       ▼
      test
       │
       ▼
      deploy


- `needs: build` ensures the test job starts only after build completes successfully.
- `needs: test` ensures the deploy job starts only after test completes successfully.
- If build fails, test and deploy are skipped.
- If test fails, deploy is skipped.


---


### Task 2: Environment Variables
- In a new workflow, use environment variables at 3 levels:
    - Workflow level — APP_NAME: myapp
    - Job level — ENVIRONMENT: staging
    - Step level — VERSION: 1.0.0
- Print all three in a single step and verify each is accessible.
- Then use a GitHub context variable — print the commit SHA and the actor (who triggered the run).



environment-variables.yml:


    name: Environment Variables Demo

    on:
      push:

    # Workflow-level environment variable
    env:
      APP_NAME: myapp

    jobs:
      demo:
        runs-on: ubuntu-latest

        # Job-level environment variable
        env:
          ENVIRONMENT: staging

        steps:
          - name: Print environment variables
            # Step-level environment variable
            env:
              VERSION: 1.0.0
            run: |
              echo "App Name: $APP_NAME"
              echo "Environment: $ENVIRONMENT"
              echo "Version: $VERSION"

         - name: Print GitHub context variables
           run: |
             echo "Commit SHA: ${{ github.sha }}"
             echo "Triggered by: ${{ github.actor }}"


commit and push:

    git add .github/workflows/environment-variables.yml
    git commit -m "Add environment variables workflow"
    git push origin main

    o/p:

    App Name: myapp
    Environment: staging
    Version: 1.0.0

    Commit SHA: 8f3d6d4c7f9c2d1b4e...
    Triggered by: tejasbijawe07 


3 levels of Environment variables:


| Variable              | Level          | Access Scope                                      |
| --------------------- | -------------- | ------------------------------------------------- |
| `APP_NAME`            | Workflow       | Available to every job and step                   |
| `ENVIRONMENT`         | Job            | Available to all steps in that job                |
| `VERSION`             | Step           | Available only within that specific step          |
| `${{ github.sha }}`   | GitHub Context | SHA of the commit that triggered the workflow     |
| `${{ github.actor }}` | GitHub Context | Username of the person who triggered the workflow |


---


### Task 3: Job Outputs
- Create a job that sets an output — e.g., today's date as a string
- Create a second job that reads that output and prints it
- Pass the value using `outputs:` and `needs.<job>.outputs.<name>`
- Write in your notes: Why would you pass outputs between jobs?


