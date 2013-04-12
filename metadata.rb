name             'drupal-windows'
maintainer       'YOUR_COMPANY_NAME'
maintainer_email 'YOUR_EMAIL'
license          'All rights reserved'
description      'Installs/Configures drupal-windows'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.11"

depends "windows" 
depends "vcruntime"
depends "php-windows"
depends "apache2-windows"
#need sql server driver for php here
