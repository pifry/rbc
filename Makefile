PTH = python3
RBC = rbc.py
TEST_DIR = test

all: $(TEST_DIR)/test0.vhd

$(TEST_DIR)/test0.vhd: $(TEST_DIR)/test0.yml $(RBC)
	$(PTH) $(RBC) -d $@ $<

.PHONY: all