PTH = python3
RBC = rbc.py
TEST_DIR = test

all: $(TEST_DIR)/test0.vhd $(TEST_DIR)/test0.md $(TEST_DIR)/test0.h

$(TEST_DIR)/test0.vhd: $(TEST_DIR)/test0.yml $(RBC)
	$(PTH) $(RBC) -d $@ $<

$(TEST_DIR)/test0.md: $(TEST_DIR)/test0.yml $(RBC)
	$(PTH) $(RBC) -m $@ $<

$(TEST_DIR)/test0.h: $(TEST_DIR)/test0.yml $(RBC)
	$(PTH) $(RBC) -c $@ $<

.PHONY: all