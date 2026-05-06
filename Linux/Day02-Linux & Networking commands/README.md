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

    

     
