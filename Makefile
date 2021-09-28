all: vhdl_tests

tests/test0.py: rbc.py
	python3 rbc.py

vhdl_tests: tests/test0.py
	docker run --rm -v $(PWD):/build --workdir /build ghdl/vunit:mcode python3 test/run.py

.PHONY: all vhdl_tests