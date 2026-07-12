## What is CI/CD?

- Understanding why CI/CD exists and what it actually does.
- GitHub Actions, Jenkins, GitLab CI, CircleCI — all are tools that implement CI/CD.


#### Task 1: The Problem
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


#### Task 2: CI vs CD
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

Task 3: Pipeline Anatomy
- A pipeline has these parts — write what each one does:
- Trigger — what starts the pipeline
- Stage — a logical phase (build, test, deploy)
- Job — a unit of work inside a stage
- Step — a single command or action inside a job
- Runner — the machine that executes the job
- Artifact — output produced by a job








