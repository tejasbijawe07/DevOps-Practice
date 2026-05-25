## Introduction to git

Task 1: Install and Configure Git
  - Verify Git is installed on your machine
  - Set up your Git identity — name and email
  - Verify your configuration


1. Verify if git installed

       git --version

2. Set up git identity

     - configure username:

           git config --global user.name "ABC"

     - configure your email:

           git config --global user.email "email@example.com"

3. Verify configuration

        git config --global user.name

        git config --global user.email

        git config --list

---

Task 2: Create Your Git Project
   - Create a new folder called devops-git-practice
   - Initialize it as a Git repository
   - Check the status — read and understand what Git is telling you
   - Explore the hidden .git/ directory — look at what's inside


1. Initialize a new folder as Git Repository

    create folder
   
       mkdir devops-git-practice

       cd devops-git-practice
   
    Initialize it as git repository
   
       git init

o/p:
- Initialized empty Git repository in /home/devops-git-practice/.git/
- This means:
     - Git has started tracking this folder
     - A hidden .git/ directory was created


2. Check git status

        git status

o/p:
On branch master

No commits yet

nothing to commit (create/copy files and use "git add" to track)


| Message                      | Meaning                                 |
| ---------------------------- | --------------------------------------- |
| `On branch master` or `main` | currently on the default branch         |
| `No commits yet`             | Repository has no saved snapshots yet   |
| `nothing to commit`          | No files are being tracked currently    |


3. Hidden .git/ directory

       ls -la

       ls -la .git


o/p:

| File/Folder | Purpose                          |
| ----------- | -------------------------------- |
| `HEAD`      | Points to current branch         |
| `config`    | Repository-specific Git settings |
| `objects/`  | Stores all commits and Git data  |
| `refs/`     | Stores branch references         |
| `hooks/`    | Scripts triggered by Git events  |
| `index`     | Git staging area metadata        |

---

Task 3: Stage and Commit
  - Stage your file
  - Check what's staged
  - Commit with a meaningful message
  - View your commit history


1. Check current status

       git status

       o/p:
       Untracked files:    (Not yet being tracked)
       git-commands.md

2. Stage the file

       git add git-commands.md

       git status

       o/p:
       Changes to be committed:     (File is staged, git is ready to include in next commit)
       new file: git-commands.md


3. Commit the File

       git commit -m "Add Git commands reference documentation"

       o/p:
       [main (root-commit) dbccdcf] Add Git commands reference documentation
       1 file changed, 29 insertions(+)
       create mode 100644 git-commands.md


4. View commit History

       git log

       o/p:
       commit dbccdcf557bb16ca1787f65e84d54cb0149cf47d (HEAD -> master)
       Author: tejasbijawe07
       Date:   Mon May 25 02:21:13 2026 +0000


       git log --oneline

       o/p:
       dbccdcf (HEAD -> master) Add Git commands reference documentation

---

Task 4: Git Workflow

1. What is the difference between git add and git commit?

    - git add moves changes into the staging area, preparing them for saving.
    - git commit permanently saves those staged changes into Git history as a snapshot with a message.
  

2. What does the staging area do? Why doesn't Git just commit directly?

    - The staging area lets us choose which changes should be included in the next commit.
    - This gives better control, allowing developers to organize commits cleanly instead of saving every file change directly.


3. What information does git log show you?

    - git log shows the commit history of the repository.
    - It includes commit IDs, author details, dates, and commit messages for each saved snapshot.

  
4. What is the .git/ folder and what happens if you delete it?

    - The .git/ folder stores all Git metadata, commits, branches, and repository history.
    - If we delete it, the folder stops being a Git repository and all version history is lost.
  

5. What is the difference between a working directory, staging area, and repository?

     - The working directory contains current project files and edits.
     - The staging area holds selected changes ready for commit, while the repository stores the committed history permanently inside Git.
    
