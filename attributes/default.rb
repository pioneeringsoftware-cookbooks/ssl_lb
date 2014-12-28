default['ssl_lb']['backend_role'] = nil
default['ssl_lb']['cert_and_key'] = nil

include_attribute 'haproxy'

default.haproxy.install_method = 'source'
default.haproxy.source.version = '1.5.9'
default.haproxy.source.url = 'http://www.haproxy.org/download/1.5/src/haproxy-1.5.9.tar.gz'
default.haproxy.source.checksum = '5f51aa8e20a8a3a11be16bd5f5ef382a5e95526803a89182fe1c15a428564722'
default.haproxy.source.use_pcre = true
default.haproxy.source.use_openssl = true
default.haproxy.source.use_zlib = true

default.haproxy.x_forwarded_for = true
default.haproxy.defaults_options << 'http-server-close'

# Avoid the warning about Diffie-Hellman parameters; increase the maximum from
# 1,024 to 2,048. Higher values increase the CPU load.
default.haproxy.global_options['tune.ssl.default-dh-param'] = 2048

default.haproxy.enable_default_http = false
