echo '
upstream php_worker {
        server 10.52.3.1;
        server 10.52.3.2;
        server 10.52.3.3;
}

server {
    listen 80;
    
    server_name canyon.f01.com;

    auth_basic "Restricted";
    auth_basic_user_file /etc/nginx/rahasiakita/.htpasswd;
    
    location / {
        proxy_pass http://php_worker;
    }

    location /its/ {
        proxy_pass http://www.its.ac.id;
    }
}' > /etc/nginx/sites-available/canyon.f01.com

service nginx restart