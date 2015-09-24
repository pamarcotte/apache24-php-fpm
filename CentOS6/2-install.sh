#!/bin/bash

CPUSER=$1
CPREGEX="^[a-z][a-z0-9]{1,16}"

if [[ $# > 1 ]] || [[ -z ${CPUSER} ]] || ! [[ ${CPUSER} =~ $CPREGEX ]]; then
        cat << EOF
This installation accepts one argument, the cPanel username.
Run as such:

        2-install.sh cpaneluser
EOF
	exit
fi

echo -ne "[+] Checking if OpCache is enabled... "
# - Set some defaults for opcache, if it's enabled
if [[ -n $(grep opcache.so /usr/local/lib/php.ini) ]]; then
	cat <<EOF >> /usr/local/lib/php.ini
opcache.enable=1
opcache.revalidate_freq=0
opcache.validate_timestamps=0 ; PRODUCTION
;opcache.validate_timestamps=1 ; DEVELOPMENT
;opcache.revalidate_freq=2 ; DEVELOPMENT
opcache.max_accelerated_files=7963
opcache.memory_consumption=128 ; in MB
opcache.interned_strings_buffer=16
opcache.fast_shutdown=1
EOF

	echo -ne "found. Enabled production config items.\n"
else
	echo -ne "not found.\n"
fi

# - Make our include dirs
echo -ne "[+] Setting up include dirs.\n"
/bin/mkdir -pv /usr/local/apache/logs /usr/local/apache/conf/userdata/{std,ssl}/2_4/${CPUSER}/ /usr/local/etc/fpm.d/

# - Set up our pool configuration.
echo -ne "[+] Setting up pool configuration.\n"
/usr/bin/wget -O /usr/local/etc/fpm.d/${CPUSER}.conf https://raw.githubusercontent.com/pamarcotte/apache24-php-fpm/master/confs/pool.conf
/bin/sed -i 's/CPUSERNAME/${CPUSER}/g' /usr/local/etc/fpm.d/${CPUSER}.conf

# - Download our include file and then sed it
echo -ne "[+] Downloading FPM include file and editing.\n"
/usr/bin/wget -O /usr/local/apache/conf/userdata/std/2_4/${CPUSER}/fpm.conf https://raw.githubusercontent.com/pamarcotte/apache24-php-fpm/master/confs/fpm.conf
/bin/cp -av /usr/local/apache/conf/userdata/std/2_4/${CPUSER}/fpm.conf /usr/local/apache/conf/userdata/ssl/2_4/${CPUSER}/fpm.conf
/bin/sed -i 's/CPUSERNAME/${CPUSER}/g' /usr/local/apache/conf/userdata/std/2_4/${CPUSER}/fpm.conf
/bin/sed -i 's/CPUSERNAME/${CPUSER}/g' /usr/local/apache/conf/userdata/ssl/2_4/${CPUSER}/fpm.conf

echo -ne "[+] Restarting Apache and PHP-FPM\n"
if [[ -z "$(/scripts/ensure_vhost_includes --user=${CPUSER})" ]] && [[ "$(/scripts/rebuildhttpdconf)" =~ "OK" ]];
	service php-fpm restart
	service httpd restart
else
	echo -ne "\n[!] Something went wrong! Please check the configs manually.\n"
fi
