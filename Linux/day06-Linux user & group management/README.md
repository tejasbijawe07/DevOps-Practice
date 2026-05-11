## Linux User and Group Management

Today's goal is to practice user and group management.

  - Create users and set passwords
  - Create groups and assign users
  - Set up shared directories with group permissions

Commands:

  - User: `useradd`, `passwd`, `usermod`
  - Group: `groupadd`, `groups`
  - Permissions: `chgrp`, `chmod`
  - Test: `sudo -u username command`

---


Task 1: Creating Users

Create three users with home directories and passwords:

tokyo
berlin
professor

a. user tokyo -

       - Create user
          sudo useradd tokyo    ...(user gets created, but without a home directory).

       - Verify user exists in `/etc/passwd`
           grep tokyo /etc/passwd
           o/p:
           tokyo:x:1001:1002::/home/tokyo:/bin/sh

       - Verify if home directory exists
           ls -ld /home/tokyo
           o/p:
           ls: cannot access '/home/tokyo': No such file or directory

       - check user details
           id tokyo
           o/p:
           uid=1001(tokyo) gid=1002(tokyo) groups=1002(tokyo)

       - create home directory
           sudo mkdir /home/tokyo
           sudo chown tokyo:tokyo /home/tokyo

       - set password
           sudo passwd tokyo
