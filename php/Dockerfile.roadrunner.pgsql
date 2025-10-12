ARG PHP_VERSION=${PHP_VERSION:-8.2}

FROM php:${PHP_VERSION}-cli-alpine AS php_base

ENV COMPOSER_ALLOW_SUPERUSER=1

# Install required packages
COPY --from=spiralscout/roadrunner:2025.1 /usr/bin/rr /usr/bin/rr
COPY --from=mlocati/php-extension-installer:2.9.7 /usr/bin/install-php-extensions /usr/local/bin/
COPY --from=composer/composer:2.8.11-bin /composer /usr/bin/composer

# Install PHP extensions
RUN install-php-extensions pdo_pgsql pgsql zip opcache apcu pcntl curl sockets intl bcmath redis amqp yaml