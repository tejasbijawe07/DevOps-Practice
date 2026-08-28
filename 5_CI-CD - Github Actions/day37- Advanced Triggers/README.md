## Advanced Triggers: PR Events, Cron Schedules & Event-Driven Pipelines

- Till now we used `push` and basic `pull_request` triggers. 
- But GitHub Actions supports dozens of event types — PR lifecycle events, scheduled cron jobs, and chaining workflows together.


### 1. Pull Request Event types:

- Instead of triggering on every PR activity, we can specify exactly which PR events should start the workflow.

             on:
              pull_request:
                types: [opened, synchronize, reopened, closed]



| Event         | When it happens                         |
| ------------- | --------------------------------------- |
| `opened`      | A new PR is created                     |
| `synchronize` | New commits are pushed to the PR branch |
| `reopened`    | A previously closed PR is reopened      |
| `closed`      | PR is closed or merged                  |


- Example:

         name: PR Events
         on:
           pull_request:
             types: [opened, synchronize, reopened, closed]

         jobs:
           test:
             runs-on: ubuntu-latest
             steps:
               - run: echo "PR event: ${{ github.event.action }}"


### 2. PR Validation workflow:

- A PR validation workflow runs tests/checks before code is merged.
- Example:


           name: PR Validation
           on:
             pull_request:
               branches: [main]

           jobs:
             validate:
               runs-on: ubuntu-latest

               steps:
                 - uses: actions/checkout@v4

                 - run: echo "Running lint"
                 - run: echo "Running tests"
                 - run: echo "Running build"


- A developer creates a PR targeting main.
- GitHub automatically starts the workflow.
- If tests fail, the PR shows a failed check.
- This prevents broken code from being merged.


### 3. Scheduled Workflows -- Cron

- A scheduled workflow runs automatically at a specific time.

          on:
            schedule:
              - cron: "0 2 * * *"

- This means: Run every day at 02:00 UTC.
- Example:

         name: Daily Health Check

         on:
           schedule:
              - cron: "0 2 * * *"

         jobs:
           check:
             runs-on: ubuntu-latest
             steps:
               - run: echo "Running daily health check"


### 4. Path & Branch Filters

- We can control which branches or files cause a workflow to run.
- Branch filter

         on:
           push:
             branches:
                - main

- Suppose application code is in: `src/`
- We can run the workflow only when files under `src/` change:

         on:
           push:
             paths:
               - "src/**"


### 5. workflow_run — Chain Workflows Together
- `workflow_run` allows one workflow to start after another workflow finishes.

          name: Deploy
          on:
            workflow_run:
              workflows: ["CI"]
              types: [completed]


### 6. repository_dispatch — External Event Triggers
- `repository_dispatch` allows an external system to tell GitHub: Something happened. Run this workflow.


Example:
   
     name: External Trigger

     on:
       repository_dispatch:
          types: [deploy]

     jobs:
       deploy:
          runs-on: ubuntu-latest
          steps:
            - run: echo "External deployment event received"



| Trigger               | Workflow starts when...               | Common use                       |
| --------------------- | ------------------------------------- | -------------------------------- |
| `push`                | Code is pushed                        | CI/CD                            |
| `pull_request`        | PR activity occurs                    | PR validation                    |
| `schedule`            | Cron time arrives                     | Daily/weekly jobs                |
| `paths`               | Specific files change                 | Targeted CI                      |
| `paths-ignore`        | Files other than ignored paths change | Avoid unnecessary CI             |
| `workflow_run`        | Another workflow completes            | CI → CD                          |
| `repository_dispatch` | External system sends an event        | External/event-driven automation |




                               Developer Push
                                   │
                                   ▼
                               Pull Request
                                   │
                                   ▼
                               PR Validation
                                   │
                                   ├── ❌ Tests fail → Developer fixes
                                   │
                                   └── ✅ Tests pass
                                   │
                                   ▼
                              Merge to main
                                   │
                                   ▼
                              CI Workflow
                                   │
                                   ▼
                              Build + Test + Docker
                                   │
                                   ▼
                               workflow_run
                                   │
                                   ▼
                               CD / Deployment


---
