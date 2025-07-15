/******************************************************************************************************************************
    Project         :   dutb
    Creation Date   :   Dec 2015
    Package         :   dutb_pkg
    Description     :   Contain dutb infra.
******************************************************************************************************************************/


// ****************************************************************************************************************************
// `timescale 1ps/1ps


package dutb_pkg;
    `include "uvm_macros.svh"
    import uvm_pkg::*;

    `include "dutb_macros.svh"
    import dutb_typedef_pkg::*;
    import dutb_param_pkg::*;
    import dutb_util_pkg::*;

    `include "dutb_util/dutb_db.svh"
    `include "dutb_util/dutb_progress_bar.svh"
    `include "dutb_util/dutb_handler.svh"
    `include "dutb_util/dutb_report_server.svh"
    `include "dutb_if_proxy/dutb_if_proxy_base.svh"

    `include "dutb_covergroup/dutb_covergroup_base.svh"

    `include "dutb_txn/dutb_txn_base.svh"
    `include "dutb_txn/dutb_txn_seq_base.svh"
    `include "dutb_txn/dutb_v_sqncr.svh"

    `include "dutb_agent/dutb_driver_base.svh"
    `include "dutb_agent/dutb_monitor_base.svh"
    `include "dutb_agent/dutb_agent_base_cfg.svh"
    `include "dutb_agent/dutb_agent_base.svh"

    `include "dutb_scb/dutb_scb_base.svh"

    `include "dutb_env/dutb_env_base_cfg.svh"
    `include "dutb_env/dutb_env_base.svh"

    `include "dutb_test/dutb_test_base.svh"
endpackage
// ****************************************************************************************************************************




