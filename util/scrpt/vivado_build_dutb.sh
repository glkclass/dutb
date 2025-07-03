TOOLS=VIVADO_TOOLS
echo $TOOLS used

if [ -z "${VIVADO_PATH}" ]; then
    VIVADO_PATH=/tools/Xilinx/2025.1/Vivado
fi

if [ -z "${DUTB_PATH}" ]; then
    DUTB_PATH=../..
fi

DUTB_SRC_PATH=${DUTB_PATH}/src

source ${VIVADO_PATH}/settings64.sh

echo "Build dutb in `pwd`" ..
xvlog \
-d $TOOLS \
-sv \
-L UVM \
${DUTB_SRC_PATH}/dutb_param_pkg.sv \
${DUTB_SRC_PATH}/dutb_typedef_pkg.sv \
${DUTB_SRC_PATH}/dutb_util_pkg.sv \
${DUTB_SRC_PATH}/dutb_pkg.sv
