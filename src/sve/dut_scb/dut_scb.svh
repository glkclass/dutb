class dut_scb #(type    t_din_txn   = dut_txn_base,
                        t_dout_txn  = dut_txn_base,
                        t_pout_txn  = dut_txn_base)
extends uvm_scoreboard;

    `uvm_component_param_utils(dut_scb #(t_din_txn, t_dout_txn, t_pout_txn))

    uvm_analysis_export #(t_din_txn)                            din_export;
    uvm_analysis_export #(t_dout_txn)                           dout_export;
    uvm_analysis_export #(t_pout_txn)                           pout_export;

    dut_predictor_base  #(t_din_txn, t_dout_txn, t_pout_txn)    dut_predictor_h;
    dut_checker         #(t_din_txn, t_dout_txn, t_pout_txn)    dut_checker_h;
    dut_fcc             #(t_din_txn, t_dout_txn, t_pout_txn)    dut_fcc_h;

    // dut_scb_cfg                                                 dut_scb_cfg_h;

    extern function new(string name = "dut_scb", uvm_component parent=null);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
endclass


function dut_scb::new(string name = "dut_scb", uvm_component parent=null);
    super.new(name, parent);
endfunction


function void dut_scb::build_phase(uvm_phase phase);

    // create ports to recieve dut input/output/probe txn
    din_export  = new("din_export", this);
    dout_export = new("dout_export", this);
    pout_export = new("pout_export", this);

    dut_fcc_h       = dut_fcc               #(t_din_txn, t_dout_txn, t_pout_txn)::type_id::create("dut_fcc_h", this);
    dut_predictor_h = dut_predictor_base    #(t_din_txn, t_dout_txn, t_pout_txn)::type_id::create("dut_predictor_h", this);
    dut_checker_h   = dut_checker           #(t_din_txn, t_dout_txn, t_pout_txn)::type_id::create("dut_checker_h", this);
endfunction


function void dut_scb::connect_phase(uvm_phase phase);
    din_export.connect(dut_predictor_h.analysis_export);
    din_export.connect(dut_checker_h.din_export);

    dout_export.connect(dut_checker_h.dout_rtl_export);
    pout_export.connect(dut_checker_h.pout_rtl_export);
    dut_predictor_h.dout_gold_aport.connect(dut_checker_h.dout_gold_export);
    dut_predictor_h.pout_gold_aport.connect(dut_checker_h.pout_gold_export);

    dut_checker_h.din_aport.connect(dut_fcc_h.din_export);
    dut_checker_h.dout_aport.connect(dut_fcc_h.dout_export);
    dut_checker_h.pout_aport.connect(dut_fcc_h.pout_export);

endfunction

