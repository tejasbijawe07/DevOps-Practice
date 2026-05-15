## Networking Fundamentals and Hands-on

1. OSI Model vs TCP/IP Model

7 layers:

| OSI Layer       | What it Does                   | Real Example      |
| --------------- | ------------------------------ | ----------------- |
| 7. Application  | User-facing network apps       | Browser, SSH, DNS |
| 6. Presentation | Data formatting/encryption     | SSL/TLS, JPEG     |
| 5. Session      | Maintains sessions/connections | Login session     |
| 4. Transport    | Reliable communication         | TCP, UDP          |
| 3. Network      | Routing between networks       | IP addressing     |
| 2. Data Link    | MAC addressing inside LAN      | Ethernet, Switch  |
| 1. Physical     | Actual cables/signals          | Wi-Fi, Fiber, NIC |


         Application Layer
          ├── HTTP / HTTPS
          ├── DNS
          └── SSH

         Transport Layer
          ├── TCP
          └── UDP

         Internet/Network Layer
          └── IP

         Network Access Layer
          └── Ethernet / Wi-Fi


| TCP/IP Layer   | Maps to OSI | Example         |
| -------------- | ----------- | --------------- |
| Application    | OSI 5–7     | HTTP, DNS, SSH  |
| Transport      | OSI 4       | TCP, UDP        |
| Internet       | OSI 3       | IP, ICMP        |
| Network Access | OSI 1–2     | Ethernet, Wi-Fi |


2. Networking commands

  - check route paths

        traceroute google.com

    Shows:
    Every hop/router between destination.

  - Test Port Connectivity: Using nc (netcat)

        nc -zv google.com 443

    Tests if port is reachable

  - curl http request
    
        curl -I https://google.com

    Shows:
    HTTP headers
    Response status


| Task          | Command            |
| ------------- | ------------------ |
| IP address    | `ip addr`          |
| Connectivity  | `ping`             |
| DNS lookup    | `dig`              |
| Route path    | `traceroute`       |
| Port test     | `nc -zv host port` |
| HTTP test     | `curl -I`          |
| Open ports    | `ss -tulnp`        |
| Routing table | `ip route`         |

---

- IP
  
  Responsible for routing packets between systems
  Every machine has an IP address
  Example:
  192.168.1.10

 - TCP

   Reliable connection
   Guarantees packet delivery and order

   Used by:
   HTTPS, SSH, FTP

 - UDP
   
   Faster but unreliable
   No guarantee of delivery
   Used by:
   DNS, Video streaming
   
 - DNS

   Converts domain names to IP addresses
   Example:
   google.com → 142.250.x.x


Example:

    curl https://example.com
    
    curl
      ↓
    HTTPS request(Application Layer)
      ↓
    TCP connection on port 443(Transport Layer)
      ↓
    IP routes packets to destination(Internet Layer)
      ↓
    Ethernet/Wi-Fi sends bits physically(Network Access Layer)


- HTTPS is an Application Layer protocol that runs over TCP, which runs over IP.

- DNS is an Application Layer protocol that usually uses UDP on port 53 over IP.
