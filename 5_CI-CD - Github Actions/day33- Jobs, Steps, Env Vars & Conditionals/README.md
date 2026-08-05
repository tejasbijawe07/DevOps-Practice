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


