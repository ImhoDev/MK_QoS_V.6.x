# Configuración inicial

# 1-. Configurar nombre del router
/system identity set name="rbnewname"

# 2-. Añadir/cambiar contraseña de administrador
/user set 0 password="password"

# 3-. Configurar dirección IP de la interfaz WAN
/ip address add address=192.168.1.2/24 interface=ether1

# Configurar dirección IP de la interfaz LAN 2
/ip address add address=192.168.2.1/24 interface=ether2

# Configurar dirección IP de la interfaz LAN 3
/ip address add address=192.168.3.1/24 interface=ether3

# Configurar dirección IP de la interfaz LAN 4
/ip address add address=192.168.4.1/24 interface=ether4

# Configurar dirección IP de la interfaz LAN 5
/ip address add address=192.168.5.1/24 interface=ether5

# Configurar servidores DHCP

# Creando POOL de IPs

/ip pool add name=lan1eth2 ranges=192.168.2.10-192.168.2.20
/ip pool add name=lan2eth3 ranges=192.168.3.10-192.168.3.20
/ip pool add name=lan3eth4 ranges=192.168.4.10-192.168.4.20
/ip pool add name=lan4eth5 ranges=192.168.5.10-192.168.5.20

# Asignando DHCP servers a las interfaces / Habilitar servidor DHCP en la interfaz LAN
/ip dhcp-server add address-pool=lan1eth2 interface=ether2 name=dhcp-server1
/ip dhcp-server add address-pool=lan2eth3 interface=ether3 name=dhcp-server2
/ip dhcp-server add address-pool=lan3eth4 interface=ether4 name=dhcp-server3
/ip dhcp-server add address-pool=lan4eth5 interface=ether5 name=dhcp-server4

# Configurar rango de direcciones IP para DHCP

/ip dhcp-server network add address=192.168.2.0/24 dns-server=8.8.8.8,8.8.4.4 gateway=192.168.2.1
/ip dhcp-server network add address=192.168.3.0/24 dns-server=8.8.8.8,8.8.4.4 gateway=192.168.3.1
/ip dhcp-server network add address=192.168.4.0/24 dns-server=8.8.8.8,8.8.4.4 gateway=192.168.4.1
/ip dhcp-server network add address=192.168.5.0/24 dns-server=8.8.8.8,8.8.4.4 gateway=192.168.5.1

# Configurar NAT en la interfaz WAN
/ip firewall nat add action=masquerade chain=srcnat out-interface=ether1

# Configurar reglas de firewall básicas

/ip firewall filter add action=accept chain=input comment="Allow established/related" connection-state=established,related
/ip firewall filter add action=accept chain=input comment="Allow local traffic" in-interface=ether2
/ip firewall filter add action=accept chain=input comment="Allow local traffic" in-interface=ether3
/ip firewall filter add action=accept chain=input comment="Allow local traffic" in-interface=ether4
/ip firewall filter add action=accept chain=input comment="Allow local traffic" in-interface=ether5
/ip firewall filter add action=drop chain=input comment="Drop everything else"

# Guardar configuración
/system backup save name="ConfiguraciónInicial"


# Agregar DNSs all cast

# Agregar gateway

/ip address add gateway=192.168.1.1

#habilitar los servidores dhcp server





# SEGUNDA FORMA SIMPLE

# Configuración básica de la WAN
/interface ethernet
set [ find default-name=ether1 ] name=WAN
/ip dhcp-client
add dhcp-options=hostname,clientid disabled=no interface=WAN use-peer-dns=yes
/ip address
add address=192.168.1.2/24 interface=WAN network=192.168.1.0

# Configuración básica de las LAN
/interface ethernet
set [ find default-name=ether2 ] name=LAN1
set [ find default-name=ether3 ] name=LAN2
set [ find default-name=ether4 ] name=LAN3
set [ find default-name=ether5 ] name=LAN4
/ip address
add address=192.168.2.1/24 interface=LAN1 network=192.168.2.0
add address=192.168.3.1/24 interface=LAN2 network=192.168.3.0
add address=192.168.4.1/24 interface=LAN3 network=192.168.4.0
add address=192.168.5.1/24 interface=LAN4 network=192.168.5.0

# Configuración de las reglas de firewall
/ip firewall filter
add action=accept chain=input comment="Permitir ICMP" protocol=icmp
add action=accept chain=input comment="Permitir SSH" dst-port=22 protocol=tcp
add action=accept chain=input comment="Permitir Winbox" dst-port=8291 protocol=tcp
add action=accept chain=input comment="Permitir tráfico DNS" dst-port=53 protocol=tcp
add action=accept chain=input comment="Permitir tráfico HTTP" dst-port=80 protocol=tcp
add action=accept chain=input comment="Permitir tráfico HTTPS" dst-port=443 protocol=tcp
add action=drop chain=input comment="Bloquear todo el tráfico no deseado" in-interface=WAN

# Configuración de la puerta de enlace predeterminada
/ip dhcp-server
add address-pool=LAN1-Pool disabled=no interface=LAN1 name=dhcp1
add address-pool=LAN2-Pool disabled=no interface=LAN2 name=dhcp2
add address-pool=LAN3-Pool disabled=no interface=LAN3 name=dhcp3
add address-pool=LAN4-Pool disabled=no interface=LAN4 name=dhcp4
/ip pool
add name=LAN1-Pool ranges=192.168.2.100-192.168.2.200
add name=LAN2-Pool ranges=192.168.3.100-192.168.3.200
add name=LAN3-Pool ranges=192.168.4.100-192.168.4.200
add name=LAN4-Pool ranges=192.168.5.100-192.168.5.200
/ip dhcp-server network
add address=192.168.2.0/24 dns-server=192.168.1.1 gateway=192.168.2.1
add address=192.168.3.0/24 dns-server=192.168.1.1 gateway=192.168.3.1
add address=192.168.4.0/24 dns-server=192.168.1.1 gateway=192.168.4.1
add address=192.168.5.0/24