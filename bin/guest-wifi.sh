#!/bin/sh +x
ANIKANET_HOME=/opt/anikanet

guests=$(uci show wireless | grep guest | grep wifi-iface | cut -d'=' -f1 | cut -d'.' -f2)
reload="N"

for network in $guests
do 
  disabled=`uci get wireless.${network}.disabled`
  case $1 in
    off|Off|OFF|0) 
        if [ $disabled -eq 0 ] 
        then
           echo "uci set wireless.${network}.disabled=1"
           uci set wireless.${network}.disabled=1 
           reload="Y"
        fi
        ;;
    on|On|ON|1)
        if [ $disabled -eq 1 ] 
        then
           echo "uci set wireless.${network}.disabled=0"
           uci set wireless.${network}.disabled=0 
           reload="Y"
        fi
        ;;
  esac
done

if [ $reload = "Y" ]
then
   echo "Commiting changes to wifi and reloading..."
   uci commit wireless
   wifi reload 
   echo "Wifi reloaded"
fi

#uci show wireless.guest2g
#uci show wireless.guest5g

#echo "*************"
#uci show wireless.guest2g
#uci show wireless.guest5g

#wifi reload $network
#wifi reload 

