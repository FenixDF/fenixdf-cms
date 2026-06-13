FROM php:8.2-fpm-alpine

RUN apk add --no-cache nginx supervisor
RUN docker-php-ext-install opcache

RUN mkdir -p /run && \
    echo '[www]' > /usr/local/etc/php-fpm.d/www.conf && \
    echo 'user = www-data' >> /usr/local/etc/php-fpm.d/www.conf && \
    echo 'group = www-data' >> /usr/local/etc/php-fpm.d/www.conf && \
    echo 'listen = /var/run/php-fpm.sock' >> /usr/local/etc/php-fpm.d/www.conf && \
    echo 'listen.owner = www-data' >> /usr/local/etc/php-fpm.d/www.conf && \
    echo 'listen.group = www-data' >> /usr/local/etc/php-fpm.d/www.conf && \
    echo 'listen.mode = 0660' >> /usr/local/etc/php-fpm.d/www.conf && \
    echo 'pm = dynamic' >> /usr/local/etc/php-fpm.d/www.conf && \
    echo 'pm.max_children = 5' >> /usr/local/etc/php-fpm.d/www.conf && \
    echo 'pm.start_servers = 2' >> /usr/local/etc/php-fpm.d/www.conf && \
    echo 'pm.min_spare_servers = 1' >> /usr/local/etc/php-fpm.d/www.conf && \
    echo 'pm.max_spare_servers = 3' >> /usr/local/etc/php-fpm.d/www.conf && \
    echo 'clear_env = no' >> /usr/local/etc/php-fpm.d/www.conf

COPY nginx.conf /etc/nginx/nginx.conf
COPY . /var/www/html/

RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html \
    && chmod 777 /var/www/html/cmsimple/config.php \
    && chmod 777 /var/www/html/cmsimple/log.txt \
    && chmod 777 /var/www/html/content \
    && chmod 777 /var/www/html/userfiles

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 80

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
