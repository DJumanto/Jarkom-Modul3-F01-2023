apt-get update
apt-get install nginx -y

rm -rf /etc/nginx/sites-enabled/*

echo '
upstream php_worker {
        server 10.52.3.3;
        server 10.52.3.4;
        server 10.52.3.5;
}

server {
    listen 80;
    
    server_name granz.canyon.f01.com;

    location / {
        proxy_pass http://php_worker;
    }
}' > /etc/nginx/sites-available/granz.canyon.f01.com

echo '
upstream laravel_worker {
        server 10.52.1.3;
        server 10.52.1.4;
        server 10.52.1.5;
}

server {
    listen 80;
    
    server_name riegel.canyon.f01.com;

    location / {
        proxy_pass http://laravel_worker;
    }
}' > /etc/nginx/sites-available/riegel.canyon.f01.com

ln -s /etc/nginx/sites-available/riegel.canyon.f01.com /etc/nginx/sites-enabled
ln -s /etc/nginx/sites-available/granz.canyon.f01.com /etc/nginx/sites-enabled