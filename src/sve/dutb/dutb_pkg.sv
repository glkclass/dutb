`timescale 1ns/1ns
package dutb_pkg;
    `include "uvm_macros.svh"
    import uvm_pkg::*;

    import dutb_typedef_pkg::*;
    import dutb_param_pkg::*;

    `include "dutb_util.svh"
    `include "dutb_handler.svh"
    `include "dutb_report_server.svh"
    `include "dutb_progress_bar.svh"

    `include "dutb_if_proxy_base.svh"
    
    `include "dutb_txn_base.svh"
    `include "dutb_v_sqncr.svh"
    `include "dutb_v_seq.svh"

    `include "dutb_driver_base.svh"
    `include "dutb_monitor_base.svh"
    `include "dutb_agent_base_cfg.svh"
    `include "dutb_agent_base.svh"

    `include "dutb_predictor_base.svh"
    `include "dutb_checker_base.svh"
    `include "dutb_fcc_base.svh"
    `include "dutb_scb_base_cfg.svh"
    `include "dutb_scb_base.svh"

    `include "dutb_env_base_cfg.svh"
    `include "dutb_env_base.svh"

    `include "dutb_test_base.svh"
endpackage




