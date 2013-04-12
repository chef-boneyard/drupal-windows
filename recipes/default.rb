#
# Cookbook Name:: drupal-windows
# Recipe:: default
#
# Copyright 2013, Opscode, Inc
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'apache2-windows'
include_recipe 'php-windows'

###########################################################
# TODO
# conditional install of all azure bits (acs, blob storage)
# as well as support for setup of both mysql and sqlserver
###########################################################

###########################################################
# drupal install
sourcepath=::File.join(Chef::Config[:file_cache_path], "drupal")
distzipfile = ::File.join(sourcepath,"drupal-latest.zip")

# source directory where we land and unroll our zip
directory sourcepath do
  action :create
end

# target dir
directory node['drupal']['windows']['path'] do
  action :create
end

# distfile
remote_file distzipfile do
  source node['drupal']['windows']['source']['url']
  checksum node['drupal']['windows']['source']['checksum']
  notifies :unzip, "windows_zipfile[#{sourcepath}]", :immediately
end

#source_index_file=::File.join(sourcepath,'index.php')
windows_zipfile sourcepath do
  # until CHEF-4082
  #action :nothing
  source distzipfile
  notifies :run, "windows_batch[move_drupal]", :immediately
  not_if {::File.exists?(source_index_file)}
end

windows_batch "move_drupal" do
  action :nothing
  code <<-EOH
  xcopy #{sourcepath}.gsub('/', '\\')\\#{node['drupal']['windows']['source']['url'].split("/").last[0,21]} #{node['drupal']['windows']['path']} /e /y
  EOH
end

###########################################################
# Azure storage plugin
sourcepath="#{Chef::Config[:file_cache_path]}/azure-storage"
distzipfile = "#{sourcepath}/azure-storage-latest.zip"

# source directory where we land and unroll our zip
directory sourcepath do
  action :create
  not_if {::File.directory?(sourcepath)}
end

remote_file distzipfile do
  source node['drupal']['windows']['azure_storage']['source']
  checksum node['drupal']['windows']['azure_storage']['checksum']
  notifies :unzip, "windows_zipfile[#{sourcepath}]", :immediately
end

windows_zipfile sourcepath do
  action :nothing
  source distzipfile
  notifies :run, "windows_batch[move_azure_storage]", :immediately
end

windows_batch "move_azure_storage" do
  action :nothing
  code <<-EOH
  xcopy #{sourcepath.gsub!('/','\\')}\\azure #{node['drupal']['windows']['modules']['path']}\\azure /i /y
  EOH
end


###########################################################
# Azure ACS plugin
sourcepath="#{Chef::Config[:file_cache_path]}/acs-latest"
distzipfile = "#{sourcepath}/azure-acs-latest.zip"

# source directory where we land and unroll our zip
directory sourcepath do
  action :create
  not_if {::File.directory?(sourcepath)}
  end

remote_file distzipfile do
  source node['drupal']['windows']['azure_acs']['source']
  checksum node['drupal']['windows']['azure_acs']['checksum']
  notifies :unzip, "windows_zipfile[#{sourcepath}]", :immediately
end

windows_zipfile sourcepath do
  action :nothing
  source distzipfile
  notifies :run, "windows_batch[move_azure_acs]", :immediately
end

windows_batch "move_azure_acs" do
  action :nothing
  code <<-EOH
  xcopy #{sourcepath.gsub!('/','\\')}\\azure_acs #{node['drupal']['windows']['modules']['path']}\\azure_acs /i /y
  EOH
end

###########################################################
#  sql php drivers
sourcepath="#{Chef::Config[:file_cache_path]}/drupal-sqlserv-driver"
distzipexe = "#{sourcepath}/drupal-sqlserv-driver.exe"

# source directory where we land and unroll our zip
directory sourcepath do
  action :create
  not_if {::File.directory?(sourcepath)}
end

remote_file distzipexe do
  source node['drupal']['windows']['sqlserv-driver']['source']
  checksum node['drupal']['windows']['sqlserv-driver']['checksum']
  #notifies :unzip, "windows_zipfile[#{sourcepath}]"
  notifies :run, 'windows_batch[open-sqlserv-driver]', :immediately
end

# unroll and dump in same dir
windows_batch "open-sqlserv-driver" do
  action :nothing
  code <<-EOH
  #{distzipexe.gsub!('/', '\\')} /T:#{sourcepath.gsub!('/','\\')} /C /Q
  EOH
  notifies :run, 'windows_batch[move-sqlserv-plugin]', :immediately
end

#
# TODO -- install
# ref: http://www.php.net/manual/en/sqlsrv.installation.php
# ref: http://drupal.org/node/1207972
# The SQLSRV extension is enabled by adding appropriate DLL file to
# your PHP extension directory and the corresponding entry to the php.ini file
# copy JUST the one we want over
userini=::File.join(node['drupal']['windows']['path'], '.user.ini' )

windows_batch "move-sqlserv-plugin" do
  action :nothing
  code <<-EOH
  xcopy #{sourcepath.gsub!('/','\\')}\\#{node['drupal']['windows']['database']['sqlserver']['driver']} #{node['drupal']['php']['install_path']}\\ext /y
  EOH
  notifies :create, "template[#{userini}]", :immediately
end

template userini do
  source ".user.ini"
  action :create
end

############################################################
#sqlserv-plugin
sourcepath="#{Chef::Config[:file_cache_path]}/drupal-sqlserv-plugin"
distzipfile = "#{sourcepath}/drupal-sqlserv-plugin.zip"

# source directory where we land and unroll our zip
directory sourcepath do
  action :create
  not_if {::File.directory?(sourcepath)}
  end

remote_file distzipfile do
  source node['drupal']['windows']['sqlserv-plugin']['source']
  checksum node['drupal']['windows']['sqlserv-plugin']['checksum']
  notifies :unzip, "windows_zipfile[#{sourcepath}]", :immediately
end

windows_zipfile sourcepath do
  action :nothing
  source distzipfile
  notifies :run, "windows_batch[move_sqlserv-plugin]", :immediately
end

windows_batch "move_sqlserv-plugin" do
  #action :nothing
  code <<-EOH
  xcopy #{sourcepath.gsub!('/','\\')}\\sqlsrv #{node['drupal']['windows']['modules']['path']}\\sqlsrv /i /y
  EOH
end

template "#{node['drupal']['windows']['path']}/sites/default/settings.php" do
  #not_if { ::File.exists?("::File.join(node['wordpress']['windows']['path']['install'],'.finished") }
  source "settings.php.erb"
  action :create
  variables(
      :database        => node[:azure][:mssql][:databasename],
      :user            => node[:azure][:mssql][:username],
      :password        => node[:azure][:mssql][:password],
      :host            => node[:azure][:mssql][:server],
      :dbprefix        => node['drupal']['database']['prefix']
  )
end


#
# install drush for windows
# to get some command line goodness
#
# http://drush.ws/sites/default/files/attachments/Drush-5.8-2012-12-10-Installer-v1.0.20.msi
#



