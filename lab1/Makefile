GHDL := ghdl
BUILD_DIR := build
VHDL_FILES := half.vhdl half_adder_tb.vhdl
TB_ENTITY := half_adder_tb

# GHDL flags
GHDL_FLAGS := --workdir=$(BUILD_DIR) --ieee=standard

.PHONY: compile run clean help

help:
	@echo "Available targets:"
	@echo "  make compile  - Compile VHDL files"
	@echo "  make run      - Compile and run simulation"
	@echo "  make clean    - Remove build directory"

compile: $(BUILD_DIR)
	$(GHDL) -a $(GHDL_FLAGS) $(VHDL_FILES)
	$(GHDL) -e $(GHDL_FLAGS) $(TB_ENTITY)

run: compile
	$(GHDL) -r $(GHDL_FLAGS) $(TB_ENTITY)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

clean:
	rm -rf $(BUILD_DIR)

.DEFAULT_GOAL := help