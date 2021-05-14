#!/bin/sh
passwd openvpn
cat >> /etc/tor/torrc <<EOF
VirtualAddrNetworkIPv4 10.192.0.0/10
AutomapHostsOnResolve 1
TransPort 9050
TransListenAddress 172.27.232.1
DNSPort 53
DNSListenAddress 172.27.232.1
EOF

cat > ~/iptables.sh <<EOF
#!/bin/sh

# Tor's TransPort
_trans_port="9050"

# your internal interface
_int_if="as0t1"

iptables -F
iptables -t nat -F

iptables -t nat -A PREROUTING -i $_int_if -p udp --dport 53 -j REDIRECT --to-ports 53
iptables -t nat -A PREROUTING -i $_int_if -p tcp --syn -j REDIRECT --to-ports $_trans_port
EOF

/bin/sh ~/iptables.sh 

update-rc.d -f tor remove
update-rc.d tor defaults 99

update-rc.d -f iptables-persistent
update-rc.d iptables-persistent defaults 99


