action :install do
  # distfile
  #{new_resource.name}
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
    code "xcopy #{sourcepath}.gsub('/', '\\')\\#{node['drupal']['windows']['source']['url'].split("/").last[0,21]} #{node['drupal']['windows']['path']} /e /y"
  end

end
