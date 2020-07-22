CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
CREATE USER 'admin'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON wordpress.* TO 'admin'@'localhost';
GRANT ALL PRIVILEGES ON phpmyadmin.* TO 'admin'@'localhost';
