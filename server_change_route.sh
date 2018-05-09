#!/bin/bash
# Setup a linux server as a router. Allow instances on an internal network to connect to internet via this server
# The routing needs to be changed on the client machines to send traffic to the router machine

# Start of user inputs
PRIVATEIFNAME="enp0s3"
# Router IP is on the same network as the client, but on the linux server
ROUTERIP="10.0.2.2"
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
# Deleting the default route on the private network
ip route del default via $ROUTERIP dev $PRIVATEIFNAME
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
