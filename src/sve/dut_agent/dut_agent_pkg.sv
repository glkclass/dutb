package dut_agent_pkg;
    `include "uvm_macros.svh"
    import uvm_pkg::*;

    // import dut_param_pkg::*;
    import dut_tb_param_pkg::*;
    import dut_sequence_pkg::*;
    import dut_util_pkg::*;
    // `include "dut_progress_bar.svh"
    `include "dut_driver_base.svh"
    `include "dut_monitor_base.svh"
    `include "dut_xds_in_driver.svh"
    `include "dut_xds_out_driver.svh"
    `include "dut_xds_in_frame_driver.svh"
    `include "dut_xds_in_frame_monitor.svh"

    `include "dut_pout_monitor.svh"
    `include "dut_agent_cfg.svh"
    `include "dut_agent.svh"
endpackage
