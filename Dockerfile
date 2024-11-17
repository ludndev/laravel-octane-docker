FROM php:8.2.4-alpine

RUN apk update

RUN apk add \
    autoconf \
    g++ \
    make \
    libpng-dev \
    libjpeg-turbo-dev \
    freetype-dev \
    libzip-dev \
    postgresql-dev

docker-php-ext-install pdo pdo_pgsql

# install and enable Swoole
RUN pecl install swoole && docker-php-ext-enable swoole

RUN docker-php-ext-install pcntl

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /usr/src/app

COPY . .

RUN cp -n .env.example .env

RUN composer install --no-interaction --optimize-autoloader --no-dev

RUN php artisan key:generate

#ENV WEB_DOCUMENT_ROOT=/usr/src/app/public
#ENV APP_HOST=0.0.0.0

RUN php artisan key:generate

RUN php artisan config:cache

RUN php artisan route:cache

RUN php artisan view:cache

EXPOSE 8000

#CMD ["php", "artisan", "serve", "--host=0.0.0.0"]

CMD ["php", "artisan", "octane:start", "--host=0.0.0.0", "--workers=4", "--task-workers=6"]
