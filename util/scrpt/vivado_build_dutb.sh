echo "Vivado build dutb in `pwd`"
source /tools/Xilinx/Vivado/2023.2/settings64.sh

if [ -z "${DUTB_PATH}" ]; then
    DUTB_PATH=../..
fi

DUTB_SRC_PATH=${DUTB_PATH}/src/sve 

xvlog \
-sv \
-L UVM \
${DUTB_SRC_PATH}/dutb_param_pkg.sv \
${DUTB_SRC_PATH}/dutb_typedef_pkg.sv \
${DUTB_SRC_PATH}/dutb_util_pkg.sv \
${DUTB_SRC_PATH}/dutb_pkg.sv
