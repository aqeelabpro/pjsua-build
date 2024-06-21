#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Download and extract PJProject
cd /usr/src/
wget https://github.com/pjsip/pjproject/archive/refs/tags/2.14.1.tar.gz
tar xvf 2.14.1.tar.gz
cd pjproject-2.14.1/

# Configure PJProject with PIC flag, build dependencies, and compile
./configure CFLAGS="-fPIC"
make dep
make

# Install SWIG
apt-get update
apt-get install -y swig

# Build and install PJProject Java bindings
cd pjsip-apps/src/swig/java
make
make install

# Add Corretto key and repository
wget -O - https://apt.corretto.aws/corretto.key | sudo gpg --dearmor -o /usr/share/keyrings/corretto-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/corretto-keyring.gpg] https://apt.corretto.aws stable main" | sudo tee /etc/apt/sources.list.d/corretto.list

# Update package list and install Amazon Corretto JDK
sudo apt-get update
sudo apt-get install -y java-19-amazon-corretto-jdk

# Done
echo "PJProject and Amazon Corretto JDK installation completed."
