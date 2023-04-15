# apr/14/2023 17:46:09 by RouterOS 6.38.5
# software id = ILG9-JXNP
#
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/ip pool
add name=lan1eth2 ranges=192.168.2.10-192.168.2.20
add name=lan2eth3 ranges=192.168.3.10-192.168.3.20
add name=lan3eth4 ranges=192.168.4.10-192.168.4.20
add name=lan4eth5 ranges=192.168.5.10-192.168.5.20
/ip dhcp-server
add address-pool=lan1eth2 disabled=no interface=ether2 name=dhcp-server1
add address-pool=lan2eth3 disabled=no interface=ether3 name=dhcp-server2
add address-pool=lan3eth4 disabled=no interface=ether4 name=dhcp-server3
add address-pool=lan4eth5 disabled=no interface=ether5 name=dhcp-server4
/ip address
add address=192.168.1.2/24 interface=ether1 network=192.168.1.0
add address=192.168.2.1/24 interface=ether2 network=192.168.2.0
add address=192.168.3.1/24 interface=ether3 network=192.168.3.0
add address=192.168.4.1/24 interface=ether4 network=192.168.4.0
add address=192.168.5.1/24 interface=ether5 network=192.168.5.0
/ip dhcp-server network
add address=192.168.2.0/24 dns-server=8.8.8.8,8.8.4.4 gateway=192.168.2.1
add address=192.168.3.0/24 dns-server=8.8.8.8,8.8.4.4 gateway=192.168.3.1
add address=192.168.4.0/24 dns-server=8.8.8.8,8.8.4.4 gateway=192.168.4.1
add address=192.168.5.0/24 dns-server=8.8.8.8,8.8.4.4 gateway=192.168.5.1
/ip dns
set allow-remote-requests=yes servers=8.8.8.8,8.8.4.4
/ip firewall filter
add action=accept chain=input comment="Allow established/related" \
    connection-state=established,related
add action=accept chain=input comment="Allow local traffic" in-interface=\
    ether2
add action=accept chain=input comment="Allow local traffic" in-interface=\
    ether3
add action=accept chain=input comment="Allow local traffic" in-interface=\
    ether4
add action=accept chain=input comment="Allow local traffic" in-interface=\
    ether5
add action=drop chain=input comment="Drop everything else"
/ip firewall nat
add action=masquerade chain=srcnat out-interface=ether1
/ip route
add distance=1 gateway=192.168.1.1
/system clock
set time-zone-name=America/Lima
/system identity
set name=RBMK
