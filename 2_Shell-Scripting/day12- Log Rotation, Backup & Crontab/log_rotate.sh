#!/bin/bash

#Exits if no argument provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <log-directory>"
    exit 1
fi

LOG_DIR="$1"


#Check if directory exists
if [ ! -d "$LOG_DIR" ]; then
    echo "Error: Directory '$LOG_DIR' does not exist."
    exit 1
fi


#Compress .log files older than 7 days
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

    if [$? -eq 0 ]; then
        ((deleted_count++))
    fi
done < <(find "$LOG_DIR" -type f -name "*.gz" -mtime +30)

#Print summary
echo "Log rotation completed"
echo "Files compressed: $compressed_count"
echo "Files deleted: $deleted_count"


