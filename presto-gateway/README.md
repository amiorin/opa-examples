# Intro
https://github.com/lyft/presto-gateway provides load balancing and naive routing. Our Presto Gateway with OPA is already more advanced.

# Rules
There two endpoint OPA, one for the authorization of impersonation clients (mstr and superset) and one for the authorization of normal clients.

# Normal clients
2. route Team cluster clients
1. blacklist principals doing broken queries
3. route all stups_datalab_.*
4. route all stups_.*
5. route all ldap users to any multitenant cluster

# Impersonate clients
1. blacklist principals doing broken queries
2. route superset and mstr clients
