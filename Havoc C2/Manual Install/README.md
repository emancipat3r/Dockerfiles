
```bash
----> BUILDING THE CLIENT
# Install aptitude because it's better at resolving dependencies
apt-get install -y aptitude

# Install Havoc C2 & Python 3.10 requirements
aptitude install -y git build-essential apt-utils cmake libfontconfig1 libglu1-mesa-dev libgtest-dev libspdlog-dev libboost-all-dev libncurses5-dev libgdbm-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev libbz2-dev mesa-common-dev qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools libqt5websockets5 libqt5websockets5-dev qtdeclarative5-dev golang-go qtbase5-dev libqt5websockets5-dev libspdlog-dev python3-dev libboost-all-dev mingw-w64 nasm zlib1g-dev libnss3-dev wget

# Download Python 3.10
wget https://www.python.org/ftp/python/3.10.0/Python-3.10.0.tgz

# Extract Python 3.10 and move into the extracted directory
tar -xvf Python-3.10.0.tgz
cd Python-3.10.0

# Configure and compile Python 3.10 the source code
./configure --enable-optimizations
make -j$(nproc)

# Install the compiled Python 3.10
make altinstall

# Modify /opt/Havoc/Client/CMakeLists.txt with the following
target_link_libraries(
        ${PROJECT_NAME}
        ${REQUIRED_LIBS_QUALIFIED}
        ${PYTHON_LIBRARIES}
        ${CMAKE_DL_LIBS}
        util
        # ${Boost_LIBRARIES}
        spdlog::spdlog
        spdlog::spdlog_header_only
)

# Compile Havoc C2 Client
make

----> BUILDING THE TEAMSERVER
# Navigate into Teamserver directory
cd /opt/Havoc/Teamserver

# Install Go dependencies
go mod download golang.org/x/sys  
go mod download github.com/ugorji/go

# Install MUSL C Compiler
./Install.sh

# Install Go version 1.18
## Download Go 1.18
wget https://go.dev/dl/go1.18.1.linux-amd64.tar.gz

## Extract the Go archive
tar -C /usr/local -xzf go1.18.1.linux-amd64.tar.gz

## Add the Go binary directory to your $PATH variable by adding the following line to your ~/.profile or ~/.bashrc file
export PATH=$PATH:/usr/local/go/bin

## Remove old Go binary
rm -f /bin/go

# Compile Teamserver binary
make

----> START TEAMSERVER
# Run Teamserver
./teamserver server --profile ./profiles/havoc.yaotl -v

# Run Client
./Havoc

----> TEAMSERVER DEFAULT CREDENTIALS
user "5pider" OR "Neo"
Password = "password1234"
```