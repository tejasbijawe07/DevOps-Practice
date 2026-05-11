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
          sudo chown tokyo:tokyo /home/tokyo ... (This command changes the ownership of the
                                                  directory /home/tokyo. tokyo:tokyo
                                                 Format is:owner:group. Make user tokyo the owner
                                                  and group tokyo the group owner).

  - set password

          sudo passwd tokyo

  - Alternative which creates directly the home directory

        sudo useradd -m tokyo ...(-m = create /home/tokyo)

b. user berlin -

   - Create user

         sudo adduser berlin
          o/p:
          info: Adding new user `berlin' (1003) with group `berlin (1003)' 
          info: Creating home directory `/home/berlin'

   - Verify user exists in `/etc/passwd`

         grep berlin /etc/passwd
           o/p:
           berlin:x:1003:1003:,,,:/home/berlin:/bin/bash

   - Verify if home directory exists

         ls -ld /home/berlin
          o/p:
          drwxr-x--- 2 berlin berlin 4096 May 11 02:58 /home/berlin

c. user professor -

  - Create user

         sudo adduser professor
          o/p:
          info: Adding new user `professor' (1003) with group `professor (1003)' 
          info: Creating home directory `/home/professor'

   - Verify user exists in `/etc/passwd`

         grep professor /etc/passwd
           o/p:
           professor:x:1003:1003:,,,:/home/berlin:/bin/bash

   - Verify if home directory exists

         ls -ld /home/berlin
          o/p:
          drwxr-x--- 2 professor professor 4096 May 11 02:58 /home/professor

          
