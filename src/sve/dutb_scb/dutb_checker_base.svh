/******************************************************************************************************************************
    Project         :   dutb
    Creation Date   :   Dec 2015
    Class           :   dutb_checker_base
    Description     :   Interface   -   
                        Task        -   
******************************************************************************************************************************/


// ****************************************************************************************************************************
class   dutb_checker_base   #(type  T_DIN_TXN = dutb_txn_base,
                                    T_DOUT_TXN = dutb_txn_base)
    extends uvm_component;

    `uvm_component_param_utils(dutb_checker_base#(T_DIN_TXN, T_DOUT_TXN))

    dutb_handler                             dutb_handler_h;

    // from dut and predictor
    uvm_analysis_export #(T_DOUT_TXN)       dout_dut_export, dout_gold_export;
    uvm_analysis_export #(T_DIN_TXN)        din_dut_export;

    // to fcc
    uvm_analysis_port   #(T_DIN_TXN)        din_fcc_aport;
    uvm_analysis_port   #(T_DOUT_TXN)       dout_fcc_aport;

    // dut and predictor data fifo
    uvm_tlm_analysis_fifo #(T_DOUT_TXN)     dout_gold_fifo, dout_dut_fifo;
    uvm_tlm_analysis_fifo #(T_DIN_TXN)      din_dut_fifo;

    uvm_barrier                             synch_seq_br_h;
    dutb_progress_bar                       progress_bar_h;

    extern function                         new(string name = "dutb_checker_base", uvm_component parent=null);
    extern function void                    build_phase (uvm_phase phase);
    extern function void                    connect_phase (uvm_phase phase);
    extern task                             run_phase (uvm_phase phase);
    extern task                             synch_seq();
endclass
// ****************************************************************************************************************************


// ****************************************************************************************************************************
function dutb_checker_base::new(string name = "dutb_checker_base", uvm_component parent=null);
    super.new(name, parent);
endfunction


function void dutb_checker_base::build_phase (uvm_phase phase);
    progress_bar_h = new("progress_bar_h", this);

    // extract dutb_handler
    if (!uvm_config_db #(dutb_handler)::get(this, "", "dutb_handler", dutb_handler_h))
        `uvm_fatal("CFG_DB_ERROR", "Unable to get 'dutb_handler' from config db")

    // extract barrier for sequences synchronization
    if (!uvm_config_db #(uvm_barrier)::get(this, "", "synch_seq_barrier", synch_seq_br_h))
        `uvm_fatal("CFG_DB_ERROR", "Unable to get 'synch_seq_barrier' from config db")

    din_dut_export      = new ("din_dut_export", this);
    dout_dut_export     = new ("dout_dut_export", this);

    dout_gold_export    = new ("dout_gold_export", this);

    din_dut_fifo        = new ("din_dut_fifo", this);
    dout_dut_fifo       = new ("dout_dut_fifo", this);
    dout_gold_fifo      = new ("dout_gold_fifo", this);

    din_fcc_aport       = new("din_fcc_aport", this);
    dout_fcc_aport      = new("dout_fcc_aport", this);
endfunction


function void dutb_checker_base::connect_phase (uvm_phase phase);
    // connect input ports with appropriate fifo buffers
    din_dut_export.connect(din_dut_fifo.analysis_export);
    dout_dut_export.connect(dout_dut_fifo.analysis_export);
    dout_gold_export.connect(dout_gold_fifo.analysis_export);
endfunction


task dutb_checker_base::run_phase( uvm_phase phase );
    forever
        begin
            bit         eq[string];
            T_DOUT_TXN  dout_dut_txn_h, dout_gold_txn_h;

            dout_dut_fifo.get(dout_dut_txn_h);
            dout_gold_fifo.get(dout_gold_txn_h);
            eq["dout"] = dout_dut_txn_h.compare(dout_gold_txn_h);  // compare dut output

            if (!eq["dout"])
                begin
                    `uvm_error("COMPARE", {"'dut' and 'gold' output don't match:\n", dout_dut_txn_h.convert2string_pair(dout_gold_txn_h)})
                    dutb_handler_h.fail(dout_dut_txn_h.pack2vector());
                end


            if (1'b1 == eq["dout"])
                begin
                    T_DIN_TXN  din_txn_h;
                    din_dut_fifo.get(din_txn_h);

                    // send to fcc
                    din_fcc_aport.write(din_txn_h);  
                    dout_fcc_aport.write(dout_dut_txn_h);
                    dutb_handler_h.success();
                end
            else 
                begin
                    T_DIN_TXN  din_txn_h;
                    din_dut_fifo.get(din_txn_h);                    
                end

            synch_seq();// finish processing of all content of the previous sequence before let the next one to proceed...
            progress_bar_h.display($sformatf("Success/Fails = %0d/%0d", dutb_handler_h.n_success, dutb_handler_h.n_fails));
            // `uvm_info("COMPARE", {"\n", pout_dut_txn_h.convert2string()}, UVM_HIGH)
            // `uvm_info("COMPARE", {"\n", pout_gold_txn_h.convert2string()}, UVM_HIGH)
        end
endtask


// finish processing of all content of the previous sequence before let the next one to proceed...
task dutb_checker_base::synch_seq();
    bit seq_finished = (1 == synch_seq_br_h.get_num_waiters()) ? 1'b1 : 1'b0;
    if (1'b1 == seq_finished && 0 == dout_gold_fifo.used())  // current sequence was finished and it's content was fully processed
        begin
            synch_seq_br_h.wait_for();  // let the next sequence to proceed
        end
endtask
// ****************************************************************************************************************************

