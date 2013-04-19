#
# SQL SERVER BITS
#

###########################################################
# SQL Server native client (in support of sql server php drivers)
windows_package "Microsoft SQL Server Native Client 11.0" do
  #source node['drupal']['windows']['sqlserv-client']['default']
  source 'http://download.microsoft.com/download/F/E/D/FEDB200F-DE2A-46D8-B661-D019DFE9D470/ENU/x64/sqlncli.msi'
  options 'IACCEPTSQLNCLILICENSETERMS=YES'
  action :install
  not_if do
    ::File.exists?('c:/Windows/System32/sqlncli11.dll')
  end
end


###########################################################
#  sql server php drivers
sourcepath=::File.join(Chef::Config[:file_cache_path], 'drupal-sqlserv-driver')
distzipexe = ::File.join(sourcepath, 'drupal-sqlserv-driver.exe')

# source directory where we land and unroll our zip
directory sourcepath

remote_file distzipexe do
  source node['drupal']['windows']['sqlserv-driver']['source']
  checksum node['drupal']['windows']['sqlserv-driver']['checksum']
  #notifies :run, 'windows_batch[open-sqlserv-driver]', :immediately
  #notifies :run, 'windows_batch[move-sqlserv-plugin]', :immediately
end

mpath=::File.join(sourcepath, node['drupal']['windows']['database']['sqlserver']['driver'])
log "**************  exist #{mpath}"

# unroll and dump in same dir
windows_batch "open-sqlserv-driver" do
  #action :nothing
  code "#{distzipexe.gsub!('/', '\\')} /T:#{sourcepath.gsub!('/','\\')} /C /Q"
  code <<-EOH
#{distzipexe.gsub('/', '\\')} /T:#{sourcepath.gsub('/','\\')} /C /Q
  EOH
  not_if do
    ::File.exists?(mpath)
  end
  #notifies :run, 'windows_batch[move-sqlserv-driver]', :immediately
end

#
# TODO -- install
# ref: http://www.php.net/manual/en/sqlsrv.installation.php
# ref: http://drupal.org/node/1207972
# The SQLSRV extension is enabled by adding appropriate DLL file to
# your PHP extension directory and the corresponding entry to the php.ini file
# copy JUST the one we want over

#userini=::File.join(node['drupal']['windows']['path'], '.user.ini' )

# don't think PDO is available to us here so remove it from both template/user.ini and here
windows_batch "move-sqlserv-driver" do
  #action :nothing
  code <<-EOH
  copy /y /b #{sourcepath.gsub('/','\\')}\\#{node['drupal']['windows']['database']['sqlserver']['driver']} #{node['drupal']['php']['install_path']}\\ext\\
  copy /y /b #{sourcepath.gsub('/','\\')}\\#{node['drupal']['windows']['database']['sqlserver']['pdo_driver']} #{node['drupal']['php']['install_path']}\\ext\\
  EOH
  not_if{::File.exists?(::File.join(node['drupal']['php']['install_path'], 'ext', node['drupal']['windows']['database']['sqlserver']['pdo_driver']))}
  #  notifies :create, "template[#{userini}]", :immediately
end