/******************************************************************************************************************************
    Project         :   dutb
    Creation Date   :   Dec 2015
    Class           :   dut_scb_base.
    Description     :   Interface   -   Two 'analisys exports' to accept DUT 'input', 'output' txn.
                        Task        -   Provide room for three units: predictor, checker, coverage collector.
                                        Setup connections between them.
******************************************************************************************************************************/


// ****************************************************************************************************************************
class dut_scb_base #(type   T_DIN_TXN   = dutb_txn_base,
                            T_DOUT_TXN  = dutb_txn_base)
extends uvm_scoreboard;
    `uvm_component_param_utils(dut_scb_base #(T_DIN_TXN, T_DOUT_TXN))

    uvm_analysis_export #(T_DIN_TXN)                            din_export;
    uvm_analysis_export #(T_DOUT_TXN)                           dout_export;

    dut_predictor_base  #(T_DIN_TXN, T_DOUT_TXN)                dut_predictor_h;
    dutb_checker_base   #(T_DIN_TXN, T_DOUT_TXN)                dutb_checker_base_h;
    dut_fcc_base        #(T_DIN_TXN, T_DOUT_TXN)                dut_fcc_h;

    // dut_scb_cfg                                                 dut_scb_cfg_h;

    extern function                                             new(string name = "dut_scb_base", uvm_component parent=null);
    extern function void                                        build_phase(uvm_phase phase);
    extern function void                                        connect_phase(uvm_phase phase);
endclass
// ****************************************************************************************************************************


// ****************************************************************************************************************************
function dut_scb_base::new(string name = "dut_scb_base", uvm_component parent=null);
    super.new(name, parent);
endfunction


function void dut_scb_base::build_phase(uvm_phase phase);

    // ports to recieve DUT input & output txn
    din_export          = new("din_export", this);
    dout_export         = new("dout_export", this);

    dut_predictor_h     = dut_predictor_base    #(T_DIN_TXN, T_DOUT_TXN)::type_id::create("dut_predictor_h", this);
    dutb_checker_base_h = dutb_checker_base     #(T_DIN_TXN, T_DOUT_TXN)::type_id::create("dutb_checker_base_h", this);
    dut_fcc_h           = dut_fcc_base          #(T_DIN_TXN, T_DOUT_TXN)::type_id::create("dut_fcc_h", this);
endfunction


function void dut_scb_base::connect_phase(uvm_phase phase);
    // input txn: from DUT to predictor
    din_export.connect(dut_predictor_h.analysis_export);
    
    // gold output txn: from predictor to checker
    dut_predictor_h.dout_gold_aport.connect(dutb_checker_base_h.dout_gold_export);
    
    // input & output txn: from DUT to checker
    din_export.connect(dutb_checker_base_h.din_dut_export);
    dout_export.connect(dutb_checker_base_h.dout_dut_export);

    // input & output txn: from checker to func coverage collector
    dutb_checker_base_h.din_fcc_aport.connect(dut_fcc_h.din_export);
    dutb_checker_base_h.dout_fcc_aport.connect(dut_fcc_h.dout_export);
endfunction
// ****************************************************************************************************************************

