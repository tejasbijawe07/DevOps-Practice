## File Permissions & File Operations Challenge

1. Understanding file permissions:

         ls -l
         o/p:
         -rwxr-xr-- 1 dell dell 59502 Apr 23 07:38 kubectl

    | Part  | Meaning                         |
    | ----- | ------------------------------- |
    | `-`   | File type (`d` means directory) |
    | `rwx` | Owner permissions               |
    | `r-x` | Group permissions               |
    | `r--` | Others permissions              |


2. Permission types:

    | Symbol | Meaning | Value |
    | ------ | ------- | ----- |
    | r      | Read    |   4   |
    | w      | Write   |   2   |
    | x      | Execute |   1   |


    | Number | Meaning |
    | ------ | ------- |
    | 7      | rwx     |
    | 6      | rw-     |
    | 5      | r-x     |
    | 4      | r--     |


3. chmod commands: use to change permissions.

    Example-

        a. Create a script:

               touch hello.sh
                -- #!/bin/bash
                    echo "Hello DevOps"

        b. check permission:

                ls -l
                o/p:
                -rw-r--r-- 1 dell 32 May 13 hello.sh

        c. Add execute permission

              chmod +x hello.sh
              o/p:
              -rwxr-xr-x

         d. execute script

             ./hello.sh


4. Group execute permission

         Before:
        -rw-r--r-- 1 developers 50 May 13 script.sh ...(r-- group members only can read)
         chmod g+x script.sh   ...(gives execute x permission to the group)
         After:
         -rw-r-xr-- 1 developers 50 May 13 script.sh ...(r-x group members can also execute the file)
   
 | Symbol | Meaning    |
 | ------ | ---------- |
 | u      | User/Owner |
 | g      | Group      |
 | o      | Others     |
 | a      | All        |
   
   
---
    
