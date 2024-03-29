/******************************************************************************************************************************
    Project         :   dutb
    Creation Date   :   Dec 2015
    Class           :   dutb_v_sqncr
    Description     :   Interface   -   
                        Task        -   
******************************************************************************************************************************/


//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
class dutb_v_sqncr #(type   T_DIN_TXN   = dutb_txn_base, 
                            T_DOUT_TXN  = dutb_txn_base) 
extends uvm_virtual_sequencer;
    `uvm_component_param_utils(dutb_v_sqncr #(T_DIN_TXN, T_DOUT_TXN))

    uvm_sequencer #(T_DIN_TXN)  din_sqncr_h;
    uvm_sequencer #(T_DOUT_TXN) dout_sqncr_h;

    extern function new(string name, uvm_component parent = null);
endclass
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


function dutb_v_sqncr::new(string name, uvm_component parent = null);
  super.new(name, parent);
endfunction
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
