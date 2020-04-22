#!/bin/sh
network="$( uci show wireless | grep \'$1\' | cut -d'=' -f1 | cut -d'.' -f2)"
if [ -z "$network" ]
then
  echo "SSID $1 not found."
  exit 1
else
  echo "set $network ($1) to $2"
  device="$( uci get wireless.$network.device )" 
  case $2 in
    off|Off|OFF|0) uci set wireless.${network}.disabled=1 ;;
    on|On|ON|1)    uci set wireless.${network}.disabled=0 ;;
  esac
  uci commit wireless
  wifi reload $network
fi