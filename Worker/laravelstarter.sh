apt-get update
apt-get install nginx -y
apt-get install php php-fpm -y
apt-get install unzip -y

rm -rf /etc/nginx/sites-enabled/*
rm -rf /var/www/html/*