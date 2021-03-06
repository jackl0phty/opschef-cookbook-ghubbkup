#
# Cookbook Name:: ghubbkup
# Recipe:: default
#
# Copyright 2014, Gerald L. Hevener Jr., M.S.
#
# Install wget & curl on arch.
case node['platform']
   
  when "arch"
    %w{ curl wget }.each do |pkg|
    package pkg
  end

end

# Install the github_api ruby gem.
# https://github.com/peter-murach/github
gem_package "github_api" do
  action :install
end

# Deploy the ghubbkup Ruby script.
template "#{node['ghubbkup']['install_dir']}/ghubbkup" do
  source "ghubbkup.erb"
  mode 0755
  owner node['ghubbkup']['user'] 
  group node['ghubbkup']['group']
end

# Make sure data bag secret exists.
if File.exists?(node['ghubbkup']['data_bag_secret']) then

  # Set up encrypted data bag.
  data_bag_secret = node['ghubbkup']['data_bag_secret']
  ghubbkup_secret = Chef::EncryptedDataBagItem.load_secret(data_bag_secret)
  ghubbkup_creds = Chef::EncryptedDataBagItem.load(node['ghubbkup']['encrypted_data_bag_name'], node['ghubbkup']['encrypted_data_bag_item'], ghubbkup_secret)

  # Save Github user & pass to variables.
  ghub_user = ghubbkup_creds["github_user"]
  ghub_pass = ghubbkup_creds["github_pass"]

  # Save creds to node.
  node.set['github_user'] = ghub_user
  node.set['github_pass'] = ghub_pass

  else

    # Inform user to create data bag & item.
    Chef::Log.info("WARNING: You must create encrypted data bag named ghubbkup & item named creds
                    with data bag secret copied to /etc/chef/encrypted_data_bag_secret on your node
                    in order to use the ghubbkup cookbook or override via role!! ")
end

# Deploy config file for ghubbkup.
template "#{node['ghubbkup']['conf_dir']}/ghubbkup.conf" do
  source "ghubbkup.conf.erb"
  mode 0640
  owner node['ghubbkup']['user']
  group node['ghubbkup']['group']
  variables(
      :github_user => ghub_user,
      :github_pass => ghub_pass)
end

# Create backup directory.
directory node['ghubbkup']['backup_dir'] do
  owner node['ghubbkup']['user']
  group node['ghubbkup']['group']
  mode "0775"
  action :create
  not_if "test -d #{node['ghubbkup']['backup_dir']}"
end

# Only install s3cmd if backup type is set to s3.
if node.default['ghubbkup']['backup_type'] = 's3'

  # Include s3cmd.
  include_recipe 'ghubbkup::s3cmd'

end
