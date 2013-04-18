drupal-windows Cookbook
=======================
Installs and configures Drupal on Windows

Requirements
------------
#### packages
- windows
- vcruntime
- php-windows
- apache2-windows

Attributes
----------

#### drupal-windows::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['drupal']['database']['driver']</tt></td>
    <td>String</td>
    <td>Drupal database driver </td>
    <td><tt>sqlsrv</tt></td>
  </tr>
  <tr>
    <td><tt>['drupal']['drupal']['database']['prefix']</tt></td>
    <td>String</td>
    <td>Drupal database prefix </td>
    <td><tt>druzi_</tt></td>
  </tr>
  <tr>
    <td><tt>['drupal']['php']['install_path']</tt></td>
    <td>String</td>
    <td>Drupal PHP install path</td>
    <td><tt>#{node['php']['windows']['path']}</tt></td>
  </tr>
  <tr>
    <td><tt>['drupal']['windows']['source']['url']</tt></td>
    <td>String</td>
    <td>Drupal source URL</td>
    <td><tt>http://www.acquia.com/sites/default/files/downloads/acquia-drupal/7.x/acquia-drupal-7.21.20.5959.zip</tt></td>
  </tr>
  <tr>
    <td><tt>['drupal']['windows']['source']['checksum']</tt></td>
    <td>String</td>
    <td>Drupal source checksum</td>
    <td><tt>6dcb3a765e804f646908f99bd6cd45906959bd8908030c0256c1608de6b21cff</tt></td>
  </tr>
  <tr>
    <td><tt>['drupal']['windows']['path']</tt></td>
    <td>String</td>
    <td>Path to Drupal files</td>
    <td><tt>#{node['apache2']['windows']['path']}/htdocs</tt></td>
  </tr>
  <tr>
    <td><tt>['drupal']['windows']['modules']['path']</tt></td>
    <td>String</td>
    <td>Path to Drupal modules</td>
    <td><tt>#{node['drupal']['windows']['path']}/sites/all/modules</tt></td>
  </tr>
  <tr>
    <td><tt>['drupal']['windows']['azure_storage']['source']</tt></td>
    <td>String</td>
    <td>Drupal Azure storage source</td>
    <td><tt>http://ftp.drupal.org/files/projects/azure-7.x-1.0-rc1.zip</tt></td>
  </tr>
  <tr>
    <td><tt>['drupal']['windows']['azure_storage']['checksum']</tt></td>
    <td>String</td>
    <td>Drupal Azure storage source checksum</td>
    <td><tt>292bf01bbade9c7b85996d602a8509aecdfe288f623948d96dd70a3a41a54e0d</tt></td>
  </tr>
  <tr>
    <td><tt>['drupal']['windows']['azure_acs']['source']</tt></td>
    <td>String</td>
    <td>Azure ACS plugin source</td>
    <td><tt>http://ftp.drupal.org/files/projects/azure_acs-7.x-1.0-rc1.zip</tt></td>
  </tr>
  <tr>
    <td><tt>['drupal']['windows']['azure_acs']['checksum']</tt></td>
    <td>String</td>
    <td>Acure ACS plugin checksum</td>
    <td><tt>71ff64922510bd40658844b8256178208ae9f243484b1225b29585b0c45ddee9</tt></td>
  </tr>
  <tr>
    <td><tt>['drupal']['windows']['sqlserv-client']['source_x86']</tt></td>
    <td>String</td>
    <td>Microsoft SQLServer client x86 source</td>
    <td><tt>http://download.microsoft.com/download/F/E/D/FEDB200F-DE2A-46D8-B661-D019DFE9D470/ENU/x86/sqlncli.msi</tt></td>
  </tr>
  <tr>
    <td><tt>['drupal']['windows']['sqlserv-client']['source_x64']</tt></td>
    <td>String</td>
    <td>Microsoft SQLServer client x64 source</td>
    <td><tt>http://download.microsoft.com/download/F/E/D/FEDB200F-DE2A-46D8-B661-D019DFE9D470/ENU/x64/sqlncli.msi</tt></td>
  </tr>
  <tr>
    <td><tt>['drupal']['windows']['sqlserv-client']['default']</tt></td>
    <td>String</td>
    <td>Microsoft SQLServer client default</td>
    <td><tt>#{node['drupal']['windows']['sqlserv-client']['source_x64']}</tt></td>
  </tr>
  <tr>
    <td><tt>['drupal']['windows']['sqlserv-driver']['source']</tt></td>
    <td>String</td>
    <td>Microsoft SQLServer driver for PHP source</td>
    <td><tt>http://download.microsoft.com/download/C/D/B/CDB0A3BB-600E-42ED-8D5E-E4630C905371/SQLSRV30.EXE</tt></td>
  </tr>
  <tr>
    <td><tt>['drupal']['windows']['sqlserv-driver']['checksum']</tt></td>
    <td>String</td>
    <td>Microsoft SQLServer driver for PHP checksum</td>
    <td><tt>6db35194c4e98f647cf8194f99904a55b3e21fd99acdf31bf789070a2b28202c</tt></td>
  </tr>
  <tr>
    <td><tt>['drupal']['windows']['database']['sqlserver']['driver']</tt></td>
    <td>String</td>
    <td>Microsoft SQLServer driver for PHP .dll</td>
    <td><tt>php_sqlsrv_54_ts.dll</tt></td>
  </tr>
  <tr>
    <td><tt>['drupal']['windows']['database']['sqlserver']['pdo_driver']</tt></td>
    <td>String</td>
    <td>Microsoft SQLServer PDO driver</td>
    <td><tt>php_pdo_sqlsrv_54_ts.dll</tt></td>
  </tr>
  <tr>
    <td><tt>['drupal']['windows']['sqlserv-plugin']['source']</tt></td>
    <td>String</td>
    <td>Microsoft SQLServer plugin for Drupal source</td>
    <td><tt>http://ftp.drupal.org/files/projects/sqlsrv-7.x-1.2.zip</tt></td>
  </tr>
  <tr>
    <td><tt>['drupal']['windows']['sqlserv-plugin']['checksum']</tt></td>
    <td>String</td>
    <td>Microsoft SQLServer plugin for Drupal checksum</td>
    <td><tt>4fc7c5ad7ff23cd7cf63f4df4bcfe4f66343fa44875b2f1be9e97840c410a604</tt></td>
  </tr>
</table>

Usage
-----
#### drupal-windows::default

Just include `drupal-windows` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[drupal-windows]"
  ]
}
```

License and Authors
-------------------
Yvo Van Doorn, James Francis, Chris McClimans
