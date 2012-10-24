
SOURCE =jtag_cores.v \
	jtag_tap_spartan6.v \
	lm32_adder.v \
	lm32_addsub.v \
	lm32_cpu.v \
	lm32_dcache.v \
	lm32_debug.v \
	lm32_decoder.v \
	lm32_dp_ram.v \
	lm32_functions.v \
	lm32_icache.v \
	lm32_include.v \
	lm32_instruction_unit.v \
	lm32_interrupt.v \
	lm32_jtag.v \
	lm32_load_store_unit.v \
	lm32_logic_op.v \
	lm32_mc_arithmetic.v \
	lm32_multiplier_spartan6.v \
	lm32_multiplier.v \
	lm32_ram.v \
	lm32_shifter.v \
	lm32_top.v \
	m1reset.v \
	soc.v

DURATION ?= 500000

PROJECT = soc.prj

all: simulation

dmp: dmp.data

dmp.data: soc ram.data
	echo -e "restart \n init \n run $(DURATION) \n" | ./soc 2> /dev/null 1> dmp.data
# Dump done, now removing useless first 10 lines
	sed -ie '1,10d' dmp.data
	@echo You can now run dmp on the dmp.data dump file to draw the pipeline

nogui: soc ram.data
	./soc

simulation: soc ram.data
	./soc -gui -view soc.wcfg

soc: $(SOURCE) $(PROJECT)
	fuse -intstyle ise -o soc -prj soc.prj --timescale 1ns/1ns soc

tools:
	$(MAKE) -C tools/h2a/

ram.data: bios.bin
	h2a bios.bin > ram.data

clean:
	rm -rf soc isim isim.* fuse.* fuseRelaunch.cmd

cleanall: clean
	$(MAKE) -C tools/h2a/ clean

.PHONY: clean cleanall simulation all tools dmp nogui
