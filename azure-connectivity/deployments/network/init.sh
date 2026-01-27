#!/bin/bash
set -e

########################
# enabled IPv4 forwarding
########################
sysctl -w net.ipv4.ip_forward=1

if ! grep -q "^net.ipv4.ip_forward=1" /etc/sysctl.conf; then
  echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
fi

###########################
# required packages
###########################
apt-get update -y
apt-get install -y \
  nftables \
  dnsutils \
  curl \
  telnet

################################
# deleted existing nftables rules
################################
nft flush ruleset

##########################
# nftables ruleset
##########################
cat << 'EOF' > /etc/nftables.conf
#!/usr/sbin/nft -f

flush ruleset

############################
# MANGLE table (packet marking)
############################
table ip mangle {
  chain prerouting {
    type filter hook prerouting priority -150;
    policy accept;

    # Restore mark from conntrack for established connections
    ct mark != 0 meta mark set ct mark

    # Mark new packets by destination port for policy-based routing
    tcp dport 2000 meta mark set 2000
    tcp dport 3000 meta mark set 3000

    # Save mark to conntrack
    ct mark set meta mark
  }

  chain output {
    type route hook output priority -150;
    policy accept;

    # Restore mark from conntrack for established connections
    ct mark != 0 meta mark set ct mark

    # Mark reply packets (SSH responses)
    tcp sport 22 meta mark != 0 meta mark set ct mark
  }
}

############################
# NAT table
############################
table ip nat {
  chain prerouting {
    type nat hook prerouting priority -100;
    policy accept;

    # DNAT port 8080 to 10.3.1.4:80
    tcp dport 8080 dnat to 10.3.1.4:80

    # DNAT ports 2000 and 3000 to SSH (port 22)
    tcp dport 2000 dnat to :22
    tcp dport 3000 dnat to :22
  }

  chain postrouting {
    type nat hook postrouting priority 100;
    policy accept;

    # MASQUERADE outbound traffic via eth0 (internet connectivity)
    oif "eth0" masquerade
  }

  chain output {
    type nat hook output priority -100;
    policy accept;

    # DNAT for locally generated traffic
    tcp dport 2000 dnat to 127.0.0.1:22
    tcp dport 3000 dnat to 127.0.0.1:22
  }
}

############################
# Filter table
############################
table ip filter {
  chain input {
    type filter hook input priority 0;
    policy accept;
    tcp dport 8080 accept;
  }

  chain forward {
    type filter hook forward priority 0;
    policy accept;
  }

  chain output {
    type filter hook output priority 0;
    policy accept;
  }
}
EOF

#########################
# enabled nftables service
#########################
systemctl enable nftables
systemctl start nftables

#####################
# nftables rules
#####################
nft -f /etc/nftables.conf

##############################
# custom routing tables
##############################
echo "2000 eth1_table" > /etc/iproute2/rt_tables
echo "3000 eth0_table" >> /etc/iproute2/rt_tables

#############################################
# routing/policy rules for the marked packets
#############################################
ip rule add fwmark 2000 lookup eth1_table priority 100
ip rule add fwmark 3000 lookup eth0_table priority 101

ip route add default via 10.2.0.1 dev eth0
ip route add 10.0.0.0/8 via 10.2.0.1 dev eth1
ip route add 168.63.129.16 via 10.2.0.1 dev eth0 table eth0_table
ip route add 168.63.129.16 via 10.2.0.1 dev eth1 table eth1_table
