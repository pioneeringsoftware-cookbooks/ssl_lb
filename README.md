# ssl_lb

The `ssl_lb` cookbook sets up a SSL-based HAProxy load balancer. It
automatically generates a self-signed SSL certificate if you do not yet have a
signed certificate, but accepts a certificate and key if you already have one.
The recipe looks for back-end application servers automatically. Connection
between the load balancer employs SSL encryption, but connections between
HAProxy and its back-end servers does not.

The cookbook accepts two ways for specifying backend servers, automatically and
manually. The same cookbook recipe operates in both modes. If `ssl_lb` cookbook
attributes give specific HAProxy members, these become back-end servers. If the
`ssl_lb` cookbook attributes specify an application server role, the recipe
adds matching nodes to the pool of back-end servers.

