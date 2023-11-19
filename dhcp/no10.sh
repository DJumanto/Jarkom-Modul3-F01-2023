echo '
host Revolte {
    hardware ethernet be:f3:a3:01:52:e9;
    fixed-address 10.52.3.69;
}
host Ritcher {
    hardware ethernet 4a:63:2c:98:8b:3e;
    fixed-address 10.52.3.70;
}
host Sein {
    hardware ethernet c6:1a:63:41:6e:f9;
    fixed-address 10.52.4.167;
}
host Stark {
    hardware ethernet 92:cd:cc:5c:84:05;
    fixed-address 10.52.4.168;
}
' >> /etc/dhcp/dhcpd.conf

service isc-dhcp-server restart
