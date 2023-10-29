PWDD := $(shell pwd)
BLOCKS := $(shell basename $(PWDD))

# ---- Include Partitioned Makefiles ----

CONFIG = caravel_user_project

#SMELL: Fix this PYTHONPATH:
#export PYTHONPATH := $(DESIGNS)/verilog/rtl/wrapped_rgb_mixer/rgb_mixer/test
export COCOTB_REDUCED_LOG_FMT=1
export LIBPYTHON_LOC=$(shell cocotb-config --libpython)


include $(MCW_ROOT)/verilog/dv/make/env.makefile
include $(MCW_ROOT)/verilog/dv/make/var.makefile
include $(MCW_ROOT)/verilog/dv/make/cpu.makefile
include $(MCW_ROOT)/verilog/dv/make/sim.makefile

#NOTE changed iverilog args:
# -g2009 to support SystemVerilog (in particular, fixed-point constant casting).
# -v to include extra spiflash emulator (texture_rom) Verilog.
# -I to help find `include files.
coco_test: rbz_basic.hex
	rm -rf sim_build/
	mkdir sim_build/

	iverilog -Ttyp -DFUNCTIONAL -DSIM -DUSE_POWER_PINS -DUNIT_DELAY=#1 \
	-f$(VERILOG_PATH)/includes/includes.rtl.caravel \
	-f$(USER_PROJECT_VERILOG)/includes/includes.rtl.$(CONFIG) \
	-v $(USER_PROJECT_VERILOG)/dv/rbz_basic/texture_rom/W25Q128JVxIM.v \
	-I $(USER_PROJECT_VERILOG)/rtl/raybox-zero/src/rtl \
	-g2009 \
	-o sim_build/sim.vvp rbz_basic_tb.v

	TESTCASE=test_start,test_all MODULE=test_rbz_basic vvp -M $$(cocotb-config --prefix)/cocotb/libs -m libcocotbvpi_icarus sim_build/sim.vvp
	! grep failure results.xml

coco_test_gl: rbz_basic.hex
	rm -rf sim_build/
	mkdir sim_build/

	iverilog -Ttyp -DFUNCTIONAL -DSIM -DUSE_POWER_PINS -DUNIT_DELAY=#1 \
	-f$(VERILOG_PATH)/includes/includes.rtl.caravel \
	-f$(USER_PROJECT_VERILOG)/includes/includes.gl.$(CONFIG) \
	-v $(USER_PROJECT_VERILOG)/dv/rbz_basic/texture_rom/W25Q128JVxIM.v \
	-I $(USER_PROJECT_VERILOG)/rtl/raybox-zero/src/rtl \
	-g2009 \
	-o sim_build/sim.vvp rbz_basic_tb.v

	TESTCASE=test_start,test_all MODULE=test_rbz_basic vvp -M $$(cocotb-config --prefix)/cocotb/libs -m libcocotbvpi_icarus sim_build/sim.vvp
	! grep failure results.xml
