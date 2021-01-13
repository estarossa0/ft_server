#!/bin/bash

#-------------------------------------------------------------------------------------------------
apt update
apt install -y nginx
apt install -y vim
apt install -y mariadb-server
apt install -y php7.3-fpm
apt install -y php-mysqli
apt install -y php php-mysql php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip
apt install -y wget
apt install -y pwgen
apt install -y procps
#-------------------------------------------------------------------------------------------------

wget https://files.phpmyadmin.net/phpMyAdmin/4.9.4/phpMyAdmin-4.9.4-all-languages.tar.gz
wget https://wordpress.org/latest.tar.gz

tar xf latest.tar.gz -C /var/www/html/
tar xf phpMyAdmin-4.9.4-all-languages.tar.gz -C /var/www/html/

rm -rf phpMyAdmin-4.9.4-all-languages.tar.gz
rm -rf latest.tar.gz

mv /var/www/html/phpMyAdmin-4.9.4-all-languages /var/www/html/phpmyadmin
mv /root/src/index.html /var/www/html/index.html
#-------------------------------------------------------------------------------------------------

blow=$(pwgen -s 32 1)
sed -i 's/\$cfg..blow.*/\$cfg\['\'blowfish_secret\''] = '\'$blow\'';/' /root/src/config.inc.php
cp /root/src/config.inc.php /var/www/html/phpmyadmin/
mkdir -p /var/lib/phpmyadmin/tmp
chown -R www-data:www-data /var/lib/phpmyadmin
mv -f /root/src/default /etc/nginx/sites-enabled/default
#-------------------------------------------------------------------------------------------------

chown -R www-data:www-data /var/www/html/wordpress
cp /root/src/myblog.conf /etc/nginx/conf.d/
cp /root/src/wp-config.php /var/www/html/wordpress
#-------------------------------------------------------------------------------------------------
mkdir /etc/nginx/ssl
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt -subj "/C=MA/ST=khouribga/L=Khouribga/O=leet/OU=./CN=."
#-------------------------------------------------------------------------------------------------

service mysql start
mysql < /var/www/html/phpmyadmin/sql/create_tables.sql
mysql -e "use mysql; create user 'estarossa'@'%' identified by '123'; grant all privileges on *.* to 'estarossa'@'%' ; flush privileges;"
mysql -e "GRANT SELECT, INSERT, UPDATE, DELETE ON phpmyadmin.* TO 'pma'@'localhost' IDENTIFIED BY 'pmapass'; flush privileges;"
mysql -e "CREATE DATABASE wordpress_db; GRANT ALL ON wordpress_db.* TO 'wp_user'@'localhost' IDENTIFIED BY 'wp_pass'; flush privileges;"
