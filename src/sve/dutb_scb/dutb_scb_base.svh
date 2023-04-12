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

    uvm_analysis_export #(T_DIN_TXN)        din_export;
    uvm_analysis_export #(T_DOUT_TXN)       dout_export;

    // DUT and predictor data fifo
    uvm_tlm_analysis_fifo #(T_DIN_TXN)      din_fifo;
    uvm_tlm_analysis_fifo #(T_DOUT_TXN)     dout_fifo;


    extern          function                    new(string name = "dut_scb_base", uvm_component parent=null);
    extern          function void               build_phase(uvm_phase phase);
    extern          function void               connect_phase(uvm_phase phase);
    extern          task                        run_phase (uvm_phase phase);
    extern virtual  task                        do_check();  // check dut output against gold
    extern virtual  function void               do_coverage(T_DIN_TXN din_txn_h, T_DOUT_TXN dout_txn_h);  // sample/analyze/report coverage

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

    din_fifo            = new ("din_dut_fifo", this);
    dout_fifo           = new ("dout_dut_fifo", this);
endfunction


function void dut_scb_base::connect_phase(uvm_phase phase);
    // connect input ports to appropriate fifo buffers
    din_export.connect(din_fifo.analysis_export);
    dout_export.connect(dout_fifo.analysis_export);
endfunction


task dut_scb_base::run_phase(uvm_phase phase);
    forever
        begin
            do_check();
            // synch_seq();// finish processing of all content of the previous sequence before let the next one to proceed...
            // progress_bar_h.display($sformatf("Success/Fails = %0d/%0d", dutb_handler_h.n_success, dutb_handler_h.n_fails));
        end
endtask


// Maybe overridden in a child class to perfrom a check or left as is now
task dut_scb_base::do_check();
    bit         eq[string];
    T_DIN_TXN   din_txn_h;
    T_DOUT_TXN  dout_txn_h, dout_gold_txn_h;

    din_fifo.get(din_txn_h);
    `ASSERT_TYPE_CAST(dout_gold_txn_h, din_txn_h.gold());
    dout_fifo.get(dout_txn_h);
    eq["dout"] = dout_txn_h.compare(dout_gold_txn_h);  // compare DUT output txn

    if (eq["dout"])
        begin            
            do_coverage(din_txn_h, dout_txn_h);
            // `uvm_debug({"DUT in:\n", din_txn_h.convert2string()})
            // `uvm_debug({"'DUT' and 'gold' output txn don't match:\n", dout_txn_h.convert2string_pair(dout_gold_txn_h)})
        end
    else 
        begin
            // `uvm_debug({"DUT in:\n", din_txn_h.convert2string()})
            `uvm_error("COMPARE", {"'DUT' and 'gold' output txn don't match:\n", dout_txn_h.convert2string_pair(dout_gold_txn_h)})
            // dutb_handler_h.fail(dout_dut_txn_h.pack2vector());
        end
endtask


// Use txn methods to handle coverage.
// Maybe overridden in case of need.
function void dut_scb_base::do_coverage(T_DIN_TXN din_txn_h, T_DOUT_TXN dout_txn_h);
    // input txn coverage
    din_txn_h.sample_coverage();
    din_txn_h.analyze_coverage_results();
    // output txn coverage
    // dout_txn_h.sample_coverage();
    // dout_txn_h.analyze_coverage_results();    
endfunction

// ****************************************************************************************************************************

