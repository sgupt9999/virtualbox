#!/bin/bash
# This script will create a static IP on a virtualbox RHEL/Centos instance attached to an internal network
# It seems DHCP doesnt work on instances attached to an internal network, so have to assign it a static IP

# Start of user inputs
#################################################
NEW_CONN="test"
IFNAME="enp0s3"
STATIC_IP="10.0.2.40/24"
GATEWAY="10.0.2.2"
DNS="10.0.0.1"
#################################################
# End of user inputs



if [[ $EUID != "0" ]]
then
        echo "ERROR. You need to have root privileges to run this script"
        exit 1
fi

nmcli connection delete $NEW_CONN > /dev/null 2>&1
nmcli connection add con-name $NEW_CONN type ethernet ifname $IFNAME ipv4.addresses $STATIC_IP ipv4.gateway $GATEWAY ipv4.dns $DNS ipv4.method manual autoconnect true

# Delete any old connection
OLD_CONN=$(nmcli device show $IFNAME | grep "GENERAL.CONNECTION" | cut -d: -f2 | sed 's/^[ \t]*//')
if [[ $OLD_CONN != "test" ]]
then
        `nmcli connection delete \"$OLD_CONN\"`
fi
nmcli connection up $NEW_CONN



