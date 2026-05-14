.ONESHELL:
SHELL=/bin/bash

-include env
export

-include user_env
export


dutb:
	$(ECHO_HEADER)
	$(SETUP_TOOLS)
	@mkdir -p $(BUILD_FOLDER)
	@cd $(BUILD_FOLDER)
	@$(VLOG_BIN_TOOL) \
	--incr \
	--relax \
	-d DUTB_USE_UVM \
	-d $(TOOLS) \
	-sv \
	-L UVM \
	-work $(LIB_NAME)=../$(LIB_FOLDER) \
	../$(DUTB_SRC_PATH)/dutb_util_pkg.sv \
	../$(DUTB_SRC_PATH)/dutb_util_mdl.sv \
	../$(DUTB_SRC_PATH)/dutb_pkg.sv
	$(ECHO_FOOTER)


clean:
	$(ECHO_HEADER)
	rm -rf $(LIB_FOLDER)
	rm -rf $(BUILD_FOLDER)

	$(ECHO_FOOTER)

