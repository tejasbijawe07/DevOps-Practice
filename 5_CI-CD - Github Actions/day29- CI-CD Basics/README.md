## What is CI/CD?

- Understanding why CI/CD exists and what it actually does.
- GitHub Actions, Jenkins, GitLab CI, CircleCI — all are tools that implement CI/CD.


### Task 1: The Problem
- Think about a team of 5 developers all pushing code to the same repo manually deploying to production.
- What can go wrong?
- What does "it works on my machine" mean and why is it a real problem?
- How many times a day can a team safely deploy manually?


#### 1. What can go wrong when 5 developers manually deploy to production?

Many issues can occur:
- Developers may overwrite each other's changes.
- Different environments can cause unexpected bugs.
- Someone may forget a deployment step.
- Wrong application version may be deployed.
- Configuration files may differ between servers.
- Human errors can cause downtime.
- Rollbacks become difficult if something fails.
- Deployment takes longer and is inconsistent.


#### 2. What does "it works on my machine" mean and why is it a real problem?

"It works on my machine" means the application runs correctly on the developer's computer but fails in another environment such as testing or production.

This happens because of differences like:
- Operating system
- Installed software versions
- Environment variables
- Missing dependencies
- Database configuration

Why it's a real problem:
- Bugs appear only after deployment.
- Team members waste time reproducing issues.
- Releases become unreliable.


With CI/CD automation, teams can safely deploy multiple times per day with consistent, repeatable processes.


### Task 2: CI vs CD
- Continuous Integration — what happens, how often, what it catches
- Continuous Delivery — how it's different from CI, what "delivery" means
- Continuous Deployment — how it differs from Delivery, when teams use it
- Write one real-world example for each.



#### 1. Continuous Integration(CI):
- Continuous Integration is the practice of frequently merging code changes into a shared repository, often several times a day. Every commit automatically triggers builds and tests to detect integration issues early.

- What it catches:
    - Build failures
    - Syntax errors
    - Failed unit tests
    - Merge conflicts
    - Integration issues

- Real-world example:
    - A developer pushes code to GitHub. A GitHub Actions or Jenkins pipeline automatically builds the application and runs unit tests. If any test fails, the developer is notified immediately.



#### 2. Continuous Delivery(CD):
- Continuous Delivery extends Continuous Integration by automatically preparing every successful build for release. The application is always in a deployable state, but a person decides when to deploy to production.

- Difference from CI:
   - CI verifies that the code is correct.
   - Continuous Delivery ensures the application can be released at any time after passing all checks.

- Real-world example:
   - After all tests pass, the application is automatically deployed to a staging environment. A release manager reviews it and clicks Deploy to release it to production.


#### 3. Continuous Deployment:
- Continuous Deployment goes one step further than Continuous Delivery. Every change that passes all automated tests is automatically deployed to production without any manual approval.

- Difference from Continuous Delivery:
    - Continuous Delivery requires human approval before production deployment.
    - Continuous Deployment deploys automatically after all quality checks succeed.

- Real-world example:
    - A small SaaS company uses GitHub Actions. Every successful commit to the main branch automatically builds, tests, and deploys the latest version to production without human intervention.


Summary:


| Feature                         | Continuous Integration | Continuous Delivery | Continuous Deployment |
| ------------------------------- | ---------------------- | ------------------- | --------------------- |
| Code merged frequently          | ✅                      | ✅                   | ✅                     |
| Automated build                 | ✅                      | ✅                   | ✅                     |
| Automated testing               | ✅                      | ✅                   | ✅                     |
| Deploy to staging               | Optional               | ✅                   | ✅                     |
| Manual approval for production  | N/A                    | ✅ Yes               | ❌ No                  |
| Automatic production deployment | ❌                      | ❌                   | ✅                     |


- CI → Build & Test.
- Continuous Delivery → Build, Test & Ready to Release.
- Continuous Deployment → Build, Test & Automatically Release.


---

### Task 3: Pipeline Anatomy
- A pipeline has these parts — write what each one does:
- Trigger — what starts the pipeline
- Stage — a logical phase (build, test, deploy)
- Job — a unit of work inside a stage
- Step — a single command or action inside a job
- Runner — the machine that executes the job
- Artifact — output produced by a job


#### 1. Trigger

- A Trigger is the event that starts a CI/CD pipeline automatically. It tells the pipeline when to begin executing.

- Examples:
    - Code pushed to a Git repository
    - Pull/Merge Request created
    - Scheduled (cron) execution
    - Manual button click


#### 2. Stage

- A Stage is a logical phase of the pipeline that groups related jobs together. Stages execute in a defined order, and the next stage usually starts only if the previous one succeeds.

- Common stages:
   - Build
   - Test
   - Deploy


#### 3. Job

- A Job is a specific unit of work performed within a stage. A stage can contain one or more jobs, which may run sequentially or in parallel depending on the pipeline configuration.

- Example: In the Test stage:
   - Unit Test Job
   - Integration Test Job
   - Security Scan Job


#### 4. Step

- A Step is an individual command or action inside a job. Jobs are made up of one or more steps executed in order.

- Example:

      git checkout
      pip install -r requirements.txt
      pytest


#### 5. Runner

- A Runner is the machine or agent that executes the pipeline jobs. It receives jobs from the CI/CD platform and performs the required commands.

- Examples:
   - GitHub Actions Runner
   - GitLab Runner
   - Jenkins Agent
   - Self-hosted Linux server


#### 6. Artifact

- An Artifact is a file or collection of files produced by a job and saved for later use. Artifacts can be downloaded, shared between pipeline stages, or used for deployment.

- Examples:
   - Compiled application (JAR, WAR, EXE)
   - Docker image metadata
   - Test reports
   - Coverage reports
   - Log files


Pipeline Flow Example:

    Trigger
      │
      ▼
    Stage: Build
      └── Job: Build Application
            ├── Step: Checkout Code
            ├── Step: Install Dependencies
            └── Step: Compile Code
                  │
                  ▼
             Artifact: app.jar
                  │
                  ▼
    Stage: Test
       └── Job: Run Tests
            ├── Step: Download Artifact
            └── Step: Execute Tests
                  │
                  ▼
    Stage: Deploy
       └── Job: Deploy Application
             └── Step: Deploy to Production

---


Task 4: Draw a Pipeline
- Draw a CI/CD pipeline for this scenario:
- A developer pushes code to GitHub. The app is tested, built into a Docker image, and deployed to a staging server.
- Include at least 3 stages.


                    CI/CD Pipeline

        Developer
            │
            │ git push
            ▼
      ┌─────────────┐
      │   GitHub    │
      └─────────────┘
            │
            │ Trigger Pipeline
            ▼
      ═══════════════════════════════════════════════

      Stage 1: Build
      ──────────────────────────────────────────────
      ✓ Checkout source code
      ✓ Install dependencies
      ✓ Build application

              │
              ▼

       Stage 2: Test
      ──────────────────────────────────────────────
       ✓ Run unit tests
       ✓ Run integration tests
       ✓ Verify build succeeds

              │
              ▼

      Stage 3: Docker Build
      ──────────────────────────────────────────────
      ✓ Build Docker image
      ✓ Tag image (example: app:v1)
      ✓ Push image to Docker Registry

             │
             ▼

      Stage 4: Deploy
      ──────────────────────────────────────────────
      ✓ Pull Docker image
      ✓ Deploy to Staging Server
      ✓ Perform health check

             │
             ▼

      Staging Environment
      ┌─────────────────┐
      │  Application    │
      │ Running on      │
      │ Staging Server  │
      └─────────────────┘

#### Stages Included:
 - Build – Compile the application and install dependencies.
 - Test – Execute automated tests to verify code quality.
 - Docker Build – Create a Docker image from the application.
 - Deploy – Deploy the Docker image to the staging server and verify it is running.


---
