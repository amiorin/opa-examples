package presto

import data.policies
import data.blacklists

test_allow {
    allow with input as {"principal": "amiorin", "action": "select", "resource": "hive.dwh.f_salesorder_position"}
}

allow {
    policies[i].principal[_] == input.principal
    policies[i].action[_] == input.action
    policies[i].resource[_] == input.resource
}

test_filter_columns {
    ["colA", "colB"] == filter_columns with input as {"principal": "team2/user1", "action": "filterColumns", "resource": "hive.dwh.f_salesorder_position"}
}

test_filter_columns_empty {
    [] == filter_columns with input as {"principal": "amiorin", "action": "filterColumns", "resource": "hive.dwh.f_salesorder_position"}
}

default filter_columns = []

filter_columns = columns {
    blacklists[i].principal[_] == input.principal
    blacklists[i].action == input.action
    blacklists[i].resource == input.resource
    columns := blacklists[i].columns
}