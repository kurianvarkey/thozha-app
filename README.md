# thozha-app

Thozha App
## Getting Started

Download the latest source
```
git clone https://github.com/kurianvarkey/thozha-app.git thozha-app
```

Please install docker if not installed

Go to thozha-app dir

```
cd thozha-app
```

Run setp.sh

```
bash ./setup.sh
```

## Or run manually

```
cp .env.example .env

docker run --rm -v $(pwd):/app composer install

docker-compose up -d

docker-compose exec api php artisan migrate
```

### Composer update
```
docker run --rm -v $(pwd):/app composer update
```

### Artisan about
```
docker-compose exec api php artisan about
```

### Run the migration
```
docker-compose exec api php artisan migrate
```

### Run the test
```
docker-compose exec api php artisan test --coverage
```

### Application url
http://localhost:8000/

http://localhost:8000/users


### Application code
The code related to this sample project is in the kapi folder.


### Run the database seeding first if requesting from postman
```
docker-compose exec api php artisan db:seed
```

## Docker Troubleshooting
In case docker is showing any issues or errors, please try following:

After downloading/cloning the mnotes,

```
$ cd thozha-app
$ docker run --rm -v $(pwd):/app composer install
$ sudo chown -R dev:dev .
```

## Install PHP 8.3
```
https://php.watch/articles/php-8.3-install-upgrade-on-debian-ubuntu#php83-debian-quick
```

## Install Composer
```
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === 'dac665fdc30fdd8ec78b38b9800061b4150413ff2e3b6f88543c636f7cd84f6db9189d43a81e5503cda447da73c7e5b6') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"
sudo mv composer.phar /usr/local/bin/composer
```

## For host setup
Add following lines in the windows host, if working from WSL
<wsl ip> - run ipconfig in cmd
```
# Added for thozha
<wsl ip> thozha.local
<wsl ip> api.thozha.local
<wsl ip> ws.thozha.local
# End 
```

## Artisan commands
Clear Application Cache
```
php artisan cache:clear
```
Clear Route Cache
```
php artisan route:clear
```
Clear Configuration Cache
```
php artisan config:clear
```