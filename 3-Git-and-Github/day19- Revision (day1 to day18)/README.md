## Topics Covered So Far

| Days | Topic | Key Concepts |
|------|-------|-------------|
| 1   | DevOps & Cloud Intro | What is DevOps, SDLC, Cloud basics |
| 2–4  | Linux Fundamentals | Architecture, commands, processes, systemd, file system hierarchy, troubleshooting, text files |
| 5   | Cloud Server Setup | Docker, Nginx, web deployment |
| 6-7  | Users, Permissions & Ownership | User/group management, file permissions, chown/chgrp |
| 8   | Networking | Fundamentals, DNS, IP, subnets, ports, hands-on checks |
| 9-11   | Shell Scripting | Basics, loops, arguments, error handling, functions |
| 12-13  | Shell Scripting Projects | Log rotation, backup, crontab, log analyzer |
| 14-17  | Git & GitHub | Init, branching, merge, rebase, stash, cherry pick, reset, revert, branching strategies |
| 18   | GitHub CLI | Managing GitHub from the terminal |

---


### 1. Linux:
 - Navigate the file system, create/move/delete files and directories
 - Manage processes — list, kill, background/foreground
 - Work with systemd — start, stop, enable, check status of services
 - ead and edit text files using vi/vim or nano
 - Troubleshoot CPU, memory, and disk issues using top, free, df, du
 - Linux file system hierarchy (/, /etc, /var, /home, /tmp, etc.)
 - Create users and groups, manage passwords
 - Set file permissions using chmod (numeric and symbolic)
 - Change file ownership with chown and chgrp
 - Check network connectivity — ping, curl, netstat, ss, dig, nslookup


### 2. Shell Scripting:
 - Write a script with variables, arguments, and user input
 - Use if/elif/else and case statements
 - Write for, while, and until loops
 - Define and call functions with arguments and return values
 - Use grep, awk, sed, sort, uniq for text processing
 - Handle errors with set -e, set -u, set -o pipefail, trap
 - Schedule scripts with crontab


### 3. Git & GitHub:
 - Initialize a repo, stage, commit, and view history
 - Create and switch branches
 - Push to and pull from GitHub
 - Merge branches — understand fast-forward vs merge commit
 - Rebase a branch and explain when to use it vs merge
 - Use git stash and git stash pop
 - Cherry-pick a commit from another branch
 - Use git reset (soft, mixed, hard) and git revert
 - GitFlow, GitHub Flow, and Trunk-Based Development

---

### Quick Notes

### 1. What does `chmod 755 script.sh` do?

Gives owner read/write/execute permissions and others read/execute permissions.

### 2. Difference between a process and a service?

* Process: A running program instance.
* Service: A background process managed by the system.

### 3. How do you find which process is using port 8080?

```bash
sudo lsof -i :8080
```

### 4. What does `set -euo pipefail` do in a shell script?

* `-e` → Exit on command failure
* `-u` → Error on undefined variables
* `pipefail` → Fail if any command in a pipeline fails

### 5. Difference between `git reset --hard` and `git revert`?

* `git reset --hard` → Removes commits and changes permanently
* `git revert` → Creates a new commit that undoes changes

### 6. What does `git stash` do and when would you use it?

Temporarily saves uncommitted changes to switch branches or tasks.

### 7. How do you schedule a script to run every day at 3 AM?

```bash
0 3 * * * /path/to/script.sh
```

### 8. Difference between `git fetch` and `git pull`?

* `git fetch` → Downloads changes only
* `git pull` → Downloads and merges changes
