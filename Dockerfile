FROM alpine:3.3

ENV TIMEZONE            America/Sao_Paulo
ENV PHP_MEMORY_LIMIT    512M
ENV MAX_UPLOAD          100M
ENV PHP_MAX_FILE_UPLOAD 100
ENV PHP_MAX_POST        100M
ENV XDEBUG_VERSION 2.3.3

WORKDIR /var/www/html

RUN apk --update add \
  autoconf \
  gcc \
  make \
  g++ \
  zlib-dev \
  file \
  g++ \
  libc-dev \
  pkgconf \
  tar \
  tzdata \
  wget \
  curl \
  php \
  php-dev \
  php-fpm \
  php-cli \
  php-pdo \
  php-dom \
  php-json \
  php-openssl \
  php-mcrypt \
  php-sqlite3 \
  php-pgsql \
  php-mysql \
  php-mysqli \
  php-pdo_sqlite \
  php-pdo_pgsql \
  php-pdo_mysql \
  php-ctype \
  php-zlib \
  php-phar \
  php-curl \
  php-pear \
  php-iconv \
  php-soap \
  php-gmp \
  php-xcache \
  php-gettext \
  php-xmlrpc \
  php-bz2 \
  php-memcache \
  php-ldap \
  php-zip \
  php-gd \
  libmemcached-dev \
  libmemcached \
  git \

  #Install NodeJS
  nodejs \

  #Install NPM
  && curl -L https://npmjs.org/install.sh | sh \

  #Install Composer
  && curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer \

  #Configuring php.ini
  && sed -i "s|;*daemonize\s*=\s*yes|daemonize = no|g" /etc/php/php-fpm.conf && \
  sed -i "s|;*listen\s*=\s*127.0.0.1:9000|listen = 9000|g" /etc/php/php-fpm.conf && \
  sed -i "s|;*listen\s*=\s*/||g" /etc/php/php-fpm.conf && \
  sed -i "s|;*date.timezone =.*|date.timezone = ${TIMEZONE}|i" /etc/php/php.ini && \
  sed -i "s|;*memory_limit =.*|memory_limit = ${PHP_MEMORY_LIMIT}|i" /etc/php/php.ini && \
  sed -i "s|;*upload_max_filesize =.*|upload_max_filesize = ${MAX_UPLOAD}|i" /etc/php/php.ini && \
  sed -i "s|;*max_file_uploads =.*|max_file_uploads = ${PHP_MAX_FILE_UPLOAD}|i" /etc/php/php.ini && \
  sed -i "s|;*post_max_size =.*|post_max_size = ${PHP_MAX_POST}|i" /etc/php/php.ini && \
  sed -i "s|;*cgi.fix_pathinfo=.*|cgi.fix_pathinfo= 0|i" /etc/php/php.ini \
  
  #Configuring xdebug
  && cd /tmp && wget http://xdebug.org/files/xdebug-$XDEBUG_VERSION.tgz \
  && tar -zxvf xdebug-$XDEBUG_VERSION.tgz \
  && cd xdebug-$XDEBUG_VERSION && phpize \
  && ./configure --enable-xdebug && make && make install \
  && echo "zend_extension=$(find /usr/lib/php/modules/ -name xdebug.so)" > /etc/php/php.ini \
  && echo "xdebug.remote_enable=on" >> /etc/php/php.ini \
  && echo "xdebug.remote_handler=dbgp" >> /etc/php/php.ini \
  && echo "xdebug.remote_connect_back=1" >> /etc/php/php.ini \
  && echo "xdebug.remote_autostart=on" >> /etc/php/php.ini \
  && echo "xdebug.remote_port=9004" >> /etc/php/php.ini \

  #Delete cache
  && apk del tzdata \
  && rm -rf /var/cache/apk/* \
  && rm -rf tmp/*

  EXPOSE 9000
  EXPOSE 9004

  CMD ["php-fpm"]
