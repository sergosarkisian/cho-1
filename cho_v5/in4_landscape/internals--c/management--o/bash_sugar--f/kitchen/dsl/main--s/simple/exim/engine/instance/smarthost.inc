###########################
###  INCLUDES                            	###
###########################

# CLI CONF
    .include /etc/exim/client_path/instance/mta.conf
#

    
# GLOBAL FUNC    
    .include /etc/exim/engine_path/engine/_globals/retry.conf
    .include /etc/exim/engine_path/engine/_globals/transport.conf
#

# ROUTER
    .include /etc/exim/engine_path/engine/router/default.router
#
