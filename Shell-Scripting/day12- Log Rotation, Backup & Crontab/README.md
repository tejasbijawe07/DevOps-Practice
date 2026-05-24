## Shell Scripting Project: Log Rotation, Backup & Crontab

Task 1: Log Rotation Script

Create log_rotate.sh that:

 - Takes a log directory as an argument (e.g. /var/log/myapp)
 - Compresses .log files older than 7 days using gzip
 - Deletes .gz files older than 30 days
 - Prints how many files were compressed and deleted
 - Exits with an error if the directory doesn't exist


log_rotate.sh


    #!/bin/bash

    # log_rotate.sh

    # Exit if no argument provided
    if [ $# -ne 1 ]; then
       echo "Usage: $0 <log-directory>"
       exit 1
    fi

    LOG_DIR="$1"

    # Check if directory exists
    if [ ! -d "$LOG_DIR" ]; then
       echo "Error: Directory '$LOG_DIR' does not exist."
       exit 1
    fi

    # Compress .log files older than 7 days
    compressed_count=0

    while IFS= read -r file; do
        gzip "$file"

        if [ $? -eq 0 ]; then
           ((compressed_count++))
        fi
    done < <(find "$LOG_DIR" -type f -name "*.log" -mtime +7)

    # Delete .gz files older than 30 days
    deleted_count=0

    while IFS= read -r file; do
       rm -f "$file"

       if [ $? -eq 0 ]; then
        ((deleted_count++))
       fi
    done < <(find "$LOG_DIR" -type f -name "*.gz" -mtime +30)

    # Print summary
    echo "Log rotation completed."
    echo "Files compressed: $compressed_count"
    echo "Files deleted: $deleted_count"


Understanding the script:

1. Check if arguments is passed
  - $# : Stores the number of arguments passed to the script.
  - -ne : not equal
  - $0 : Represents the script name itself.


2. Stores argument in a variable
  - LOG_DIR="$1" : $1 represents the first argument passed.


3. Check if directory exists
   - -d : Checks whether path is a directory.
   - ! : means NOT, so if this directory does not exists.
  

4. Initialize counter
   - compressed_count=0 : creates a counter to count compressed files.
  
5. Find old log files
   - find "$LOG_DIR" -type f -name "*.log" -mtime +7
        - find - Searches files/directories.
        - "$LOG_DIR" - Search inside this directory.
        - -type f - Only find regular files.
        - -name "*.log" - Find files ending with .log
        - -mtime +7 - Find files modified more than 7 days ago.
    

6. Process each file using while loop
   - while IFS= read -r file; do : This reads each file one by one from the find output.
        - IFS - Prevents trimming spaces.
        - read -r - Reads raw input safely.
    

7. Compress file
   - gzip "$file"
   - compresses app.log into app.log.gz
  
8. Check if gzip succeeded
   - if [ $? -eq 0 ]
   - $? : Stores exit status of previous command.


---

Task 2:
