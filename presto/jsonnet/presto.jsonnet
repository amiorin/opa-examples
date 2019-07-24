local utils = import 'utils.libsonnet';

{
    groups:: {
        # create insiders from all users programmatically
        insiders: [
            "user1",
            "user2",
            self.team1,
            self.team2,
        ],
        team1: [
            "amiorin",
            "sverma"
        ],
        team2: [
            "team3/user1",
            "team3/user2"
        ],
    },

    tags:: {
        "sales": [
            "hive.dwh.f_salesorder_position",
            "hive.dwh.d_article_config",
        ]
    },

    insiders:: [
        {
            resource: "hive.dwh.f_salesorder_position",
            columns: [
                "colA",
                "colB",
            ],
        },
        {
            resource: "hive.dwh.d_article_config",
            columns: [
                "colD",
            ],
        },
    ],

    policies: [
        {
            principal: utils.deepFlatten($.groups.team1),
            action: [
                "select"
            ],
            resource: utils.deepFlatten($.tags.sales),
        }
    ],

    insiders_group: utils.deepFlatten($.groups.insiders),
    insiders_tables: $.insiders,
    confidentials: [
        {
            principal: utils.deepFlatten($.groups.team1),
            resource: utils.deepFlatten($.tags.sales)
        },
    ]
}