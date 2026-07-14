# Git Commands Reference

## Setup & Config

### Check Git version
Displays the installed Git version.
`git --version`

### Configure Username and Email
Sets git username globally.
`git config --global user.name "ABC"`
`git config --global user.email "@email.com"`

### Initialize Git repository
Creates a new Git repository in the current directory.
`git init`

---

## Viewing Changes

### check repository status
Shows the current state of tracked and untracked files.
`git status`

### List Hidden files
Displays all files including hidden files like .git.
`ls -la`

---

## Commit History commands

### view full commit history
Displays detailed commit history
`git log`

### view compact commit history
`git log --oneline`

---

## Staging commands

### stage all changes
Stages all modified and new files.
`git add .`

### view differences
Shows changes made since the last commit.
`git diff`

### Commit the file changes
Commit the file.
`git commit -m "Add git commands"`
---

## Branching commands

### List branches
Displays all branches in a repository.
`git branch`

---

### Create a branch
Creates a new branch.
`git branch feature-1`


### Switch branch
moves from one branch to another.
`git switch feature-1`


### Create and switch branch
Creates a new branch and switches to it immediately in a single command.
`git switch -c feature-2`


### Delete branch
Deletes a branch that is not required.
`git branch -d feature-2`

---

## Connect Local repository to remote github

### Add remote.
`git remote add origin https://github.com/your-username/devops-git-practice.git`

### verify remote
`git remote -v`

### push to master branch
`git push -u origin master`

### useful commands

| Task                | Command                            |
| ------------------- | ---------------------------------- |
| Add remote          | `git remote add origin <repo-url>` |
| View remotes        | `git remote -v`                    |
| Push branch         | `git push -u origin master`        |
| Push feature branch | `git push -u origin feature-1`     |

### pull from github
git pull downloads the changes and automatically merges into current local branch.
`git pull`
