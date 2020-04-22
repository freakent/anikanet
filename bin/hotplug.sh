# ln -s /opt/anikanet/bin/hotplug.sh /etc/hotplug.d/iface/39-anikanet
ANIKANET_HOME=/opt/anikanet
LOGFILE=/tmp/anikanet.log
echo `date`, $ACTION, $INTERFACE, $DEVICE >> $LOGFILE

case "$INTERFACE" in (wan|wwan|tethering|modem)
    case "$ACTION" in (ifup|ifdown)
        mwan3 interfaces >> $LOGFILE
        active=$(mwan3 interfaces | grep active | wc -l)

        if [ $active -eq 0 ]
        then
            $ANIKANET_HOME/bin/guest-wifi.sh off
            echo "guest wifi off ($active)" >> $LOGFILE
        else
            $ANIKANET_HOME/bin/guest-wifi.sh on
            echo "guest wifi on ($active)" >> $LOGFILE
        fi 
    ;; esac
;;esac