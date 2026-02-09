
OBJDIR ?= $(PWD)/v_fpu_objs
SRCDIR ?= $(dir $(realpath $(lastword ${MAKEFILE_LIST})))

SEED ?= 21
NX ?= 11
NM ?= 52
CLZ_N ?= 32
TEST_N ?= 100000

TOPM = main
SOURCES = $(SRCDIR)/macros.sv \
	$(SRCDIR)/fpu.sv \
	$(SRCDIR)/fp_conv.sv \
	$(SRCDIR)/fp_utils.sv \
	$(SRCDIR)/testing.sv


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
		--Mdir $(OBJDIR) \
		-DSEED=$(SEED) \
		-DNX=$(NX) \
		-DNM=$(NM) \
		-DCLZ_N=$(CLZ_N) \
		-DTEST_N=$(TEST_N) \
		--top $(TOPM) \
		$(SOURCES)

run: bin
	$(OBJDIR)/V$(TOPM)

clean:
	rm -rf $(OBJDIR)

