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

directory node['drupal']['windows']['sourcepath'] do
  action :create
end

#
# TODO - find a way to clean up/fix the unzip'd path/directory
#
windows_zipfile node['drupal']['windows']['sourcepath'] do
  source distzipfile
  action :unzip
  not_if {::File.exists?(::File.join(node['drupal']['windows']['sourcepath'],'index.php'))}
end

# now copy that file off to final destination
#
windows_batch "move_drupal" do
    #xcopy C:\\source\\ruby-1.8.7-p352-i386-mingw32 C:\\ruby /e /y
    code <<-EOH
    xcopy #{node['drupal']['windows']['sourcepath']\\acquia-drupal-7.21.20} #{node['drupal']['windows']['path']} /e /y
    EOH
end

