#!/bin/sh -e

# Update & cleanup
apt-get update

rm -rfv /tmp/bootstrap
apt-get install curl

curl https://raw.githubusercontent.com/LuRsT/hr/master/hr > /usr/local/bin/hr
chmod +x /usr/local/bin/hr


# sh -c "echo 'LC_ALL=en_US.UTF-8\nLANG=en_US.UTF-8' >> /etc/environment"

# As root (su)

hr; echo "Installing global system tools"; hr
apt-get -y install aptitude
aptitude update
aptitude -y install sudo htop bash-completion ncdu mc network-manager

hr; echo "Install dfc"; hr
aptitude -y install cmake gettext
mkdir -p /tmp/bootstrap/dfc && cd /tmp/bootstrap/dfc
wget http://projects.gw-computing.net/attachments/download/467/dfc-3.0.5.tar.gz
tar xvf dfc-3.0.5.tar.gz
cd dfc-3.0.5/
mkdir build
cd build/
cmake ..
make
make install
rm -rf /tmp/dfc
# aptitude -y purge cmake gettext

hr; echo "Install cdu"; hr
mkdir -p /tmp/bootstrap/cdu && cd /tmp/bootstrap/cdu
wget http://arsunik.free.fr/pkg/cdu-0.37.tar.gz
tar xvf cdu-0.37.tar.gz
cd cdu-0.37
make install
rm -rf /tmp/cdu

hr; echo "Installing node"; hr
cd /
curl -sL https://deb.nodesource.com/setup_0.12 | bash -
cd /
apt-get -y install nodejs
npm install -g npm


hr; echo "Installing more awesome sysadmin tools"; hr
npm install -g vtop

# Pip
hr; echo "Installing python pip"; hr
mkdir -p /tmp/bootstrap/get-pip && cd /tmp/bootstrap/get-pip
wget https://raw.github.com/pypa/pip/master/contrib/get-pip.py
python get-pip.py

#/usr/local/bin/pip install --upgrade Glances
hr; echo "Installing Glances"; hr
curl -L http://bit.ly/glances | /bin/bash

cd /
#curl -L http://bit.ly/glances | /bin/bash

hr; echo "Installing libvirt / KVM"; hr
aptitude -y install qemu-kvm libvirt-bin

hr; echo "Installing webmin"; hr
rm -vf /etc/apt/sources.list.d/webmin.list

# Create a new webmin.list
tee /etc/apt/sources.list.d/webmin.list > /dev/null <<'_EOF_'
deb http://download.webmin.com/download/repository sarge contrib
deb http://webmin.mirror.somersettechsolutions.co.uk/repository sarge contrib
_EOF_

# Install
cd /root
rm -f jcameron-key.asc
wget http://www.webmin.com/jcameron-key.asc
apt-key add jcameron-key.asc

aptitude update
aptitude -y install webmin

# hr; echo "Web terminal"; hr

hr; echo "Cleanup apt packages"; hr
apt-get clean
apt-get autoclean
apt-get autoremove

hr; echo "Remove unnecessary locale files"; hr
rm -rfv /usr/share/man/??
rm -rfv /usr/share/man/??_*

# Manually delete all but en_US locales
find /usr/share/locale -maxdepth 1 -mindepth 1 -type d | grep -v -e "en_US" | xargs rm -rf

# Delete unused locales from local-archive
# localedef --list-archive | grep -v -e "en_US" | xargs localedef --delete-from-archive
# mv /usr/lib/locale/locale-archive /usr/lib/locale/locale-archive.tmpl
# dpkg-reconfigure locales

hr; echo "Remove ipv6 files"; hr
rm -rvf /lib/xtables/libip6t_*

hr; echo "Remove translations"; hr
# http://oneofmanyworlds.blogspot.se/2012/02/debian-wheezy-removing-unused-locales.html

hr; echo "Disable unneded services"; hr
systemctl disable bluetooth
systemctl disable ModemManager

hr; echo "Reboot for effect"; hr
