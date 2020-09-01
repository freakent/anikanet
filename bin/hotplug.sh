# ln -s /opt/anikanet/bin/hotplug.sh /etc/hotplug.d/iface/39-anikanet
ANIKANET_HOME=/opt/anikanet
LOGFILE=$ANIKANET_HOME/log/hotplug.log
echo `date`, "hotplug", $ACTION, $INTERFACE, $DEVICE >> $LOGFILE

case "$INTERFACE" in (wan|wwan|tethering|modem)
    case "$ACTION" in (ifup|ifdown)
        echo `date`, "hotplug switching guest wifi", $ACTION, $INTERFACE, $DEVICE >> $LOGFILE
        mwan3 interfaces >> $LOGFILE
        active=$(mwan3 interfaces | grep active | wc -l)

        if [ $active -eq 0 ]
        then
            $ANIKANET_HOME/bin/guest-wifi.sh off >> $LOGFILE
            echo `date`, "guest wifi off ($active)" >> $LOGFILE
        else
            $ANIKANET_HOME/bin/guest-wifi.sh on >> $LOGFILE
            echo `date`, "guest wifi on ($active)" >> $LOGFILE
        fi 
        echo `date`, "hotplug end", $ACTION, $INTERFACE, $DEVICE >> $LOGFILE
    ;; esac
;;esac
