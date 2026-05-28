## Git: Merge, Rebase, Stash & Cherry Pick

Task 1: Git Merge — Hands-On
  - Create a new branch feature-login from main, add a couple of commits to it
  - Switch back to main and merge feature-login into main
  - Observe the merge — did Git do a fast-forward merge or a merge commit?
  - Now create another branch feature-signup, add commits to it — but also add a commit to main before merging
  - Merge feature-signup into main — what happens this time?


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
