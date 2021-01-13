#!/bin/bash

check() {
	pgrep nginx >/dev/null
	ret=$(echo $?)
	if [[ $ret -ne 0 ]]; then
		echo "nginx stopped"
		return 1
	fi
	pgrep mysqld >/dev/null
	ret=$(echo $?)
	if [[ $ret -ne 0 ]]; then
		echo "mysql stopped"
		return 1
	fi
	pgrep php-fpm7.3 >/dev/null
	ret=$(echo $?)
	if [[ $ret -ne 0 ]]; then
		echo "php7.3-fpm stopped"
		return 1
	fi
	return 0
}

service mysql start
service nginx start
service php7.3-fpm start
while true; do
	{
		check
		ret=$(echo $?)
		if [[ $ret -eq 1 ]]; then
			exit 1
		fi
		read -t 10 input
		if [[ $input == "index off" ]]; then
			sed -i 's/autoindex on;/autoindex off;/' /etc/nginx/sites-enabled/default
			service nginx restart
			echo "autoindex is off"
		elif [[ $input == "index on" ]]; then
			sed -i 's/autoindex off;/autoindex on;/' /etc/nginx/sites-enabled/default
			service nginx restart
			echo "autoindex is on"
		fi
	}
done
