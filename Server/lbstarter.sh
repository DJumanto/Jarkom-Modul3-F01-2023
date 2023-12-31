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
    
    server_name canyon.f01.com;

    location / {
        proxy_pass http://php_worker;
    }
}' > /etc/nginx/sites-available/canyon.f01.com

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
ln -s /etc/nginx/sites-available/channel.f01.com /etc/nginx/sites-enabled

service nginx restart