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
