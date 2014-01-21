#
# Cookbook Name:: ghubbkup
# Recipe:: default
#
# Copyright 2014, Gerald L. Hevener Jr., M.S.
#
# Set config file for ghubbkup.
default['ghubbkup']['conf'] = '/etc/ghubbkup.conf'

# Set ghubbkup install dir.
default['ghubbkup']['install_dir'] = '/usr/local/bin'

# Set Github user. You should probably override this!
default['ghubbkup']['user'] = 'root'

# Set group owner of config & backup dir. You should probably override this!
default['ghubbkup']['group'] = 'root'

# Set Github password. You should probably override this!
default['ghubbkup']['pass'] = 'secret'

# Encrypted data bag secret file.
default['ghubbkup']['data_bag_secret'] = '/etc/chef/encrypted_data_bag_secret'

# Encrypted data bag name.
default['ghubbkup']['encrypted_data_bag_name'] = 'ghubbkup'

# Encrypted data bag item.
default['ghubbkup']['encrypted_data_bag_item'] = 'creds'

# Set tmp repo list.
default['ghubbkup']['tmp_repo_list'] = '/tmp/repos.txt'

# Set repo list.
default['ghubbkup']['repo_list'] = '/tmp/repos2.txt'

# Set backup directory.
default['ghubbkup']['backup_dir'] = '/tmp/github_repos_backup'

# Set git extension.
default['ghubbkup']['git_extension'] = '.git'

# Set git URL.
default['ghubbkup']['git_url'] = 'https://github.com/'

# Backup method. Possible options: s3.
# Set to s3 if you wan to backup repos to s3. No backups are done by default.
default['ghubbkup']['backup_type'] = ''

# Override this with appropriate s3cmd line options you need.
default['ghubbkup']['s3cmd_cmdline_options'] = 'sync'

# You MUST Override this with a file[s]/dir[s] you want to backup to S3!
default['ghubbkup']['files_to_backup'] = ''

# You MUST override this with an S3 bucket you want to backup files to!
default['s3_bucket'] = ''
