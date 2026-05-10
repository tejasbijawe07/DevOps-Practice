## Cloud Server Setup: Docker, Nginx & Web Deployment

Deploy a real web server on the cloud and learn practical server management.
   - Launch a cloud instance (AWS EC2)
   - Connect via SSH
   - Install Nginx
   - Configure security groups for web access (port 80 by default for nginx)
   - Extract and save logs to a file
   - Verify if webpage is accessible from the internet

---

### Part 1: Launch Cloud Instance & SSH Access

   - Step 1: Create a cloud instance
      -->In AWS, a virtual server is called an EC2 Instance.
     
       - Click Launch Instance
       - Configure: Name → First-cloud-server ; AMI → Ubuntu Server
       - Create a key pair: myKey.pem
       - In Network Settings → Allow SSH (Port 22) from IP
     
        <img width="1910" height="362" alt="AWSInstance" src="https://github.com/user-attachments/assets/4a6f7868-defb-47ac-ba40-738c97d982ef" />

   
       - Allow SSH traffic from → My IP
       - Port 22 (SSH) - only for SSH access, not for opening the NGINX website in browser.
       
              -  With this we can:
   
                   - SSH into server
                   - Install NGINX
                   - Start/stop services
                   - Download logs
                   - View logs from terminal
      
              - But we cannot open the NGINX webpage in browser because:
         
                   - Web traffic uses: Port 80 (HTTP) ; Port 443 (HTTPS)
                   - So, select option Anywhere (0.0.0.0/0)



     | Type | Port | Source  |
     | ---- | ---- | ------- |
     | SSH  |  22  | Your IP |
     | HTTP  | 80  | Anywhere|
     | HTTPS | 443 | Anywhere|


   
   - Step 2: Connect via SSH

      What is SSH?

      -->SSH = Secure Shell
     It is a secure protocol used to:

        - Connect to remote Linux servers
        - Execute commands remotely
        - Transfer files securely


      SSH using Ubuntu WSL:

            Change directory to the downloaded key pem file
             cd /mnt/c/Users/DELL/Downloads

             Permission to PEM File
             chmod 400 myKey.pem  (Owner can read ; Others cannot access)

             Connect to Server
             ssh -i myKey.pem ubuntu@65.0.4.144

     Useful ssh commands:

            Check server hostname
            hostname

            Check OS
            cat /etc/os-release

     Flow Summary:

            Windows Machine
                  ↓
         SSH Client (PowerShell / Ubuntu WSL)
                  ↓
               Internet
                  ↓
         AWS EC2 Linux Server

### Part 2: Install Docker & Nginx

   - Step 1: Update System
     
         - Update Package list
           sudo apt update

         - Upgrade installed Packages
           sudo apt upgrade -y

   - Step 2: Install Docker

         - Install docker
           sudo apt install docker.io -y

         - Start docker service
           sudo systemctl start docker

         - Enable docker at boot
           sudo systemctl enable docker

         - Verify docker
           docker --version

         - Check docker service
           sudo systemctl status docker


  - Step 3: Install Nginx

           - Install Nginx
             sudo apt install nginx -y

  - Step 4: Verify Nginx is running

            - Check status:
               sudo systemctl status nginx

   - Step 5: Open Nginx web page
    
              http://65.0.4.144

           <img width="1692" height="792" alt="NginxHomePage" src="https://github.com/user-attachments/assets/57000f61-c26b-4f82-93a2-f518a3e36834" />


### Part 3: Extract Nginx Logs

   - Step 1: View Nginx logs

            | Log Type    | Path                        |
            | ----------- | --------------------------- |
            | Access Logs | `/var/log/nginx/access.log` |
            | Error Logs  | `/var/log/nginx/error.log`  |

            - View Access logs
               sudo cat /var/log/nginx/access.log

            - Watch logs live (New request appearing live)
               sudo tail -f /var/log/nginx/access.log

  - Step 2: Save logs to file

            - Save access logs
               sudo cp /var/log/nginx/access.log ~/nginx-access.log

            - Verify files
               ls -l ~/*.log

  - Step 3: Download Log file to local

             Run command from:
             Ubuntu WSL and not inside EC2.

                scp -i ~/.ssh/myKey.pem ubuntu@65.0.4.144:~/nginx-access.log .

             - Verify
                ls

       Useful linux log commands

            Last 20 lines
              tail -20 /var/log/nginx/access.log

            Search errors
              grep "404" /var/log/nginx/access.log

---

  DevOps Usecase:

         | Scenario       | Why Logs Matter          |
         | -------------- | ------------------------ |
         | Website down   | Check error logs         |
         | High traffic   | Analyze access logs      |
         | Security issue | Detect suspicious IPs    |
         | Debugging      | Identify failed requests |
         | Monitoring     | Observe user activity    |


   Workflow:

        EC2 → SSH → Nginx → Logs → SCP Download

