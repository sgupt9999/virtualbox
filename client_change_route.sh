#!/bin/bash
# This script changes the default route to go via the router machine instance of default gateway

# Start of user inputs
##########################################################################################
IFNAME="enp0s3"
# Router IP is the IP of the server instance on the same network as the client
NEWROUTERIP="10.0.2.10"
OLDROUTERIP="10.0.2.2"
##########################################################################################
# End of user inputs


if [[ $EUID != "0" ]]
then
	echo "ERROR. You need to have root privileges to run this script"
	exit 1
fi

# Create file called by systemd service
rm -rf /usr/local/src/routes.sh
cat << EOF > /usr/local/src/routes.sh
#!/bin/bash
# Adding the route to send default traffic via the instance acting as a router and deleteing the route via default gateway
ip route add default via $NEWROUTERIP dev $IFNAME
ip route del default via $OLDROUTERIP dev $IFNAME
EOF
chmod a+x /usr/local/src/routes.sh
# End of file with the new route

# Create a new systemd service
rm -rf /etc/systemd/system/new_routes.service
cat << EOF > /etc/systemd/system/new_routes.service
[Unit]
Description=Configure new routes
After=network-online.target network.service

[Service]
ExecStart=/usr/local/src/routes.sh

[Install]
WantedBy=network-online.target network.service
EOF
# End of new systemd service

echo "New systemd service - new routes created"

systemctl daemon-reload
systemctl enable new_routes.service
systemctl restart network
echo "Network restarted successfully"

