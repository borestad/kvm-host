#!/bin/sh -e

cd /tmp
apt-get -y install git
rm -rf /tmp/kvm-host

git clone https://github.com/borestad/kvm-host.git
cd kvm-host
./install.sh

