// - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
class dut_driver_base #(type t_dut_txn = dut_txn_base) extends uvm_driver #(t_dut_txn);
    `uvm_component_param_utils (dut_driver_base #(t_dut_txn))

    virtual dut_if                  dut_vif;
    dut_progress_bar                progress_bar_h;

    extern function new(string name = "dut_driver_base", uvm_component parent=null);
    extern function void build_phase(uvm_phase phase);
endclass
// - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


function dut_driver_base::new(string name = "dut_driver_base", uvm_component parent=null);
    super.new(name, parent);
endfunction


function void dut_driver_base::build_phase(uvm_phase phase);
    progress_bar_h = new("progress_bar_h", this);

    // connect to dut interface
    if (!uvm_config_db #(virtual dut_if)::get(this, "", "dut_vif", dut_vif))
        `uvm_fatal("NOVIF", "Unable to get 'dut_vif' from config db}")
endfunction
// - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
