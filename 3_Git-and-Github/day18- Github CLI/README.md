## GitHub CLI: Manage GitHub from Terminal


Task 1: Install and Authenticate
- Install the GitHub CLI on your machine
- Authenticate with your GitHub account
- Verify you're logged in and check which account is active

1. Install using apt
  
       sudo apt update
       sudo apt install gh -y

2. Authenticate with github

       gh auth login

       o/p:
       ? What account do you want to log into? GitHub.com
       ? What is your preferred protocol for Git operations? HTTPS
       ? Authenticate Git with your GitHub credentials? Yes
       ? How would you like to authenticate? Login with a web browser

       GitHub.com
       HTTPS (recommended)
       Login with web browser (easiest)


3. Verify login and active account

       gh auth status
       gh api user


### 1. What authentication methods does gh support?

GitHub CLI supports several authentication methods:

1. Web Browser Authentication (Recommended)

       gh auth login

  - Opens browser
  - Sign in normally
  - Uses OAuth flow

2. Personal Access Token (PAT)

       gh auth login --with-token < token.txt

  Useful for:
  - Servers
  - Automation
  - CI/CD

---

Task 2: Working with Repositories
 - Create a new GitHub repo directly from the terminal — make it public with a README
 - Clone a repo using gh instead of git clone
 - View details of one of your repos from the terminal
 - List all your repositories
 - Open a repo in your browser directly from the terminal
 - Delete the test repo you created


1. create a repository from terminal

       gh repo create test-gh-repo \
         --public \
         --description "Testing GitHub CLI" \
         --add-readme

command explained:
 - `test-gh-repo` → repo name
 - `--public` → creates public repo
 - `--add-readme` → automatically creates README.md
 - `--description` → optional description 


3. view details of one repo

       gh repo view test-gh-repo

4. list all repository

       gh repo list

5. Open Repository in Browser from Terminal

       gh repo view --web


Summary

| Task                 | Command                                             |
| -------------------- | --------------------------------------------------- |
| Create repo          | `gh repo create test-gh-repo --public --add-readme` |
| Clone repo           | `gh repo clone username/repo`                       |
| View repo            | `gh repo view repo-name`                            |
| List repos           | `gh repo list`                                      |
| Open repo in browser | `gh repo view --web`                                |
| Delete repo          | `gh repo delete repo-name`                          |

---

Task 3: Issues
- Create an issue on one of your repos from the terminal — give it a title, body, and a label
- List all open issues on that repo
- View a specific issue by its number
- Close an issue from the terminal


| Task         | Command                   |
| ------------ | ------------------------- |
| Create issue | `gh issue create`         |
| List issues  | `gh issue list`           |
| View issue   | `gh issue view <number>`  |
| Close issue  | `gh issue close <number>` |
| Open browser | `gh issue view --web`     |

---

Task 5: GitHub Actions & Workflows (Preview)
- List the workflow runs on any public repo that uses GitHub Actions
- View the status of a specific workflow run
- Answer: How could gh run and gh workflow be useful in a CI/CD pipeline?


1. list workflow runs on a public repo

       gh run list \
          --repo cli/cli

       o/p:
       completed  success  Release Pipeline      main  push  234567890
       completed  failure  Tests                 main  pull_request 234567891
       in_progress success Documentation Build   main  push  234567892


2. view status of specific workflow run

       gh run view 234567890 \
         --repo cli/cli

   view only summary:

        gh run view 234567890 \
          --repo cli/cli \
          --json status,conclusion,name

   watch live progress:

        gh run watch 234567890 \
          --repo cli/cli

   
### How could gh run and gh workflow be useful in a CI/CD pipeline?
- gh run and gh workflow help automate monitoring, triggering, and controlling CI/CD processes directly from scripts and pipelines.

1. Trigger deployments automatically

       gh workflow run deploy.yml

  Useful for:
   - manual production deployments
   - scheduled jobs

 2. monitor pipeline health

        gh run list --status failure

    Usefule for:
    - detect failed builds
    - monitor test failures
    - notify teams automatically
   
  3. fetch logs automatically

         gh run view 123456 --log

summary:

| Task               | Command                         |
| ------------------ | ------------------------------- |
| List workflow runs | `gh run list --repo owner/repo` |
| View run           | `gh run view <run-id>`          |
| Watch run          | `gh run watch <run-id>`         |
| List workflows     | `gh workflow list`              |
| Trigger workflow   | `gh workflow run workflow.yml`  |

---
