apt-get update
apt-get install isc-dhcp-server -y
dhcpd --version

echo 'INTERFACESv4="eth0"' > /etc/default/isc-dhcp-server

echo '

subnet 10.52.1.0 netmask 255.255.255.0 {}
subnet 10.52.2.0 netmask 255.255.255.0 {}

subnet 10.52.3.0 netmask 255.255.255.0 {
    range 10.52.3.16 10.52.3.32;
    range 10.52.3.64 10.52.3.80;
    option routers 10.52.3.0;
    option broadcast-address 10.52.3.255;
    option domain-name-servers 10.52.1.1;
    default-lease-time 180;   
    max-lease-time 5760;        
}

subnet 10.52.4.0 netmask 255.255.255.0 {
    range 10.52.4.12 10.52.4.20;
    range 10.52.4.162 10.52.4.168;
    option routers 10.52.4.0;
    option broadcast-address 10.52.4.255;
    option domain-name-servers 10.52.1.1;
    default-lease-time 720;   
    max-lease-time 5760;        
}
' > /etc/dhcp/dhcpd.conf

service isc-dhcp-server restart

