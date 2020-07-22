#!/bin/bash

#start services
service php7.3-fpm start \
&& service nginx start \
&& service mysql start

#create DB and user
echo -n "Importing databases"
mysql -u root < /var/www/html/phpmyadmin/sql/create_tables.sql
echo -n "."
mysql -u root < /ft_server/create.sql
echo -n "."
mysql -u admin -p'password' -D wordpress < /ft_server/wordpress.sql
echo ". [ \033[32mok\e[0m ]"
bash
