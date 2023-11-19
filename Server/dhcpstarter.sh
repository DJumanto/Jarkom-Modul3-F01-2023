apt-get update apt-get install isc-dhcp-server -y dhcpd --version

rm /run/dhcpd.pid

service isc-dhcp-server stop
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

host Fern{
   hardware ethernet ba:8a:1a:8d:47:cf;
   fixed-address 10.52.4.3;

}

host Frieren {
    hardware ethernet 66:59:e8:50:60:65;
    fixed-address 10.52.4.1;
}


host Flamme {
    hardware ethernet 26:0c:dc:43:d2:be;
    fixed-address 10.52.4.2;
}


host Lawine {
    hardware ethernet 5a:5b:20:c2:0e:23;
    fixed-address 10.52.3.1;
}

host Lugner {
    hardware ethernet ca:7b:cb:c2:a0:7d;
    fixed-address 10.52.3.3;
}

host Linie {
    hardware ethernet 16:80:c6:25:17:11;
    fixed-address 10.52.3.2;
}' > /etc/dhcp/dhcpd.conf