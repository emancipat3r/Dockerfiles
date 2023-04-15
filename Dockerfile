# DESCRIPTION:  Create Havoc C2 Client and Teamserver in a container 

# Start from a Kali Linux base image
FROM kalilinux/kali-rolling

# Set working directory to /opt
WORKDIR /opt

# Update packages
RUN apt-get update -y && apt-get upgrade -y && apt-get dist-upgrade -y && \
    apt-get -y autoremove && apt-get clean

# Install dependencies
RUN apt-get install -y git build-essential apt-utils cmake libfontconfig1 libglu1-mesa-dev libgtest-dev libspdlog-dev libboost-all-dev libncurses5-dev libgdbm-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev libbz2-dev mesa-common-dev qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools libqt5websockets5 libqt5websockets5-dev qtdeclarative5-dev golang-go qtbase5-dev libqt5websockets5-dev libspdlog-dev python3-dev libboost-all-dev mingw-w64 nasm python3-dev python3.10-dev libpython3.10 libpython3.10-dev python3.10

# Clone the repository
RUN git clone https://github.com/HavocFramework/Havoc.git /opt

# Build Havoc Client
RUN cd /opt/Havoc/Client && \
    make

# Build Havoc Teamserver
RUN cd /opt/Havoc/Teamserver && \
    go mod download golang.org/x/sys  && \
    go mod download github.com/ugorji/go && \
    sh -c "./Install.sh" && \
    make
