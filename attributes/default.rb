default['drupal']['database']['driver']='sqlsrv'
default['drupal']['database']['prefix']='dru_'

default['drupal']['php']['install_path']='C:/php'

default['drupal']['windows']['source']['url'] = 'http://www.acquia.com/sites/default/files/downloads/acquia-drupal/7.x/acquia-drupal-7.21.20.5959.zip'
default['drupal']['windows']['source']['checksum'] = '6dcb3a765e804f646908f99bd6cd45906959bd8908030c0256c1608de6b21cff'
default['drupal']['windows']['path'] = "#{node['apache2']['windows']['path']}/htdocs"

# azure php plugin  -- required by storage
#default['drupal']['windows']['azure_php_sdk']['source'] = "d"
#default['drupal']['windows']['azure_php_sdk']['checksum'] = "d"

default['drupal']['windows']['modules']['path'] = "#{node['php']['windows']['path']}/ext/modules"

# azure storage plugin
default['drupal']['windows']['plugins']['azure_storage']['source'] = 'http://ftp.drupal.org/files/projects/azure-7.x-1.0-rc1.zip'
default['drupal']['windows']['plugins']['azure_storage']['checksum'] = '292bf01bbade9c7b85996d602a8509aecdfe288f623948d96dd70a3a41a54e0d'


# azure ACS plugin
default['drupal']['windows']['plugins']['azure_acs']['source'] = 'http://ftp.drupal.org/files/projects/azure_acs-7.x-1.0-rc1.zip'
default['drupal']['windows']['plugins']['azure_acs']['checksum'] = '71ff64922510bd40658844b8256178208ae9f243484b1225b29585b0c45ddee9'

# sql server plugin for drupal
default['drupal']['windows']['plugins']['sqlsrv']['source'] = 'http://ftp.drupal.org/files/projects/sqlsrv-7.x-1.2.zip'
default['drupal']['windows']['plugins']['sqlsrv']['checksum'] = '4fc7c5ad7ff23cd7cf63f4df4bcfe4f66343fa44875b2f1be9e97840c410a604'

default['drupal']['windows']['enabled_plugins']=['azure_storage','azure_acs','sqlsrv']

