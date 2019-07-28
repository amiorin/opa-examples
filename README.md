# Intro
These are 3 POCs for LAKEFS and Presto. ```presto-gateway``` has his own README.

# Cluster everything
Instead of creating thousands of policies like "user can read table", we want
to cluster principals and resources together so that we can reduce the number
of policies. JSONNET is used to produce a flat data model for OPA (lake.json
and presto.json). The policy written in REGO is inspired by AWS IAM with
principal, action and resource.

```sh
# first POC for LAKEFS
cd lake
make

# second POC for Presto
cd presto
make
```

If you have installed OPA and JSON. The output should be
```sh
# first POC
jsonnet -o lake.json lake.jsonnet
opa test -v .
data.lake.test_lake: PASS (1.212857ms)
--------------------------------------------------------------------------------
PASS: 1/1
```

```sh
# second POC
jsonnet -o presto.json presto.jsonnet
opa test -v .
data.presto.test_allow: PASS (1.348603ms)
data.presto.test_filter_columns: PASS (748.879µs)
data.presto.test_filter_columns_empty: PASS (632.974µs)
--------------------------------------------------------------------------------
PASS: 3/3
```

# Requirements
```sh
# install jsonnet
# osx
brew install jsonnet
# install opa
# https://www.openpolicyagent.org/docs/latest/get-started#prerequisites
# osx
curl -L -o opa https://github.com/open-policy-agent/opa/releases/download/v0.12.1/opa_darwin_amd64
# linux
curl -L -o opa https://github.com/open-policy-agent/opa/releases/download/v0.12.1/opa_linux_amd64

# enter the first POC
cd lake/jsonnet

# run the test
make

# inspect the flat data model
cat lake.json
```

# LAKEFS POC
1. Can this principal read or write this S3 path?

# Presto POC
1. Can this principal ```select from catalog.database.table```?
2. What column should a filter for this user when he select from this catalog.database.table?

# Observations
The Presto POC doesn't require the creation of views anymore. The Java Interface ```SystemAccessControl``` allows to filter catalogs, databases, tables, and **columns** for all type of connector, not only ```hive```.