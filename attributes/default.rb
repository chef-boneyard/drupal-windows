# local files
default['drupal']['windows']['source'] = "http://www.acquia.com/sites/default/files/downloads/acquia-drupal/7.x/acquia-drupal-7.21.20.5959.zip"
default['drupal']['windows']['source']['checksum'] = "6dcb3a765e804f646908f99bd6cd45906959bd8908030c0256c1608de6b21cff"
default['drupal']['windows']['path'] = "c:\\drupal"

# azure php plugin  -- required by storage
default['drupal']['windows']['azure_php_sdk']['source'] = ""
default['drupal']['windows']['azure_php_sdk']['checksum'] = ""

# azure storage plugin
default['drupal']['windows']['azure_storage']['source'] = "http://ftp.drupal.org/files/projects/azure-7.x-1.0-rc1.zip"
default['drupal']['windows']['azure_storage']['checksum'] = "292bf01bbade9c7b85996d602a8509aecdfe288f623948d96dd70a3a41a54e0d"

# azure ACS plugin
default['drupal']['windows']['azure_acs']['source'] = "http://ftp.drupal.org/files/projects/azure_acs-7.x-1.0-rc1.zip"
default['drupal']['windows']['azure_acs']['checksum'] = "71ff64922510bd40658844b8256178208ae9f243484b1225b29585b0c45ddee9"


# database configs -- mysql
#default['drupal']['db']['database'] = "drupal01"
#default['drupal']['db']['user'] = "drupal"
#default['drupal']['db']['host'] = "localhost"
#
#default['drupal']['site']['admin'] = "admin"
#default['drupal']['site']['pass'] = "drupaladmin"
#default['drupal']['site']['name'] = "Drupal7"
#default['drupal']['apache']['port'] = "80"
#

