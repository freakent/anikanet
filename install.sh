#!/bin/sh 

# Update the list of available openwrt packages
echo
echo "Updating openwrt package list"
opkg -V0 update

# Install git if not already installed
echo
echo "Checking for presence of git"
(which git) ||  (opkg install git)

# Clone the anikanet tools into /opt/anikanet
echo
echo "Installing into /opt/anikanet"
git clone --depth=1 git://github.com:/freakent/anikanet.git /opt/anikanet
