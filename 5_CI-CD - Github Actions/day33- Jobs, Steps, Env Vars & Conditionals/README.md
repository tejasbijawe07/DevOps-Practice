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


