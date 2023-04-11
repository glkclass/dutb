/******************************************************************************************************************************
    Project         :   dutb
    Creation Date   :   Dec 2015
    Class           :   dut_predictor_base.
    Description     :   Interface   -   Single 'analisys export' to accept DUT 'input' txn.
                                        Two output analisys exports to send gold 'output' and 'probe'(if required) txns.
                        Task        -   Accept 'input' txn and generate gold reference for it. The same for 'probe' txn if required.
                                        To be inherited and extended with gold reference generation tools.
*******************************************************************************************************************************/


// ****************************************************************************************************************************
class dut_predictor_base    #(type  T_DIN_TXN   = dutb_txn_base,
                                    T_DOUT_TXN  = dutb_txn_base)
extends uvm_subscriber      #(T_DIN_TXN);
    `uvm_component_param_utils (dut_predictor_base #(T_DIN_TXN, T_DOUT_TXN))

    uvm_analysis_port   #(T_DOUT_TXN)       dout_gold_aport;

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
endfunction


// May be overridden in a child classes to provide access to gold references of left as is now.
function void dut_predictor_base::write(T_DIN_TXN t);
    T_DIN_TXN       din_txn;    // input DUT txn
    T_DOUT_TXN      dout_txn;   // output 'gold' txn to be sent to checker

    $cast(din_txn, t.clone());
    // `uvm_debug({"Content:\n", din_txn.convert2string()})

    // override 'input txn'.gold() method to generate gold 'output txn'
    `ASSERT_TYPE_CAST(dout_txn, din_txn.gold());
    dout_gold_aport.write(dout_txn);
endfunction
// ****************************************************************************************************************************









