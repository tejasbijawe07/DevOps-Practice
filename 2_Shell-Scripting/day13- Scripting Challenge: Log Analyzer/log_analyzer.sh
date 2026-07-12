#!/bin/bash

#Script name: log_analyzer.sh

#Check if log file path argument is provided

if [ $# -eq 0 ]; then
    echo "Error: No log file provided."
    echo "Usage: $0 <log_file_path>"
    exit 1
fi

# Storage argument in variable
LOG_FILE="$1"

#Check if file exists
if [ ! -f  "$LOG_FILE" ]; then
   echo "Error: File '$LOG_FILE' does not exist."
   exit 1
fi

echo "Log file '$LOG_FILE' found successfully."



# Count lines containing ERROR or FAILED
ERROR_COUNT=$(grep -Ei "ERROR|Failed" "$LOG_FILE" | wc -l)

# Print total error count
echo "Total Error Count: $ERROR_COUNT"

# Search for CRITICAL events with line number

echo "Critical Events:"
CRITICAL_COUNT=$(grep -c "CRITICAL" "$LOG_FILE")

if [ "$CRITICAL_COUNT" -eq 0 ]; then
    echo "0"
else 
     grep -n "CRITICAL" "LOG_FILE"
fi

#Top 5 most common ERROR messages
echo "Top 5 Error messages:"

grep "ERROR" "$LOG_FILE" | \
sort | \
uniq -c | \
sort -nr | \
head -5
