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


#### 1. preinstalled-tools.yml:

    name: Explore Pre-installed Tools

    on:
     push:

    jobs:
     ubuntu-tools:
       runs-on: ubuntu-latest

       steps:
        - name: Print Docker version
          run: docker --version

        - name: Print Python version
          run: python3 --version

        - name: Print Node.js version
          run: node --version

        - name: Print Git version
          run: git --version


Understanding file:

1. Print Docker version -

       o/p:
       docker --version
       shell: /usr/bin/bash -e {0}
       Docker version 28.0.4, build b8034c0

2. Print Python version -

       o/p:
       python3 --version
       shell: /usr/bin/bash -e {0}
       Python 3.12.3

3. Print git version -

       o/p:
       git --version
       shell: /usr/bin/bash -e {0}
       git version 2.54.0

- GitHub maintains a list of all software installed on each runner image:

      https://docs.github.com/en/actions/reference/runners/github-hosted-runners?utm_source=chatgpt.com


#### Why does it matter that runners come with tools pre-installed?
- You don't need to install common tools like Git, Docker, Python, Node.js, Java, or .NET before using them.
- Workflows start faster because setup time is reduced.
- CI/CD pipelines are simpler and shorter.
- Builds are more consistent since every GitHub-hosted runner starts from a clean environment with the same pre-installed toolset for that image.
- You only need to install additional software if your project requires tools that aren't already available.


----

### Task 3: Set Up a Self-Hosted Runner
- Go to your GitHub repo → Settings → Actions → Runners → New self-hosted runner: Choose Linux as the OS
- Follow the instructions to download and configure the runner on:
- Your local machine, OR A cloud VM (EC2, Utho, or any VPS)
- Start the runner — verify it shows as Idle in GitHub
- Verify: Your runner appears in the Runners list with a green dot.


### What is Self-Hosted Runner?
- Unlike GitHub-hosted runners, a self-hosted runner is a machine that you own and manage. It can be your local PC, a WSL Ubuntu instance, an EC2 instance, or any Linux VM.


#### 1. Runner settings
- Open your GitHub repository.
- Navigate to:
- Settings → Actions → Runners → New self-hosted runner


#### 2. Select the runner and configure it
- Operating System: Linux , Architecture: x64 .
- github displays commands:

      mkdir actions-runner && cd actions-runner
  
      curl -o actions-runner-linux-x64-2.336.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.336.0/actions-runner-linux-x64-2.336.0.tar.gz
  
      tar xzf ./actions-runner-linux-x64-2.336.0.tar.gz

      ./config.sh --url https://github.com/tejasbijawe07/github-actions-practice --token AVNC5T7MAZCRWILZVYTUY6LKNQPD2

- Enter the name of the runner group to add this runner to: [press Enter for Default]
- Enter the name of runner: [press Enter for DESKTOP-T5F9213]
- This runner will have the following labels: 'self-hosted', 'Linux', 'X64'
Enter any additional labels (ex. label-1,label-2): [press Enter to skip]
- Enter name of work folder: [press Enter for _work]


#### 3. Start the Runner

     ./run.sh

     √ Connected to GitHub
     Current runner version: '2.336.0'
     2026-07-31 03:18:43Z: Listening for Jobs
     2026-07-31 03:30:02Z: Running job: self-hosted-job

#### 4. verify in github

    Settings → Actions → Runners

    ✓ my-runner
      Status: Idle


---

### Task 4: Use Your Self-Hosted Runner
- Create .github/workflows/self-hosted.yml
- Set runs-on: self-hosted
- Add steps that:
- Print the hostname of the machine (it should be YOUR machine/VM)
- Print the working directory
- Create a file and verify it exists on your machine after the run
- Trigger it and watch it run on your own hardware
- Verify: Check your machine — is the file there?


#### 1. self-hosted.yml

    name: Self Hosted Runner Demo

    on:
      push:

    jobs:
      self-hosted-job:
        runs-on: self-hosted

        steps:
          - uses: actions/checkout@v4

          - name: Print Hostname
            run: hostname

          - name: Print Working Directory
            run: pwd

          - name: Create a file
            run: |
               echo "Hello from my self-hosted runner!" > runner-test.txt
  
          - name: Verify file exists
            run: ls -l runner-test.txt


Understanding commands:
- `runs-on: self-hosted` - send this job to one of my registered runners.
- `- uses: actions/checkout@v4` - Downloads repository to the runner's working directory.
- `run: hostname` - Unlike GitHub-hosted runners, this hostname is your own machine or VM.
- `run: pwd` - This shows where the repository has been checked out on your machine.


#### 2. verify the file created on machine

- check the runner workspace on your machine:

      actions-runner/
      └── _work/
          └── <repository-name>/
              └── <repository-name>/
                  └── runner-test.txt

          cat runner-test.txt
          o/p:
          Hello from my self-hosted runner!

----


### Task 5: Labels
- Add a label to your self-hosted runner (e.g., my-linux-runner)
- Update your workflow to use runs-on: [self-hosted, my-linux-runner]
- Trigger it — does it still pick up the job?
- Write in your notes: Why are labels useful when you have multiple self-hosted runners?


### Why are Labels useful?
- Labels allow GitHub to choose which self-hosted runner should execute a workflow.
- For example, if you have:
     - WSL Ubuntu runner
     - AWS EC2 runner
     - Windows runner
- you can target a specific one using labels.
- `runs-on: [self-hosted, aws]` - Runs only on the AWS EC2 runner.
- You can route jobs based on operating system, installed software, hardware, or location.


----

### Task 6: GitHub-Hosted vs Self-Hosted


| Feature                 | GitHub-Hosted                                                                              | Self-Hosted                                                                                                                               |
| ----------------------- | ------------------------------------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------- |
| **Who manages it?**     | GitHub manages the runner, OS, updates, and maintenance.                                   | You manage the machine, OS, updates, and maintenance.                                                                                     |
| **Cost**                | Included with GitHub Actions minutes (subject to plan limits).                             | You pay for and maintain the hardware or cloud VM.                                                                                        |
| **Pre-installed tools** | Comes with many common tools (Git, Docker, Python, Node.js, Java, etc.).                   | You install and maintain the tools you need.                                                                                              |
| **Good for**            | General CI/CD, open-source projects, and most workflows without infrastructure management. | Custom environments, private networks, specialized hardware (GPU), long-running jobs, or software not available on GitHub-hosted runners. |
| **Security concern**    | GitHub secures and isolates the runner; each job gets a fresh VM.                          | You are responsible for securing the machine, patching it, controlling access, and protecting secrets.                                    |


### Summary:
- GitHub-hosted runners are quick to use, require no maintenance, and are ideal for most CI/CD pipelines.
- Self-hosted runners provide full control and customization, making them suitable for specialized workloads, private infrastructure, or environments with unique software and hardware requirements.


----


### Notes:

### Different options as self-hosted runner:

#### 1. WSL Ubuntu
- Uses your Windows PC.
- Runs Linux natively through WSL2.
- No extra cost.
- Perfect for Docker, GitHub Actions, Kubernetes, and Linux practice.


#### 2. Ubuntu Virtual Machine
- Install Ubuntu in:
     - VirtualBox
     - VMware Workstation
     - Hyper-V
- Install the GitHub runner inside the VM.


#### 3. AWS EC2
- Launch: Ubuntu Server
- t2.micro or t3.micro (Free Tier, if eligible)
- SSH into it: `ssh -i key.pem ubuntu@<public-ip>`
- Install the GitHub runner.


#### 4. Oracle Cloud Free Tier
- Oracle offers an Always Free Ubuntu VM.
- Advantages:
    - Runs 24/7
    - Public IP
    - Good CPU and RAM for learning


---


#### AWS EC2 Ubuntu instance as Github self-hosted runner:

#### 1. Launch an EC2 Instance
- In the AWS Console:
- AMI: Ubuntu Server 24.04 LTS (or 22.04 LTS)
- Instance type: t3.micro (or t2.micro if available)
- Key pair: Create or use an existing .pem file.
- Security Group: SSH (22) → Your IP ; (Optional) HTTP (80)
- Launch the instance.


#### 2. Connect to EC2
- From your terminal:

      chmod 400 my-key.pem
      ssh -i my-key.pem ubuntu@<EC2_PUBLIC_IP>


#### 3. Create directory for runner
#### 4. generate runner in github
#### 5. Run commands provided by github
#### 6. Configure and start the runner
#### 7. Verify file on EC2.

---
