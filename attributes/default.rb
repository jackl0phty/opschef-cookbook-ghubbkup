#
# Cookbook Name:: ghubbkup
# Recipe:: default
#
# Copyright 2014, Gerald L. Hevener Jr., M.S.
#
# Set config dir for ghubbkup.
node.set['ghubbkup']['conf_dir'] = '/etc'

# Set ghubbkup install dir.
node.set['ghubbkup']['install_dir'] = '/usr/local/bin'

# Set ghubbkup user.
node.set['ghubbkup']['user'] = 'root'

# Set ghubbkup user.
node.set['ghubbkup']['pass'] = 'root'

# Encrypted data bag secret file.
node.set['ghubbkup']['data_bag_secret'] = '/etc/chef/encrypted_data_bag_secret'

# Encrypted data bag name.
node.set['ghubbkup']['encrypted_data_bag_name'] = 'ghubbkup'

# Encrypted data bag item.
node.set['ghubbkup']['encrypted_data_bag_item'] = 'creds'
