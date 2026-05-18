## Shell Scripting Basics

What is a Shebang(#!/bin/bash)?

       #!/bin/bash
        “Run this script using the Bash shell.”
        #! → special characters indicating interpreter path
        /bin/bash → location of the Bash shell

Without it, the system may try to run the script using another shell (like sh), which can cause unexpected behavior if script uses Bash-specific features.


Task1- First Script:

  Create a file

      touch firstScript.sh
      
      #!/bin/bash
       echo "Hello, DevOps!"

  Making script executable

      chmod +x firstScript.sh

 Task2- Variables:

     nano scripting.sh

     #!/bin/bash

    NAME="Tejas"
    ROLE="DevOps Engineer"

    echo "Hello, I am $NAME and I am a $ROLE"
