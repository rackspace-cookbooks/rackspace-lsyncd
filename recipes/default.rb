#
# Cookbook Name:: rackspace-lsyncd
# Default:: default
#
# Copyright 2013, Rackspace, Inc.
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

#make sure all sync and log dirs exist
directory File.dirname(node['rackspace-lsyncd']['log-file'])
directory File.dirname(node['rackspace-lsyncd']['status-file'])
directory File.dirname(node['rackspace-lsyncd']['config-file'])
directory node['rackspace-lsyncd']['source']


Chef::Log.warn("target-server-role is #{node['rackspace-lsyncd']['target-server-role']}")
Chef::Log.warn("not-target-server-role is #{node['rackspace-lsyncd']['not-target-server-role']}")
Chef::Log.warn("target-server-Environment is #{node.chef_environment}")

if node['rackspace-lsyncd']['not-target-server-role'].nil?
  target_servers = search("node", "recipes:#{node['rackspace-lsyncd']['target-server-role']} AND chef_environment:#{node.chef_environment}") || []
else
  target_servers = search("node", "recipes:#{node['rackspace-lsyncd']['target-server-role']} AND chef_environment:#{node.chef_environment} NOT recipes:#{node['rackspace-lsyncd']['not-target-server-role']}") || []
end
target_servers.sort!()
Chef::Log.warn("target servers are #{target_servers}")



Chef::Log.warn("add #{target_servers.length} nodes")
#this logic is based on the excellent Opscode haproxy cookbook
target_servers.map! do |member|
  Chef::Log.warn(member)

  server_ip = begin
    if member.attribute?('cloud')
      if node.attribute?('cloud') && (member['cloud']['provider'] == node['cloud']['provider'])
         member['cloud']['local_ipv4']
      else
        member['cloud']['public_ipv4']
      end
    else
      member['ipaddress']
    end
  end
  {:ipaddress => server_ip, :hostname => member['hostname']}
end


case node['platform']
when "ubuntu", "debian"

  include_recipe "apt"

  apt_repository "rackops" do
    uri "http://repo.rackops.org/apt/ubuntu/"
    distribution node['lsb']['codename']
    key "http://repo.rackops.org/rackops-signing-key.asc"
    components ["main"]
    action :add
  end

  execute "apt-get-update-periodic" do
    command "apt-get update"
    ignore_failure true
    only_if do
      File.exists?('/var/lib/apt/periodic/update-success-stamp') &&
      File.mtime('/var/lib/apt/periodic/update-success-stamp') < Time.now - 86400
    end
  end

  package "lsyncd" do
    action :install
  end
  
  template "/etc/init.d/lsyncd" do
  	source "ubuntu_init.erb"
  	mode 0755
  	owner "root"
  	group "root"
  end

when "redhat","centos","fedora", "amazon","scientific"

  include_recipe "yum::epel"

  package "lsyncd" do
    action :install
  end

  template '/etc/sysconfig/lsyncd' do
  	source "cent_sysconfig.erb"
    mode 0644
    owner "root"
    group "root"  	
  end

  template '/etc/init.d/lsyncd' do
  	source "cent_init.erb"
    mode 0755
    owner "root"
    group "root"  	
  end

end

template node['rackspace-lsyncd']['config-file'] do
  source "lsyncd-config.erb"
  mode 0755
  owner "root"
  group "root"
  notifies :restart, "service[lsyncd]"
  variables(
    :target_servers => target_servers.uniq
  )
end

service "lsyncd" do
  supports :restart => true, :status => true, :reload => true
  action [:enable]
end
