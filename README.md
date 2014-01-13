ghubbkup Cookbook
=================
ghubbkup is a Ruby cmd-line utility that can be used to backup Git repos on Github using the Github API v3.

Requirements
------------
A working Ruby 1.9.x installation.

Attributes
----------
Set config dir for ghubbkup.
node.set['ghubbkup']['conf_dir'] = '/etc'

Set ghubbkup install dir.
node.set['ghubbkup']['install_dir'] = '/usr/local/bin'

Set owner of ghubbkup utility.
node.set['ghubbkup']['user'] = 'root'

Set group owner of ghubbkup utility.
node.set['ghubbkup']['pass'] = 'root'

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
id:            s3cfg 
s3_access_key: YOUR_ACCESS_KEY_HERE
s3_secret_key: YOUR_SECRET_KEY_HERE
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

Now just include `ghubbkup` in your node's `run_list`:

<pre><code>
{
  "name":"my_node",
  "run_list": [
    "recipe[ghubbkup]"
  ]
}
</pre></code>

SAMPLE ROLE
-----------
Below is a sample role you could use:
<pre><code>
name "ghubbkup"
description "Install ghubbkup cmd-line tool to backup Github repos."
override_attributes "ghubbkup" => {
	"data_bag_secret" => "/home/skywalker/data_bag_secret_key",
	"group" => "skywalker",
        "backup_type" => 's3'
}
run_list "recipe[ghubbkup]"
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
