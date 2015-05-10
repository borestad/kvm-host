#!/bin/sh -e

cd /
rm -r /etc/environment
sh -c "echo 'LC_ALL=en_US.UTF-8\nLANG=en_US.UTF-8' >> /etc/environment"

apt-get -y install git
rm -rf /tmp/kvm-host
git clone https://github.com/borestad/kvm-host.git /tmp/kvm-host
/tmp/kvm-host/install.sh

