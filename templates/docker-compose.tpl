version: "3"

services:
  mysql_db:
    image: mysql:8.0
    container_name: mysql_db
    restart: always
    env_file: 
      - .env
    environment:
      MYSQL_ROOT_PASSWORD: ${WORDPRESS_ROOT_PASSWORD}
      MYSQL_DATABASE: wordpressdatabase
      MYSQL_USER: ${WORDPRESS_DB_USER}
      MYSQL_PASSWORD: ${WORDPRESS_DB_PASSWORD}
    volumes: 
      - ~/mysql_db_data:/var/lib/mysql
    networks:
      - proxy

  sandbox_01:
    depends_on:
      - mysql_db
    image: wordpress:php7.4-fpm-alpine
    container_name: sandbox_01
    restart: always
    volumes:
      - ~/sandbox_01:/var/www/html:ro
      - ./php-fpm/www.conf:/usr/local/etc/php-fpm.d/www.conf
    env_file:
      - .env
    environment:
      WORDPRESS_DB_HOST: mysql_db:3306
      WORDPRESS_DB_USER: ${WORDPRESS_DB_USER}
      WORDPRESS_DB_PASSWORD: ${WORDPRESS_DB_PASSWORD}
      WORDPRESS_DB_NAME: wordpressdatabase
      VIRTUAL_HOST: www.${domain}
      LETSENCRYPT_HOST: www.${domain}
      LETSENCRYPT_EMAIL: ${email}
    networks:
      - proxy

  phpmyadmin:
    depends_on:
      - mysql_db
    image: phpmyadmin:fpm-alpine
    container_name: phpmyadmin
    restart: always
    env_file:
      - .env
    environment:
      PMA_HOST: mysql_db:3306
    networks:
      - proxy

networks:
  proxy:
    external: true