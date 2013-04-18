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
include_recipe 'drupal-windows::php-sqlserver-drivers'

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

drupal_versioned_dir=::File.join(sourcepath, node['drupal']['windows']['source']['url'].split('/').last[0,21])
windows_zipfile sourcepath do
  # until CHEF-4082
  #action :nothing
  source distzipfile
  notifies :run, "windows_batch[move_drupal]", :immediately
  not_if {::File.exists?(::File.join(drupal_versioned_dir,'index.php'))}
end

windows_batch "move_drupal" do
  action :nothing
  code <<-EOH
  xcopy #{drupal_versioned_dir.gsub('/', '\\') } #{node['drupal']['windows']['path'].gsub('/', '\\') } /e /y
  EOH
end

###########################################################
# Azure storage plugin
sourcepath="#{Chef::Config[:file_cache_path]}/azure-storage"
distzipfile = "#{sourcepath}/azure-storage-latest.zip"

# source directory where we land and unroll our zip
directory sourcepath

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
  #action :nothing
  code <<-EOH
  xcopy #{sourcepath.gsub('/','\\')}\\azure #{node['drupal']['windows']['modules']['path'].gsub('/', '\\')}\\azure /i /y
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
  xcopy #{sourcepath.gsub('/','\\')}\\azure_acs #{node['drupal']['windows']['modules']['path'].gsub('/', '\\')}\\azure_acs /i /y
  EOH
end

#template userini do
#  source ".user.ini"
#  action :create
#end



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


#directory "#{node['drupal']['windows']['modules']['path']}"
directory "#{node['drupal']['windows']['path']}\\sites\\all\\modules"

windows_batch "move_sqlserv-plugin" do
  #action :nothing
  code <<-EOH
  xcopy #{sourcepath.gsub('/','\\')}\\sqlsrv  #{node['drupal']['windows']['path'].gsub('/', '\\')}\\sites\\all\\modules\\sqlsrv /i /y
  xcopy #{sourcepath.gsub('/','\\')}\\sqlsrv\\sqlsrv  #{node['drupal']['windows']['path'].gsub('/', '\\')}\\includes\\database\\sqlsrv /i /y
  EOH
end

template "#{node['drupal']['windows']['path']}/sites/default/settings.php" do
  #not_if { ::File.exists?("::File.join(node['wordpress']['windows']['path']['install'],'.finished") }
  source "settings.php.erb"
  action :create
  variables(
      :driver          => 'sqlsrv',
      # need to magically gen this like in the wp cookbook
      :databasename    => node[:azure][:mssql][:databasename],
      :username        => node[:azure][:mssql][:username],
      :password        => node[:azure][:mssql][:password],
      :host            => node[:azure][:mssql][:server],
      :dbprefix        => (0...6).map{('a'..'z').to_a[rand(26)]}.join << '_'
  )
end

#
# install drush for windows
# to get some command line goodness
#
# http://drush.ws/sites/default/files/attachments/Drush-5.8-2012-12-10-Installer-v1.0.20.msi
#
service 'Apache2.2' do
  action :restart
end


