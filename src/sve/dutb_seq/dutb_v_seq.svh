// base virtual sequence - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
class dutb_v_seq #(type T_DIN_TXN = dutb_txn_base) extends uvm_virtual_sequence;
    `uvm_object_param_utils(dutb_v_seq #(T_DIN_TXN))

    dutb_v_sqncr #(T_DIN_TXN)       v_sqncr ;
    uvm_sequencer #(T_DIN_TXN)      din_sqncr_h;

    extern function new(string name = "dutb_v_seq");
    extern task body();
endclass
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function dutb_v_seq::new(string name = "dutb_v_seq");
  super.new(name);
endfunction

task dutb_v_seq::body();
    if(!$cast(v_sqncr, get_sequencer()))
        begin
            `uvm_error("CAST_ERROR", "Virtual sequencer pointer cast failed");
        end
    din_sqncr_h =   v_sqncr.din_sqncr_h;
endtask
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
