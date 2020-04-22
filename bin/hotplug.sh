# ln -s /opt/anikanet/bin/hotplug.sh /etc/hotplug.d/iface/39-anikanet
LOGFILE=/tmp/anikanet.log
echo `date`, $ACTION, $INTERFACE, $DEVICE >> $LOGFILE

case "$INTERFACE" in (wan|wwan|tethering|modem)
    case "$ACTION" in (ifup|ifdown)
        active=$(mwan3 interfaces | grep 0 | wc -l)

        if [ $active -eq 0 ]
        then
            echo "guest wifi off ($active)" >> $LOGFILE
        else
            echo "guest wifi on ($active)" >> $LOGFILE
        fi 
    ;; esac
;;esac