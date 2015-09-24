# apache24-php-fpm
Setup tools for Apache 2.4 with PHP-FPM on cPanel servers.

# Setup Instructions
You must run EasyApache and configure the following items:
- Apache 2.4 with Worker MPM
- `mod_proxy`
- `mod_proxy_fcgi`
- PHP 5.4+

The following items are optional, but recommended for performance:
- PHP Zend OpCache from the PECL repository

# Installation
There are two installation scripts that are used to set up the environment to use PHP-FPM on.

1. Run `1-install.sh`. This will add rawopts into EasyApache, and download a couple of configuration files to the system.

2. Run `/scripts/easyapache` and enable the following:
 * Apache 2.4
 * PHP 5.4 or higher
 * `mod_proxy`

3. Run `2-install.sh <username>`. This sets up the Apache include files, enables opcache settings (if installed), sets up the PHP-FPM pool, and restarts Apache and PHP-FPM to pick up the changes.

During the EasyApache compile process, the rawopts should automatically enable PHP-FPM and `mod_proxy_fcgi`.

# Credits
`opcache.php` provided from GitHub user RLerdorf: https://github.com/rlerdorf/opcache-status
