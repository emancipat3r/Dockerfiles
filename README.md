```bash
# 1. Create Havoc Docker network
sudo docker network create havoc-network

# 2. Build the Havoc Client Docker image:
sudo docker build -t havoc-client -f /path/to/Havoc_Client .

# 3. Build the Havoc Teamserver Docker image:
sudo docker build -t havoc-teamserver -f /path/to/Havoc_Teamserver .

# 4. Run the Havoc Client container:
sudo docker run -d --name havoc-client --network havoc-network -p 5900:5900 havoc-client

# 5. Run the Havoc Teamserver container:
sudo docker run -d --name havoc-teamserver --network havoc-network -p 40056:40056 havoc-teamserver

# 6. Connect to havoc-client container's VNC server to gain access to the C2 panel
vncviewer <Docker_host_IP>:5900
```