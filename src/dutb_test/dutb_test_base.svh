/******************************************************************************************************************************
    Project         :   dutb
    Creation Date   :   Dec 2015
    Class           :   dutb_test_base
    Description     :
******************************************************************************************************************************/


// ****************************************************************************************************************************
class dutb_test_base     #(parameter integer N_AGNT = 2, N_SCB = 1) extends uvm_test;
    `uvm_component_param_utils (dutb_test_base)

    dutb_report_server                                      dutb_report_server_h;
    dutb_env #(N_AGNT, N_SCB)                               env_h;
    dutb_handler                                            dutb_handler_h;
    // uvm_tr_database                                         dutb_db;

    extern function                                         new(string name, uvm_component parent = null);
    extern function void                                    build_phase(uvm_phase phase);
    extern function void                                    end_of_elaboration_phase(uvm_phase phase);
    extern function void                                    start_of_simulation_phase(uvm_phase phase);
    extern function void                                    final_phase(uvm_phase phase);
endclass
// ****************************************************************************************************************************


// ****************************************************************************************************************************
function dutb_test_base::new(string name, uvm_component parent = null);
    super.new(name, parent);
endfunction


function void dutb_test_base::build_phase(uvm_phase phase);
    // replace 'default report server' with customized version
    dutb_report_server_h = new ("dutb_report_server_h");
    uvm_report_server::set_server( dutb_report_server_h );//substitute default report server

    //create utils stack
    dutb_handler_h          = dutb_handler::type_id::create ("dutb_handler_h", this);
    uvm_config_db #(dutb_handler)::set(this, "*", "dutb_handler_h", dutb_handler_h);
    uvm_config_db #(dutb_db)::set(this, "*", "txn_db_h", dutb_handler_h.txn_db_h);

    // create env
    env_h = dutb_env #(N_AGNT, N_SCB)::type_id::create("env_h", this);

    // uvm_config_db #(int)::dump();
endfunction


function void dutb_test_base::end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
endfunction


function void dutb_test_base::start_of_simulation_phase(uvm_phase phase);
    // uvm_top.print_topology();
    super.start_of_simulation_phase(phase);
endfunction


function void dutb_test_base::final_phase(uvm_phase phase);
    super.final_phase(phase);
endfunction
// ****************************************************************************************************************************
