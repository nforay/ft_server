#!/bin/bash

if grep -q "autoindex off" /etc/nginx/sites-available/localhost
then
	sed -i 's/autoindex off/autoindex on/g' /etc/nginx/sites-available/localhost
	echo "autoindex on"
else
	sed -i 's/autoindex on/autoindex off/g' /etc/nginx/sites-available/localhost
	echo "autoindex off"
fi
service nginx reload > /dev/null
