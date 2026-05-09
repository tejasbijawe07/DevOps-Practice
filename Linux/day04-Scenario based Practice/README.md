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

Scenario 1: Service Not Starting

    A web application service called 'nginx' failed to start after a server reboot.
    What commands would you run to diagnose the issue?


 Step 1: Check service status

     systemctl status nginx
     
   Why?: It shows if the service is active, failed, or stopped.

 Step 2: If service not found, list all services

     systemctl list-units --type=service

   Why?: To check what services exist on the system.

 Step 3: Check the logs

    journalctl -u nginx -n 50

   Why?: It shows the last 50 log entries.

 Step 4: Check if service is enabled to start on boot

    systemctl is-enabled nginx

   Why?: To know if it will start automatically after reboot.

---

 Scenario 2: High CPU Usage

    Your manager reports that the application server is slow.
    You SSH into the server. What commands would you run to identify
    which process is using high CPU?

  Step 1: List the processes

     top

  Why?: To check different processes and their live CPU usages.

  Step 2: Sort the processes by CPU usage

    ps aux --sort=-%cpu | head -10

     | Commands       | Meaning                                         |
     | ------         | ----------------------------                    |
     | `ps aux`       | Lists all running processes                     |
     | `--sort=-%cpu` | Sort processes by CPU usage in descending order,
                        - means descending,
                        %cpu means sort using CPU usage                 |
     | `| head -10`   | Show only first 10 lines.                       |
  
  Why?: Shows top CPU-consuming processes.

---

Scenario 3: Finding Service Logs

    A developer asks: "Where are the logs for the 'docker' service?"
    The service is managed by systemd.
    What commands would you use?
