#!/bin/sh +x
ANIKANET_HOME=/opt/anikanet

guests=$(uci show wireless | grep guest | grep wifi-iface | cut -d'=' -f1 | cut -d'.' -f2)
for network in $guests
do 
  case $1 in
    off|Off|OFF|0) 
        echo "uci set wireless.${network}.disabled=1"
        uci set wireless.${network}.disabled=1 
        ;;
    on|On|ON|1)
        echo "uci set wireless.${network}.disabled=0"
        uci set wireless.${network}.disabled=0 
        ;;
  esac
done

uci show wireless.guest2g
uci show wireless.guest5g

uci commit wireless
#wifi reload $network
wifi reload 

