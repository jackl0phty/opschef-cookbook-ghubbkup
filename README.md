Travis-ci status: [![Build Status](https://secure.travis-ci.org/jackl0phty/opschef-cookbook-ghubbkup.png?branch=master)](http://travis-ci.org/jackl0phty/opschef-cookbook-ghubbkup)

ghubbkup Cookbook
=================
ghubbkup is a Ruby cmd-line utility that can be used to backup Git repos on Github using the Github API v3.

Requirements
------------
* A working Ruby 1.9.x installation.
* Installation of [s3cmd](http://s3tools.org/s3cmd)

Ruby Gem Dependencies
---------------------
* [github_api](https://github.com/peter-murach/github) by Peter Murach.

Attributes
----------
# Set config file for ghubbkup.
default['ghubbkup']['conf_dir'] = '/etc'

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

Usage
-----
You'll need to create a secret key for your data bag.
<pre><code>
skywalker@alderaan:~$ openssl rand -base64 512 > data_bag_secret_key
</pre></code>
Create new data bag item to be used with S3.
<pre><code>
skywalker@alderaan:~/your/chef-repo$ knife data bag create  --secret-file ~/data_bag_secret_key ghubbkup creds 
Created data_bag[ghubbkup] 
Created data_bag_item[creds] 

{ 
  "id": "creds", 
  "github_user": "YOUR_GITHUB_USER NAME_HERE", 
  "github_pass": "YOUR_GITHUB_PASSWORD_HERE" 
} 
</pre></code>

If you get the following error below...
<pre><code>
ERROR: RuntimeError: Please set EDITOR environment variable
</pre></code>

...make sure you export your editor as EDITOR
<pre><code>
export EDITOR=vim
</pre></code>

Verify your encrypted data bag items.
<pre><code>
 skywaler@alderaan:~/your/chef-repo$ knife data bag show ghubbkup creds
id:            creds
github_user: 
  cipher:         aes-256-cbc 
  encrypted_data:  BUNCH_OF_RANDOM_CHARS_HERE
  iv:             RANDOM_CHARS_HERE
  version:        1 
github_pass: 
  cipher:         aes-256-cbc 
  encrypted_data: BUNCH_OF_RANDOM_CHARS_HERE
  iv:             RANDOM_CHARS_HERE
  version:        1 
skywaler@alderaan:~/your/chef-repo$ 
</pre></code>

Now check your decrypted data bag items
<pre><code>
skywaler@alderaan:~/your/chef-repo$ knife data bag show –secret-file=/home/you/data_bag_secret_key ghubbkup creds
id:            creds 
github_pass: YOUR_GITHUB_PASSWORD_HERE
github_user: YOUR_GITHUB_USER_HERE
</pre></code>

You may also want to export an encrypted version of your data bag to add to your version control such as Git
<pre><code>
skywalker@alderaan:~ knife data bag show ghubbkup creds -Fj > data_bags/ghubbkup/ghubbkup.json
</pre></code>

Copy your secret key to your node.
<pre><code>
skywalker@alderaan:~ $ scp /home/you/data_bag_secret_key skywalker@alderaan: 
skywalker@alderaan's password: 
data_bag_secret_key                                                                                                                                                            100%  695     0.7KB/s   00:00    
</pre></code>

Move your key to /etc/chef
<pre><code>
skywalker@alderaan:~ $ sudo mv /home/skywalker/data_bag_secret_key /etc/chef/
</pre></code>

BACKING UP TO AMAZON'S S3
-------------------------
1. By  default, ghubbkup will not try to backup your repos anywhere.
2. You must override `default['ghubbkup']['backup_type']` & set to `s3`.
3. The only non-local backup method supported is Amazon's S3.
4. You must also set `default['s3_bucket']` to name of the bucket you want to backup files to.
5. You must also set `default['ghubbkup']['files_to_backup']` to the files you'd like to backup.
6. You must also set `default['ghubbkup']['backup_dir'] ` to the directory you want to backup your repos to.
7. You can ignore the aforementioned attributes if you don't want to backup to S3 ( just clone all repos locally without copying to S3 ).
8. You must follow the README in the amazon_s3cmd cookbook to set up encrypted data bag for your S3 credentials.

COOKBOOK DEPENDENCIES
---------------------
This cookbook depends on my [amazon_s3cmd](https://github.com/jackl0phty/opschef-cookbook-amazon_s3cmd) cookbook which installs the s3cmd.

SAMPLE ROLE
-----------
Below is a sample role you could use:
<pre><code>
name "ghubbkup"
description "Install ghubbkup cmd-line tool to backup Github repos."
override_attributes( "amazon_s3cmd" => {
	"data_bag_secret" => "/home/skywalker/data_bag_secret",
	"encrypted_data_bag_name" => "s3cmd-ghubbkup" },
	"ghubbkup" => {
	"data_bag_secret" => "/home/skywalker/data_bag_secret",
	"group" => "skywalker",
        "backup_type" => 's3',
	"files_to_backup" => "/mnt/backup/github/*",
	"s3_bucket" => "s3://skywalker-github-backup" }
)
}
run_list "recipe[ghubbkup]"
</pre></code>

Now just include your `ghubbkup` role in your node's `run_list`:

<pre><code>
{
  "name":"my_node",
  "run_list": [
    "role[ghubbkup]"
  ]
}
</pre></code>

Example ghubbkup commands
-------------------------
Clone ALL repos for a single Github user or org.
<pre><code>
skywalker@alderaan:~$ ghubbkup all
</pre></code>

THINGS TO NOTE
--------------
* You should issue ghubbkup commands as the user who has access to your Github account.
* You can override node['ghubbkup']['git_url'] & set it to git@github.com: to use SSH.
* Command <code>ghubbkup all</code> will do <code>git clone</code> if repo isn't cloned & <code>git pull</code> if repo is already cloned.

Contributing
------------
1. Fork the repository on Github by clicking [here](https://github.com/jackl0phty/opschef-cookbook-ghubbkup/fork).
2. Create a topic branch (like `yourname-add-awesomeness`).
3. Write you change.
4. Write tests for your change (if applicable).
5. Run the tests, ensuring they all pass.
6. Submit a Pull Request using Github [here](https://github.com/jackl0phty/opschef-cookbook-ghubbkup).

License and Authors
-------------------
Author: Gerald L. Hevener Jr., AKA jackl0phty. 
