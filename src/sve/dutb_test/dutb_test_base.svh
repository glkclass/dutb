/******************************************************************************************************************************
    Project         :   dutb
    Creation Date   :   Dec 2015
    Class           :   dutb_test_base
    Description     :   Interface   -   
                        Task        -   
******************************************************************************************************************************/


// ****************************************************************************************************************************
class dutb_test_base     #(type T_DIN_TXN   = dutb_txn_base,
                                T_DOUT_TXN  = dutb_txn_base)
extends uvm_test;
    `uvm_component_param_utils (dutb_test_base #(T_DIN_TXN, T_DOUT_TXN))

    dutb_if_proxy_base                                      dutb_if_h;
    dutb_env_base_cfg                                       env_cfg_h;
    dutb_env_base #( T_DIN_TXN, T_DOUT_TXN)                 env_h;
    dutb_handler                                            dutb_handler_h;
    uvm_tr_database                                         dutb_db;

    extern function                                         new(string name = "dutb_test_base", uvm_component parent = null);
    extern function void                                    build_phase(uvm_phase phase);
    extern function void                                    end_of_elaboration_phase(uvm_phase phase);
    extern function void                                    start_of_simulation_phase(uvm_phase phase);
    extern function void                                    final_phase(uvm_phase phase);
endclass
// ****************************************************************************************************************************


// ****************************************************************************************************************************
function dutb_test_base::new(string name = "dutb_test_base", uvm_component parent = null);
    super.new(name, parent);
endfunction


function void dutb_test_base::build_phase(uvm_phase phase);
    // replace 'default report server' with customized version
    dutb_report_server dutb_report_server_h = new ("dutb_report_server_h");
    


    //create util stack
    dutb_handler_h          = new ("dutb_handler_h", this);
    uvm_config_db #(dutb_handler)::set(this, "*", "dutb_handler", dutb_handler_h);

    env_cfg_h               = dutb_env_base_cfg::type_id::create("env_cfg_h", this);
    
    // create dut_if_proxy and pass it to env config
    dutb_if_h               = dutb_if_proxy_base::type_id::create("dutb_if_h", this);
    env_cfg_h.dutb_if_h     = dutb_if_h;

    // pass env config to env
    uvm_config_db #(dutb_env_base_cfg)::set(this, "env_h", "cfg_h", env_cfg_h);
    
    // create env
    env_h                   = dutb_env_base #(T_DIN_TXN, T_DOUT_TXN)::type_id::create("env_h", this);
endfunction


function void dutb_test_base::end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
endfunction


function void dutb_test_base::start_of_simulation_phase(uvm_phase phase);
    uvm_top.print_topology();
    super.start_of_simulation_phase(phase);
endfunction


function void dutb_test_base::final_phase(uvm_phase phase);
    super.final_phase(phase);
endfunction
// ****************************************************************************************************************************
