#!/bin/sh
ANIKANET_HOME=/opt/anikanet
$ANIKANET_HOME/bin/wifi-ctrl.sh ANIKANET $1
$ANIKANET_HOME/bin/wifi-ctrl.sh ANIKANET-5G $1

