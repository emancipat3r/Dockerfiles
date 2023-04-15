# WITHOUT NETWORK

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
```

> Don't forget to expose any necessary ports if you need to access the services remotely. Add `-p <host-port>:<container-port>` to the docker run commands as needed.

# CONSIDERING NETWORKING AND ACCESSING GUI
Since the Havoc Client requires the Teamserver to be running and accessible, you will need to ensure proper networking between the two containers. Docker provides a few different networking options, but the most straightforward one in this case is to create a custom network and attach both containers to it. This will allow the containers to communicate with each other using their container names as hostnames.

Here are the steps to create a custom network and run the containers:

1. Create a custom Docker network:

```bash
sudo docker network create havoc-network
```

2. Run the Havoc Client container and attach it to the custom network:

```bash
sudo docker run -d --name havoc-client --network havoc-network havoc-client
```

3. Run the Havoc Teamserver container and attach it to the custom network:

```bash
sudo docker run -d --name havoc-teamserver --network havoc-network havoc-teamserver
```

Now, the Havoc Client container should be able to connect to the Teamserver container using the hostname havoc-teamserver. You might need to modify the Havoc Client configuration to use this hostname instead of localhost.

Regarding the GUI, running GUI applications inside Docker containers can be a bit more complicated, as it requires forwarding the X server connection from the container to the host. If you need to access the GUI for the Havoc Client, you can consider the following options:

    Run the Havoc Client locally on your host system and connect it to the Teamserver running inside the Docker container. You'll need to expose the Teamserver's port to the host when running the container using -p <host-port>:<container-port>.

    Forward the X server connection from the Havoc Client container to your host. This approach requires some additional configuration on both the host and the container. Here's a general outline of the steps you need to follow:

        Install the necessary X server-related packages in your Havoc Client Dockerfile:

        arduino

RUN apt-get install -y xorg xauth

Update the Havoc Client Dockerfile to include the ENV instruction for the DISPLAY variable:

css

ENV DISPLAY :0

Build the Havoc Client Docker image with the updated Dockerfile.

Enable X server access control on your host system:

xhost +

Run the Havoc Client container with the DISPLAY environment variable and necessary volume mounts:

css

        sudo docker run -d --name havoc-client --network havoc-network -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix havoc-client

    Note that this approach may have security implications, as it allows any user on your host system to connect to your X server. Make sure to revoke the access permissions when you're done using the GUI by running xhost -.

Keep in mind that running GUI applications inside Docker containers is not a common use case and might require additional troubleshooting and configuration. You may also face issues with graphics performance, depending on your host's configuration.
