name             'ssl_lb'
maintainer       'The Authors'
maintainer_email 'you@example.com'
license          'all_rights'
description      'Installs/Configures ssl_lb'
long_description 'Installs/Configures ssl_lb'
version          '0.1.0'

%w(haproxy).each do |cb|
  depends cb
end
