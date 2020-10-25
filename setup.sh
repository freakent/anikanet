#!/bin/sh

ln -s /mnt/sda1 /opt

opkg -V0 update

(which git) || opkg install git

git status
