#!/bin/sh -e

apt-get install git
rm -rf /tmp/kvm-host && git clone https://github.com/borestad/kvm-host.git
./install.sh
