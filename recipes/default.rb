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


distfilename = "drupal-latest.zip"
distzipfile = ::File.join(Chef::Config[:file_cache_path],distfilename)

remote_file distzipfile do
  source node['drupal']['windows']['source']
  checksum node['drupal']['windows']['checksum']
end

directory node['drupal']['windows']['path'] do
  action :create
end

windows_zipfile node['drupal']['windows']['path'] do
  source distzipfile
  action :unzip
  not_if {::File.exists?(::File.join(node['drupal']['windows']['path'],'index.php'))}
end




#    # define the command
#    command "#{node['drupal']['drush']['dir']}/drush -y dl drupal-#{node['drupal']['version']} --destination=#{File.dirname(node['drupal']['dir'])} --drupal-project-rename=#{File.basename(node['drupal']['dir'])} && \
#    #{node['drupal']['drush']['dir']}/drush -y site-install -r #{node['drupal']['dir']} --account-name=#{node['drupal']['site']['admin']} --account-pass=#{node['drupal']['site']['pass']} --site-name=#{node['drupal']['site']['name']} \
#    --db-url=mysql://#{node['drupal']['db']['user']}:'#{node['drupal']['db']['password']}'@localhost/#{node['drupal']['db']['database']}"
#    not_if "#{node['drupal']['drush']['dir']}/drush -r #{node['drupal']['dir']} status | grep #{node['drupal']['version']}"
#

    # ref: http://drupal.org/documentation/install/windows


end
