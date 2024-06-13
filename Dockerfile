FROM php:8.1-fpm

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

# Créer les répertoires nécessaires et définir les permissions
RUN mkdir -p /var/www/chinelink/var/cache/dev /var/www/chinelink/var/log \
    && chown -R www-data:www-data /var/www/chinelink \
    && chmod -R 777 /var/www/chinelink \
    && chown -R www-data:www-data /var/www/chinelink/var/cache \
    && chmod -R 777 /var/www/chinelink/var/cache \
    && chown -R www-data:www-data /var/www/chinelink/var/log \
    && chmod -R 777 /var/www/chinelink/var/log

# Exécution de Composer en tant que root avec débogage
RUN composer install --no-interaction --prefer-dist --optimize-autoloader \
    || { echo "Composer install failed" && ls -al /var/www/chinelink && ls -al /var/www/chinelink/vendor && cat /var/www/chinelink/composer.lock && exit 1; }

# Vérification de la présence du répertoire vendor après l'installation de Composer
RUN echo "Vérification après composer install" && ls -al /var/www/chinelink/vendor

# Exposition du port 9000 pour PHP-FPM
EXPOSE 9000

CMD ["php-fpm"]
