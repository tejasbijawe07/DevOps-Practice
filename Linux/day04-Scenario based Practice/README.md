## Linux Scenario based practice

The du command in Linux stands for:

du = Disk Usage

It is used to check:

 - how much disk space files/folders consume
 - directory sizes
 - storage usage analysis

       du -sh /var/log

       Example o/p:
       1.1G    /var/log

   Largest Files/Folders:

       du -ah /var | sort -rh | head -10

       | Command Part | Purpose                    |
       | ------------ | -------------------------- |
       | `du -ah`     | All files + human readable |
       | `sort -rh`   | Sort largest first         |
       | `head -10`   | Show top 10                |


Find the largest log files/directories inside /var/log:

       du -sh /var/log/* 2>/dev/null | sort -h | tail -5

       Example o/p:
       116K    /var/log/bootstrap.log
       752K    /var/log/syslog

       |Command Part| Meaning                   |
       | ------     | ------------------------- |
       |  `-s`      | Show summary only         |
       |  `-h`      | Human readable (KB/MB/GB) |
       |   `2`      | STDERR                    |
       |   `>`      | Redirect                  |
       | `/dev/null`| Discard o/p               |  --> Some files may require root permission.
       |  | sort -h | Sorts o/p by size         |
       |  | tail -5 | Shows last 5 lines        |


----



