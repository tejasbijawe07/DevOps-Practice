## Bash Scripting Challenge: Log Analyzer



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
