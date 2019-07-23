all: test 

compile:
	jsonnet -o lake.json lake.jsonnet

test: compile
	opa test -v .

.PHONY: all compile