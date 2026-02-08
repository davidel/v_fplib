
SEED ?= 21
NX ?= 11
NM ?= 52
CLZ_N ?= 32
TEST_N ?= 100000

TOPM = main
SOURCES = macros.sv fpu.sv fp_conv.sv fp_utils.sv testing.sv

check: $(SOURCES)
	verilator \
		-sv \
		--lint-only \
		-DSEED=$(SEED) \
		-DNX=$(NX) \
		-DNM=$(NM) \
		-DCLZ_N=$(CLZ_N) \
		-DTEST_N=$(TEST_N) \
		--top $(TOPM) \
		$(SOURCES)

bin: $(SOURCES)
	verilator \
		-sv \
		--binary \
		--Mdir $(PWD) \
		-DSEED=$(SEED) \
		-DNX=$(NX) \
		-DNM=$(NM) \
		-DCLZ_N=$(CLZ_N) \
		-DTEST_N=$(TEST_N) \
		--top $(TOPM) \
		$(SOURCES)

run: bin
	./obj_dir/V$(TOPM)

clean:
	rm -rf obj_dir/

