apt-get update && apt-get install apache2-utils -y
htpasswd -c /etc/nginx/rahasiakita/.htpasswd netics

echo '
upstream php_worker {
        server 10.52.3.1;
        server 10.52.3.2;
        server 10.52.3.3;
}

server {
    listen 80;
    
    server_name channel.f01.com;

    location / {
        auth_basic "Restricted";
        auth_basic_user_file /etc/nginx/rahasiakita/.htpasswd;
        proxy_pass http://php_worker;
    }
}' > /etc/nginx/sites-available/channel.f01.com