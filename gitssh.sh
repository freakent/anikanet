#!/bin/sh

# See https://forum.archive.openwrt.org/viewtopic.php?id=47551
# Generate your identity key on openwrt
# dropbearkey -t rsa -f ~/.ssh/id_rsa
# Copy this file to your home directory and rename to a hidden file
# cp gitssh.sh ~/gitssh.sh
# chmod +x ~/.gitssh.sh
# echo "export GIT_SSH=\$HOME/.gitssh.sh" >> /etc/profile

dbclient -y -i ~/.ssh/id_rsa $*
