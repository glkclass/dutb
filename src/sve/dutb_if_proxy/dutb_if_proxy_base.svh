/******************************************************************************************************************************
    Project         :   dutb
    Creation Date   :   Dec 2015
    Class           :   dutb_if_proxy_base
    Description     :   Interface   -   
                        Task        -   
******************************************************************************************************************************/


// ****************************************************************************************************************************
class dutb_if_proxy_base extends uvm_component;
    `uvm_component_utils (dutb_if_proxy_base)

    extern function         new(string name, uvm_component parent=null);
    extern function void    build_phase(uvm_phase phase);
endclass
// ****************************************************************************************************************************


// ****************************************************************************************************************************
function dutb_if_proxy_base::new(string name, uvm_component parent=null);
    super.new(name, parent);
endfunction


function void dutb_if_proxy_base::build_phase(uvm_phase phase);
    // connect to dutb interface    
    // if (!uvm_config_db #(virtual dut_if)::get(this, "", "dut_vif", dut_vif))
    //     `uvm_fatal("CFG_DB_ERROR", "Unable to get \"dut_if\" from config db")
endfunction
// ****************************************************************************************************************************
