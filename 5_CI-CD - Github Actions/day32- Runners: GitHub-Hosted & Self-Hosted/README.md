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


