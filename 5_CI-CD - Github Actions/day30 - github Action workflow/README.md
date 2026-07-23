### First GitHub Actions Workflow

write your first GitHub Actions pipeline and watch it run in the cloud.

#### Task 1: Set Up
- Create a new public GitHub repository called github-actions-practice
- Clone it locally
- Create the folder structure: .github/workflows/


#### 1. Create a Github Repository

 https://github.com/tejasbijawe07/github-actions-practice/tree/main


#### 2. Clone the repository

    git clone https://github.com/tejasbijawe07/github-actions-practice.git


#### 3. Create workflow folder

    mkdir -p .github/workflows

---


#### Task 2: Hello Workflow
- Create .github/workflows/hello.yml with a workflow that:
- Triggers on every push
- Has one job called greet
- Runs on ubuntu-latest
- Step 1: Check out the code using actions/checkout
- Step 2: Print Hello from GitHub Actions!
- Push it. Go to the Actions tab on GitHub and watch it run.
- Verify: Is it green? Click into the job and read every step.


#### 1. Create a file hello.yml:

    .github/workflows/hello.yml


hello.yml

    name: Hello Workflow

    on:
      push:

    jobs:
      greet:
        runs-on: ubuntu-latest

        steps:
          - name: Checkout Repository
            uses: actions/checkout@v4

          - name: Print Greeting
            run: echo "Hello from GitHub Actions!"


#### Understanding the Workflow:

1. Workflow name - The name displayed in the Actions tab.

       name: Hello Workflow
   
2. Trigger - Runs every time code is pushed to any branch.

       on:
         push:

3. Job - Defines one job named greet.

        jobs:
           greet:

4. Runner - GitHub creates a fresh Ubuntu virtual machine to execute the workflow.

        runs-on: ubuntu-latest

5. Steps -

  - STEP 1 -  Downloads your repository onto the runner so later steps can access the files.

        - name: Checkout Repository
          uses: actions/checkout@v4

  - Step 2 - Runs a shell command that prints: Hello from GitHub Actions!

        - name: Print Greeting
        run: echo "Hello from GitHub Actions!"


#### 2. Commit and Push:

     git add .
     git commit -m "Add first GitHub Actions workflow"
     git push origin main

---

#### Task 3: Understand the Anatomy
- Look at your workflow file and write in your notes what each key does:
- on, jobs, runs-on, steps, uses, run, name (on a step).


| Key                     | Purpose                                                                                                                                 |
| ----------------------- | --------------------------------------------------------------------------------------------------------------------------------------- |
| **`on:`**               | Specifies the event that triggers the workflow, such as `push`, `pull_request`, or `schedule`.                                          |
| **`jobs:`**             | Defines one or more jobs to run in the workflow. Jobs can run sequentially or in parallel.                                              |
| **`runs-on:`**          | Specifies the type of runner (operating system) where the job will execute, e.g., `ubuntu-latest`, `windows-latest`. |
| **`steps:`**            | Lists the individual tasks that make up a job. Steps run one after another in the order they are listed.                                |
| **`uses:`**             | Uses an existing GitHub Action created by GitHub or the community. Example: `actions/checkout@v4` checks out your repository code.      |
| **`run:`**              | Executes one or more shell commands directly on the runner. Example: `echo "Hello from GitHub Actions!"`.                               |
| **`name:`** (on a step) | Gives a descriptive name to a step, making it easier to identify in the GitHub Actions logs.                                            |


How it works:
- `on: push` → Start the workflow whenever code is pushed.
- `jobs:` → Create a job named `greet`.
- `runs-on: ubuntu-latest` → Run the job on an Ubuntu virtual machine.
- `steps:` → Execute the listed steps one by one.
- `uses: actions/checkout@v4` → Download your repository to the runner.
- `run: echo "Hello from GitHub Actions!"`→ Print a greeting in the workflow logs.
- `name:` → Display friendly names ("Checkout Repository", "Print Greeting") in the Actions tab instead of generic step descriptions.


---

#### Task 4: Add More Steps
- Update hello.yml to also:
- Print the current date and time
- Print the name of the branch that triggered the run (hint: GitHub provides this as a variable)
- List the files in the repo
- Print the runner's operating system
- Push again — watch the new run.


hello.yml:

    name: Hello Workflow

    on:
      push:

    jobs:
      greet:
      runs-on: ubuntu-latest

      steps:
        - name: Checkout Repository
          uses: actions/checkout@v4

        - name: Print Greeting
          run: echo "Hello from GitHub Actions!"

        - name: Print Current Date and Time
          run: date

        - name: Print Branch Name
          run: echo "Branch: ${{ github.ref_name }}"

        - name: List Repository Files
          run: ls -la

        - name: Print Runner Operating System
          run: echo "Runner OS: $RUNNER_OS"


#### Understanding the workflow:

#### 1. Print current date and Time - Executes the Linux date command. Displays the current date and time on the GitHub Actions runner.

    - name: Print Current Date and Time
      run: date

#### 2. Print Branch Name - Uses the GitHub Actions context variable github.ref_name. Prints the branch that triggered the workflow.

    - name: Print Branch Name
      run: echo "Branch: ${{ github.ref_name }}"

#### 3. List repository files - Lists all files and directories in the checked-out repository, including hidden ones like .git and .github.

     - name: List Repository Files
       run: ls -la

#### 4. Print Runner OS - Uses the predefined environment variable RUNNER_OS. Displays the operating system of the GitHub-hosted runner.

     - name: Print Runner Operating System
       run: echo "Runner OS: $RUNNER_OS"

#### 5. Verify:
- Open your repository → Actions → latest Hello Workflow run.
- these steps execute successfully with green check marks:

      ✔ Checkout Repository
      ✔ Print Greeting
      ✔ Print Current Date and Time
      ✔ Print Branch Name
      ✔ List Repository Files
      ✔ Print Runner Operating System

---

#### Task 5: Break It On Purpose
- Add a step that runs a command that will fail (e.g., exit 1 or a misspelled command)
- Push and observe what happens in the Actions tab
- Fix it and push again
- Write in your notes: What does a failed pipeline look like? How do you read the error?

