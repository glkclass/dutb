// ****************************************************************************************************************************
class dutb_if_proxy_base extends uvm_component;
    `uvm_component_utils (dutb_if_proxy_base)

    // virtual dutb_if         dutb_vif;

    extern function         new(string name = "dutb_if_proxy_base", uvm_component parent=null);
    extern function void    build_phase(uvm_phase phase);
endclass
// ****************************************************************************************************************************


// ****************************************************************************************************************************
function dutb_if_proxy_base::new(string name = "dutb_if_proxy_base", uvm_component parent=null);
    super.new(name, parent);
endfunction


function void dutb_if_proxy_base::build_phase(uvm_phase phase);
    // connect to dutb interface    
    // if (!uvm_config_db #(virtual dutb_if)::get(this, "", "dutb_vif", dutb_vif))
    //     `uvm_fatal("CFG_DB_ERROR", "Unable to get \"dutb_if\" from config db")
endfunction
// ****************************************************************************************************************************
