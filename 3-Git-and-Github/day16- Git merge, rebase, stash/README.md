## Git: Merge, Rebase, Stash & Cherry Pick

Task 1: Git Merge — Hands-On
  - Create a new branch feature-login from main, add a couple of commits to it
  - Switch back to main and merge feature-login into main
  - Observe the merge — did Git do a fast-forward merge or a merge commit?
  - Now create another branch feature-signup, add commits to it — but also add a commit to main before merging
  - Merge feature-signup into main — what happens this time?


A. Fast-forward merge scenario:

        master branch --> echo "Welcome App" > app.txt
        
1. create feature-login branch

       git checkout -b feature-login
       echo "Login page added" >> app.txt

       git add .
       git commit -m "Added login page"

       echo "Login validation added" >> app.txt
       git add .
       git commit -m "Added login validation"

2. switch to main and merge

          git checkout main
   
          git merge feature-login

          o/p:
          git merge feature-login
          Updating ccd3d57..9037b57
          Fast-forward     ...(main has no commits after branch was created)
          app.txt | 2 ++
          1 file changed, 2 insertions(+)


B. Merge commit scenario:

1. create another branch

         git checkout -b feature-signup

         echo "Signup page added" >> app.txt
         git add .
         git commit -m "Added signup page"

2. switch to main and merge

        git checkout main
        echo "Hotfix on main branch" >> app.txt
        git add .
        git commit -m "Hotfix commit on main"

        git merge feature-signup  ... (merge conflict)


C. Merge conflict example

1.  create a new branch

        git checkout -b conflict-demo  ...(changing a line)
        git add .
        git commit -m "Changed welcome message in conflict branch"

2. switch to main and merge

        git checkout main  ...(edit same line differently)
        git add .
        git commit -m "Changed welcome message in main"

        git merge conflict-demo
        o/p:
        CONFLICT (content): Merge conflict in app.txt
        Automatic merge failed


Git conflict markers:

`<<<<<<< HEAD`
   - This marks the start of current branch's changes.
   - HEAD means the branch you are currently on (for example main or master).

`=======`
   - This is the separator between the two conflicting versions.
   - Everything above it belongs to your branch.
   - Everything below it belongs to the branch being merged.

`>>>>>>> feature-signup`
   - This marks the end of the conflict block.
   - feature-signup is the branch you were merging into your current branch.


         <<<<<<< HEAD
         (Current branch code)
          =======
         (Incoming branch code)
         >>>>>>> feature-signup


### 1. What is a fast-forward merge?
   - A fast-forward merge happens when the target branch has no new commits since the feature branch was created.
   - Git simply moves the branch pointer forward without creating a new merge commit.
   - Example:

         main: A---B
         feature:     C---D

         After merge:
         main: A---B---C---D

     
### 2. When does Git create a merge commit instead?
   - Git creates a merge commit when both branches have new commits and histories have diverged.

   - Example:

          main:    A---B---E
          feature:      C---D

          After merge:

          A---B---E
              \   \
               C---D---M    ...(M is the merge commit).


### 3. What is a merge conflict?
   - A merge conflict occurs when Git cannot automatically decide which changes to keep.
   - Usually happens when:
        - Same line edited in both branches
        - One branch deletes a file while another modifies it
   - Git asks the developer to manually resolve the conflict.

---

Task 2: Git Rebase — Hands-On
   - Create a branch feature-dashboard from main, add 2-3 commits
   - While on main, add a new commit (so main moves ahead)
   - Switch to feature-dashboard and rebase it onto main
   - Observe your git log --oneline --graph --all — how does the history look compared to a merge?


1. create feature branch

       git checkout -b feature-dashboard

2. Adding commits

       echo "Dashboard UI" > dashboard.txt
       git add .
       git commit -m "Added dashboard UI"

       echo "Dashboard API integration" >> dashboard.txt
       echo "Dashboard styling" >> dashboard.txt
       git add .
       git commit -m "Added dashboard styling"

3. Moving main ahead

       git checkout main
       echo "Critical hotfix" > hotfix.txt
       git add .
       git commit -m "Hotfix on main"

   histories diverged:

         main:      A --- B
                       \
        feature:        C --- D --- E

4. Rebase feature branch onto main

       git checkout feature-dashboard
       git rebase main    ...(git takes feature commits and reapplies them on top of main)

        A --- B --- C' --- D' --- E'

5. check history

       git log --oneline --graph --all


If used merge here:

       A --- B -------- M
             \         /
              C --- D --- E


| Merge                     | Rebase                             |
| ------------------------- | ---------------------------------- |
| Preserves branch history  | Rewrites history                   |
| Creates merge commit      | No merge commit                    |
| Non-linear graph          | Linear graph                       |
| Safer for shared branches | Better for cleaning local branches |


### 1. What does rebase actually do to your commits?
   - Rebase takes your commits, removes them temporarily, moves your branch to a new base commit, then reapplies your commits one by one.

Before rebase:

         main:      A --- B
                        \
         feature:        C --- D --- E

  After rebase:

         A --- B --- C' --- D' --- E'


### 2. How is history different from a merge?

- Merge History

       A --- B -------- M
             \         /
              C --- D

- Characteristics:

     - Keeps original branch structure
     - Creates merge commit (M)
     - Preserves full history
     - Non-linear graph


- Rebase History

      A --- B --- C' --- D'

- Characteristics:

     - Rewrites commit history
     - No merge commit
     - Cleaner graph
     - Linear history
 

### 3. Why should you never rebase commits that have been pushed and shared?

   - Because rebase changes commit hashes.

   - Example:

     Before push:
  
          A --- B --- C

     After rebase:

          A --- B --- C'

     Teammates still have:

          A --- B --- C     ... (C ≠ C')
     
     Problems caused:

        - Duplicate commits
        - Confusing history
        - Forced pushes required
        - Team merge issues
    
    
### 4. When would you use rebase vs merge?
  
Use Rebase When:
  - Cleaning local branch history
  - Updating feature branch with latest main
  - Preparing commits before PR
  - You want linear history
  - Example:

        git checkout feature
        git rebase main

Use Merge When:
   - Working with shared branches
   - Preserving branch history matters
   - Multiple developers collaborate
   - Integrating completed features
   - Example:

         git checkout main
         git merge feature

---

Task 3: Squash Commit vs Merge Commit
   - Create a branch feature-profile, add 4-5 small commits (typo fix, formatting, etc.)
   - Merge it into main using --squash — what happens?
   - Check git log — how many commits were added to main?
   - Now create another branch feature-settings, add a few commits
   - Merge it into main without --squash (regular merge) — compare the history



1. create branch and commit

       git checkout main
       git checkout -b feature-profile

       echo "Profile page" > profile.txt
       echo "Formatting updated" >> profile.txt
       echo "Profile validation" >> profile.txt
   
       git add .
       git commit -m "Updated formatting"
   
history:
 
      main:     A
                 \
      feature:   B---C---D---E---F

2. Squash merge

        git checkout main
        git merge --squash feature-profile

    - Git combines all changes
    - No merge commit created automatically
    - Commits are squashed into staged changes

3. check log

        git log --oneline --graph
        o/p:
        A --- G
   
    - only one commit added to main.

4. Regular merge

       git checkout -b feature-settings

       echo "Settings UI" > settings.txt
       echo "Dark mode" >> settings.txt
       echo "Notification settings" >> settings.txt

       git add .
       git commit -m "Added notifications"

   switch to main and merge

       git checkout main
       git merge feature-settings


5. check log

       git log --oneline --graph --all

 history:

      main:        A --- G -------- M
                           \      /
      feature:              H--I--J


Comparing history:

| Feature                            | Squash Merge | Regular Merge |
| ---------------------------------- | ------------ | ------------- |
| Number of commits added to main    | 1            | All commits   |
| Keeps feature commit history       | No           | Yes           |
| Creates merge commit automatically | No           | Sometimes     |
| Cleaner history                    | Yes          | More detailed |
| Good for many tiny commits         | Yes          | Less ideal    |


### 1. What does squash merging do?
 
   - Squash merge combines all commits from a feature branch into one single commit before adding them to the target branch.

   - Example:

      Before squash:

             main:      A
                           \
             feature:       B --- C --- D --- E

       After squash:
     
             A -------- S

     - Multiple commits become one commit
     - Original feature branch commits are not added individually to main
     - Produces cleaner history


### 2. When would you use squash merge vs regular merge?

Use Squash Merge When:
  - Feature branch has many tiny commits
  - Commits include typo fixes / formatting / WIP commits
  - You want cleaner Git history
  - Working on small features
  - Merging pull requests with noisy commit history

Use Regular Merge When:
  - Commit history is important
  - Multiple developers contributed
  - You need full traceability
  - Feature commits tell a useful story
  - Large features need audit/history


### 3. What is the trade-off of squashing?

Advantages:
  - Cleaner history
  - Easier log reading
  - Fewer noisy commits
  - Simpler main branch

Disadvantages:
  - Lose commit-by-commit history
  - Harder debugging (git bisect)
  - Cannot see development progression
  - Individual contributor work becomes less visible

---

