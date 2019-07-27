local utils = import 'utils.libsonnet';

{
    groups:: {
        team1: [
            "amiorin",
            "sverma",
            "stups_rdp"
        ],
    },
    shared:: {
        fast: [
            "ip-172-31-141-208.eu-central-1.compute.internal",
            "ip-172-31-142-208.eu-central-1.compute.internal",
        ],
        slow: [
            "ip-172-31-141-207.eu-central-1.compute.internal",
            "ip-172-31-142-207.eu-central-1.compute.internal",
        ],
        datalab: [
            "ip-172-31-141-206.eu-central-1.compute.internal",
            "ip-172-31-142-206.eu-central-1.compute.internal",
        ]
    },
    clusters:: {
        impersonation: [
            {
                blacklist: ["sverma"],
                application: "mstr",
                resource: {
                    public: "mstr.presto.zalando.net",
                    private:  $.shared.fast,
                },
            },
            {
                blacklist: [],
                application: "superset",
                resource: {
                    public: "superset.presto.zalando.net",
                    private:  $.shared.fast,
                },
            },
        ],
        multitenants: [
            {
                public: "datalab.presto.zalando.net",
                private: $.shared.datalab
            },
            {
                public: "etl.presto.zalando.net",
                private: $.shared.slow
            },
            {
                public: "presto.data-lake.zalan.do",
                private: $.shared.slow
            },
            {
                public: "presto.saiki.zalan.do",
                private: $.shared.slow
            },
            {
                public: "lake-jdbc.zalan.do",
                private: $.shared.slow
            },
        ],
        team1: [
            {
                public: "team1.presto.zalando.net",
                private: [
                    "ip-172-31-141-204.eu-central-1.compute.internal",
                ]
            },
            {
                public: "team1-dev.presto.zalando.net",
                private: [
                    "ip-172-31-141-205.eu-central-1.compute.internal"
                ]
            },
        ],
    },
    policies_teams: [
        {
            principal: utils.deepFlatten($.groups.team1),
            action: [
                "presto:execute"
            ],
            resource: utils.deepFlatten($.clusters.team1)
        },
    ],
    blacklist: [
        "stups_datalab_crazyquery"
    ],
    policies_multitenants: [
        {
            action: [
                "presto:execute"
            ],
            resource: utils.deepFlatten($.clusters.multitenants)
        },
    ],
    policies_datalab: {
        action: [
            "presto:execute"
        ],
        resource: $.shared.datalab
    },
    policies_etl: {
        action: [
            "presto:execute"
        ],
        resource: $.shared.slow
    },
    policies_impersonation: [
        {
            blacklist: x.blacklist,
            application: x.application,
            action: [
                "presto:execute"
            ],
            resource: x.resource
        } for x in $.clusters.impersonation
    ],
}