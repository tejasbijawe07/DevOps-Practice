## Linux Practice and Network Troubleshooting commands

1. Basic Network Troubleshooting commands
    - `curl`, `ping`, `wget`, `ip addr`, etc.

2. Run and record output for at least 6 commands:
    - Include 2 process commands (`ps`, `top`, `pgrep`, etc.)
    - Include 2 service commands (`systemctl status`, `systemctl list-units`, etc.)
    - Include 2 log commands (`journalctl -u <service>`, `tail -n 50`, etc.)
    - Pick one service on your system (example: ssh, cron, docker) and inspect it
---
### Networking Commands:

   a. ping- Check connectivity to a host

       ping google.com

   b. ip addr - Show IP address of a system

       ip addr

   c. curl - Send http request/API call

       curl http://example.com

   d. wget - download files from internet

       wget https://example.com/file.zip

   e. hostname - show system hostname

       hostname

   f. dig - DNS lookup

       dig google.com

 Real DevOps Use Cases:
 - App not working → curl localhost:8080
 - Port issue → ss -tulnp
 - DNS issue → dig domain.com
 - Server unreachable → ping
 - Logs analysis → grep error app.log

----

### Linux Practice: Processes and Services
 
 Objective
  - Practice Linux fundamentals with real commands
  - Check running processes
  - Inspect one systemd service
  - Log check


1. Process Commands:

    `ps` - List all running process.
    
       ps -ef
   
       Example o/p:
       UID          PID    PPID  C STIME TTY          TIME CMD
       root           1       0  2 02:37 ?        00:00:01 /sbin/init
       root           2       1  0 02:37 ?        00:00:00 /init

     `top` - Shows CPU memory usage in real time.

       top

       Example o/p:
       PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
       314 dell      20   0    6072   5248   3584 S   0.0   0.1   0:00.04 bash
       315 root      20   0    6688   4096   3584 S   0.0   0.1   0:00.01 login

   `pgrep` - Find process id by name.

     - a. Find pid of a process:

           pgrep bash

           Example o/p:
           314
           421

      - b. Show process name with PID:

            pgrep -l bash

            Example o/p:
            314 bash
            421 bash

   `kill` -     Kill a process.

       kill -9 bash

   
### DevOps Practical Use Case for `Process commands`

Suppose server is slow.

Step 1:

`top`

 we noticed:
 java using 95% CPU
 
Step 2:

Find exact PID:
`pgrep java`

Step 3:

Inspect:
`ps -fp $(pgrep java)`

Step 4:

Take action:
Restart service,
Kill stuck process,
Check logs

---


2. Service Commands(systemd):

   `systemctl list-units` - List all running services.

       systemctl list-units --type=service

       Example o/p:
       console-setup.service                  loaded active exited  Set console font and keymap
       cron.service                           loaded active running Regular background program processing daemon
       dbus.service                           loaded active running D-Bus System Message Bus


    `systemctl list-unit-files` - List all running services including stopped services.

       systemctl list-unit-files --type=service

 `systemctl status` - Check service status

     systemctl status cron

     Example o/p:
     cron.service - Regular background program processing daemon
     Loaded: loaded (/usr/lib/systemd/system/cron.service; enabled; preset: enabled)
     Active: active (running) since Thu 2026-05-07 02:37:37 UTC; 1h 19min ago


`sudo systemctl start ssh` - Start a service.

`sudo systemctl stop ssh` - Stop a service.

`sudo systemctl restart ssh` - Restart a service.

---

3. Log Management commands:

`journalctl -u <service>` - View logs for a service.

    journalctl -u cron

    o/p:
    Apr 23 06:20:06 DESKTOP-T5F9213 systemd[1]: Started cron.service - Regular background program processing daemon.
    Apr 23 06:20:06 DESKTOP-T5F9213 (cron)[189]: cron.service: Referenced but unset environment variable evaluates to an em>
    Apr 23 06:20:06 DESKTOP-T5F9213 cron[189]: (CRON) INFO (pidfile fd = 3)
    Apr 23 06:20:06 DESKTOP-T5F9213 cron[189]: (CRON) INFO (Running @reboot jobs)

`journalctl -u cron -n 50` - Last 50 log lines.

`tail -n 50 /var/log/syslog` - Read log file manually.
