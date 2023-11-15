echo '
upstream php_worker {
        server 10.52.3.3;
        server 10.52.3.4;
        #server 10.52.3.5;
}

server {
    listen 80;
    
    server_name canyon.f01.com;

    location / {
        proxy_pass http://php_worker;
    }
}' > /etc/nginx/sites-available/canyon.f01.com

service nginx restart