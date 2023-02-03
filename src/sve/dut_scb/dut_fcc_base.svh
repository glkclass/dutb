// functional coverage collector base - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
class   dut_fcc_base #(type     t_din_txn   = dut_txn_base,
                                t_dout_txn  = dut_txn_base,
                                t_pout_txn  = dut_txn_base)
extends uvm_component;
    `uvm_component_param_utils (dut_fcc_base #(t_din_txn, t_dout_txn, t_pout_txn))

    typedef dut_fcc_base    #(t_din_txn, t_dout_txn, t_pout_txn)     this_type;

    uvm_analysis_export #(t_din_txn)        din_export;
    uvm_analysis_export #(t_dout_txn)       dout_export;
    uvm_analysis_export #(t_pout_txn)       pout_export;

    uvm_tlm_analysis_fifo #(t_din_txn)      din_fifo;
    uvm_tlm_analysis_fifo #(t_dout_txn)     dout_fifo;
    uvm_tlm_analysis_fifo #(t_pout_txn)     pout_fifo;

    t_din_txn               din_txn;
    t_dout_txn              dout_txn;
    t_pout_txn              pout_txn;

    dut_handler             dut_handler_h;
    dut_progress_bar        progress_bar_h;

    map_flt                 cov_result;
    map_int                 cov_value;

    extern          function        new(string name = "dut_fcc_base", uvm_component parent=null);
    extern          function void   build_phase(uvm_phase phase);
    extern          function void   connect_phase (uvm_phase phase);
    extern          task            run_phase( uvm_phase phase );
    extern virtual  function void   sample_coverage();
    extern virtual  function void   check_coverage_results();
endclass
// - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


// - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
function dut_fcc_base::new(string name = "dut_fcc_base", uvm_component parent=null);
    super.new(name, parent);
endfunction


function void dut_fcc_base::build_phase(uvm_phase phase);
    din_export  = new ("din_export", this);
    dout_export = new ("dout_export", this);
    pout_export = new ("pout_export", this);

    din_fifo = new ("din_fifo", this);
    dout_fifo = new ("dout_fifo", this);
    pout_fifo = new ("pout_fifo", this);

    progress_bar_h = new("progress_bar_h", this);

    // extract dut_handler
    if (!uvm_config_db #(dut_handler)::get(this, "", "dut_handler", dut_handler_h))
        `uvm_fatal("CFG_DB_ERROR", "Unable to get 'dut_handler' from config db")
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
// - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
