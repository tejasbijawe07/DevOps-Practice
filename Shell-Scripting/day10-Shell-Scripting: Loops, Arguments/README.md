## Shell Scripting: Loops, Arguments & Error Handling

Task 1: For Loop

Create for_loop.sh that: Loops through a list of 5 fruits and prints each one

    #!/bin/bash

    for FRUIT in Apple Banana Mango Orange Grapes
    do
    echo "Fruit: $FRUIT"
    done

- for FRUIT in Apple Banana Mango Orange Grapes, means:
- "Take each item one by one and store it in variable FRUIT.”

---

Task 2: While Loop

Create countdown.sh that: Takes number from user, Counts down to 0 using a while loop.

    
     #!/bin/bash
     read -p "Enter a number: " NUM
     while [ $NUM -ge 0 ]
     do
     echo $NUM
     NUM=$((NUM - 1))
     done

     echo "Done!"

- NUM=$((NUM - 1)) : This performs arithmetic subtraction.
- without this loop would go infinite. ex: 5 → 4 → 3 → 2 → 1 → 0

---

Task 3: Command-line Arguments

In shell scripts $1 means First command-line argument passed to the script.

Ex: ./greet.sh Tejas... (Here $1=Tejas)


1. Create greet.sh that:
  - Accepts a name as $1
  - Prints Hello, <name>!
  - If no argument is passed, prints "Usage: ./greet.sh "


        #!/bin/bash

        if [ -z "$1" ]; then
        echo "Usage: ./greet.sh <name>"

        else
           echo "Hello, $1!"
        fi

  If script run:
  - without argument (./greet.sh) -- o/p: Usage: ./greet.sh <name>
  - with argument (./greet.sh Tejas) -- o/p: Hello, Tejas!

  -z "$1" checks:
  - “Is the string empty?”
  - If no argument is passed:
     - $1 is empty
     - condition becomes true
   
Common variables in Shell Script

| Variable | Meaning             |
| -------- | ------------------- |
| `$0`     | script name         |
| `$1`     | first argument      |
| `$2`     | second argument     |
| `$#`     | number of arguments |
| `$@`     | all arguments       |
| `$$`     | current process ID  |

ex: ./test.sh apple mango
 - $0: ./test.sh
 - $1: apple
 - $2: mango
 - $#: 2


2. Create args_demo.sh that:
 - Prints total number of arguments ($#)
 - Prints all arguments ($@)
 - Prints the script name ($0)

        #!/bin/bash

       echo "Script name: $0"

       echo "Total number of arguments: $#"

       echo "All arguments: $@"

 Ex:
 ./args_demo.sh apple mango banana

 o/p:
 - Script name: ./args_demo.sh
 - Total number of arguments: 3
 - All arguments: apple mango banana

---

Task 4: Install Packages via Script

This script will:

- Define package list
- Loop through packages
- Check if package is installed
- Install missing packages
- Skip already installed packages
- Print status messages


      #!/bin/bash

      PACKAGES="nginx curl wget"

      for PACKAGE in $PACKAGES
      do
         echo "Checking package: $PACKAGE"

         if dpkg -s $PACKAGE >/dev/null 2>&1; then
            echo "$PACKAGE is already installed"

         else
            echo "$PACKAGE is NOT installed"
            echo "Installing $PACKAGE..."

            sudo apt update -y
            sudo apt install -y $PACKAGE

            echo "$PACKAGE installation completed"
        fi

        echo "-----------------------------"
      done


      o/p:
      Checking package: nginx
      nginx is NOT installed
      Installing nginx...
      nginx installation completed
      -----------------------------

      Checking package: curl
      curl is already installed
      -----------------------------

  Understanding script:
  
  - Package List: Stores multiple package names.
         - `PACKAGES="nginx curl wget"`

  - Loop: Processes packages one by one.
         - `for PACKAGE in $PACKAGES`

  - Check Installation: Checks if package exists on Ubuntu.
         - `dpkg -s $PACKAGE`

  - Redirect o/p: Hides unnecessary o/p /errors.
         - `>/dev/null 2>&1`
 
  - Install Package: sudo → admin privileges, apt install → install package, 
-y → auto-confirm yes.
         - `sudo apt install -y $PACKAGE`

---

Task 5: Error Handling

This script demonstrates:
  - set -e
  - error handling
  - || operator
  - safe scripting practices


        #!/bin/bash

        set -e

        mkdir /tmp/devops-test || {
            echo "Failed to create directory"
        }

        cd /tmp/devops-test || {
            echo "Failed to enter directory"
        }

        touch testfile.txt || {
           echo "Failed to create file"
        }

        echo "Script completed successfully"

    Understanding script:

    - `set -e`: Exits the script immediately if any command fails.
    - || : `command || echo "Error" `; if command fails, run the right-side command.


| Option     | Purpose                            |
| ---------- | ---------------------------------- |
| `-e`       | exit on error                      |
| `-u`       | fail on undefined variables        |
| `pipefail` | fail pipeline if any command fails |


- For loop: for item in list; do ... done
- While loop: while [ condition ]; do ... done
- Arguments: $1 first arg, $# count, $@ all args
- Check root: if [ "$EUID" -ne 0 ]; then echo "Run as root"; exit 1; fi
- Check package: dpkg -s <pkg> &> /dev/null && echo "installed"
