// - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
class dutb_test_base     #(type T_DIN_TXN   = dutb_txn_base,
                                T_DOUT_TXN  = dutb_txn_base,
                                T_POUT_TXN  = dutb_txn_base)
extends uvm_test;
    `uvm_component_param_utils (dutb_test_base #(T_DIN_TXN, T_DOUT_TXN, T_POUT_TXN))

    // virtual dutb_if                                         dutb_vif;
    dutb_if_proxy_base                                      dutb_if_h;
    dutb_env_base_cfg                                       env_cfg_h;
    dutb_env_base #( T_DIN_TXN, T_DOUT_TXN, T_POUT_TXN)     env_h;
    dutb_handler                                            dutb_handler_h;

    extern function                                         new(string name = "dutb_test_base", uvm_component parent = null);
    extern function void                                    build_phase(uvm_phase phase);
    extern function void                                    start_of_simulation();
endclass
// - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


// - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
function dutb_test_base::new(string name = "dutb_test_base", uvm_component parent = null);
    super.new(name, parent);
endfunction

function void dutb_test_base::start_of_simulation();
    // replace 'default report server' with customized version
    dutb_report_server dutb_report_server_h = new ("dutb_report_server_h");
    super.start_of_simulation();
    
endfunction

function void dutb_test_base::build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    //create util stack
    dutb_handler_h          = new ("dutb_handler_h", this);
    uvm_config_db #(dutb_handler)::set(this, "*", "dutb_handler", dutb_handler_h);

    env_cfg_h               = dutb_env_base_cfg::type_id::create("env_cfg_h", this);
    
    // if (!uvm_config_db #(virtual dutb_if)::get(this, "", "dutb_vif", dutb_vif))
    //     `uvm_fatal("CFG_DB_ERROR", "Unable to get \"dutb_vif\" from config db")
    // else
    //     // pass dutb_vif to dutb_if_proxy
    //     uvm_config_db #(virtual dutb_if)::set(this, "dutb_if_h", "dutb_vif", dutb_vif);

    // create dut_if_proxy and pass it to env config
    dutb_if_h               = dutb_if_proxy_base::type_id::create("dutb_if_h", this);
    env_cfg_h.dutb_if_h     = dutb_if_h;

    // pass env config to env
    uvm_config_db #(dutb_env_base_cfg)::set(this, "env_h", "cfg_h", env_cfg_h);
    
    // create env
    env_h                   = dutb_env_base #(T_DIN_TXN, T_DOUT_TXN, T_POUT_TXN)::type_id::create("env_h", this);
endfunction
// - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
