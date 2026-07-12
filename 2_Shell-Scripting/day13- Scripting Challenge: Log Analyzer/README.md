## Bash Scripting Challenge: Log Analyzer

Task 1: Input and Validation

 - Accept the path to a log file as a command-line argument
 - Exit with a clear error message if no argument is provided
 - Exit with a clear error message if the file doesn't exist


log_analyzer.sh:

    #!/bin/bash

    # Script Name: log_analyzer.sh

    # Check if log file path argument is provided
    if [ $# -eq 0 ]; then
         echo "Error: No log file provided."
         echo "Usage: $0 <log_file_path>"
        exit 1
    fi

    # Store argument in variable
    LOG_FILE="$1"

    # Check if file exists
    if [ ! -f "$LOG_FILE" ]; then
         echo "Error: File '$LOG_FILE' does not exist."
        exit 1
    fi

    echo "Log file '$LOG_FILE' found successfully."


Understanding the script:

   - `if [ $# -eq 0 ] ` - Checks whether no arguments were passed.
   - `"$1"` - First command-line argument (log file path).
   - `-f` - Checks if the given file exists and is a regular file.
   - `exit 1` - Exits the script with an error status.

---

Task 2: Error Count

 - Count the total number of lines containing the keyword ERROR or Failed
 - Print the total error count to the console

log_analyzer.sh:

       # Count lines containing ERROR or Failed
       ERROR_COUNT=$(grep -Ei "ERROR|Failed" "$LOG_FILE" | wc -l)

       # Print total error count
       echo "Total Error Count: $ERROR_COUNT"


Understanding the script:

  - `grep` - Searches text in the file.
  - `-Ei` - Enables extended regex (ERROR|Failed).
  - `-i` - Case insensitive matching.
  - `ERROR|Failed` - Matches either keyword.
  - `wc -l` - counts the number of matching line.

---

Task 3: Critical Events

 - Search for lines containing the keyword CRITICAL
 - Print those lines along with their line number

log_analyzer.sh:

       # Search for CRITICAL events with line numbers
       echo "Critical Events:"
       CRITICAL_COUNT= $(grep -c "CRITICAL" "$LOG_FILE")

       if [ "$CRITICAL_COUNT" -eq 0 ]; then
           echo "0"
       else
           grep -n "CRITICAL" "$LOG_FILE"
       fi


Understanding the script:

   - `-c` - counts matching lines.
   - `grep` - Searches text in the file
   - `-n` - Displays matching line numbers
   - `CRITICAL` - Keyword to search

---

Task 4: Top Error Messages

  - Extract all lines containing ERROR
  - Identify the top 5 most common error messages
 - Display them with their occurrence count, sorted in descending order


 log_analyzer.sh:

     # Top 5 most common ERROR messages
     echo "Top 5 Error Messages:"

    TOP_ERRORS=$(grep "ERROR" "$LOG_FILE" | \
    sort | \
    uniq -c | \
    sort -nr | \
    head -5)


Understanding the script:

  - `sort` - Sorts lines so duplicate messages come together.
  - `uniq -c` - Counts occurrences of duplicate lines.
  - `sort -nr` - -n: Numeric sort; -r: Descending order.
  - `head -5` - Displays only the top 5 results.  
