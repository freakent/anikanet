# ln -s /opt/anikanet/bin/hotplug.sh /etc/hotplug.d/iface/39-anikanet
LOGFILE=/tmp/anikanet.log
echo `date`, $ACTION, $INTERFACE, $DEVICE >> $LOGFILE
