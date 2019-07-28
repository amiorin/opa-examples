all: test 

compile:
	jsonnet -o presto.json presto.jsonnet

test: compile
	opa test -v .

.PHONY: all compile