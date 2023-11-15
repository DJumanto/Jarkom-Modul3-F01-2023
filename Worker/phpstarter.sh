apt-get update
apt-get install nginx -y
apt-get install php php-fpm -y
apt-get install unzip -y

rm -rf /etc/nginx/sites-enabled/*
rm -rf /var/www/html/*

wget --no-check-certificate "https://drive.google.com/uc?export=download&id=1ViSkRq7SmwZgdK64eRbr5Fm1EGCTPrU1" -O phpapp.zip

unzip phpapp.zip -d /var/www/html

service php7.3-fpm stop
echo '
server {
    listen 80;
    server_name _;

    root /var/www/html/modul-3;
    index index.php index.html index.htm;

    location / {
        try_files $uri $uri/ /index.php?$args;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php7.3-fpm.sock;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }
}' > /etc/nginx/sites-available/phpapp.com

ln -s /etc/nginx/sites-available/phpapp.com /etc/nginx/sites-enabled

service nginx restart
service php7.3-fpm start
