package presto

test_allow {
    allow with input as {"principal": "amiorin", "action": "select", "resource": "hive.dwh.f_salesorder_position"}
}

allow {
    data.policies[i].principal[_] == input.principal
    data.policies[i].action[_] == input.action
    data.policies[i].resource[_] == input.resource
}

test_insider {
    ["colA", "colB"] == insider with input as {"principal": "user1", "resource": "hive.dwh.f_salesorder_position"}
}

test_confidential_amiorin {
    true == confidential with input as {"principal": "amiorin", "resource": "hive.dwh.f_salesorder_position"}
}

test_confidential_user1 {
    false == confidential with input as {"principal": "user1", "resource": "hive.dwh.f_salesorder_position"}
}

insider = columns {
    data.insiders_group[_] == input.principal
    data.insiders_tables[i].resource == input.resource
    columns := data.insiders_tables[i].columns
}

default confidential = false

confidential {
    data.confidentials[i].principal[_] == input.principal
    data.confidentials[i].resource[_] == input.resource
}