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

 - tokyo
 - berlin
 - professor
   
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
           professor:x:1003:1003:,,,:/home/professor:/bin/bash

   - Verify if home directory exists

         ls -ld /home/berlin
          o/p:
          drwxr-x--- 2 professor professor 4096 May 11 02:58 /home/professor

 ---

 Task 2: Create Groups

  Create two groups:

  - developers
  - admins

  a. Create groups:

     sudo groupadd developers     
     sudo groupadd admins

  b. Verify groups:

     grep -E "developers|admins" /etc/group
     
     o/p:
     developers:x:1005:   ...(developers → group name
                              1005 → Group ID (GID))
     admins:x:1006:

---
    
Task 3: Assign to Groups

Assign users:

 - tokyo → developers
 - berlin → developers + admins (both groups)
 - professor → admins

a. Add Users to Groups
 
 tokyo → developers

    sudo usermod -aG developers tokyo

 berlin → developers + admins
  
    sudo usermod -aG developers,admins berlin

 professor → admins

    sudo usermod -aG admins professor

b. Verify Group Membership

  Using id-
     
     id tokyo
     id berlin
     id professor

     o/p:
     uid=1001(tokyo) gid=1002(tokyo) groups=1002(tokyo),1005(developers)
     uid=1003(berlin) gid=1003(berlin) groups=1003(berlin),100(users),1005(developers),1006(admins)
     uid=1004(professor) gid=1004(professor) groups=1004(professor),100(users),1006(admins)

   Using /etc/group-
    
     grep -E "developers|admins" /etc/group

     o/p:
     developers:x:1005:tokyo,berlin
     admins:x:1006:berlin,professor

---

Task 4: Shared Directory

  - Create directory: /opt/dev-project
  - Set group owner to developers
  - Set permissions to 775 (rwxrwxr-x)
  - Test by creating files as tokyo and berlin


1. Create directory:

       sudo mkdir /opt/users-groups

2. group owner to developers:

       sudo chown root:developers /opt/users-groups  ...(owner user = root, owner group = developers)

       - Verify:
            ls -ld /opt/users-groups

3. Set permissions to `775`:

        sudo chmod 775 /opt/users-groups

        o/p:
        drwxrwxr-x 2 root developers 4096 May 12 01:21 /opt/users-groups
   
       | User Type | Permissions          |
       | --------- | -------------------- |
       | Owner     | read, write, execute |
       | Group     | read, write, execute |
       | Others    | read, execute        |

4. Test using tokyo and berlin user:

     - switch user

           su - tokyo

     - create file

           touch /opt/users-groups/tokyo-file.txt

     - verify

           ls -l /opt/dev-project

   similarly, test and create file using berlin user.

---

Task 5: Team Workspace

   - Create user nairobi with home directory
   - Create group project-team
   - Add nairobi and tokyo to project-team
   - Create /opt/team-workspace directory
   - Set group to project-team, permissions to 775
   - Test by creating file as nairobi


1. Creat user nairobi

        sudo adduser nairobi

2. Create group project-team

        sudo groupadd project-team

        verify:
        grep project-team /etc/group
        o/p:
        project-team:x:1008:

3. Add tokyo and nairobi into project-team group

       sudo usermod -aG project-team nairobi
       sudo usermod -aG project-team tokyo

4. create workspace directory

       sudo mkdir /opt/team-workspace

5. set group ownership

       sudo chown root:project-team /opt/team-workspace

6. set permission to `775`

       sudo chmod 775 /opt/team-workspace

       verify:
       ls -ld /opt/team-workspace

       o/p:
       drwxrwxr-x 2 root project-team 4096 May 12 02:48 /opt/team-workspace

7. test as nairobi user

     - switch user

            su - nairobi

     - crwate file
  
           touch /opt/team-workspace/test.txt

  verification commands:

      ls -ld /opt/team-workspace
      ls -l /opt/team-workspace
      grep project-team /etc/group
      id nairobi
      id tokyo


### What we created today using users and group management linux commands

Users & Groups Created
   - Users: tokyo, berlin, professor, nairobi
   - Groups: developers, admins, project-team

Group Assignments
   - developers --> tokyo, berlin
   - admins --> berlin, professor
   - project-team --> tokyo, nairobi

Directories Created
   - users-groups - drwxrwxr-x 2 root developers 4096 May 12 02:37 /opt/users-groups
   - team-workspace - drwxrwxr-x 2 root project-team 4096 May 12 02:48 /opt/team-workspace

