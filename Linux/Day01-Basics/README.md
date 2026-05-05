## Linux Commands, Processes and systemd

Topics Covered:
- The core components of Linux (kernel, user space, init/systemd).
- How processes are created and managed.
- What systemd does.
- Basic Linux commands.
- Basic Networking commands.
-----

## Core Components

1. Kernel-

   The kernel is the core of the OS that directly interacts with hardware.

Responsibilities:
- CPU scheduling (which process runs when)
- Memory management
- Process management


2. User Space-

   Everything outside the kernel runs in user space.

Includes:
- Shell(bash)
- Application (Docker, Jenkins)
- Libraries


3. systemd-

   The first process started by the kernel during boot.

Roles:
- Boots the system
- Starts/Stops services
- Manages system state
- Starts services in parallel (faster boot)

Example:

        systemctl start nginx
        systemctl enable nginx
        systemctl status nginx

## Process States

1. Running (R)

   Process is executing or ready to run
   
2. Sleeping (S/D)

   Waiting for resource (I/O, input)
   Example: waiting for disk read

3. Stopped (T)

   Paused
   
4. Zombie (Z)

   Process finished execution
   But parent hasn't read its exit status

## Real-World Example
If app crashes in Kubernetes node

We check:
1. systemctl status app
2. journalctl -u app
3. ps aux | grep app
4. top --> CPU/memory usage
5. Kill stuck process --> restart service

## Important Basic Linux Commands

File & Directory

1. ls- List files 

        ls -l

2. cd- Change directory

        cd /var/log

3. pwd - Show current directory

         pwd
   
4. mkdir - Create directory
   
        mkdir demo

5. rm - Remove file/directory

        rm -rf demo

   
  File Operations
  
