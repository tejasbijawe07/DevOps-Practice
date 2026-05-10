## Cloud Server Setup: Docker, Nginx & Web Deployment

Deploy a real web server on the cloud and learn practical server management.
   - Launch a cloud instance (AWS EC2)
   - Connect via SSH
   - Install Nginx
   - Configure security groups for web access (port 80 by default for nginx)
   - Extract and save logs to a file
   - Verify if webpage is accessible from the internet
---

Part 1: Launch Cloud Instance & SSH Access

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
             ssh -i myKey.pem ubuntu@13.233.xx.xx
