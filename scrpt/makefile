.ONESHELL:
SHELL=/bin/bash

TOOLS=VIVADO_TOOLS
VIVADO_PATH=/tools/Xilinx/2025.1/Vivado
TOOLS_USED="$(TOOLS) [$(VIVADO_PATH)]"

ECHO_HEADER=@echo -e "[INFO] Make $@\n$(TOOLS_USED)"
ECHO_FOOTER=@echo -e "[INFO] ..Finished\n"
SETUP_TOOLS=@source $(VIVADO_PATH)/settings64.sh

ifndef DUTB_RUN_DIR
	DUTB_RUN_DIR=.
endif

ifndef DUTB_PATH
	DUTB_PATH=$(DUTB_RUN_DIR)/..
endif


PROJECT_ROOT_PATH=$(DUTB_PATH)
DUTB_SRC_PATH=${PROJECT_ROOT_PATH}/src


# rules
all: clean dutb


dutb:
	$(ECHO_HEADER)
	$(SETUP_TOOLS)
	@xvlog \
	--incr \
	--relax \
	-d DUTB_USE_UVM \
	-d $TOOLS \
	-sv \
	-L UVM \
	$(DUTB_SRC_PATH)/dutb_util_pkg.sv \
	$(DUTB_SRC_PATH)/dutb_util_mdl.sv \
	$(DUTB_SRC_PATH)/dutb_pkg.sv
	$(ECHO_FOOTER)


clean:
	@echo "Cleanup.."
	@rm -rf $(DUTB_RUN_DIR)/xsim.dir
	@rm -rf $(DUTB_RUN_DIR)/*.log
	@rm -rf $(DUTB_RUN_DIR)/*.pb
	@rm -rf $(DUTB_RUN_DIR)/*.log
	$(ECHO_FOOTER)

