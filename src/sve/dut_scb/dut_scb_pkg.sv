package dut_scb_pkg;
    `include "uvm_macros.svh"
    import uvm_pkg::*;

    import typedef_pkg::*;
    import dut_tb_param_pkg::*;
    import dut_param_pkg::*;
    import dut_util_pkg::*;    
    import dut_handler_pkg::*;    
    import dut_sequence_pkg::*;

    `include "dut_dpi_prototypes.svh"
    `include "dut_fcc_base.svh"
    `include "dut_fcc.svh"

    `include "dut_checker.svh"
    `include "dut_predictor_base.svh"
    `include "dut_scb_cfg.svh"
    `include "dut_scb.svh"
endpackage
