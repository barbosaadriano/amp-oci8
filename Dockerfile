FROM php:7.3-apache

Maintainer Adriano Barbosa <adriano@adrianob.com.br>

ADD ./oracle/	/tmp/oracle/

RUN apt-get update && apt-get install -y --no-install-recommends alien libaio1 && \
	docker-php-ext-install pdo_mysql && apt-get clean && \
	alien -i /tmp/oracle/oracle-instantclient11.2-basic-11.2.0.4.0-1.x86_64.rpm &&  \
	alien -i /tmp/oracle/oracle-instantclient11.2-sqlplus-11.2.0.4.0-1.x86_64.rpm && \
	alien -i /tmp/oracle/oracle-instantclient11.2-devel-11.2.0.4.0-1.x86_64.rpm && \
	a2enmod rewrite && \
	echo "ServerName localhost" >> /etc/apache2/apache2.conf && \
	sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

RUN echo /usr/lib/oracle/11.2/client64/lib > /etc/ld.so.conf.d/oracle.conf && \
	ldconfig && \
	export ORACLE_HOME=/usr/lib/oracle/11.2/client64/ && \
	echo instantclient,/usr/lib/oracle/11.2/client64/lib | pecl install oci8

ADD ./php/oci8.ini /usr/local/etc/php/conf.d/oci8.ini
