
[www]
user = www-data
group = www-data

listen = /run/php/php8.0-fpm.sock

listen.owner = www-data
listen.group = www-data

pm = dynamic

pm.max_children = 15

pm.start_servers = 5

pm.min_spare_servers = 5

pm.max_spare_servers = 10
