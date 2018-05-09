# virtualbox
All virtualbox setup scripts
##########################################################################################
internal_network.sh 
1. DHCP doesnt seem to work on instances attached to an internal network
2. This script will create a static IP address in the 10.0.2.0/24 network
3. To assign addresses to additional instances, just increment the IP address, keeping all else the same
##########################################################################################
Setup an instance as a router
Setup -
1. Create instance attached to an internal network. 
2. Server instance has 2 nics. One is on the same internal network and the second one has a public facing address.
3. Make the server act as a router, so the internal network can have a public outlet
#########

Steps -
1. Create client and server instances attached to the same internal network
2. Run internal_network.sh on both instances with different IP addresses. Reboot client and server and make sure
the two machines can send a ping
3. Run client_change_route.sh on client. Make sure to have the correct user inputs. Make sure the two machines can send a ping
4. Turn off both the machines
5. Add a second network card to the server instance. Attach this card to NAT and restart
6. Run server_change_route.sh and server_router_setup.sh on the server. Make sure to have the correct user inputs
7. Use the firewalld option on the router setup as iptables option doesnt make persistent change
8. Reboot server and restart client
9. If this order is not followed on virtualbox for some reason it gives an error
##########################################################################################
