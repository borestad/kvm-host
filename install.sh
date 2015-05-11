#!/bin/bash -e

# Fix locale issues
update-locale LC_ALL="en_US.UTF-8"
export LANGUAGE="en_US.UTF-8"
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
locale-gen en_US.UTF-8
dpkg-reconfigure locales

function confirmContinue () {
  read -r -p "${1:-Are you sure? [y/N]} " response
  case $response in
    [yY][eE][sS]|[yY])
      true
      ;;
    *)
      false
      ;;
  esac
}

function confirmExit () {
  read -r -p "${1:-Continue? [ y/N ]} " response
  case $response in
    [yY][eE][sS]|[yY])
      true
      ;;
    *)
      exit
      ;;
  esac
}


echo "Run this installation script as root ('su' or 'su root' or 'sudo su')" && confirmExit
echo "\nAre you sure?" && confirmExit

# Update & cleanup
apt-get update

rm -rfv /tmp/bootstrap
apt-get install curl

curl https://raw.githubusercontent.com/LuRsT/hr/master/hr > /usr/local/bin/hr
chmod +x /usr/local/bin/hr

sh -c "echo 'LC_ALL=en_US.UTF-8\nLANG=en_US.UTF-8' >> /etc/environment"

hr; echo "\nInstalling global system tools\n"; hr
apt-get -y install aptitude
aptitude update
aptitude -y install sudo htop bash-completion ncdu mc network-manager silversearcher-ag

hr; echo "\nInstall dfc\n"; hr
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

hr; echo "\nInstall cdu\n"; hr
mkdir -p /tmp/bootstrap/cdu && cd /tmp/bootstrap/cdu
wget http://arsunik.free.fr/pkg/cdu-0.37.tar.gz
tar xvf cdu-0.37.tar.gz
cd cdu-0.37
make install
rm -rf /tmp/cdu

hr; echo "\nInstalling node\n"; hr
cd /
curl -sL https://deb.nodesource.com/setup_0.12 | bash -
cd /
apt-get -y install nodejs
npm install -g npm


hr; echo "\nInstalling more awesome sysadmin tools\n"; hr
npm install -g vtop

# Pip
hr; echo "\nInstalling python pip\n"; hr
mkdir -p /tmp/bootstrap/get-pip && cd /tmp/bootstrap/get-pip
wget https://raw.github.com/pypa/pip/master/contrib/get-pip.py
python get-pip.py

#/usr/local/bin/pip install --upgrade Glances
hr; echo "\nInstalling Glances\n"; hr
curl -L http://bit.ly/glances | /bin/bash

cd /
#curl -L http://bit.ly/glances | /bin/bash

hr; echo "\nInstalling libvirt / KVM\n"; hr
aptitude -y install qemu-kvm libvirt-bin

hr; echo "\nInstalling webmin\n"; hr
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

# hr; echo "\nWeb terminal\n"; hr

hr; echo "\nCleanup apt packages\n"; hr
apt-get clean
apt-get autoclean
apt-get autoremove

hr; echo "\nRemove unnecessary locale files\n"; hr
rm -rfv /usr/share/man/??
rm -rfv /usr/share/man/??_*

# Manually delete all but en_US locales
find /usr/share/locale -maxdepth 1 -mindepth 1 -type d | grep -v -e "en_US" | xargs rm -rf

# Delete unused locales from local-archive
# localedef --list-archive | grep -v -e "en_US" | xargs localedef --delete-from-archive
# mv /usr/lib/locale/locale-archive /usr/lib/locale/locale-archive.tmpl
# dpkg-reconfigure locales

hr; echo "\nRemove ipv6 files\n"; hr
rm -rvf /lib/xtables/libip6t_*

hr; echo "\nRemove translations\n"; hr
# http://oneofmanyworlds.blogspot.se/2012/02/debian-wheezy-removing-unused-locales.html

hr; echo "\nDisable unneded services\n"; hr
systemctl stop bluetooth
systemctl disable bluetooth
systemctl stop ModemManager
systemctl disable ModemManager

# Stripped down gist
# https://gist.github.com/dcloud9/8918580
# dpkg-query -Wf '${Package;-40}${Essential} | ${Priority}\n'


# echo "Install a minimal XFCE Desktop?"
# confirmContinue && apt-get install --no-install-recommends \
# xorg  slim alsa-base alsa-utils \
# hal gamin dbus-x11 sudo xdg-utils


# confirmContinue && apt-get install --no-install-recommends \
# desktop-base gnome-icon-theme dmz-cursor-theme \
# xfce4-terminal xfce4-taskmanager xfce4-screenshooter-plugin \
# thunar-archive-plugin thunar-media-tags-plugin

hr; echo "\nReboot for effect\n"; hr
