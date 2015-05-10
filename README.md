# kvm-host
My custom "lightweight" kvm/debian host with tons of cli/ncurses awesomness

# Installation (run as root)
apt-get install ca-certificates && wget --no-cache -O- https://raw.githubusercontent.com/borestad/kvm-host/master/bootstrap.sh | /bin/bash

This should result in a fancy hybrid KVM host ~ 1.5GB of disk space and minimal resources (~110 Mb RAM)

This script can be run multiple times in a row and won't clutter the system
