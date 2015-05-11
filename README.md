# kvm-host
My custom "lightweight" kvm/debian host with tons of cli/ncurses awesomness

# Installation (run as root)
apt-get install ca-certificates && wget --no-cache -O- https://raw.githubusercontent.com/borestad/kvm-host/master/bootstrap.sh | /bin/bash

This should result in a fancy hybrid KVM host ~ 1.5GB of disk space and minimal resources (~110 Mb RAM)

# Useful software included

## Cli tools
    - sudo 
    - bash-completion 
    - cdu
    - dfc
    - silversearcher-ag
    - curl

## ncurses tools
    - htop 
    - ncdu 
    - mc 
    - network-manager 
    - aptitude
    - node.js
    - vtop
    - Glances

## Programming languages
    - node.js 0.12 & npm (latest)
    - Python & python-pip

## Daemons / Services
    - libvirtd (qemu-kvm)
    - webmin

## Cleanup
    - Removing unneeded services like ipv6, bluetooth, modemmanager

This script can be run multiple times in a row and won't clutter the system
