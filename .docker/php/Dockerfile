FROM php:8.3-fpm

ARG user
ARG uid

COPY .docker/php/php.ini /usr/local/etc/php/
COPY .docker/php/docker.conf /usr/local/etc/php-fpm.d/docker.conf

# Set working directory
WORKDIR /var/www

RUN apt-get update

# Install useful tools
RUN apt-get -y install apt-utils nano wget dialog vim procps postgresql-client

# Install system dependencies
RUN apt-get -y install --fix-missing \
    build-essential \   
    locales \
    zip \
    unzip \
    git \
    curl \
    libpng-dev \
    libcurl4 \
    libcurl4-openssl-dev \
    zlib1g-dev \
    libzip-dev \
    libbz2-dev \
    locales \
    libmcrypt-dev \
    libicu-dev \
    libonig-dev \
    libxml2-dev \
    supervisor \
    sudo

RUN docker-php-ext-install \
    exif \
    bcmath \
    ctype \
    curl \
    pcntl \
    zip \
    pdo \
    pdo_mysql \
    intl \
    sockets

# Install Postgre PDO
RUN apt-get install -y libpq-dev libz-dev libmemcached-dev \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install pdo_pgsql pgsql

# Install Redis
RUN pecl install redis \
    && docker-php-ext-enable redis

# Install Memcached
RUN pecl install memcached && \
    docker-php-ext-enable memcached

# Install Mongodob
RUN pecl install mongodb \
    && docker-php-ext-enable mongodb

# Install xdebug
RUN pecl install xdebug-3.3.2 \
    && docker-php-ext-enable xdebug
    
# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy the application code into the container
COPY . /var/www

# Run Composer install
RUN composer install

RUN useradd -G www-data,root -u $uid -d /home/$user $user
RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user


#Supervisor Config
# Make supervisor log directory
RUN mkdir -p /var/log/supervisor
RUN touch /var/run/supervisor.sock

# Change current user to www
USER $user

# Expose port 9000 and start php-fpm server
EXPOSE 9000