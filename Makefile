
SEED ?= 21

TOPM = main
SOURCES = macros.sv fpu.sv fp_conv.sv fp_utils.sv testing.sv

check: $(SOURCES)
	verilator -sv --lint-only -DSEED=$(SEED) --top $(TOPM) $(SOURCES)

bin: $(SOURCES)
	verilator -sv --binary -DSEED=$(SEED) --top $(TOPM) $(SOURCES)

run: bin
	./obj_dir/V$(TOPM)

clean:
	rm -rf obj_dir/

