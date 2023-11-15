apt-get update
apt-get install isc-dhcp-server -y
dhcpd --version

echo 'INTERFACES="eth0"' > /etc/default/isc-dhcp-server

echo '
subnet 10.52.1.0 netmask 255.255.255.0 {
    range 10.52.1.16 10.52.1.32;
    option routers 10.52.1.0;
    option broadcast-address 10.52.1.255;
    option domain-name-servers 10.52.2.1;
    default-lease-time 720;
    max-lease-time 720;
}
' > /etc/dhcp/dhcpd.conf

