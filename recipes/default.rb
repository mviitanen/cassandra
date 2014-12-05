#
# Cookbook Name:: myapp
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#


#echo "deb http://debian.datastax.com/community stable main" | sudo tee -a /etc/apt/sources.list.d/cassandra.sources.list
#execute "add-datastax-repo" do
#    command "echo "deb http://debian.datastax.com/community stable main" | sudo tee -a /etc/apt/sources.list.d/cassandra.sources.list"
#end
apt_repository 'datastax' do
  uri          'http://debian.datastax.com/community'
  components   ['stable', 'main']
  key          'http://debian.datastax.com/debian/repo_key'
  arch         'amd64'
end


# 15  sudo apt-get update
include_recipe "apt::default"

apt_package "install-cassandra" do
  package_name "cassandra"
  version "2.0.11"
  action :install
end

# 16  sudo apt-get install dsc20
apt_package "install-dsc20" do
  package_name "dsc20"
  version "2.0.11-1"
  action :install
end

apt_package "datastax-agent" do
  package_name "datastax-agent"
  action :install
end

cookbook_file "cassandra.yaml" do
  path "/etc/cassandra/cassandra.yaml"
  action :create
end

execute "start-cassandra" do
    command "sudo cassandra"
end

template "/etc/cassandra/cassandra.yaml" do
  source "etc/cassandra/cassandra.yaml.erb"
  mode 0644
  owner "root"
  group "root"
  variables({
     :cluster_name => node[:cassandra][:config][:cluster_name],
     :seed => node[:cassandra][:config][:seed],
     :listen_address => node[:cassandra][:config][:listen_address]
  })
end
