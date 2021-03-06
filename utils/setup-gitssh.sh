#!/bin/sh

# Update the list of available openwrt packages
echo
echo "Updating openwrt package list"
opkg update

# Install git if not already installed
echo
echo "Checking for presence of git"
(which git) ||  (opkg install git)

# Generate your identity key on openwrt
echo 
echo "Checking for private key"
mkdir -p ~/.ssh
[ -f ~/.ssh/id_rsa ] || dropbearkey -t rsa -f ~/.ssh/id_rsa

# Change git ssh command
echo
echo "Configuring git to use busybox keys"
echo "#!/bin/sh" > ~/.gitssh.sh
echo "dbclient -y -i ~/.ssh/id_rsa \$*" >> ~/.gitssh.sh
chmod +x ~/.gitssh.sh
echo "export GIT_SSH=\$HOME/.gitssh.sh" >> ~/.profile

echo 
echo "Log out then back in again or"
echo "export GIT_SSH=$HOME/.gitssh.sh"

# Last step
# Convert public key from dropbear binary to openssh text
echo "Copy and paste output from below to git account ssh keys"
dropbearkey -y -f ~/.ssh/id_rsa | head -n 2 | tail -1
echo

# Now login again to openwrt
#echo
#echo "Clone the anikanet tools into /opt/anikanet"
#git clone git://github.com:/freakent/anikanet.git /opt/anikanet

#git clone git@github.com:freakent/anikanet.git /opt/anikanet

