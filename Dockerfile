FROM ubuntu:20.04

ENV DEBIAN_FRONTEN noninteractive

# Expose PortsINTAINER hieu.tnbk2011@yahoo.com
# Install Packages
WORKDIR /var/www/html/
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates curl nano mysql-client git 
RUN export LANG=en_US.UTF-8 \ 
    && apt-get install -y software-properties-common \
    && apt-get install -y language-pack-en-base \
    && LC_ALL=en_US.UTF-8 add-apt-repository ppa:ondrej/php \
    && apt-get update 
RUN  apt-get -y install php7.4 php7.4-pdo php7.4-mysqlnd php7.4-opcache php7.4-xml php7.4-gd php7.4-mysql php7.4-curl php7.4-zip php7.4-intl php7.4-mbstring php7.4-bcmath php7.4-iconv php7.4-soap php7.4-json 
# Config Apache & PHP
RUN sed -i -e"s/^memory_limit\s*=\s*128M/memory_limit = 2048M/" /etc/php/7.4/apache2/php.ini \
    && sed -i -e"s/^;opcache.enable=1/opcache.enable=1/" /etc/php/7.4/apache2/php.ini \ 
    && a2enmod rewrite \
    && a2enmod headers \
    && rm -rf /var/www/html/* \
    && sed -i "s/None/all/g" /etc/apache2/apache2.conf
ENV APACHE_DOCUMENT_ROOT=/var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf 
# Install composer
RUN curl -sS https://getcomposer.org/installer -o composer-setup.php \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \ 
    && rm -f composer-setup.php
# Install dependencies
COPY www .
COPY config/cmd.sh /cmd.sh
RUN chmod +x /cmd.sh
RUN composer install
RUN chown -R www-data:www-data *
RUN sed -i 's/80/8080/g' /etc/apache2/ports.conf /etc/apache2/sites-available/000-default.conf
ENTRYPOINT ["/cmd.sh"]
