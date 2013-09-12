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
#

default['rackspace-lsyncd']['log-file']    = "/var/log/lsyncd/lsyncd.log"
default['rackspace-lsyncd']['status-file'] = "/var/log/lsyncd/lsyncd-status.log"
default['rackspace-lsyncd']['config-file'] = "/etc/lsyncd.lua"


default['rackspace-lsyncd']['source'] = "/var/www"
default['rackspace-lsyncd']['target'] = "/var/www"

default['rackspace-lsyncd']['target-user']        = "developer"
default['rackspace-lsyncd']['target-server-role'] = "webserver"

default['rackspace-lsyncd']['rsync-options'] = ["-a", "-z", "-t", "--delete"]

case node['platform']
when "redhat","centos", "amazon","scientific"

	if node['yum']['epel']['includepkgs'].nil?
		default['yum']['epel']['includepkgs'] = "lsyncd"

	elsif not node['yum']['epel']['includepkgs'].include? "lsyncd" do
		includepkgs = "#{node['yum']['epel']['includepkgs']} lsyncd"
        default['yum']['epel']['includepkgs'] = includepkgs
    end

  end
end