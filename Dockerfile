# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: nforay <nforay@student.42.fr>              +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/07/20 17:34:37 by nforay            #+#    #+#              #
#    Updated: 2020/07/20 17:34:57 by nforay           ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM debian:buster

MAINTAINER nforay

EXPOSE 80 443

ADD ./srcs /ft_server

RUN apt-get update -y \
    && apt-get upgrade -y
RUN apt-get install -y curl mariadb-server mariadb-client php7.3 php7.3-fpm php7.3-mbstring php7.3-mysql nginx 

# OpenSSL
RUN openssl req -batch -x509 -nodes -days 365 -newkey rsa:2048 \
      -keyout /etc/ssl/private/localhost.key \
      -out /etc/ssl/certs/localhost.crt
RUN openssl dhparam -out /etc/ssl/certs/dhparam.pem 1024

# NGINX
COPY srcs/localhost /etc/nginx/sites-available
RUN ln -s /etc/nginx/sites-available/localhost /etc/nginx/sites-enabled

# Create folders and download tarball
RUN mkdir -p /var/www/html/phpmyadmin
RUN mkdir -p /var/www/html/wordpress
RUN curl --connect-timeout 5 --retry 5 -L https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-english.tar.gz -o /var/www/html/phpmyadmin/phpmyadmin.tar.gz
RUN curl --connect-timeout 5 --retry 5 -L https://fr.wordpress.org/latest-fr_FR.tar.gz -o /var/www/html/wordpress/wordpress.tar.gz
COPY srcs/ft_server.php /var/www/html
COPY srcs/phpinfo.php /var/www/html
RUN chown -R www-data.www-data /var/www/html

# PhpMyAdmin
WORKDIR /var/www/html/phpmyadmin
RUN su www-data -s /bin/sh -c 'tar -xzf phpmyadmin.tar.gz --strip-components 1' \
      && rm -r phpmyadmin.tar.gz
RUN randomBlowfish=$(openssl rand -base64 32) \
  && sed -e "s|cfg\['blowfish_secret'\] = ''|cfg['blowfish_secret'] = '$randomBlowfish'|" config.sample.inc.php > config.inc.php

# Wordpress
WORKDIR /var/www/html/wordpress
RUN su www-data -s /bin/sh -c 'tar -xzf wordpress.tar.gz --strip-components 1' \
      && rm -r wordpress.tar.gz
RUN cp /ft_server/wp-config.php . && chown www-data.www-data wp-config.php

# Start Services
WORKDIR /ft_server
CMD ["sh", "start.sh"]

# docker build -t ft_server .
# docker run -it -p 80:80 -p 443:443 ft_server
# docker system prune -a
