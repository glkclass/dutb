`timescale 1ns/1ns
package dut_sequence_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import typedef_pkg::*;
    import dut_tb_param_pkg::*;
    import dut_handler_pkg::*;
    import dut_util_pkg::*;

    `include "dut_txn_base.svh"
    `include "dut_v_sqncr.svh"
    `include "dut_v_seq.svh"
endpackage

