apt-get update
apt-get install bind9 -y

rm -rf /etc/bind/jarkom/*
mkdir /etc/bind/jarkom/
echo '
zone "canyon.f01.com" {
	type master;
	file "/etc/bind/jarkom/canyon.f01.com";
};

zone "channel.f01.com" {
	type master;
	file "/etc/bind/jarkom/channel.f01.com";
};
' > /etc/bind/named.conf.local

echo '
;
; BIND data file for local loopback interface
;
$TTL  604800
@   IN      SOA     canyon.f01.com.  root.canyon.f01.com. (
                    2023100601      ; Serial
                        604800      ; Refresh
                        86400       ; Retry 
                        2419200     ; Expire
                        604800  )   ; Negative Cache TTL
;
@   IN      NS      canyon.f01.com.
@   IN      A       10.52.2.2       ;
www IN      CNAME   canyon.f01.com.
granz IN      A     10.52.3.1       ;
' > /etc/bind/jarkom/canyon.f01.com

echo '
;
; BIND data file for local loopback interface
;
$TTL  604800
@   IN      SOA     channel.f01.com.  root.channel.f01.com. (
                    2023100601      ; Serial
                        604800      ; Refresh
                        86400       ; Retry 
                        2419200     ; Expire
                        604800  )   ; Negative Cache TTL
;
@   IN      NS      channel.f01.com.
@   IN      A       10.52.2.2       ;
www IN      CNAME   channel.f01.com.
riegel IN      A     10.52.4.1       ;
' > /etc/bind/jarkom/channel.f01.com
echo '
options {
    directory "/var/cache/bind";

    forwarders {
          192.168.122.1;
    };

    allow-query{any;};
    auth-nxdomain no;    # conform to RFC1035
    listen-on-v6 { any; };
};
'> /etc/bind/named.conf.options


service bind9 restart