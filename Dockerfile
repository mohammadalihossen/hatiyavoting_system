FROM php:8.2-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www

# আপনার সব ফাইল কপি করা
COPY . .

# যদি আপনার ফাইলগুলো 'votingsystem' ফোল্ডারের ভেতর থাকে, তবে নিচের লাইনটি ব্যবহার করুন
# RUN mv votingsystem/* . && mv votingsystem/.* . || true

# পারমিশন ঠিক করা (খুবই জরুরি)
RUN chmod -R 775 storage bootstrap/cache
RUN chown -R www-data:www-data storage bootstrap/cache

# Composer install চালানো
RUN composer install --no-interaction --optimize-autoloader --no-dev

CMD php artisan serve --host=0.0.0.0 --port=10000
