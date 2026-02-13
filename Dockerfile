FROM php:8.2-apache

# Install MySQLi extension
RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli

# Enable Apache mod_rewrite for clean URLs
RUN a2enmod rewrite

# Allow .htaccess overrides
RUN sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

# Create writable directories
RUN mkdir -p /var/www/html/qa-cache /var/www/html/qa-blobs /var/www/html/qa-content

# Copy Q2A source
COPY --chown=www-data:www-data . /var/www/html/

# Copy .htaccess from example
COPY --chown=www-data:www-data .htaccess-example /var/www/html/.htaccess

# Copy entrypoint
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Set permissions
RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html && \
    chmod -R 775 /var/www/html/qa-cache /var/www/html/qa-content

EXPOSE 80

ENTRYPOINT ["entrypoint.sh"]
CMD ["apache2-foreground"]
