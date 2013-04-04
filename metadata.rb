name             'drupal-windows'
maintainer       'YOUR_COMPANY_NAME'
maintainer_email 'YOUR_EMAIL'
license          'All rights reserved'
description      'Installs/Configures drupal-windows'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends "windows" 
depends "vcruntime-cookbook"
depends "php-windows-cookbook"
depends "apache2-windows-cookbook"
#need sql server driver for php here
