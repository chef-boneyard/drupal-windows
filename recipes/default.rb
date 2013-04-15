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
directory sourcepath

# target dir
directory node['drupal']['windows']['path']

# distfile
remote_file distzipfile do
  source node['drupal']['windows']['source']['url']
  checksum node['drupal']['windows']['source']['checksum']
  notifies :unzip, "windows_zipfile[#{sourcepath}]", :immediately
end

#source_index_file=::File.join(sourcepath,'index.php')
windows_zipfile sourcepath do
  action :nothing
  source distzipfile
  notifies :run, "windows_batch[move_drupal]", :immediately
  # until CHEF-4082 we can't notify with '\' in the filepath
  #not_if {::File.exists?(source_index_file)}
end

windows_batch "move_drupal" do
  action :nothing
  code <<-EOH
  xcopy #{sourcepath}.gsub('/', '\\')\\#{node['drupal']['windows']['source']['url'].split("/").last[0,21]} #{node['drupal']['windows']['path']} /e /y
  EOH
end

node['drupal']['windows']['modules'].each do |dmodule, parms|
  drupal_windows_module dmodule do
    source parms['source']
    checksum parms['checksum']
    dir "#{node['drupal']['windows']['modules']['path']}/azure"
  end
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

template ::File.join(node['drupal']['windows']['path'], '.user.ini') do
  source ".user.ini"
  notifies :restart, 'service[Apache2.2]'
end

############################################################
#sqlsrv-plugin
sourcepath="#{Chef::Config[:file_cache_path]}/drupal-sqlsrv-plugin"
distzipfile = "#{sourcepath}/drupal-sqlsrv-plugin.zip"

# source directory where we land and unroll our zip
directory sourcepath do
  action :create
  not_if {::File.directory?(sourcepath)}
end

remote_file distzipfile do
  source node['drupal']['windows']['sqlsrv-plugin']['source']
  checksum node['drupal']['windows']['sqlsrv-plugin']['checksum']
  notifies :unzip, "windows_zipfile[#{sourcepath}]", :immediately
end

windows_zipfile sourcepath do
  action :nothing
  source distzipfile
  notifies :run, "windows_batch[move_sqlsrv-plugin]", :immediately
end

windows_batch "move_sqlsrv-plugin" do
  action :nothing
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



