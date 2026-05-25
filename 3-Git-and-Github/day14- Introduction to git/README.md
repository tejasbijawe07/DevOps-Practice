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
