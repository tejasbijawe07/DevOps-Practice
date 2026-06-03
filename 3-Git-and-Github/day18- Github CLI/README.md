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
