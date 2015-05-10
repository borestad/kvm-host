#!/bin/sh -e

apt-get -y install git
rm -rf /tmp/kvm-host && cd /tmp && git clone https://github.com/borestad/kvm-host.git
./install.sh
