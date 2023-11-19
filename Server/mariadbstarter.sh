apt-get update && apt-get install mariadb-server -y
service mysql start

echo '
[mysqld]
skip-networking=0
skip-bind-address
' >> /etc/mysql/my.cnf

service mysql restart

CREATE USER 'kelompokf01'@'%' IDENTIFIED BY 'passwordf01';
CREATE USER 'kelompokf01'@'localhost' IDENTIFIED BY 'passwordf01';
CREATE DATABASE dbkelompokf01;
GRANT ALL PRIVILEGES ON *.* TO 'kelompokf01'@'%';
GRANT ALL PRIVILEGES ON *.* TO 'kelompokf01'@'localhost';
FLUSH PRIVILEGES;