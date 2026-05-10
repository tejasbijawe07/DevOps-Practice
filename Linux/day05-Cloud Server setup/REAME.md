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

Step 1: Create a cloud instance
      -->In AWS, a virtual server is called an EC2 Instance.
     
  - Click Launch Instance
  - Configure: Name → First-cloud-server ; AMI → Ubuntu Server
  - Create a key pair: myKey.pem
  - In Network Settings → Allow SSH (Port 22) from IP





Step 2: Connect via SSH

  What is SSH?

-->SSH = Secure Shell

It is a secure protocol used to:

  - Connect to remote Linux servers
  - Execute commands remotely
  - Transfer files securely

