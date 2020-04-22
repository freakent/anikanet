#!/bin/sh

# Update the list of available openwrt packages
opkg update

# Install git if not already installed
(which git) ||  (opkg install git)

#Generate your identity key on openwrt
mkdir -p ~/.ssh
dropbearkey -t rsa -f ~/.ssh/id_rsa

# Change git ssh command
echo "#!/bin/sh" > ~/.gitssh.sh
echo "dbclient -y -i ~/.ssh/id_rsa \$\*" >> ~/.gitssh.sh
chmod +x ~/.gitssh.sh
echo "export GIT_SSH=\$HOME/.gitssh.sh" >> ~/.profile

export GIT_SSH=$HOME/.gitssh.sh

# Last step
# Convert public key from dropbear binary to openssh text
# Copy and paste output from below to git account ssh keys
dropbearkey -y -f ~/.ssh/id_rsa | head -n 2 | tail -1

# Now login again to openwrt
