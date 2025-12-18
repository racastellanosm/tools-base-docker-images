# docker bake build this image as pre-requsite to be used here
FROM php_base_local AS php_base

# Install required packages
COPY --from=spiralscout/roadrunner:2025.1 /usr/bin/rr /usr/bin/rr

# Install PHP extensions
RUN install-php-extensions pdo_pgsql pgsql zip opcache apcu pcntl curl sockets intl bcmath redis amqp yaml