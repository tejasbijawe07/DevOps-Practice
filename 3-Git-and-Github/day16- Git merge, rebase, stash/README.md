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

