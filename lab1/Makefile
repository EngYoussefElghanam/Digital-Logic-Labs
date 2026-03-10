GHDL := ghdl
GTKWAVE := gtkwave
BUILD_DIR := build
VHDL_FILES := half.vhdl full_adder.vhdl half_adder_tb.vhdl full_adder_tb.vhdl 4-bit_ripple.vhdl ripple_tb.vhdl
TB_ENTITY := full_adder_tb

# GHDL flags
GHDL_FLAGS := --workdir=$(BUILD_DIR) --ieee=standard

.PHONY: compile run clean help test_half test_full wave_half wave_full view_half view_full test_ripple wave_ripple view_ripple
help:
	@echo "Available targets:"
	@echo "  make test_half   - Test Half Adder"
	@echo "  make test_full   - Test Full Adder (default)"
	@echo "  make test_ripple   - Test 4-bit Ripple Adder"
	@echo "  make wave_half   - Generate Half Adder waveform"
	@echo "  make wave_full   - Generate Full Adder waveform"
	@echo "  make wave_ripple   - Generate 4-bit Ripple waveform"
	@echo "  make view_half   - Generate and view Half Adder waveform"
	@echo "  make view_full   - Generate and view Full Adder waveform"
	@echo "  make view_ripple   - Generate and view 4-bit Ripple waveform"
	@echo "  make compile     - Compile VHDL files"
	@echo "  make clean       - Remove build directory"

compile: $(BUILD_DIR)
	$(GHDL) -a $(GHDL_FLAGS) $(VHDL_FILES)
	$(GHDL) -e $(GHDL_FLAGS) $(TB_ENTITY)

run: compile
	$(GHDL) -r $(GHDL_FLAGS) $(TB_ENTITY)

test_half: $(BUILD_DIR)
	$(GHDL) -a $(GHDL_FLAGS) half.vhdl half_adder_tb.vhdl
	$(GHDL) -e $(GHDL_FLAGS) half_adder_tb
	$(GHDL) -r $(GHDL_FLAGS) half_adder_tb

test_full: $(BUILD_DIR)
	$(GHDL) -a $(GHDL_FLAGS) half.vhdl full_adder.vhdl full_adder_tb.vhdl
	$(GHDL) -e $(GHDL_FLAGS) full_adder_tb
	$(GHDL) -r $(GHDL_FLAGS) full_adder_tb

test_ripple: $(BUILD_DIR)
	$(GHDL) -a $(GHDL_FLAGS) 4-bit_ripple.vhdl ripple_tb.vhdl
	$(GHDL) -e $(GHDL_FLAGS) ripple_tb
	$(GHDL) -r $(GHDL_FLAGS) ripple_tb

wave_half: $(BUILD_DIR)
	$(GHDL) -a $(GHDL_FLAGS) half.vhdl half_adder_tb.vhdl
	$(GHDL) -e $(GHDL_FLAGS) half_adder_tb
	$(GHDL) -r $(GHDL_FLAGS) half_adder_tb --vcd=$(BUILD_DIR)/half_adder.vcd
	@echo "Waveform saved to $(BUILD_DIR)/half_adder.vcd"

wave_full: $(BUILD_DIR)
	$(GHDL) -a $(GHDL_FLAGS) half.vhdl full_adder.vhdl full_adder_tb.vhdl
	$(GHDL) -e $(GHDL_FLAGS) full_adder_tb
	$(GHDL) -r $(GHDL_FLAGS) full_adder_tb --vcd=$(BUILD_DIR)/full_adder.vcd
	@echo "Waveform saved to $(BUILD_DIR)/full_adder.vcd"

wave_ripple: $(BUILD_DIR)
	$(GHDL) -a $(GHDL_FLAGS) 4-bit_ripple.vhdl ripple_tb.vhdl
	$(GHDL) -e $(GHDL_FLAGS) ripple_tb
	$(GHDL) -r $(GHDL_FLAGS) ripple_tb --vcd=$(BUILD_DIR)/ripple.vcd
	@echo "Waveform saved to $(BUILD_DIR)/ripple.vcd"

view_half: $(BUILD_DIR) wave_half
	$(GTKWAVE) $(BUILD_DIR)/half_adder.vcd

view_full: $(BUILD_DIR) wave_full
	$(GTKWAVE) $(BUILD_DIR)/full_adder.vcd

view_ripple: $(BUILD_DIR) wave_ripple
	$(GTKWAVE) $(BUILD_DIR)/ripple.vcd

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

clean:
	rm -rf $(BUILD_DIR)

.DEFAULT_GOAL := help
