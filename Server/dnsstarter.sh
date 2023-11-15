apt-get update
apt-get install bind9 -y

mkdir /etc/bind/jarkom/canyon.f01.com

echo 'zone "canyon.f01.com" {
	type master;
	file "/etc/bind/jarkom/canyon.f01.com";
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
@   IN      A       10.52.4.2       ;
www IN      CNAME   canyon.f01.com.
riegel IN     A     10.52.4.2       ;
granz IN      A     10.52.4.2       ;
' > /etc/bind/jarkom/canyon.f01.com


service bind9 restart