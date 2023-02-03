class dut_test_base     #(type  t_din_txn   = dut_txn_base,
                                t_dout_txn  = dut_txn_base,
                                t_pout_txn  = dut_txn_base)
extends uvm_test;
    `uvm_component_param_utils (dut_test_base #(t_din_txn, t_dout_txn, t_pout_txn))

    virtual dut_if              dut_vif;
    dut_env_cfg                 env_cfg_h;

    dut_env #(  t_din_txn,
                t_dout_txn,
                t_pout_txn)     env_h;

    dut_handler                 dut_handler_h;

    extern function new(string name = "dut_test_base", uvm_component parent = null);
    extern function void build_phase(uvm_phase phase);
    extern function void start_of_simulation();
endclass

function dut_test_base::new(string name = "dut_test_base", uvm_component parent = null);
    super.new(name, parent);
endfunction

function void dut_test_base::start_of_simulation();
    // replace 'default report server' with customized version
    // dut_report_server dut_report_server_h = new ("dut_report_server_h");
    super.start_of_simulation();
endfunction

function void dut_test_base::build_phase(uvm_phase phase);
    //create util stack
    dut_handler_h = new ("dut_handler_h", this);
    uvm_config_db #(dut_handler)::set(this, "*", "dut_handler", dut_handler_h);
    `uvm_warning("xxx", "yyy")

    // extract 'dut if' handle from db
    if (!uvm_config_db #(virtual dut_if)::get(this, "", "dut_if", dut_vif))
        `uvm_fatal("CFG_DB_ERROR", "Unable to get \"dut_if\" from config db")

    // create/initialize env/config
    env_h = dut_env #(t_din_txn, t_dout_txn, t_pout_txn)::type_id::create("env_h", this);
    env_cfg_h = dut_env_cfg::type_id::create("env_cfg_h", this);
    env_cfg_h.dut_vif = dut_vif;
    env_h.cfg_h = env_cfg_h;
endfunction
