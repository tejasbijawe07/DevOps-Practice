## Shell Scripting: Functions & intermediate Concepts

Task 1: Basic Functions
  - Create functions.sh with:
      - A function greet that takes a name as argument and prints Hello, <name>!
      - A function add that takes two numbers and prints their sum
      - Call both functions from the script
   

            #!/bin/bash

            # Function to greet a user
            greet() {
                echo "Hello, $1!"
            }

            # Function to add two numbers
            add() {
              sum=$(( $1 + $2 ))
              echo "Sum: $sum"
            }

            # Calling the functions
            greet "Tejas"
            add 10 20

            o/p:
            Hello, Tejas!
            Sum: 30

---

Task 2: Functions with Return Values
  - Create disk_check.sh with:
  - A function check_disk that checks disk usage of / using df -h
  - A function check_memory that checks free memory using free -h
  - A main section that calls both and prints the results


        #!/bin/bash

        # Function to check disk usage
        check_disk() {
        echo "===== Disk Usage ====="
        df -h /
        }

        # Function to check memory usage
        check_memory() {
        echo "===== Memory Usage ====="
        free -h
        }

        # Main section
        echo "System Resource Report"
        echo

        check_disk
        echo

        check_memory

---

Task 3: Strict Mode — set -euo pipefail
    - Create strict_demo.sh with set -euo pipefail at the top
    - Try using an undefined variable — what happens with set -u?
    - Try a command that fails — what happens with set -e?
    - Try a piped command where one part fails — what happens with set -o pipefail?


       #!/bin/bash

       # Enable strict mode
       set -euo pipefail

       echo "===== Strict Mode Demo ====="

      # -----------------------------
      # 1. Undefined Variable Demo
      # -----------------------------
      echo "Testing undefined variable..."

      echo "$USERNAME"

      # Script will stop here because USERNAME is not defined


       # -----------------------------
        # 2. Command Failure Demo
       # -----------------------------
       echo "Testing command failure..."

       mkdir /tmp/demo-dir
       mkdir /tmp/demo-dir

      # Second mkdir fails because directory already exists
      # Script exits immediately due to set -e


      # -----------------------------
      # 3. Pipe Failure Demo
      # -----------------------------
      echo "Testing pipe failure..."

       cat missingfile.txt | grep "hello"

       # cat fails because file does not exist
       # Due to pipefail, entire pipeline fails and script exits


### Understanding `set -euo pipefail` 
  - Bash Strict Mode.

    1. set -u : echo "$USERNAME"

       - If USERNAME is not defined:
       - Without set -u :(empty output)
       - With set -u :./strict_demo.sh: line 12: USERNAME: unbound variable. (Script stops immediately).
   
    2. set -e : Stops script if any command fails.
   
    3. set -o pipefail

        - cat missing.txt | grep hello
        - here Bash only checks last command (grep).
        - without pipefail: pipeline may appear successful.
        - with pipefail: if any command fails - whole pipeline fails.
        - cat: missingfile.txt: No such file or directory.
      
---



