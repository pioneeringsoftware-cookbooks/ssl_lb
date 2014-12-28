name             'ssl_lb'
maintainer       'The Authors'
maintainer_email 'you@example.com'
license          'all_rights'
description      'Installs/Configures ssl_lb'
long_description 'Installs/Configures ssl_lb'
version          '0.1.0'

# Depends on `apt` and `ssl_certificate` cookbooks for SSL. Apt needs updating
# for the latest version of OpenSSL development package. The `ssl_certificate`
# cookbook has providers for self-signed certificate generation.
%w(haproxy apt ssl_certificate).each do |cb|
  depends cb
end
