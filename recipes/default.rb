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

include_recipe 'windows'
include_recipe 'apache2-windows'
include_recipe 'php-windows'
require 'digest'

sourcepath=::File.join(Chef::Config[:file_cache_path], "drupal")
distfilename = "drupal-latest.zip"
distzipfile = ::File.join(sourcepath, distfilename)

# source directory where we land and unroll our zip
directory sourcepath do
  action :create
  not_if {::File.directory?(sourcepath)}
end

# target dir
directory node['drupal']['windows']['path'] do
  action :create
  not_if {::File.directory?(node['drupal']['windows']['path'])}
end

remote_file distzipfile do
  source node['drupal']['windows']['source']['url']
  checksum node['drupal']['windows']['source']['checksum']
  notifies :unzip, "windows_zipfile[#{sourcepath}]"
end

#source_index_file=::File.join(sourcepath,'index.php')
windows_zipfile sourcepath do
  action :nothing
  source distzipfile
  notifies :run, "windows_batch[move_drupal]"
  #not_if {::File.exists?(source_index_file)}
end

windows_batch "move_drupal" do
  action :nothing
  code <<-EOH
  xcopy #{sourcepath}\\#{node['drupal']['windows']['source']['url'].split("/").last[0,21]} #{node['drupal']['windows']['path']} /e /y
  EOH
end

# create drupal database and user
# Create Wordpress database
# should check if this stuff exists and create if it doesn't
#
#windows_batch "create_drupal_database" do
#  creates "c:/drupaldb.log"
#  code <<-EOH
#  cd c:/mysql/bin
#  mysql -u root -e "CREATE DATABASE #{node['drupal']['db']['database']}"
#  mysql -u root -e "GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, ALTER, INDEX,
#  DROP, CREATE TEMPORARY TABLES, LOCK TABLES
#  ON #{node['drupal']['db']['database']}.*
#  TO '#{node['drupal']['db']['user']}'@'#{node['drupal']['db']['host']}' IDENTIFIED BY 'opscode';"
#  mysql -u root -e "FLUSH PRIVILEGES"
#  touch c:/drupaldb.log
#  EOH
#end
#


#
# Azure storage plugin
#
sourcepath=::File.join(Chef::Config[:file_cache_path], "azure-storage")
distfilename = "azure-storage-latest.zip"
distzipfile = ::File.join(sourcepath, distfilename)

# source directory where we land and unroll our zip
directory sourcepath do
  action :create
  not_if {::File.directory?(sourcepath)}
end

remote_file distzipfile do
  source node['drupal']['windows']['azure_storage']['source']
  checksum node['drupal']['windows']['azure_storage']['checksum']
  notifies :unzip, "windows_zipfile[#{sourcepath}]"
end

windows_zipfile sourcepath do
  action :nothing
  source distzipfile
  notifies :run, "windows_batch[move_azure_storage]"
end

windows_batch "move_azure_storage" do
  action :nothing
  code <<-EOH
  xcopy #{sourcepath}\\azure #{node['drupal']['windows']['path']} /e /y
  EOH
end


#
# Azure ACS plugin
#
sourcepath=::File.join(Chef::Config[:file_cache_path], "acs-latest")
distfilename = "azure-acs-latest.zip"
distzipfile = ::File.join(Chef::Config[:file_cache_path],distfilename)

# source directory where we land and unroll our zip
directory sourcepath do
  action :create
  not_if {::File.directory?(sourcepath)}
  end

remote_file distzipfile do
  source node['drupal']['windows']['azure_acs']['source']
  checksum node['drupal']['windows']['azure_acs']['checksum']
  notifies :unzip, "windows_zipfile[#{sourcepath}]"
end

windows_zipfile sourcepath do
  action :nothing
  source distzipfile
  notifies :run, "windows_batch[move_azure_acs]"
end

windows_batch "move_azure_acs" do
  code <<-EOH
  xcopy #{sourcepath}\\azure #{node['drupal']['windows']['path']} /e /y
  EOH
  # don't copy if 1) file exists or 2) file in unrolled zip file doesn't match hash
end

