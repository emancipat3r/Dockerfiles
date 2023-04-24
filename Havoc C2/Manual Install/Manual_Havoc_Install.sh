#!/bin/bash

start_time=$(date +%s)

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

echo -e "\n======================================="
echo "#        BUILDING CLIENT              #"
echo "======================================="

echo -e "Step 1.1: Downgrading libvulkan1"
apt-get install -y --allow-downgrades libvulkan1=1.2.162.0-1 libhwloc15=2.4.1+dfsg-1 libnss3=2:3.61-1+deb11u3 libnspr4-dev=2:4.29-1 libnspr4=2:4.29-1

echo -e "\n\n\nStep 1.2: Installing Havoc C2 & Python 3.10 requirements"
apt-get install -y git build-essential apt-utils cmake libfontconfig1 libglu1-mesa-dev libgtest-dev libspdlog-dev libboost-all-dev libncurses5-dev libgdbm-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev libbz2-dev mesa-common-dev qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools libqt5websockets5 libqt5websockets5-dev qtdeclarative5-dev golang-go libqt5websockets5-dev libspdlog-dev python3-dev libboost-all-dev mingw-w64 nasm zlib1g-dev libnss3-dev wget libvulkan-dev

echo -e "\n\n\nStep 1.3: Downloading Python 3.10"
wget https://www.python.org/ftp/python/3.10.0/Python-3.10.0.tgz

echo -e "\n\n\nStep 1.4: Extracting Python 3.10 and moving into the extracted directory"
tar -xvf Python-3.10.0.tgz
cd Python-3.10.0

echo -e "\n\n\nStep 1.5: Configuring and compiling Python 3.10 source code"
./configure --enable-optimizations
make -j$(nproc)

echo -e "\n\n\nStep 1.6: Installing the compiled Python 3.10"
make altinstall

echo -e "\n\n\nStep 1.7: Preparing for git clone"
cd /opt
git clone https://github.com/HavocFramework/Havoc.git
cd Havoc/Client

echo -e "\n\n\nStep 1.8: Modifying /opt/Havoc/Client/CMakeLists.txt"
sed -i '/${Boost_LIBRARIES}/a \        ${CMAKE_DL_LIBS}\n        util' /opt/Havoc/client/CMakeLists.txt

echo -e "\n\n\nStep 1.9: Compiling Havoc C2 Client"
make

echo -e "\n======================================="
echo "#        BUILDING TEAMSERVER          #"
echo "======================================="

echo -e "Step 2.1: Navigating into Teamserver directory"
cd /opt/Havoc/Teamserver

echo -e "\n\n\nStep 2.2: Installing Go dependencies"
go mod download golang.org/x/sys  
go mod download github.com/ugorji/go

echo -e "\n\n\nStep 2.3: Installing MUSL C Compiler"
./Install.sh


echo -e "\n\n\nStep 2.4: Installing Go version 1.18"
wget https://go.dev/dl/go1.18.1.linux-amd64.tar.gz
tar -C /usr/local -xzf go1.18.1.linux-amd64.tar.gz
echo "export PATH=$PATH:/usr/local/go/bin" >> /root/.bashrc
source /root/.bashrc
rm -f /bin/go


echo -e "\n\n\nStep 2.5: Compiling Teamserver binary"
# Using absolute path of new version of Go because source /root/.bashrc only sets the env variable for the script process
# Editing the makefile to account for this absolute path
sed -i 's#^GOCMD.*#GOCMD\t= /usr/local/go/bin/go#' /opt/Havoc/Teamserver/makefile
cd /opt/Havoc && make                      

if [ -f /opt/Havoc/teamserver/teamserver ]; then
  echo -e "\n======================================="
  echo "#        INSTALLATION COMPLETE        #"
  echo "======================================="
  echo -e "\n[-] Run the teamserver"
  echo -e '\t./teamserver server --profile ./profiles/havoc.yaotl -v'

  echo -e '\n[-] Run the client (needs to be run as non-root user)'
  echo -e '\t./Havoc'

  echo -e '\n[-] Credentials'
  echo -e '\tUSER: 5pider OR Neo'
  echo -e '\tPASS: password1234'
  end_time=$(date +%s)
  time_elapsed=$((end_time - start_time))
  minutes=$((time_elapsed / 60))
  seconds=$((time_elapsed % 60))
  echo -e "\n[-] Installation completed in $minutes minutes $seconds seconds"
  echo '[-] Please run 'source ~/.bashrc' in your terminal to update the environment variables if you need Go'
else
  echo "[-] Install failed
fi