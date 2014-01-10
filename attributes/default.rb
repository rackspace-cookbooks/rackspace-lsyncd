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
default['rackspace-lsyncd']['not-target-server-role'] = nil

default['rackspace-lsyncd']['rsync-options']['acls']          = false
default['rackspace-lsyncd']['rsync-options']['archive']       = true
default['rackspace-lsyncd']['rsync-options']['binary']        = "/usr/bin/rsync"
default['rackspace-lsyncd']['rsync-options']['checksum']      = false
default['rackspace-lsyncd']['rsync-options']['compress']      = true
default['rackspace-lsyncd']['rsync-options']['copy_links']    = false
default['rackspace-lsyncd']['rsync-options']['cvs_exclude']   = false
default['rackspace-lsyncd']['rsync-options']['dry_run']       = false
default['rackspace-lsyncd']['rsync-options']['executability'] = false
default['rackspace-lsyncd']['rsync-options']['hard_links']    = false
default['rackspace-lsyncd']['rsync-options']['ignore_times']  = false
default['rackspace-lsyncd']['rsync-options']['ipv4']          = false
default['rackspace-lsyncd']['rsync-options']['ipv6']          = false
default['rackspace-lsyncd']['rsync-options']['links']         = false
default['rackspace-lsyncd']['rsync-options']['one_file_system'] = false
default['rackspace-lsyncd']['rsync-options']['owner']         = false
default['rackspace-lsyncd']['rsync-options']['password_file'] = nil
default['rackspace-lsyncd']['rsync-options']['perms']         = false
default['rackspace-lsyncd']['rsync-options']['protect_args']  = false
default['rackspace-lsyncd']['rsync-options']['prune_empty_dirs'] = false
default['rackspace-lsyncd']['rsync-options']['quiet']         = false
default['rackspace-lsyncd']['rsync-options']['rsh']           = nil
default['rackspace-lsyncd']['rsync-options']['rsync_path']    = nil
default['rackspace-lsyncd']['rsync-options']['sparse']        = false
default['rackspace-lsyncd']['rsync-options']['temp_dir']      = nil
default['rackspace-lsyncd']['rsync-options']['times']         = false
default['rackspace-lsyncd']['rsync-options']['update']        = false
default['rackspace-lsyncd']['rsync-options']['verbose']       = false
default['rackspace-lsyncd']['rsync-options']['whole_file']    = false
default['rackspace-lsyncd']['rsync-options']['xattrs']        = false
default['rackspace-lsyncd']['rsync-options']['_extra']        = nil

default['rackspace-lsyncd']['logrotate-options']['rotate'] = 7
default['rackspace-lsyncd']['logrotate-options']['frequency'] = "daily"
default['rackspace-lsyncd']['logrotate-options']['compress'] = true

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
