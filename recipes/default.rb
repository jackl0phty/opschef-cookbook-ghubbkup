#
# Cookbook Name:: ghubbkup
# Recipe:: default
#
# Copyright 2014, Gerald L. Hevener Jr., M.S.
#
# Deploy the chefknife Ruby script.
template "/usr/local/bin/ghubbkup" do
  source "ghubbkup.erb"
  mode 0755
  owner "root"
  group "root"
end
