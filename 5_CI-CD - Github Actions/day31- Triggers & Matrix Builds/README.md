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


#### To add a scheduled trigger in GitHub Actions, use the schedule event with a cron expression.


schedule.yml :

    name: Scheduled Workflow

    on:
      schedule:
       # Runs every day at 00:00 UTC
       - cron: '0 0 * * *'

       workflow_dispatch:

    jobs:
      scheduled-job:
        runs-on: ubuntu-latest

        steps:
          - name: Print message
            run: echo "This workflow was triggered by the schedule."


#### Understanding the cron expression:

    0 0 * * *
    │ │ │ │ │
    │ │ │ │ └── Day of week (0–7, Sunday = 0 or 7)
    │ │ │ └──── Month (1–12)
    │ │ └────── Day of month (1–31)
    │ └──────── Hour (0–23)
    └────────── Minute (0–59)

0 0 * * * : Runs every day at 00:00 (midnight) UTC.
- Minute: 0
- Hour: 0
- Every day of the month
- Every month
- Every day of the week
- Scheduled workflows only run after the workflow file has been pushed to the default branch(main). They do not run immediately—you'll need to wait for the scheduled time or trigger them manually if you've included workflow_dispatch.

#### Cron expression for every Monday at 9:00 AM UTC:

    0 9 * * 1

- Explanation:
- `0` → Minute 0
- `9` → 09:00
- `*` → Every day of the month
- `*` → Every month
- `1` → Monday

----

#### Task 3: Manual Trigger
- Create .github/workflows/manual.yml with a workflow_dispatch: trigger
- Add an input that asks for an environment name (staging/production)
- Print the input value in a step
- Go to the Actions tab → find the workflow → click Run workflow
- Verify: Can you trigger it manually and see your input printed?

#### The workflow_dispatch event allows to run a workflow manually from the GitHub Actions page and optionally provide inputs.


#### 1. create workflow:

manual.yml:

    name: Manual Workflow

    on:
      workflow_dispatch:
        inputs:
          environment:
           description: "Select deployment environment"
           required: true
           default: "staging"
           type: choice
           options:
            - staging
            - production

     jobs:
       manual-job:
        runs-on: ubuntu-latest

        steps:
          - name: Print selected environment
            run: | 
              echo "Environment selected: ${{ github.event.inputs.environment }}"


#### 2. commit and push:

    git add .github/workflows/manual.yml
    git commit -m "Add manual workflow"
    git push origin main


#### 3. Run the workflow manually:
- Open GitHub repository.
- Click the Actions tab.
- Select Manual Workflow from the left sidebar.
- Click Run workflow.
- Choose an environment:
   - staging
   - production
- Click Run workflow.


### Notes:

#### 1. 21:81 error line too long (82 > 80 characters) (line-length)
- error is on the echo command: split using multiline run block.

      run: |
        echo "Environment selected: ${{ github.event.inputs.environment }}"


#### 2. pushed through feature/pr-check branch; merge into main:
- Switch to `main` : `git checkout main`
- Pull latest changes: `git pull origin main`
- merge feature branch: `git merge feature/pr-check`
- push the updated `main`: `git push origin main`


#### 3. updated the file changes from main branch; now as feature/pr-check branch is behind push from feature branch:
- Using `Rebase`:

      git checkout feature/pr-check
      git fetch origin
      git rebase origin/main
      git push --force-with-lease

- Before rebase:

       A --- B --- C  (main)
              \
               D --- E  (feature)
  
 - using rebase - "I'll temporarily remove D and E, move the branch to C, then replay D and E."

        A --- B --- C --- D' --- E'  (feature)

 - git creates new commits with new commit Id's:
       - During rebase:
       - moves HEAD to C
       - applies changes from D
       - creates new commit D'
       - applies changes from E
       - creates new commit E'

 - we use `git push --force` which replaces whatever is on github with our local branch. so, `git push --force-with-lease` force push only if nobody else has updated the branch since we last fetched it.


----

#### Task 4: Matrix Builds
- Create .github/workflows/matrix.yml that:
- Uses a matrix strategy to run the same job across:
- Python versions: 3.10, 3.11, 3.12
- Each job installs Python and prints the version
- Watch all 3 run in parallel
- Then extend the matrix to also include 2 operating systems — how many total jobs run now?


#### What is Matrix Builds?
- Matrix builds are one of the most powerful Github Actions feature. Instead of writing same job multiple times, we define a matrix of values and github automatically creates one job for each combination.
- Without a matrix, we have to write 3 nearly identical jobs:
    - job-python-310
    - job-python-311
    - job-python-312
- With a matrix, we write job once and github runs it 3 times with different python versions.


#### 1. Create matrix.yml

    name: Matrix Build

    on:
      workflow_dispatch:

    jobs:
      test:
        runs-on: ${{ matrix.os }}

        strategy:
          matrix:
            os: 
             - ubuntu-latest
             - windows-latest
            python-version: 
             - "3.10"
             - "3.11"
             - "3.12"

        steps:
          - name: Checkout code
            uses: actions/checkout@v4

          - name: Set up Python
            uses: actions/setup-python@v5
            with:
               python-version: ${{ matrix.python-version }}

          - name: Print Python version
            run: python --version


- `strategy`: causes github to automatically creates three jobs. They run in parallel.
- 6 jobs are created with 2 OS and 3 python versions.
- Matrix builds are commonly used to test software across multiple environments:
    - Multiple Python versions (3.10, 3.11, 3.12)
    - Multiple Node.js versions (18, 20, 22)
    - Multiple Java versions (17, 21)
    - Multiple operating systems (Ubuntu, Windows, macOS)
- This lets us verify that our code works everywhere without duplicating workflow definitions.


----

### Notes:

1. two important matrix features:
- `exclude` – Skip specific matrix combinations.
- `fail-fast` – Control whether other matrix jobs stop when one fails.

      strategy:
        fail-fast: false
        matrix:
          os:
           - ubuntu-latest
           - windows-latest
          python-version:
           - "3.10"
           - "3.11"
           - "3.12"

          exclude:
           - os: windows-latest
             python-version: "3.10"

      steps:
       - uses: actions/checkout@v4

       - uses: actions/setup-python@v5
         with:
          python-version: ${{ matrix.python-version }}

       - name: Print Python version
         run: python --version

       - name: Fail on Ubuntu Python 3.11
         if: matrix.os == 'ubuntu-latest' && matrix.python-version == '3.11'
         run: exit 1

2. when ubuntu + python 3.11 fails, the other jobs continue running.

----
