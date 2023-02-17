//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
class dutb_v_sqncr #(type T_DIN_TXN = dutb_txn_base) extends uvm_virtual_sequencer;
    `uvm_component_param_utils(dutb_v_sqncr #(T_DIN_TXN))

    uvm_sequencer #(T_DIN_TXN) din_sqncr_h;
    extern function new(string name = "dutb_v_sqncr", uvm_component parent = null);

endclass
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


function dutb_v_sqncr::new(string name = "dutb_v_sqncr", uvm_component parent = null);
  super.new(name, parent);
endfunction
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
