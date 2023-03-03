/******************************************************************************************************************************
    Project         :   dutb
    Author          :   glkclass@gmail.com
    Creation Date   :   Dec 2015
    Class           :   dut_predictor_base. To be inherited and extended with gold reference generation tools.
    Interface       :   Single 'analisys export' to accept DUT 'input' txn.
                        Two output analisys exports to send gold 'output' and 'probe'(if required) txns.
    Desc            :   Accept 'input' txn and generate gold reference for it. The same for 'probe' txn if required.
*******************************************************************************************************************************/


// ****************************************************************************************************************************
class dut_predictor_base    #(type  T_DIN_TXN   = dutb_txn_base,
                                    T_DOUT_TXN  = dutb_txn_base,
                                    T_POUT_TXN  = dutb_txn_base)
extends uvm_subscriber      #(T_DIN_TXN);
    `uvm_component_param_utils (dut_predictor_base #(T_DIN_TXN, T_DOUT_TXN, T_POUT_TXN))

    uvm_analysis_port   #(T_DOUT_TXN)       dout_gold_aport;
    uvm_analysis_port   #(T_POUT_TXN)       pout_gold_aport;

    extern function                         new(string name = "dut_predictor_base", uvm_component parent=null);
    extern function void                    build_phase(uvm_phase phase);
    extern virtual function void            write(T_DIN_TXN t);
endclass
// ****************************************************************************************************************************


// ****************************************************************************************************************************
function dut_predictor_base::new(string name = "dut_predictor_base", uvm_component parent=null);
    super.new(name, parent);
endfunction


function void dut_predictor_base::build_phase(uvm_phase phase);
    dout_gold_aport = new("dout_gold_aport", this);
    pout_gold_aport = new("pout_gold_aport", this);
endfunction


// Should be overridden in a child classes to provide access to gold references 
function void dut_predictor_base::write(T_DIN_TXN t);
    T_DIN_TXN       din_txn;    // input DUT txn
    T_DOUT_TXN      dout_txn;   // output 'gold' txn to be sent to checker

    $cast(din_txn, t.clone());
    `uvm_debug("PREDICTOR", {"Content:", din_txn.convert2string()})

    dout_txn = T_DOUT_TXN::type_id::create("dout_txn");
    // generate gold dout_txn smth here..
    dout_gold_aport.write(dout_txn);
    `uvm_error("VFNOTOVRDN", "Override predictor 'write ()' method")
endfunction
// ****************************************************************************************************************************









