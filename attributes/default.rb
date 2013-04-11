default['drupal']['php']['install_path']="C:\\php"

default['drupal']['windows']['source']['url'] = 'http://www.acquia.com/sites/default/files/downloads/acquia-drupal/7.x/acquia-drupal-7.21.20.5959.zip'
default['drupal']['windows']['source']['checksum'] = '6dcb3a765e804f646908f99bd6cd45906959bd8908030c0256c1608de6b21cff'
default['drupal']['windows']['path'] = "#{node['apache2']['windows']['path']}\\htdocs"

# azure php plugin  -- required by storage
#default['drupal']['windows']['azure_php_sdk']['source'] = "d"
#default['drupal']['windows']['azure_php_sdk']['checksum'] = "d"

default['drupal']['windows']['modules']['path'] = "C:\\Apache2\\htdocs\\modules"

# azure storage plugin
default['drupal']['windows']['azure_storage']['source'] = 'http://ftp.drupal.org/files/projects/azure-7.x-1.0-rc1.zip'
default['drupal']['windows']['azure_storage']['checksum'] = '292bf01bbade9c7b85996d602a8509aecdfe288f623948d96dd70a3a41a54e0d'


# azure ACS plugin
default['drupal']['windows']['azure_acs']['source'] = 'http://ftp.drupal.org/files/projects/azure_acs-7.x-1.0-rc1.zip'
default['drupal']['windows']['azure_acs']['checksum'] = '71ff64922510bd40658844b8256178208ae9f243484b1225b29585b0c45ddee9'

# ms sql server drivers for php
default['drupal']['windows']['sqlserv-driver']['source'] = 'http://download.microsoft.com/download/C/D/B/CDB0A3BB-600E-42ED-8D5E-E4630C905371/SQLSRV30.EXE'
default['drupal']['windows']['sqlserv-driver']['checksum'] = '6db35194c4e98f647cf8194f99904a55b3e21fd99acdf31bf789070a2b28202c'
default['drupal']['windows']['database']['sqlserver']['driver']='php_sqlsrv_54_ts.dll'

# sql server plugin for drupal
default['drupal']['windows']['sqlserv-plugin']['source'] = 'http://ftp.drupal.org/files/projects/sqlsrv-7.x-1.2.zip'
default['drupal']['windows']['sqlserv-plugin']['checksum'] = '4fc7c5ad7ff23cd7cf63f4df4bcfe4f66343fa44875b2f1be9e97840c410a604'

