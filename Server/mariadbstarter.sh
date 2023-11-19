apt-get update && apt-get install mariadb-server -y
service mysql start

CREATE USER 'kelompokf01'@'%' IDENTIFIED BY 'passwordf01';
CREATE USER 'kelompokf01'@'localhost' IDENTIFIED BY 'passwordf01';
CREATE DATABASE dbkelompokf01;
GRANT ALL PRIVILEGES ON *.* TO 'kelompokf01'@'%';
GRANT ALL PRIVILEGES ON *.* TO 'kelompokf01'@'localhost';
FLUSH PRIVILEGES;