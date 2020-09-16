#!/bin/bash

# Author: Abdul Azeez Omar
# File: build.sh
# Purpose: This is a builder for the whole tool it'll install all dependencies of the project.

## check for the user executing the script if it's a privileged user. All the installation steps require root privilege.
user=`whoami`
if [ $user != "root" ]
then
	echo -e "[-] Permission failure...\nPlease run the build script as root"
	kill $$
fi
echo "[+] Updating..."
sudo apt-get update
echo "[+] Installing git..."
sudo apt-get install git -y # installing git if it's not here already
apt-get install cmake -y    #installing cmake to build needed dependencies
apt install mingw-w64 clang build-essential -y    # installing mingw and clang compilers for linux to build the result EXE file later
echo "[+] Installing wclang project..."
git clone --depth 1 https://github.com/tpoechtrager/wclang.git ~/wclang
cd ~/wclang
cmake -DCMAKE_INSTALL_PREFIX=_prefix_ .
make
make install
cd -
echo "export PATH=$HOME/wclang/_prefix_/bin:$PATH" >> ~/.bashrc
export PATH=$HOME/wclang/_prefix_/bin:$PATH
echo "[+] Installing DONUT project..."
git clone http://github.com/thewover/donut.git ~/donut   #getting donut project
cd ~/donut
make
echo "export PATH=$HOME/donut:$PATH" >> ~/.bashrc
export PATH=$HOME/donut:$PATH
cd -
echo "[+] Installing GOLANG v1.13..."
wget https://dl.google.com/go/go1.13.3.linux-amd64.tar.gz -O ~/golang.tar.gz
cd ~/
apt install tar -y
tar -xvf golang.tar.gz
mv go /usr/local
echo "export GOROOT=/usr/local/go" >> ~/.bashrc
export GOROOT=/usr/local/go
echo "export GOPATH=$HOME/Projects/Proj1" >> ~/.bashrc
export GOPATH=$HOME/Projects/Proj1
echo "export PATH=$GOPATH/bin:$GOROOT/bin:$PATH" >> ~/.bashrc
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
rm ~/golang.tar.gz
cd -
echo "[+] Installing Shikata ga nai v2.0..."   #copying sgn binary in /usr/bin and giving it a execution permission
mv ./sgn /usr/bin
chmod +x /usr/bin/sgn
echo "[+] Done."
