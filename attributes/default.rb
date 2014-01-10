#
# Cookbook Name:: ghubbkup
# Recipe:: default
#
# Copyright 2014, Gerald L. Hevener Jr., M.S.
#
# Set config file for ghubbkup.
node.set['ghubbkup']['conf'] = '/etc/ghubbkup.conf'

# Set ghubbkup install dir.
node.set['ghubbkup']['install_dir'] = '/usr/local/bin'

# Set Github user. You should probably override this!
node.set['ghubbkup']['user'] = 'root'

# Set group owner of config & backup dir. You should probably override this!
node.set['ghubbkup']['group'] = 'root'

# Set Github password. You should probably override this!
node.set['ghubbkup']['pass'] = 'secret'

# Encrypted data bag secret file.
node.set['ghubbkup']['data_bag_secret'] = '/etc/chef/encrypted_data_bag_secret'

# Encrypted data bag name.
node.set['ghubbkup']['encrypted_data_bag_name'] = 'ghubbkup'

# Encrypted data bag item.
node.set['ghubbkup']['encrypted_data_bag_item'] = 'creds'

# Set tmp repo list.
node.set['ghubbkup']['tmp_repo_list'] = '/tmp/repos.txt'

# Set repo list.
node.set['ghubbkup']['repo_list'] = '/tmp/repos2.txt'

# Set backup directory.
node.set['ghubbkup']['backup_dir'] = '/tmp/github_repos_backup'

# Set git extension.
node.set['ghubbkup']['git_extension'] = '.git'

# Set git URL.
node.set['ghubbkup']['git_url'] = 'https://github.com/'

# Backup method. Possible options: s3.
# Set to s3 if you wan to backup repos to s3. No backups are done by default.
node.set['ghubbkup']['backup_type'] = ''
