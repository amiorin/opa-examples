# Intro
This is a proof of concept of creating an authorization system with OPA and JSONNET for LAKEFS.

```sh
cd lake/jsonnet
make
```

If you have installed OPA and JSON. The output should be
```
jsonnet -o lake.json lake.jsonnet
opa test -v .
data.lake.test_lake: PASS (1.212857ms)
--------------------------------------------------------------------------------
PASS: 1/1
```

# Cluster everything
Instead of creating thousands of policies like "user can read table", we want
to cluster principal and resources together so that we can reduce the number of policies.
JSONNET is used to produce a flat data model for OPA (lake.json). The policy written in
REGO is inspired by AWS IAM with principal, action and resource.

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

# run the test
make

# inspect the flat data model
cat lake.json
```
