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
