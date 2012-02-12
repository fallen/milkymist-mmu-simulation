
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

PROJECT = soc.prj

all: simulation

simulation: soc ram.data
	./soc -gui -view soc.wcfg

soc: $(SOURCE) $(PROJECT)
	fuse -intstyle ise -o soc -prj soc.prj --timescale 1ns/1ns soc

tools:
	$(MAKE) -C tools/h2a/

ram: ram.data

ram.data: bios.bin
	h2a bios.bin > ram.data

clean:
	rm -rf soc isim isim.* fuse.* fuseRelaunch.cmd

cleanall: clean
	$(MAKE) -C tools/h2a/ clean

.PHONY: clean cleanall simulation all tools ram
