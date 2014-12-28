#-------------------------------------------------------------------------------
#
# Cookbook Name:: ssl_lb
#        Recipe:: default
#
#-------------------------------------------------------------------------------
#
# Copyright (c) 2014, Pioneering Software, United Kingdom. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may not
# use this file except in compliance with the License. You may obtain a copy of
# the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either expressed or implied. See the
# License for the specific language governing permissions and limitations under
# the License.
#
#-------------------------------------------------------------------------------

# Include the Apt recipe in order to update the Apt cache. The default `apt`
# recipe updates Apt and automatically updates packages no longer needed.
# HAProxy with SSL will fail to install successfully on some Ubuntu platforms
# because Apt cannot find the `libssl-dev` package.
include_recipe 'apt'

# With no supplied certificate or key, create a self-signed certificate. Note
# that the PEM for HAProxy combines the certificate and private key
# concatenated.
cert_and_key = node['ssl_lb']['cert_and_key'] || begin
  crt = ssl_certificate 'ssl_lb'
  crt.cert_content + crt.key_content
end

pem_file = file '/etc/ssl/private/ssl_lb.pem' do
  content cert_and_key
end

# Define the load-balancer's front end.
ssl_incoming = %w(address port).map { |x| node['haproxy']["ssl_incoming_#{x}"] }.join(':')
frontend_params = [
  "bind #{ssl_incoming} ssl crt #{pem_file.path} ciphers RC4:HIGH:!aNULL:!MD5",
  'reqadd X-Forwarded-Proto:\ https',
  'default_backend www-http',
]
haproxy_lb 'www-https' do
  type 'frontend'
  params frontend_params
end

# Set up the back-end servers.
backend_role = node['ssl_lb']['backend_role'] || node['haproxy']['app_server_role']
backend_nodes = search('node', "role:#{backend_role} AND chef_environment:#{node.chef_environment}") || []
backend_nodes << node if node.run_list.roles.include?(backend_role)
backend_servers = backend_nodes.map do |backend_node|
  %W[
    #{backend_node.hostname}
    #{backend_node.ipaddress}:#{node['haproxy']['member_port']}
    weight 1
    maxconn #{node['haproxy']['member_max_connections']}
    check
  ].join(' ')
end
backend_params = [
  'redirect scheme https if !{ ssl_fc }',
]
haproxy_lb 'www-http' do
  type 'backend'
  params backend_params
  servers backend_servers
end

# The default recipe MUST run; it sets up and enables the HAProxy
# service. Important that it runs at the end, after setting up the HAProxy
# listeners using `haproxy_lb`.
include_recipe 'haproxy::default'
