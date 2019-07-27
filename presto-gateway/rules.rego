package presto_gateway

test_crazyquery {
    {"allow": false} == policy with input as
    {"principal": "stups_datalab_crazyquery", "action": "presto:execute", "resource": "lake-jdbc.zalan.do"}
}

test_multitenant {
    {"allow": true, "clusters": ["ip-172-31-141-207.eu-central-1.compute.internal", "ip-172-31-142-207.eu-central-1.compute.internal"]} == policy with input as
    {"principal": "amiorin", "action": "presto:execute", "resource": "lake-jdbc.zalan.do"}
}

test_team_cluster {
    {"allow": true, "clusters": ["ip-172-31-141-204.eu-central-1.compute.internal"]} == policy with input as
    {"principal": "amiorin", "action": "presto:execute", "resource": "team1.presto.zalando.net"}
}

test_datalab_user {
    {"allow": true, "clusters": ["ip-172-31-141-206.eu-central-1.compute.internal","ip-172-31-142-206.eu-central-1.compute.internal"]} == policy with input as
    {"principal": "stups_datalab_user", "action": "presto:execute", "resource": "xxx"}
}

test_etl {
    {"allow": true, "clusters": ["ip-172-31-141-207.eu-central-1.compute.internal","ip-172-31-142-207.eu-central-1.compute.internal"]} == policy with input as
    {"principal": "stups_app", "action": "presto:execute", "resource": "xxx"}
}

policy = result {
    # team clusters
    data.policies_teams[i].principal[_] == input.principal
    data.policies_teams[i].action[_] == input.action
    data.policies_teams[i].resource[j].public == input.resource
    result := {"allow": true, "clusters": data.policies_teams[i].resource[j].private}
} else = result {
    # blacklisted users because they distrupt the service
    data.blacklist[_] == input.principal
    result := {"allow": false}
} else = result {
    # stups_datalab_.*
    re_match("stups_datalab_.*", input.principal)
    data.policies_datalab.action[_] == input.action
    result := {"allow": true, "clusters": data.policies_datalab.resource}
} else = result {
    # stups_.*
    re_match("stups_.*", input.principal)
    data.policies_etl.action[_] == input.action
    result := {"allow": true, "clusters": data.policies_etl.resource}
} else = result {
    # ldap users can use any multitenant cluster
    data.policies_multitenants[i].action[_] == "presto:execute"
    data.policies_multitenants[i].resource[j].public == input.resource
    result := {"allow": true, "clusters": data.policies_multitenants[i].resource[j].private}
}

test_mstr {
    {"allow": true, "clusters": ["ip-172-31-141-208.eu-central-1.compute.internal","ip-172-31-142-208.eu-central-1.compute.internal"]} == policy_impersonate with input as
    {"principal": "amiorin", "application": "mstr", "action": "presto:execute", "resource": "mstr.presto.zalando.net"}
}

test_mstr_blacklist {
    {"allow": false} == policy_impersonate with input as
    {"principal": "sverma", "application": "mstr", "action": "presto:execute", "resource": "mstr.presto.zalando.net"}
}

policy_impersonate = result {
    data.policies_impersonation[i].blacklist[_] == input.principal
    data.policies_impersonation[i].action[_] == input.action
    data.policies_impersonation[i].application == input.application
    data.policies_impersonation[i].resource.public == input.resource
    result := {"allow": false}
} else = result {
    data.policies_impersonation[i].action[_] == input.action
    data.policies_impersonation[i].application == input.application
    data.policies_impersonation[i].resource.public == input.resource
    result := {"allow": true, "clusters": data.policies_impersonation[i].resource.private}
}