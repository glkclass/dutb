/*
    Class:      dut_fcc_base
    Port:       Three input analisys ports to accept DUT 'input', 'output, 'probe' txn.
    Task:       Collect functional coverage

*/


// - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
class   dut_fcc_base #(type     T_DIN_TXN   = dutb_txn_base,
                                T_DOUT_TXN  = dutb_txn_base,
                                T_POUT_TXN  = dutb_txn_base)
extends uvm_component;
    `uvm_component_param_utils (dut_fcc_base #(T_DIN_TXN, T_DOUT_TXN, T_POUT_TXN))

    typedef dut_fcc_base    #(T_DIN_TXN, T_DOUT_TXN, T_POUT_TXN)     this_type;

    uvm_analysis_export     #(T_DIN_TXN)    din_export;
    uvm_analysis_export     #(T_DOUT_TXN)   dout_export;
    uvm_analysis_export     #(T_POUT_TXN)   pout_export;

    uvm_tlm_analysis_fifo   #(T_DIN_TXN)    din_fifo;
    uvm_tlm_analysis_fifo   #(T_DOUT_TXN)   dout_fifo;
    uvm_tlm_analysis_fifo   #(T_POUT_TXN)   pout_fifo;

    T_DIN_TXN                               din_txn;
    T_DOUT_TXN                              dout_txn;
    T_POUT_TXN                              pout_txn;

    dutb_handler                             dutb_handler_h;
    dutb_progress_bar                        progress_bar_h;

    map_flt                                 cov_result;
    map_int                                 cov_value;

    extern          function                new(string name = "dut_fcc_base", uvm_component parent=null);
    extern          function void           build_phase(uvm_phase phase);
    extern          function void           connect_phase (uvm_phase phase);
    extern          task                    run_phase( uvm_phase phase );
    extern virtual  function void           sample_coverage();
    extern virtual  function void           check_coverage_results();
endclass
// - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


// - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
function dut_fcc_base::new(string name = "dut_fcc_base", uvm_component parent=null);
    super.new(name, parent);
endfunction


function void dut_fcc_base::build_phase(uvm_phase phase);
    din_export      = new ("din_export", this);
    dout_export     = new ("dout_export", this);
    pout_export     = new ("pout_export", this);

    din_fifo        = new ("din_fifo", this);
    dout_fifo       = new ("dout_fifo", this);
    pout_fifo       = new ("pout_fifo", this);

    progress_bar_h  = new("progress_bar_h", this);

    // extract dutb_handler
    if (!uvm_config_db #(dutb_handler)::get(this, "", "dutb_handler", dutb_handler_h))
        `uvm_fatal("CFG_DB_ERROR", "Unable to get 'dutb_handler' from config db")
endfunction


function void dut_fcc_base::connect_phase (uvm_phase phase);
    // connect input ports with appropriate fifo buffers
    din_export.connect(din_fifo.analysis_export);
    dout_export.connect(dout_fifo.analysis_export);
    pout_export.connect(pout_fifo.analysis_export);
endfunction


task dut_fcc_base::run_phase( uvm_phase phase );
    forever
        begin
            din_fifo.get(din_txn);
            dout_fifo.get(dout_txn);
            pout_fifo.get(pout_txn);
            sample_coverage();
            check_coverage_results();
        end
endtask


function void dut_fcc_base::sample_coverage();
    `uvm_error("VFNOTOVRDN", "Method should be overridden...")
endfunction


function void dut_fcc_base::check_coverage_results();
    `uvm_error("VFNOTOVRDN", "Method should be overridden...")
endfunction
// - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
