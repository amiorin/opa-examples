local utils = import 'utils.libsonnet';

{
    groups:: {
        team1: [
            "amiorin",
            "sverma",
            $.groups.team2
        ],
        team2: [
            "team2/user1",
            "team2/user2",
            $.groups.team3
        ],
        team3: [
            "team3/user1",
            "team3/user2"
        ],
    },

    tags:: {
        sales: [
            "s3://bucket3/warehouse/database/table/snapshot=2019-07-24",
            $.coords["dwh:f_salesorder_position"]
        ],
        behaviour: [
            "s3://bucket2/warehouse/database/table/snapshot=2019-07-24",
            $.coords["gap:clicks"]
        ],
    }, 

    coords:: {
        "dwh:f_salesorder_position": [
            "s3://bucket1/warehouse/database/table/snapshot=2019-07-22",
            "s3://bucket1/warehouse/database/table/snapshot=2019-07-23"
        ],
        "gap:clicks": [
            "s3://bucket4/warehouse/database/table/snapshot=2019-07-22",
            "s3://bucket4/warehouse/database/table/snapshot=2019-07-23",
        ],
    },

    policies: [
        {
            principal: utils.deepFlatten($.groups.team1),
            action: [
                "read",
                "write"
            ],
            resource: utils.deepFlatten($.tags.sales + $.tags.behaviour)
        }
    ]
}