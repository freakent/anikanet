# ln -s /opt/anikanet/bin/hotplug.sh /etc/hotplug.d/iface/39-anikanet
ANIKANET_HOME=/opt/anikanet
LOGFILE=$ANIKANET_HOME/log/hotplug.log
echo `date`, "hotplug", $ACTION, $INTERFACE, $DEVICE >> $LOGFILE

case "$INTERFACE" in (wan|wwan|tethering|modem)
  case "$ACTION" in
    (connected) #(ifup|IFUP)
           iwinfo wlan-sta info >> $LOGFILE
        echo `date`, "hotplug switching guest wifi on", $ACTION, $INTERFACE, $DEVICE >> $LOGFILE
        $ANIKANET_HOME/bin/guest-wifi.sh on >> $LOGFILE
        ;;
    (disconnected|ifdown|ifup-failed) #(ifdown|IFDOWN)
        #if [ $DEVICE = "wlan-sta" ]
        #then
           iwinfo wlan-sta DEVICE info >> $LOGFILE
           echo `date`, Waiting 2 mins to see if wifi is back up  >> $LOGFILE
           sleep 2m
           sid=$(iwinfo wlan-staE info | grep ESSID | awk '{ split ($0,a,"\""); print a[2]}')
           echo `date`, Checking SID after waiting 2 minutes : $sid >> $LOGFILE
           if [ $sid = "unknown" ]
	   then	
             echo `date`, "hotplug wlan-sta is down so switching guest wifi off", $ACTION, $INTERFACE, $DEVICE >> $LOGFILE
             $ANIKANET_HOME/bin/guest-wifi.sh off >> $LOGFILE
           fi
        #fi
        ;;
    (other)
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
