#!/bin/sh

echo "Running the atrisan migrate for dev db"
php artisan migrate

echo "Clearing the cache"
php artisan optimize:clear

echo "Reloading the supervisor - Done"
supervisord -c /etc/supervisor/supervisord.conf