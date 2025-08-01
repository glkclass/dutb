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

ifndef DUTB_RUN_DIR
    DUTB_RUN_DIR=.
endif

ifndef DUTB_PATH
    DUTB_PATH=$(DUTB_RUN_DIR)/../..
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
	-incr \
	-d DUTB_USE_UVM \
	-d $TOOLS \
	-sv \
	-L UVM \
	$(DUTB_SRC_PATH)/dutb_util_pkg.sv \
	$(DUTB_SRC_PATH)/dutb_pkg.sv
	@echo "..Finished"
	@echo ""


clean:
	@echo "Cleanup.."
	@rm -rf $(DUTB_RUN_DIR)/xsim.dir
	@rm -rf $(DUTB_RUN_DIR)/*.log
	@rm -rf $(DUTB_RUN_DIR)/*.pb
	@rm -rf $(DUTB_RUN_DIR)/*.log
	@echo "..Finished"
	@echo ""

