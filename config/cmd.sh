#!/bin/bash
cd /var/www/html 
runuser -u www-data -- php artisan migrate --force --no-interaction
# Start apache
/usr/sbin/apache2ctl -DFOREGROUND
