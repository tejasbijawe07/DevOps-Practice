## Git Branching and Github

 - Branches allow isolated development without affecting the main branch.
 - Each branch can have its own commits, files, and history until merged.

Task 1: Understanding Branches
  - What is a branch in Git?
  - Why do we use branches instead of committing everything to main?
  - What is HEAD in Git?
  - What happens to your files when you switch branches?

### 1. What is a branch in Git?

A branch in Git is an independent line of development.  
It allows developers to work on features, fixes, or experiments separately without affecting the main project code.


### 2. Why do we use branches instead of committing everything to main?

Branches help keep the main branch stable and production-ready.  
Developers can safely test new changes in separate branches and merge them only after verification.


### 3. What is HEAD in Git?

HEAD is a pointer that refers to the current branch and latest commit we are working on.  
It tells Git where we currently are inside the repository history.


### 4. What happens to your files when you switch branches?

When we switch branches, Git changes the working directory files to match the selected branch's latest commit.  
Files may appear, disappear, or change depending on the contents of that branch.

---

Task 2: Branching Commands — Hands-On

 - List all branches in your repo
 - Create a new branch called feature-1
 - Switch to feature-1
 - Create a new branch and switch to it in a single command — call it feature-2
 - Try using git switch to move between branches — how is it different from git checkout?
 - Make a commit on feature-1 that does not exist on main
 - Switch back to main — verify that the commit from feature-1 is not there
 - Delete a branch you no longer need
 - Add all branching commands to your git-commands.md


1. List all branches

       git branch

       o/p:
       * main   ...(* indicates the current branch)


2. create a new branch feature-1

        git branch feature-1


3. switch to feature-1

       git checkout feature-1

       or using switch:
       git switch feature-1


4. create and switch in single command (feature-2)

        git checkout -b feature-2

        or using switch
        git switch -c feature-2


5. make a commit on feature-1

         git switch feature-1

         create test file:
         echo "Feature 1 changes" > feature1.txt

         stage it:
         git add feature1.txt

         commit it:
         git commit -m "Add feature1 test file"


6. switch back to master

       git switch master

       feature-1 is not present in master


7. delete unused branch

        git branch -d feature-2

---

Task 3: Push to GitHub
  - Create a new repository on GitHub (do NOT initialize it with a README)
  - Connect your local devops-git-practice repo to the GitHub remote
  - Push your main branch to GitHub
  - Push feature-1 branch to GitHub
  - Verify both branches are visible on GitHub
