## Triggers & Matrix Builds

#### Your pipeline runs on push. Today we learn every way to trigger a workflow and how to run jobs across multiple environments at once.

---

#### Task 1: Trigger on Pull Request
- Create `.github/workflows/pr-check.yml`
- Trigger it only when a pull request is opened or updated against main
- Add a step that prints: `PR check running for branch: <branch name>`
- Create a new branch, push a commit, and open a PR
- Watch the workflow run automatically
- Verify: Does it show up on the PR page?


#### 1. create yaml file in workflow

pr-check.yml:

    name: PR Check

    on:
      pull_request:
         branches:
           - main
         types:
           - opened
           - synchronize

    jobs:
      pr-check:
      runs-on: ubuntu-latest

      steps:
        - name: Print PR branch
          run: 'echo "PR check running for branch: ${{ github.head_ref }}"'


Understanding the yaml file:

1. workflow responds to Pull Request events.

       on:
         pull_request:

2. only runs for PRs targeting main.

       branches:
         - main

3. Two events:

       types:
         - opened
         - synchronize

| Event         | When it happens                         |
| ------------- | --------------------------------------- |
| `opened`      | A new PR is created                     |
| `synchronize` | New commits are pushed to the PR branch |


4. `${{ github.head_ref }}`: gives the source branch of the Pull Request.

if branch is `feature/pr-check`, the wrokflow prints: PR check running for branch: feature/pr-check

#### 2. Test workflow:

    git checkout main
    git pull origin main


1. create a new branch:

       git checkout -b feature/pr-check
    
       git add .github/workflows/pr-check.yml
       git commit -m "Add PR check workflow"
       git push -u origin feature/pr-check


2. Create a Pull Request from github
  
3. Check PR:

      Pull Request page, we can see something similar to:

          Checks
          ✓ PR Check

      in logs:

         PR check running for branch: feature/pr-check

#### 3. Test synchronize trigger: If we make another change, a new commit to existing PR branch, the synchronize event occurs.

---

#### Task 2: Scheduled Trigger
- Add a schedule: trigger to any workflow using cron syntax
- Set it to run every day at midnight UTC
- Write in your notes: What is the cron expression for every Monday at 9 AM?

