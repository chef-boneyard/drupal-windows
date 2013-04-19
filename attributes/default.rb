default['drupal']['database']['driver']='sqlsrv'
default['drupal']['database']['prefix']='druzi_'

default['drupal']['php']['install_path']="#{node['php']['windows']['path']}"
default['drupal']['windows']['source']['url'] = 'http://www.acquia.com/sites/default/files/downloads/acquia-drupal/7.x/acquia-drupal-7.21.20.5959.zip'
default['drupal']['windows']['source']['checksum'] = '6dcb3a765e804f646908f99bd6cd45906959bd8908030c0256c1608de6b21cff'
default['drupal']['windows']['path'] = "#{node['apache2']['windows']['path']}/htdocs"

# azure php plugin  -- required by storage
#default['drupal']['windows']['azure_php_sdk']['source'] = "d"
#default['drupal']['windows']['azure_php_sdk']['checksum'] = "d"

#default['drupal']['windows']['modules']['path'] = "#{node['php']['windows']['path']}\\ext\\modules"
default['drupal']['windows']['modules']['path'] = "#{node['drupal']['windows']['path']}/sites/all/modules"

# azure storage plugin
default['drupal']['windows']['azure_storage']['source'] = 'http://ftp.drupal.org/files/projects/azure-7.x-1.0-rc1.zip'
default['drupal']['windows']['azure_storage']['checksum'] = '292bf01bbade9c7b85996d602a8509aecdfe288f623948d96dd70a3a41a54e0d'


# azure ACS plugin
default['drupal']['windows']['azure_acs']['source'] = 'http://ftp.drupal.org/files/projects/azure_acs-7.x-1.0-rc1.zip'
default['drupal']['windows']['azure_acs']['checksum'] = '71ff64922510bd40658844b8256178208ae9f243484b1225b29585b0c45ddee9'


# MS SQLServer client
default['drupal']['windows']['sqlserv-client']['source_x86']='http://download.microsoft.com/download/F/E/D/FEDB200F-DE2A-46D8-B661-D019DFE9D470/ENU/x86/sqlncli.msi'
default['drupal']['windows']['sqlserv-client']['source_x64']= 'http://download.microsoft.com/download/F/E/D/FEDB200F-DE2A-46D8-B661-D019DFE9D470/ENU/x64/sqlncli.msi'
default['drupal']['windows']['sqlserv-client']['default']= #{node['drupal']['windows']['sqlserv-client']['source_x64']}

# ms sql server drivers for php
default['drupal']['windows']['sqlserv-driver']['source'] = 'http://download.microsoft.com/download/C/D/B/CDB0A3BB-600E-42ED-8D5E-E4630C905371/SQLSRV30.EXE'
default['drupal']['windows']['sqlserv-driver']['checksum'] = '6db35194c4e98f647cf8194f99904a55b3e21fd99acdf31bf789070a2b28202c'
default['drupal']['windows']['database']['sqlserver']['driver']='php_sqlsrv_54_ts.dll'
default['drupal']['windows']['database']['sqlserver']['pdo_driver']='php_pdo_sqlsrv_54_ts.dll'

# sql server plugin for drupal
default['drupal']['windows']['sqlserv-plugin']['source'] = 'http://ftp.drupal.org/files/projects/sqlsrv-7.x-1.x-dev.zip'
default['drupal']['windows']['sqlserv-plugin']['checksum'] = '47a21755029f3af3c31210eb5319c014f898007140ad1624e7c76674d4708e70'

default['drupal']['php']['extension']['init']=['php_pdo_sqlsrv_54_ts.dll','php_sqlsrv_54_ts.dll']