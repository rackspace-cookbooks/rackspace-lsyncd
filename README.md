# rackspace-lsyncd cookbook
This cookbook will install lysncd as well as setup rsync blocks for all servers in a role defined by node['rackspace-lsyncd']['target-server-role']

# Requirements
This cookbook currently supports Cent6.4 from epel and Ubuntu 12.04 from a custom repo.
It also requires either the apt or the yum cookbook depending on the Operating system you are deploying to. 

# Usage
This should work almost completely out of the box, however you will almost definitely need to set the 'source', 'target', 'user' and 'target-server-role' attributes to match your environment.

# Attributes

Source folder on lsyncd-master
node['rackspace-lsyncd']['source']

Target folder on receiving nodes
node['rackspace-lsyncd']['target']

Role for servers that will become receiving nodes
node['rackspace-lsyncd']['target-server-role']

User that rsync will attempt to use on the destination servers
node['rackspace-lsyncd']['target-user']

You can also change log and config files with the following attributes. However the defaults should work for most people.
node['rackspace-lsyncd']['log-file']
node['rackspace-lsyncd']['status-file']
node['rackspace-lsyncd']['config-file']

All standard lsyncd options are in the attribute tree under,
node['rackspace-lsyncd']['rsync-options']
Any set to a boolean value of true will be set as true in the config, any set to strings will be dropped into the config with the string as the value.
The following are defaulted to on,
node['rackspace-lsyncd']['rsync-options']['archive'] = true
node['rackspace-lsyncd']['rsync-options']['binary'] = "/usr/bin/rsync"
node['rackspace-lsyncd']['rsync-options']['compress'] = true

# Author

Author:: Thomas Cate (thomas.cate@rackspace.com)
