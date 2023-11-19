# Laporan Praktikum Modul 3 Jaringan Komputer

| Kelompok | Nama | NRP |
|----------|------|-----|
| F01      |Alfa Fakhrur Rizal Zaini|5025211214|


## nomor 1

### Problem
Setelah mengalahkan Demon King, perjalanan berlanjut. Kali ini, kalian diminta untuk melakukan register domain berupa riegel.canyon.yyy.com untuk worker Laravel dan granz.channel.yyy.com untuk worker PHP (0) mengarah pada worker yang memiliki IP [prefix IP].x.1.

### Solution:
```sh
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
riegel IN      A     10.52.4.1       ;
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
granz IN      A     10.52.3.1       ;
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
```

pengaturan ini akan mengarahkan request riegel.channel.f01.com ke worker laravel dan granz.canyon.f01.com ke worker php dengan sufix x.1

### Result:
![no 1 test](img/no1_test.png)
![no_1_1 test](img/no1_1test.png)

## nomor 2
### Problem
Lakukan konfigurasi sesuai dengan peta yang sudah diberikan.

### Solution
![no 2 test](img/no2_test.png)

## nomor 3, 4, 5, 6
### Problem
Client yang melalui Switch3 mendapatkan range IP dari [prefix IP].3.16 - [prefix IP].3.32 dan [prefix IP].3.64 - [prefix IP].3.80

Client yang melalui Switch4 mendapatkan range IP dari [prefix IP].4.12 - [prefix IP].4.20 dan [prefix IP].4.160 - [prefix IP].4.168

Client mendapatkan DNS dari Heiter dan dapat terhubung dengan internet melalui DNS tersebut (4)

Lama waktu DHCP server meminjamkan alamat IP kepada Client yang melalui Switch3 selama 3 menit sedangkan pada client yang melalui Switch4 selama 12 menit. Dengan waktu maksimal dialokasikan untuk peminjaman alamat IP selama 96 menit (5)


### solution
```sh
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
```


## nomor 7, 8
### Problem
Pada masing-masing worker PHP, lakukan konfigurasi virtual host untuk website berikut dengan menggunakan php 7.3. (6)

Kepala suku dari Bredt Region memberikan resource server sebagai berikut:
Lawine, 4GB, 2vCPU, dan 80 GB SSD.
Linie, 2GB, 2vCPU, dan 50 GB SSD.
Lugner 1GB, 1vCPU, dan 25 GB SSD.
aturlah agar Eisen dapat bekerja dengan maksimal, lalu lakukan testing dengan 1000 request dan 100 request/second. (7)


### Solution
```sh
apt-get update
apt-get install nginx -y

rm -rf /etc/nginx/sites-enabled/*

echo '
upstream php_worker {
        server 10.52.3.1 weight=5;
        server 10.52.3.2 weight=4;
        server 10.52.3.3 weight=3;
}

server {
    listen 80;
    
    server_name channel.f01.com;

    location / {
        proxy_pass http://php_worker;
    }
}' > /etc/nginx/sites-available/channel.f01.com

echo '
upstream laravelworker {
        server 10.52.4.1 weight=5;
        server 10.52.4.2 weight=4;
        server 10.52.4.3 weight=3;
}

server {
    listen 80;
    
    server_name canyon.f01.com;

    location / {
        proxy_pass http://laravelworker;
    }
}' > /etc/nginx/sites-available/canyon.f01.com
ln -s /etc/nginx/sites-available/channel.f01.com /etc/nginx/sites-enabled
ln -s /etc/nginx/sites-available/canyon.f01.com /etc/nginx/sites-enabled

service nginx restart
```

### Result
![no_8 test](img/no8_test.png)

## nomor 9
Karena diminta untuk menuliskan grimoire, buatlah analisis hasil testing dengan 200 request dan 10 request/second masing-masing algoritma Load Balancer dengan ketentuan sebagai berikut:
- Nama Algoritma Load Balancer
- Report hasil testing pada Apache Benchmark
- Grafik request per second untuk masing masing algoritma. 
- Analisis (8)

### Solution:
| No  | Algorithm              | Req/sec (mean) |
|----|------------------------|----------------|
| 1  | Round Robin            | 107.4          |
| 2  | Weighted Round Robin   | 103.82         |
| 3  | Least Conn             | 115.37         |
| 4  | IP Hash                | 480.02         |
| 5  | Generic Hash           | 434.13         |

### Statistic

![no 9 test](img/no9_test.png)

## nomor 10

### Problem
Dengan menggunakan algoritma Round Robin, lakukan testing dengan menggunakan 3 worker, 2 worker, dan 1 worker sebanyak 100 request dengan 10 request/second, kemudian tambahkan grafiknya pada grimoire. (9)

### Solution

9.1
```sh
echo '
upstream php_worker {
        server 10.52.3.1;
        server 10.52.3.2;
        server 10.52.3.3;
}

server {
    listen 80;
    
    server_name canyon.f01.com;

    location / {
        proxy_pass http://php_worker;
    }
}' > /etc/nginx/sites-available/canyon.f01.com
```

9.2
```sh
echo '
upstream php_worker {
        server 10.52.3.1;
        server 10.52.3.2;
        #server 10.52.3.3;
}

server {
    listen 80;
    
    server_name canyon.f01.com;

    location / {
        proxy_pass http://php_worker;
    }
}' > /etc/nginx/sites-available/canyon.f01.com
```

9.3
```sh
echo '
upstream php_worker {
        server 10.52.3.1;
        #server 10.52.3.2;
        #server 10.52.3.3;
}

server {
    listen 80;
    
    server_name canyon.f01.com;

    location / {
        proxy_pass http://php_worker;
    }
}' > /etc/nginx/sites-available/canyon.f01.com
```

### Result
| No  | Total Worker | Trial 1 | Trial 2 | Trial 3 | Trial 4 | Trial 5 | Mean    |
|----|--------------|---------|---------|---------|---------|---------|---------|
| 1  | 3 Worker     | 389.11  | 408.45  | 446.76  | 457.98  | 441.53  | 428.766 |
| 2  | 2 Worker     | 443.62  | 466.8   | 444.73  | 458.13  | 422.08  | 447.072 |
| 3  | 1 Worker     | 451.17  | 457.36  | 446.67  | 452.28  | 472.45  | 455.986 |


### Statistic
![Alt text](img/no10_test.png)

## nomor 11
### problem
Selanjutnya coba tambahkan konfigurasi autentikasi di LB dengan dengan kombinasi username: “netics” dan password: “ajkyyy”, dengan yyy merupakan kode kelompok. Terakhir simpan file “htpasswd” nya di /etc/nginx/rahasisakita/ (10)


### Solution

```sh
htpasswd -c /etc/nginx/rahasiakita/.htpasswd netics

echo '
upstream php_worker {
        server 10.52.3.1;
        server 10.52.3.2;
        server 10.52.3.3;
}

server {
    listen 80;
    
    server_name channel.f01.com;

    location / {
        auth_basic "Restricted";
        auth_basic_user_file /etc/nginx/rahasiakita/.htpasswd;
        proxy_pass http://php_worker;
    }
}' > /etc/nginx/sites-available/channel.f01.com
```


### Result
![no 11 test](img/no11_test.png)

## nomor 12
### Problem
Lalu buat untuk setiap request yang mengandung /its akan di proxy passing menuju halaman https://www.its.ac.id. (11) hint: (proxy_pass)

### Solution
```sh
echo '
upstream php_worker {
        server 10.52.3.1;
        server 10.52.3.2;
        server 10.52.3.3;
}

server {
    listen 80;
    
    server_name channel.f01.com;

    auth_basic "Restricted";
    auth_basic_user_file /etc/nginx/rahasiakita/.htpasswd;
    
    location / {
        proxy_pass http://php_worker;
    }

    location /its/ {
        proxy_pass http://www.its.ac.id;
    }
}' > /etc/nginx/sites-available/channel.f01.com

service nginx restart
```
### Result
![no12_test](img/no12_test.png)

## nomor 13
### Problem
Semua data yang diperlukan, diatur pada Denken dan harus dapat diakses oleh Frieren, Flamme, dan Fern.

### Solution
```sh
apt-get update && apt-get install mariadb-server -y
service mysql start

echo '
[mysqld]
skip-networking=0
skip-bind-address
' >> /etc/mysql/my.cnf

service mysql restart

# in mysql
CREATE USER 'kelompokf01'@'%' IDENTIFIED BY 'passwordf01';
CREATE USER 'kelompokf01'@'localhost' IDENTIFIED BY 'passwordf01';
CREATE DATABASE dbkelompokf01;
GRANT ALL PRIVILEGES ON *.* TO 'kelompokf01'@'%';
GRANT ALL PRIVILEGES ON *.* TO 'kelompokf01'@'localhost';
FLUSH PRIVILEGES;
```

dengan set-up ini, maka worker laravel dapat mengakses database 

### Result
![no 13 test](img/no13_test.png)

## nomor 14
### Problem
Frieren, Flamme, dan Fern memiliki Riegel Channel sesuai dengan quest guide berikut. Jangan lupa melakukan instalasi PHP8.0 dan Composer (14)

### Solution
Pada masing-masing worker, jalankan shell script berikut:
```sh
apt-get update && apt-get install nginx -y


rm -rf /etc/nginx/sites-enabled/*
rm -rf /var/www/html/*

apt-get install -y lsb-release ca-certificates apt-transport-https software-properties-common gnupg2
curl -sSLo /usr/share/keyrings/deb.sury.org-php.gpg https://packages.sury.org/php/apt.gpg
sh -c 'echo "deb [signed-by=/usr/share/keyrings/deb.sury.org-php.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'
apt-get update

apt-get install php8.0 php8.0-mbstring php8.0-xml php8.0-cli php8.0-common php8.0-intl php8.0-opcache php8.0-readline php8.0-mysql php8.0-fpm php8.0-curl unzip wget -y

wget https://getcomposer.org/download/2.0.13/composer.phar
chmod +x composer.phar
mv composer.phar /usr/bin/composer
apt-get install git -y
cd /var/www/html/

git clone https://github.com/martuafernando/laravel-praktikum-jarkom.git

cd laravel-simple-rest-api

composer install
composer update

chown -R www-data:www-data storage

echo '
APP_NAME=Laravel
APP_ENV=local
APP_KEY=
APP_DEBUG=true
APP_URL=http://localhost

LOG_CHANNEL=stack
LOG_DEPRECATIONS_CHANNEL=null
LOG_LEVEL=debug

DB_CONNECTION=mysql
DB_HOST=10.52.2.1
DB_PORT=3306
DB_DATABASE=dbkelompokf01
DB_USERNAME=kelompokf01
DB_PASSWORD=passwordf01

BROADCAST_DRIVER=log
CACHE_DRIVER=file
FILESYSTEM_DISK=local
QUEUE_CONNECTION=sync
SESSION_DRIVER=file
SESSION_LIFETIME=120

MEMCACHED_HOST=127.0.0.1

REDIS_HOST=127.0.0.1
REDIS_PASSWORD=null
REDIS_PORT=6379

MAIL_MAILER=smtp
MAIL_HOST=mailpit
MAIL_PORT=1025
MAIL_USERNAME=null
MAIL_PASSWORD=null
MAIL_ENCRYPTION=null
MAIL_FROM_ADDRESS="hello@example.com"
MAIL_FROM_NAME="${APP_NAME}"

AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
AWS_DEFAULT_REGION=us-east-1
AWS_BUCKET=
AWS_USE_PATH_STYLE_ENDPOINT=false

PUSHER_APP_ID=
PUSHER_APP_KEY=
PUSHER_APP_SECRET=
PUSHER_HOST=
PUSHER_PORT=443
PUSHER_SCHEME=https
PUSHER_APP_CLUSTER=mt1

VITE_PUSHER_APP_KEY="${PUSHER_APP_KEY}"
VITE_PUSHER_HOST="${PUSHER_HOST}"
VITE_PUSHER_PORT="${PUSHER_PORT}"
VITE_PUSHER_SCHEME="${PUSHER_SCHEME}"
VITE_PUSHER_APP_CLUSTER="${PUSHER_APP_CLUSTER}"
' > .env
php artisan key:generate

service php8.0-fpm stop
service php8.0-fpm start

php artisan migrate:fresh
php artisan db:seed --class=AiringsTableSeeder
```

Jangan lupa untuk menjalankan ``php artisan jwt:secret`` untuk mendapatkan secret jwt yang diperlukan untuk autentikasi

## nomor 15-17
### Problem
Riegel Channel memiliki beberapa endpoint yang harus ditesting sebanyak 100 request dengan 10 request/second. Tambahkan response dan hasil testing pada grimoire.
POST /auth/register (15)
POST /auth/login (16)
GET /me (17)

## Solution
Pengujian dilakukan dengan menggunakan load balancer, berikut adalah beberapa contoh script untuk melakukan pengujian tersebut

no 15
```sh
ab -n 100 -c 10 -p data.json -T "application/json" -H "Accept: application/json" -H "Content-Type: application/json" http://channel.f01.com/auth/register
```
dengan data.json sebagai berikut:
```json
{
    "username":"djumanto",
    "password":"djumantoguanteng"
}
```
no 16
```sh
ab -n 100 -c 10 -p login.json -T "application/json" -H "Accept: application/json" -H "Content-Type: application/json" http://channel.f01.com/auth/login
```

dengan login.json sebagai berikut:
```json
{
    "username":"djumanto",
    "password":"djumantoguanteng"
}
```
no 17
```sh
ab -n 100 -c 10 -H "Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vbGFyYXZlbF93b3JrZXIvYXBpL2F1dGgvbG9naW4iLCJpYXQiOjE3MDAxMjQ5MDIsImV4cCI6MTcwMDEyODUwMiwibmJmIjoxNzAwMTI0OTAyLCJqdGkiOiJ4T29rS1A5c3MxWGJrdHBCIiwic3ViIjoiMSIsInBydiI6IjIzYmQ1Yzg5NDlmNjAwYWRiMzllNzAxYzQwMDg3MmRiN2E1OTc2ZjcifQ.A9Bhei2kRyahLtUCdNQbMitgxvN62RcXlhaDhRRTyi8" -H "Content-Type: application/json" http://canyon.f01.com/api/me
```

### Result
| No   | Request/Sec    |
|------|-----------------|
| 15   | 121 req/sec     |
| 16   | 198 req/sec     |
| 17   | 241 req/sec     |

## nomor 18
### Problem
Untuk memastikan ketiganya bekerja sama secara adil untuk mengatur Riegel Channel maka implementasikan Proxy Bind pada Eisen untuk mengaitkan IP dari Frieren, Flamme, dan Fern. (18)
### Solution
```sh
echo '
upstream laravelworker {
        server 10.52.4.1 weight=5;
        server 10.52.4.2 weight=4;
        server 10.52.4.3 weight=3;
}

server {
    listen 80;
    
    server_name channel.f01.com;

    location / {
        proxy_pass http://laravelworker;
    }
}' > /etc/nginx/sites-available/channel.f01.com
ln -s /etc/nginx/sites-available/canyon.f01.com /etc/nginx/sites-enabled

service nginx restart
```

## nomor 19
### Problem
Untuk meningkatkan performa dari Worker, coba implementasikan PHP-FPM pada Frieren, Flamme, dan Fern. Untuk testing kinerja naikkan 
- pm.max_children
- pm.start_servers
- pm.min_spare_servers
- pm.max_spare_servers
sebanyak tiga percobaan dan lakukan testing sebanyak 100 request dengan 10 request/second kemudian berikan hasil analisisnya pada Grimoire.(19)

### Solution
Berikut setup yang saya gunakan untuk 3 jenis percobaan
| Process Manager Settings | Setup 1 | Setup 2 | Setup 3 |
|--------------------------|---------|---------|---------|
| pm.max_children          | 15      | 20      | 25      |
| pm.start_servers         | 5       | 10      | 15      |
| pm.min_spare_servers     | 5       | 5       | 15      |
| pm.max_spare_servers     | 10      | 15      | 20      |

### Result
Berikut adalah hasil pengujian masing-masing set up dengan 3 percobaan untuk masing-masing set-up
| Settings_No | Trial 1 | Trial 2 | Trial 3 | Mean          |
|-------------|---------|---------|---------|---------------|
| Setup 1     | 45.66   | 61      | 59.16   | 55.27333333   |
| Setup 2     | 32.96   | 61.36   | 60.53   | 51.61666667   |
| Setup 3     | 30.13   | 53.58   | 55.97   | 46.56         |

### Statistic
Statistik yang dihasilkan adalah sebagai berikut:

![no 19 test](img/no19_test.png)

Dari data yang ditunjukkan. terbukti bahwa semakin tinggi tune up yang diberikan,. semakin kuat server untuk memprosess request, dengan bayaran penggunaan server yang menjadi lebih berat 

### no 20
### Problem
Nampaknya hanya menggunakan PHP-FPM tidak cukup untuk meningkatkan performa dari worker maka implementasikan Least-Conn pada Eisen. Untuk testing kinerja dari worker tersebut dilakukan sebanyak 100 request dengan 10 request/second. (20)
### Solution
Kita hanya perlu menambahkan least_conn pada upstream block, sehingga load balancing yang dilakukan adalah dengan mencari yang
```sh
echo '
upstream laravel_worker {
        least_conn;
        server 10.52.4.1;
        server 10.52.4.2;
        server 10.52.4.3;
}

server {
    listen 80;
    
    server_name channel.f01.com;

    
    location / {
        proxy_pass http://laravel_worker;
    }
}' > /etc/nginx/sites-available/channel.f01.com
ln -s /etc/nginx/sites-available/channel.f01.com /etc/nginx/sites-enabled

service nginx restart
ab -n 100 -c 10 -k -H http://canyon.f01.com/
```
### Result
```sh
Server Software:        nginx/1.14.2
Server Hostname:        canyon.f01.com
Server Port:            80

Document Path:          /
Document Length:        18880 bytes

Concurrency Level:      10
Time taken for tests:   1.934 seconds
Complete requests:      100
Failed requests:        0
Keep-Alive requests:    0
Total transferred:      1998800 bytes
HTML transferred:       1888000 bytes
Requests per second:    51.71 [#/sec] (mean)
Time per request:       193.399 [ms] (mean)
Time per request:       19.340 [ms] (mean, across all concurrent requests)
Transfer rate:          1009.29 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    2   2.6      1      14
Processing:    46  183  49.3    178     347
Waiting:       37  176  49.7    171     340
Total:         46  186  49.4    180     348

Percentage of the requests served within a certain time (ms)
  50%    180
  66%    192
  75%    204
  80%    217
  90%    238
  95%    296
  98%    346
  99%    348
 100%    348 (longest request)
```

