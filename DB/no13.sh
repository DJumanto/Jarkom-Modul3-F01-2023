echo '
[mysqld]
skip-networking=0
skip-bind-address
' >> /etc/mysql/my.cnf

service mysql restart