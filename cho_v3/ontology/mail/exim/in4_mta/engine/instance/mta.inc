###########################
###  INCLUDES                            	###
###########################

# CLI CONF
    .include /etc/exim/client_path/instance/mta.conf
#

# ROUTER LOOKUPS
    .include /etc/exim/engine_path/engine/router/default_sql.lookup
#    
    
# GLOBAL FUNC    
    .include /etc/exim/engine_path/engine/_globals/retry.conf
    .include /etc/exim/engine_path/engine/_globals/transport.conf
    .include /etc/exim/engine_path/engine/_globals/auth.conf
    .include /etc/exim/engine_path/engine/_globals/cli_lists.conf    
#

# CLI FUNC
    .include /etc/exim/client_path/instance/mta.func
#

# ROUTER
    .include /etc/exim/engine_path/engine/router/default.router
#
