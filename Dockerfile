# Utilisez une image de base PHP compatible avec arm64 pour macOS M1
FROM php:8.1-fpm

# Installez les extensions PHP nécessaires
RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libzip-dev \
    zip \
    unzip \
    git \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install pdo pdo_mysql zip

# Installez Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www

COPY . /var/www

RUN composer install

# Créez le répertoire var s'il n'existe pas
RUN mkdir -p /var/www/var

# Changez les permissions des fichiers
RUN chown -R www-data:www-data /var/www/var /var/www/vendor

CMD ["php-fpm"]
