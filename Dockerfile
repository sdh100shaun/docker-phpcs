FROM php:7.1-alpine
RUN mkdir /.composer
RUN mkdir /.composer/cache/
RUN chmod -R 777 /.composer
RUN apk update && apk add bash git openssh rsync tini libxml2 libxml2-dev \
&& docker-php-ext-install dom xml

WORKDIR /tmp

COPY --from=composer:latest usr/bin/composer /usr/bin/composer
RUN echo "phar.readonly = 0" >> /usr/local/etc/php/php.ini

RUN composer create-project "squizlabs/php_codesniffer=2.0.*@dev"

RUN ln -s /tmp/php_codesniffer/scripts/phpcs /usr/local/bin/phpcs
RUN ln -s /tmp/php_codesniffer/scripts/phpcbf /usr/local/bin/phpcbf 
CMD ["phpcbf"]
CMD ["phpcs"]
