all: test 

compile:
	jsonnet -o data.json data.jsonnet

test: compile
	opa test -v .

.PHONY: all compile