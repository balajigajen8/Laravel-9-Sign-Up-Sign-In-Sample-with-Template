# Stage 1: Builder
FROM composer:2.6 AS builder
WORKDIR /app
COPY app/ /app
RUN composer install --no-dev --optimize-autoloader

# Stage 2: Final Image
FROM php:8.1-fpm
WORKDIR /var/www
COPY --from=builder /app /var/www
RUN docker-php-ext-install pdo pdo_mysql

# Nginx
RUN apt-get update && apt-get install -y nginx
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80
CMD ["php-fpm", "-D", "&&", "nginx", "-g", "daemon off;"]
