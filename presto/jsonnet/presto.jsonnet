local utils = import 'utils.libsonnet';

{
    groups:: {
        confidential_access: [
            "amiorin",
            "sverma"
        ],
        insider_access: [
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
        "sales": [
            "hive.dwh.f_salesorder_position"
        ]
    },

    filter_columns:: [
        {
            table: "hive.dwh.f_salesorder_position",
            columns: [
                "colA",
                "colB",
            ],
        },
        {
            table: "hive.dwh.d_article_config",
            columns: [
                "colD",
            ],
        },
    ],

    policies: [
        {
            principal: utils.deepFlatten($.groups.confidential_access),
            action: [
                "select"
            ],
            resource: utils.deepFlatten($.tags.sales),
        }
    ],

    blacklists: utils.explode_filter_columns($.groups.insider_access, $.filter_columns)
}