
# ------------------------------------------------------------------------------
# Dockerfile to build basic Apache Linux container images
# Based on Oracle Linux Debian 
# ------------------------------------------------------------------------------

# Set the base image to Apache with Oracle Interface
FROM debian:jessie as apache

# File Author / Maintainer
# Use LABEL rather than deprecated MAINTAINER

LABEL maintainer="https://hub.docker.com/u/fajarneta"

# End

RUN apt-get update
RUN apt-get -y upgrade

# Install Apache2 / PHP 5.6 & Co.
RUN apt-get -y install apache2 \ 
php5 \ 
libapache2-mod-php5 \ 
php5-dev \ 
php-pear \ 
php5-curl \ 
curl \ 
libaio1 \ 
libfreetype6-dev \
libjpeg62-turbo-dev \
libmcrypt-dev \
libpng-dev \
php5-gd \ 
php5-mcrypt

# Install the Oracle Instant Client
ADD ./build/env/oracle/oracle-instantclient12.1-basic_12.1.0.2.0-2_amd64.deb /tmp
ADD ./build/env/oracle/oracle-instantclient12.1-devel_12.1.0.2.0-2_amd64.deb /tmp
ADD ./build/env/oracle/oracle-instantclient12.1-sqlplus_12.1.0.2.0-2_amd64.deb /tmp
RUN dpkg -i /tmp/oracle-instantclient12.1-basic_12.1.0.2.0-2_amd64.deb
RUN dpkg -i /tmp/oracle-instantclient12.1-devel_12.1.0.2.0-2_amd64.deb
RUN dpkg -i /tmp/oracle-instantclient12.1-sqlplus_12.1.0.2.0-2_amd64.deb
RUN rm -rf /tmp/oracle-instantclient12.1-*.deb

# Set up the Oracle environment variables
ENV LD_LIBRARY_PATH /usr/lib/oracle/12.1/client64/lib/
ENV ORACLE_HOME /usr/lib/oracle/12.1/client64/lib/

# Install the OCI8 PHP extension
RUN echo 'instantclient,/usr/lib/oracle/12.1/client64/lib' | pecl install -f oci8-2.0.8
RUN echo "extension=oci8.so" > /etc/php5/apache2/conf.d/30-oci8.ini

# Custom apache2.conf & php.ini
ADD ./build/env/apache2/apache2.conf /etc/apache2/
ADD ./build/env/apache2/sites-available/000-default.conf /etc/apache2/sites-available/
ADD ./build/env/apache2/sites-available/default-ssl.conf /etc/apache2/sites-available/
ADD ./build/env/php5/php.ini /etc/php5/apache2/

# Enable Apache2 modules
RUN a2enmod rewrite

# Set up the Apache2 environment variables
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

EXPOSE 80 443

# Run Apache2 in Foreground
CMD /usr/sbin/apache2 -D FOREGROUND
