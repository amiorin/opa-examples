package lake

import data.policies

test_lake {
    allow with input as {"principal": "amiorin", "action": "write", "resource": "s3://bucket3/warehouse/database/table/snapshot=2019-07-24"}
}

allow {
    policies[i].principal[_] == input.principal
    policies[i].action[_] == input.action
    policies[i].resource[_] == input.resource
}