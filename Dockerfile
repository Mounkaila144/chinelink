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

# Définir le répertoire de travail
WORKDIR /var/www/chinelink

# Copier le code source dans le conteneur
COPY . /var/www/chinelink

# Créer les répertoires nécessaires
RUN mkdir -p /var/www/chinelink/storage /var/www/chinelink/bootstrap/cache

# Changer les permissions du répertoire de travail
RUN chown -R www-data:www-data /var/www/chinelink \
    && chmod -R 777 /var/www/chinelink \
    && chown -R www-data:www-data /var/www/chinelink/storage \
    && chmod -R 777 /var/www/chinelink/storage \
    && chown -R www-data:www-data /var/www/chinelink/bootstrap/cache \
    && chmod -R 777 /var/www/chinelink/bootstrap/cache

# Exécuter Composer sous l'utilisateur non-root
USER composeruser

# Installation des dépendances PHP
RUN composer install --no-interaction --prefer-dist --optimize-autoloader || { cat /var/www/chinelink/vendor/composer/installed.json; exit 1; }

# Revenir à l'utilisateur root pour les étapes suivantes
USER root

# Exposition du port 9000 pour PHP-FPM
EXPOSE 9000

CMD ["php-fpm"]
