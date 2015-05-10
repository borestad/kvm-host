#!/bin/sh -e

cd /

apt-get -y install git
rm -rf /tmp/kvm-host
git clone https://github.com/borestad/kvm-host.git /tmp/kvm-host
/tmp/kvm-host/install.sh

