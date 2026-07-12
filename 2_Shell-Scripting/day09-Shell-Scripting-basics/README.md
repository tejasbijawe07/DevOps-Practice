## Shell Scripting Basics

What is a Shebang(#!/bin/bash)?

       #!/bin/bash
        “Run this script using the Bash shell.”
        #! → special characters indicating interpreter path
        /bin/bash → location of the Bash shell

Without it, the system may try to run the script using another shell (like sh), which can cause unexpected behavior if script uses Bash-specific features.

---

Task 1- First Script:

  Create a file

      touch firstScript.sh
      
      #!/bin/bash
       echo "Hello, DevOps!"

  Making script executable

      chmod +x firstScript.sh

---

 Task 2- Variables:

     nano scripting.sh

    { #!/bin/bash

     NAME="Tejas"
     ROLE="DevOps Engineer"

     echo "Hello, I am $NAME and I am a $ROLE" }

     chmod +x scripting.sh
     ./scripting.sh

---

Task 3 - User Input with Read

  Takes input from keyboard, Stores it in variable NAME, TOOL.

     #!/bin/bash
     
     echo "Enter your name:"
     read NAME

     echo "Enter your favourite tool:"
     read TOOL

     echo "Hello $NAME, your favourite tool is $TOOL"


ALTERNATIVE using `read -p`:

    #!/bin/bash

    read -p "Enter your name: " NAME
    read -p "Enter your favourite tool: " TOOL

    echo "Hello $NAME, your favourite tool is $TOOL"

---

TASK 4 - If-Else condition

 a. create file, take a num using read, print whether it is positive, negative or zero.
    
     #!/bin/bash

    read -p "Enter a number: " NUM

    if [ $NUM -gt 0 ]; then           ## -gt → greater than
    echo "The number is positive"

    elif [ $NUM -lt 0 ]; then         ## -lt → less than
    echo "The number is negative"

    else
    echo "The number is zero"
    fi


    Ex o/p:
    Enter a number: -5
    The number is negative
     
     
| Operator | Meaning       |
| -------- | ------------- |
| `-gt`    | greater than  |
| `-lt`    | less than     |
| `-eq`    | equal         |
| `-ge`    | greater/equal |
| `-le`    | less/equal    |
| `-ne`    | not equal     |


 b. create file, and check the existence of file.

    #!/bin/bash

    read -p "Enter filename: " FILE

    if [ -f "$FILE" ]; then
    echo "File exists"

    else
    echo "File does not exist"
    fi


| Operator | Meaning               |
| -------- | --------------------- |
| `-f`     | regular file exists   |
| `-d`     | directory exists      |
| `-e`     | file/directory exists |
| `-r`     | readable              |
| `-w`     | writable              |
| `-x`     | executable            |

---

Task 5 - server_check.sh

   - Store a service name in a variable (nginx).  
   - Asks the user: "Do you want to check the status? (y/n)".
   - If y — runs systemctl status <service> and prints whether it's active or not.


         #!/bin/bash

         SERVICE="cron"

         read -p "Do you want to check the status of $SERVICE? (y/n): " CHOICE

         if [ "$CHOICE" = "y" ]; then

             systemctl status $SERVICE

             if systemctl is-active --quiet $SERVICE; then
                 echo "$SERVICE is active"

             else
                 echo "$SERVICE is not active"
             fi

         else
             echo "Skipped."
         fi


Understanding the script:

 - variable SERVICE stores the service name(cron).
 - user response stored in CHOICE.
 - if user entered y --> is-active → checks service state; --quiet → hides output.
 - systemctl is-active returns proper exit codes.
