#!/bin/bash
#Change default port
sed -i "s/80/$LISTEN_PORT/g" /etc/nginx/nginx.conf /etc/nginx/sites-available/default.conf
# Start supervisord and services
/usr/bin/supervisord -n -c /etc/supervisord.conf
