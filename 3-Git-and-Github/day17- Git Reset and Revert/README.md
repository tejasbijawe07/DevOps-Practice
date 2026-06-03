## Git Reset, Revert & Branching Strategies

### Task 1: Git Reset — Hands-On
- Make 3 commits in your practice repo (commit A, B, C)
- Use git reset --soft to go back one commit — what happens to the changes?
- Re-commit, then use git reset --mixed to go back one commit — what happens now?
- Re-commit, then use git reset --hard to go back one commit — what happens this time?


1. Creating commits

         echo "Commit A" > file.txt
         git add .
         git commit -m "Commit A"

         echo "Commit B" >> file.txt
         git add .
         git commit -m "Commit B"

        echo "Commit C" >> file.txt
        git add .
        git commit -m "Commit C"


2. git reset --soft HEAD~1

       git reset --soft HEAD~1

        git status
        o/p:
        Changes to be committed:
        modified: file.txt
   
 - Commit C disappears from commit history
 - Changes from Commit C remain staged
 - Working directory keeps the changes
 - Ready to recommit immediately
 - HEAD points to commit B.

Recommit:
        
        git commit -m "Commit C again"

        
3. git reset --mixed HEAD~1

        git reset --mixed HEAD~1

        git status
        o/p:
        Changes not staged for commit:
        modified: file.txt
   
 - Commit removed from history
 - Changes remain in your files
 - Changes become unstaged
 - Working directory unchanged

 Restage and Recommit:

      git add .
      git commit -m "Commit C once more"


4. git reset --hard HEAD~1

       git reset --hard HEAD~1

       git status
       git log --oneline
       cat file.txt

       o/p:
       nothing to commit, working tree clean

 - Commit removed from history
 - Changes deleted from staging area
 - Changes deleted from working directory
 - File content returns to previous commit state

Summary:
- Soft → “Keep everything staged”
- Mixed → “Keep files, unstage changes”
- Hard → “Delete changes completely”


### 1. What is the difference between --soft, --mixed, and --hard?

- Staging" means preparing your modified files to be included in your next commit, while "unstaging" means removing those files from the preparation area without deleting your code changes.


| Reset Type          | Commit History  | Staging Area           | Working Directory     | Result                                      |
| ------------------- | --------------- | ---------------------- | --------------------- | ------------------------------------------- |
| `git reset --soft`  | Moves HEAD back | Keeps changes staged   | Keeps files unchanged | Undo commit but keep work ready to recommit |
| `git reset --mixed` | Moves HEAD back | Unstages changes       | Keeps files unchanged | Undo commit but keep changes in files       |
| `git reset --hard`  | Moves HEAD back | Removes staged changes | Deletes file changes  | Completely remove commit and changes        |


### 2. When to use each one?

- `--soft`

  Use when:

     - want to change commit messages
     - Combine commits (squash)
     - Recreate a commit without losing staged changes

- `--mixed`

  Use when:

     - if committed too early
     - want to modify files before recommitting
     - want to unstage file

- `--hard`

  Use when:

     - You want to discard local work completely
     - Remove unwanted commits and file changes
     - Clean up experimental changes

---

### Task 2: Git Revert
- Make 3 commits (commit X, Y, Z)
- Revert commit Y (the middle one) — what happens?
- Check git log — is commit Y still in the history?


1. Revert commit B

       git revert b2c3d4e


   Verify:

       git log --oneline

       o/p:
       d5e6f7g Revert "Commit B"
       c3d4e5f Commit C
       b2c3d4e Commit B
       a1b2c3d Commit A

 - Git created a new commit.
 - Original Commit B still exists.
 - New revert commit applies the opposite changes of B.
 - History remains intact.
 - git revert does not remove commits from history.
 - It creates an additional commit that reverses the effect of the selected commit.


### 1. How is `git revert` different from `git reset`?


| Feature                              | `git reset`                                                            | `git revert`                                                          |
| ------------------------------------ | ---------------------------------------------------------------------- | --------------------------------------------------------------------- |
| **What it does**                     | Moves branch pointer backward and can modify staging/working directory | Creates a new commit that undoes changes from a previous commit       |
| **Removes commit from history?**     | Yes (rewrites history)                                                 | No (keeps history, adds new commit)                                   |
| **Safe for shared/pushed branches?** | No (can break history, requires force push)                            | Yes (safe for collaboration)                                          |
| **When to use**                      | For local commits, cleaning up history, undoing unpushed commits       | For shared branches, undoing changes safely without rewriting history |


Summary:
 - git revert → Creates a new commit that reverses previous changes.
 - git reset → Moves HEAD backward and can remove commits/changing staging state.

---

### Task 3: Branching Strategies
   - GitFlow — develop, feature, release, hotfix branches
   - GitHub Flow — simple, single main branch + feature branches
   - Trunk-Based Development — everyone commits to main, short-lived branches
  
  
**1. GitFlow:**
 - GitFlow uses multiple long-lived branches to manage structured development, releases, and hotfixes.

 - Main branches:
    - main (production)
    - develop (integration)

    - Supporting branches:
    - feature/*
    - release/*
    - hotfix/*
  
 - When/where it is used:
    - Large teams
    - Projects with scheduled releases
    - Strict QA and release cycles


**2. GitHub Flow**
 - A simple workflow where everything branches from main and merges back via pull requests.

 - Branches:
    - main
    - feature/* (short-lived)

 - When/where it is used:
    - Web apps
    - Continuous deployment systems
    - Teams deploying frequently


**3. Trunk-Based Development**

 - All developers commit directly to a single branch (main or trunk) with very short-lived branches (or none).

 - When/where it is used
    - CI/CD-heavy environments
    - Companies like Google, Facebook style workflows


Summary:
 - GitFlow → “structured and strict”
 - GitHub Flow → “simple and fast”
 - Trunk-Based → “everything goes to main quickly”
