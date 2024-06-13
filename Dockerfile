FROM php:8.3-fpm

# Installation des extensions PHP nécessaires
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
    && docker-php-ext-install zip pdo pdo_mysql

# Installation de Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copie du code source
COPY . /var/www
WORKDIR /var/www

# Installation des dépendances PHP
RUN composer install --no-dev --optimize-autoloader

# Permissions sur le dossier de stockage
RUN chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache

# Exposition du port 9000 pour PHP-FPM
EXPOSE 9000

CMD ["php-fpm"]
