## Runners: GitHub-Hosted & Self-Hosted

- Every job needs a machine to run on. 
- Today we understand runners — GitHub's hosted ones and how to set up your own self-hosted runner on a real server.


### Task 1: GitHub-Hosted Runners
- Create a workflow with 3 jobs, each on a different OS:
- ubuntu-latest, windows-latest, macos-latest
- In each job, print:
- The OS name, The runner's hostname, The current user running the job
- Watch all 3 run in parallel
- Write in your notes: What is a GitHub-hosted runner? Who manages it?


#### What is a Github Hosted Runner?
- A GitHub-hosted runner is a temporary virtual machine (VM) that GitHub automatically creates whenever your workflow runs.
- It comes with a pre-installed operating system (Ubuntu, Windows, or macOS).
- It already includes common development tools like Git, Python, Node.js, Java, Docker (Linux), etc.
- After the workflow finishes, GitHub deletes the VM.
- we don't have to install, configure, or maintain the machine.

#### who manages it?
- GitHub manages the infrastructure, operating system updates, security patches, and cleanup.
- we only write the workflow YAML file.


#### 1. github-hosted-runners.yml:

    name: GitHub Hosted Runners Demo
     
    on:
      push:

    jobs:
      ubuntu-job:
        runs-on: ubuntu-latest

        steps:
          - name: Print OS
            run: echo "Operating System: $RUNNER_OS"

          - name: Print Hostname
            run: hostname

          - name: Print Current User
            run: whoami

    windows-job:
      runs-on: windows-latest

      steps:
        - name: Print OS
          run: echo "Operating System: $env:RUNNER_OS"

        - name: Print Hostname
          run: hostname

        - name: Print Current User
          run: whoami

    macos-job:
      runs-on: macos-latest

      steps:
        - name: Print OS
          run: echo "Operating System: $RUNNER_OS"

        - name: Print Hostname
          run: hostname

        - name: Print Current User
          run: whoami


Understanding the yaml file:
- `on: push:` - The workflow starts automatically whenever you push code to the repository.
- `jobs:` :
   - Defines all the jobs in the workflow.
   - There are three independent jobs:
        - ubuntu-job
        - windows-job
        - macos-job
   - GitHub runs all three in parallel if runners are available.
- `runs-on` - This tells GitHub which operating system to create for that job.
- `steps` : Each job contains steps that run one after another.
   - Print OS: `RUNNER_OS` is a built-in environment variable provided by GitHub.
   - Print hostname: Displays the name of the temporary virtual machine.
   - Example: fv-az391-820. Every workflow gets a different hostname because a new VM is created each time.
   - Print Current user: Shows the user account under which the workflow is running.


#### Summary:
- After pushing the workflow:
- Open the Actions tab in your GitHub repository.
- Open the workflow run.
- three jobs: Ubuntu, Windows, macOS
- They should all start around the same time, demonstrating parallel execution.


----

### Task 2: Explore What's Pre-installed
- On the ubuntu-latest runner, run a step that prints:
- Docker version, Python version, Node version, Git version
- Look up the GitHub docs for the full list of pre-installed software on ubuntu-latest.
- Write in your notes: Why does it matter that runners come with tools pre-installed?



