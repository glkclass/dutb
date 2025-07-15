.ONESHELL:
SHELL=/bin/bash

ifndef TOOLS
	TOOLS=VIVADO_TOOLS
	ifndef VIVADO_PATH
		VIVADO_PATH=/tools/Xilinx/2025.1/Vivado
	endif
	TOOLS_USED="$(TOOLS) : $(VIVADO_PATH)"
else
	TOOLS_USED="$(TOOLS)"
endif

ifndef DUTB_PATH
    DUTB_PATH=../..
endif

PROJECT_ROOT_PATH=$(DUTB_PATH)
DUTB_SRC_PATH=${PROJECT_ROOT_PATH}/src


# rules
all: clean dutb


dutb:
	@echo "$(TOOLS_USED)"
	@echo "DUTB build.."
ifdef VIVADO_PATH
	@source $(VIVADO_PATH)/settings64.sh
endif
	@xvlog \
	-d $TOOLS \
	-sv \
	-L UVM \
	$(DUTB_SRC_PATH)/dutb_param_pkg.sv \
	$(DUTB_SRC_PATH)/dutb_typedef_pkg.sv \
	$(DUTB_SRC_PATH)/dutb_util_pkg.sv \
	$(DUTB_SRC_PATH)/dutb_pkg.sv
	@echo "..Finished"
	@echo ""


clean:
	@echo "Cleanup.."
	@rm -rf xsim.dir
	@rm -rf *.log
	@rm -rf *.pb
	@rm -rf *.log
	@echo "..Finished"
	@echo ""

