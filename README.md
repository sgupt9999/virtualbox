# virtualbox
All virtualbox setup scripts. These scripts had inconsistent behavior in 32 bit, but are working well in 64 bit
#################################################
Assign a static IP to an instance in an internal network
1. DHCP doesnt seem to work on instances attached to an internal network
2. This script will create a static IP address in the 10.0.2.0/24 network
3. To assign addresses to additional instances, just increment the IP address, keeping all else the same

Steps -
1. Run internal_network.sh

#################################################
Setup a network of two instances. The first one is in a private network and the 2nd one is both a part of the same private and a public network
1. Create instance #1 attached to an internal network. 
2. Create instance #2 with one NIC attached to the same internal network and the 2nd one to a bridge network
3. Configure the instance #2 to act as a router and NAT for instace #1

Steps -
1. Run internal_network.sh, server_change_route.sh and server_router_setup.sh on the 2nd instance
2. Run internal_network.sh and client_change_route.sh on the 1st instance
3. Reboot the 2 machines
#################################################
