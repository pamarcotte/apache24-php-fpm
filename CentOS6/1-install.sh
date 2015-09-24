#!/bin/bash

# - Make backups first
/bin/mv -fv /var/cpanel/easy/apache/rawopts/all_php5{,.php-fpm.back}
/bin/mv -fv /var/cpanel/easy/apache/rawopts/all_php5{,.php-fpm.back}
/bin/mv -fv /var/cpanel/easy/apache/rawopts/Apache2_{,.php-fpm.back}

# - EasyApache rawopts for configuring fpm and proxy-fcgi:
echo '--enable-fastcgi' >> /var/cpanel/easy/apache/rawopts/all_php5
echo '--enable-fpm' >> /var/cpanel/easy/apache/rawopts/all_php5
echo '--enable-proxy-fcgi=static' >> /var/cpanel/easy/apache/rawopts/Apache2_

# - Download our configs beforehand
/bin/mkdir -pv /usr/local/etc/fpm.d/
/bin/mkdir -pv /var/run/php-fpm/
/usr/bin/wget --no-check-certificate -O /usr/local/etc/php-fpm.conf https://raw.githubusercontent.com/pamarcotte/apache24-php-fpm/master/confs/php-fpm.conf
/usr/bin/wget --no-check-certificate -O /usr/local/etc/fpm.d/pool.conf.default https://raw.githubusercontent.com/pamarcotte/apache24-php-fpm/master/confs/pool.conf

/usr/bin/wget --no-check-certificate -O /etc/init.d/php-fpm https://raw.githubusercontent.com/pamarcotte/apache24-php-fpm/master/CentOS6/php-fpm
/bin/chmod 0755 /etc/init.d/php-fpm
/sbin/chkconfig php-fpm on

# - compile easyapache with proxy, apache 2.4 worker mpm, php 5.4+
cat << EOF

1) You must now run /scripts/easyapache with the following options enabled:
  * Apache 2.4
  * PHP 5.4 or higher
  * Worker MPM
  * mod_proxy

  NOTE: PHP-FPM and mod_proxy_fcgi will be enabled automatically per rawopts.

2) (OPTIONAL) When EasyApache has finished installing, you'll need to install Zend Opcache using PECL:
  pecl install ZendOpcache

EOF
