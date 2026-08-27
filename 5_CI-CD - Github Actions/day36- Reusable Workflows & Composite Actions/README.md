## Reusable Workflows & Composite Actions

- We've been writing workflows from scratch every time.
- In the real world, teams don't repeat themselves — they create reusable workflows that any repo can call like a function.


### Task 1: Understand `workflow_call`
- Before writing any code, research and answer in your notes:
- What is a reusable workflow?
- What is the `workflow_call` trigger?
- How is calling a reusable workflow different from using a regular action `(uses:)`?
- Where must a reusable workflow file live?


### 1. What is a reusable workflow?

- A reusable workflow is a GitHub Actions workflow that is designed to be called and used by other workflows, instead of being triggered independently every time.
- For example, suppose you have 10 repositories and all of them need the same:
  - Build
  - Test
  - Docker image creation
  - Security scan
  - Deployment
- Instead of maintaining the same YAML in all 10 repositories, we can create the workflow once and reuse it.
- A reusable workflow can also accept inputs and secrets from the calling workflow and can return outputs.


### 2. What is the workflow_call trigger?

- `workflow_call` tells GitHub:
- This workflow is not meant to be triggered directly by a push/PR. Other workflows can call it.

      on:
        workflow_call:

- The calling workflow can then provide these values using `with:` and `secrets:`.


### 3. How is calling a reusable workflow different from using a regular action `(uses:)`?

| Reusable Workflow                                       | Regular/Composite Action                                   |
| ------------------------------------------------------- | ---------------------------------------------------------- |
| Reuses an **entire workflow**                           | Reuses a **step or group of steps**                        |
| Called at the **job level**                             | Called inside a **job's steps**                            |
| Can contain **multiple jobs**                           | Runs as a step                                             |
| Can define jobs, runners, permissions, conditions, etc. | Primarily packages reusable step logic                     |
| Uses `workflow_call`                                    | Uses an action's `action.yml`                              |
| Can accept inputs and secrets                           | Can accept inputs; secrets are passed through the workflow |
| Ideal for complete CI/CD processes                      | Ideal for reusable pieces of CI/CD logic                   |


### 4. Where must a reusable workflow file live?
- A reusable workflow must be inside: .github/workflows/
- And it must contain:

      on:
        workflow_call:


---


### Task 2: Create Your First Reusable Workflow
Create .github/workflows/reusable-build.yml:

1. Set the trigger to workflow_call
2. Add an inputs: section with:
   - app_name (string, required)
   - environment (string, required, default: staging)
3. Add a secrets: section with:
   - docker_token (required)
4. Create a job that:
   - Checks out the code
   - Prints Building <app_name> for <environment>
   - Prints Docker token is set: true (never print the actual secret)

Verify: This file alone won't run — it needs a caller. That's next.


#### 1. reusable-build.yml


      name: Reusable Build

      on:
       workflow_call:
          inputs:
            app_name:
              description: "Name of the application"
              required: true
              type: string

            environment:
              description: "Target environment"
              required: true
              default: staging
              type: string

          secrets:
             docker_token:
               description: "Docker authentication token"
               required: true

      jobs:
        build:
          runs-on: ubuntu-latest

          steps:
            - name: Checkout code
              uses: actions/checkout@v4

            - name: Build application
              run: |
                echo "Building ${{ inputs.app_name }} for ${{ inputs.environment }}"

            - name: Check Docker token
              run: |
                if [ -n "${{ secrets.docker_token }}" ]; then
                   echo "Docker token is set: true"
                else
                   echo "Docker token is set: false"
                fi


- `workflow_call` → makes this workflow callable by another workflow.
- `inputs.app_name` → required string supplied by the caller.
- `inputs.environment` → required string with a default value of staging.
- `secrets.docker_token` → required secret supplied by the caller.
- `actions/checkout@v4` → checks out the repository code.
- `${{ inputs.app_name }}` → reads the input passed by the caller.
- `${{ secrets.docker_token }}` → accesses the secret, but we only check whether it is non-empty.


---


### Task 3: Create a Caller Workflow
Create .github/workflows/call-build.yml:

1. Trigger on push to main
2. Add a job that uses your reusable workflow:

        jobs:
          build:
             uses: ./.github/workflows/reusable-build.yml
             with:
               app_name: "my-web-app"
               environment: "production"
             secrets:
               docker_token: ${{ secrets.DOCKER_TOKEN }}
   
3. Push to main and watch it run


#### 1. call-build.yml


    name: Call Reusable Build

    on:
      workflow_dispatch:

    jobs:
      build:
        uses: ./.github/workflows/reusable-build.yml
        with:
          app_name: "my-web-app"
          environment: "production"
        secrets:
          docker_token: ${{ secrets.DOCKER_TOKEN }}


#### 2.  flow


       Caller workflow
           │
           │ uses:
           ▼
       reusable-build.yml
           │
           ├── Checkout
           ├── Build
           └── Check secret


---

### Composite Action:

- A composite action packages multiple steps into one reusable action.
- Unlike a reusable workflow, you use it inside `steps:`. Composite actions use an `action.yml` metadata file, `runs.using: composite`, and can expose outputs mapped from step outputs.

        Reusable Workflow
        → Reuses complete jobs/workflows
        → Called under jobs.<job_id>.uses

        Composite Action
        → Reuses multiple steps as one action
        → Called inside steps using uses:



### Reusable workflow vs Composite Action:


| **Feature**                      | **Reusable Workflow**                                              | **Composite Action**                                                 |
| -------------------------------- | ------------------------------------------------------------------ | -------------------------------------------------------------------- |
| **Triggered by**                 | `workflow_call`                                                    | `uses:` in a step                                                    |
| **Can contain jobs?**            | ✅ Yes, multiple jobs                                               | ❌ No, it runs as part of a job                                       |
| **Can contain multiple steps?**  | ✅ Yes                                                              | ✅ Yes                                                                |
| **Lives where?**                 | `.github/workflows/`                                               | `.github/actions/<action-name>/action.yml`                           |
| **Can accept secrets directly?** | ✅ Yes, using `secrets:`                                            | ❌ No direct `secrets:` declaration; pass secrets as inputs if needed |
| **Best for**                     | Reusing an **entire CI/CD pipeline** across repositories/workflows | Reusing a **group of steps** within jobs                             |


- A reusable workflow is used when we want to reuse complete jobs or CI/CD pipelines, while a composite action is used when we want to package multiple steps into a reusable action.
- Reusable workflows are called at the job level using `uses:` and `workflow_call`, whereas composite actions are called inside a job's `steps:`.


---
