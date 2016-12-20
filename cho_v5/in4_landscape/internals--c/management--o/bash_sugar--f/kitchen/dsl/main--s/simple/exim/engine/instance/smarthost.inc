###########################
###  INCLUDES                            	###
###########################

# CLI CONF
GLOBAL_MXES_FQDN = 127.0.0.1
##
GLOBAL_PRIMARY_HOSTNAME = 127.0.0.1
GLOBAL_QUALIFY_DOMAIN = 127.0.0.1
GLOBAL_QUALIFY_RECIPIENT = 127.0.0.1
GLOBAL_TESTUSER = testuser
SCHEME_NAME = localhost
domainlist hosted_domains = localhost
#

    
# GLOBAL FUNC    
    .include /etc/exim/engine_path/engine/_globals/retry.conf
    .include /etc/exim/engine_path/engine/_globals/transport.conf
#

# ROUTER
    .include /etc/exim/engine_path/engine/router/default.router
#
