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