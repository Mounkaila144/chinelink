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

# Ajouter un utilisateur non-root pour exécuter Composer
RUN useradd -m -s /bin/bash composeruser

# Définir le répertoire de travail
WORKDIR /var/www/chinelink

# Copier le code source dans le conteneur
COPY . /var/www/chinelink

# Changer les permissions du répertoire de travail
RUN chown -R composeruser:composeruser /var/www/chinelink

# Exécuter Composer sous l'utilisateur non-root
USER composeruser

# Installation des dépendances PHP sans exécuter les scripts
RUN composer install --no-dev --optimize-autoloader --no-scripts

# Revenir à l'utilisateur root pour les étapes suivantes
USER root

# Créer les répertoires nécessaires
RUN mkdir -p /var/www/chinelink/storage /var/www/chinelink/bootstrap/cache

# Permissions sur le dossier de stockage
RUN chown -R www-data:www-data /var/www/chinelink/storage /var/www/chinelink/bootstrap/cache

# Exposition du port 9000 pour PHP-FPM
EXPOSE 9000

CMD ["php-fpm"]
