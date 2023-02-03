class   dut_checker   #(type    t_din_txn = dut_txn_base,
                                t_dout_txn = dut_txn_base,
                                t_pout_txn = dut_txn_base)
extends uvm_component;

    `uvm_component_param_utils(dut_checker#(t_din_txn, t_dout_txn, t_pout_txn))

    dut_handler                             dut_handler_h;

    uvm_analysis_export #(t_dout_txn)       dout_gold_export, dout_rtl_export;
    uvm_analysis_export #(t_pout_txn)       pout_gold_export, pout_rtl_export;
    uvm_analysis_export #(t_din_txn)        din_export;

    uvm_analysis_port   #(t_din_txn)        din_aport;
    uvm_analysis_port   #(t_dout_txn)       dout_aport;
    uvm_analysis_port   #(t_pout_txn)       pout_aport;

    uvm_tlm_analysis_fifo #(t_dout_txn)     dout_gold_fifo, dout_rtl_fifo;
    uvm_tlm_analysis_fifo #(t_pout_txn)     pout_gold_fifo, pout_rtl_fifo;
    uvm_tlm_analysis_fifo #(t_din_txn)      din_fifo;

    uvm_barrier                             synch_seq_br_h;
    dut_progress_bar                        progress_bar_h;

    extern function         new(string name = "dut_checker", uvm_component parent=null);
    extern function void    build_phase (uvm_phase phase);
    extern function void    connect_phase (uvm_phase phase);
    extern task             run_phase (uvm_phase phase);
    extern task             synch_seq();
endclass


function dut_checker::new(string name = "dut_checker", uvm_component parent=null);
    super.new(name, parent);
endfunction


function void dut_checker::build_phase (uvm_phase phase);
    progress_bar_h = new("progress_bar_h", this);

    // extract dut_handler
    if (!uvm_config_db #(dut_handler)::get(this, "", "dut_handler", dut_handler_h))
        `uvm_fatal("CFG_DB_ERROR", "Unable to get 'dut_handler' from config db")

    // extract barrier for sequences synchronization
    if (!uvm_config_db #(uvm_barrier)::get(this, "", "synch_seq_barrier", synch_seq_br_h))
        `uvm_fatal("CFG_DB_ERROR", "Unable to get 'synch_seq_barrier' from config db")

    din_export = new ("din_export", this);
    din_fifo = new ("din_fifo", this);

    dout_gold_export = new ("dout_gold_export", this);
    dout_gold_fifo = new ("dout_gold_fifo", this);

    dout_rtl_export = new ("dout_rtl_export", this);
    dout_rtl_fifo = new ("dout_rtl_fifo", this);

    pout_rtl_export = new ("pout_rtl_export", this);
    pout_rtl_fifo = new ("pout_rtl_fifo", this);

    pout_gold_export = new ("pout_gold_export", this);
    pout_gold_fifo = new ("pout_gold_fifo", this);

    din_aport = new("din_aport", this);
    dout_aport = new("dout_aport", this);
    pout_aport = new("dpout_aport", this);


endfunction


function void dut_checker::connect_phase (uvm_phase phase);
    // connect input ports with appropriate fifo buffers
    din_export.connect(din_fifo.analysis_export);
    dout_rtl_export.connect(dout_rtl_fifo.analysis_export);
    dout_gold_export.connect(dout_gold_fifo.analysis_export);
    pout_rtl_export.connect(pout_rtl_fifo.analysis_export);
    pout_gold_export.connect(pout_gold_fifo.analysis_export);
endfunction


task dut_checker::run_phase( uvm_phase phase );
    forever
        begin
            bit         eq[string];
            t_pout_txn  pout_gold_txn_h, pout_rtl_txn_h;
            t_dout_txn  dout_gold_txn_h, dout_rtl_txn_h;

            dout_gold_fifo.get(dout_gold_txn_h);
            dout_rtl_fifo.get(dout_rtl_txn_h);
            eq["dout"] = dout_rtl_txn_h.compare(dout_gold_txn_h);  // compare dut output

            pout_gold_fifo.get(pout_gold_txn_h);
            pout_rtl_fifo.get(pout_rtl_txn_h);
            eq["pout"] = pout_rtl_txn_h.compare(pout_gold_txn_h);  // compare dut probes


            if (!eq["dout"])
                begin
                    `uvm_error("COMPARE", {"'rtl' and 'gold' output don't match:\n", dout_rtl_txn_h.convert2string_pair(dout_gold_txn_h)})
                    dut_handler_h.fail(dout_rtl_txn_h.pack2vector());
                end

            if (!eq["pout"])
                begin
                    `uvm_error("COMPARE", {"'rtl' and 'gold' probes don't match:\n", pout_rtl_txn_h.convert2string_pair(pout_gold_txn_h)})
                    dut_handler_h.fail(pout_rtl_txn_h.pack2vector());
                end

            if ( (1'b1 == eq["dout"]) && (1'b1 == eq["pout"]) )
                begin
                    t_din_txn  din_txn;
                    din_fifo.get(din_txn);
                    din_aport.write(din_txn);  // send to fcc
                    dout_aport.write(dout_rtl_txn_h);  // send to fcc
                    pout_aport.write(pout_rtl_txn_h);  // send to fcc
                    dut_handler_h.success();
                end

            synch_seq();// finish processing of all content of the previous sequence before let the next one to proceed...
            progress_bar_h.display($sformatf("Success/Fails = %0d/%0d", dut_handler_h.n_success, dut_handler_h.n_fails));
            // `uvm_info("COMPARE", {"\n", pout_rtl_txn_h.convert2string()}, UVM_HIGH)
            // `uvm_info("COMPARE", {"\n", pout_gold_txn_h.convert2string()}, UVM_HIGH)
        end
endtask


// finish processing of all content of the previous sequence before let the next one to proceed...
task dut_checker::synch_seq();
    bit seq_finished = (1 == synch_seq_br_h.get_num_waiters()) ? 1'b1 : 1'b0;
    if (1'b1 == seq_finished && 0 == dout_gold_fifo.used())  // current sequence was finished and it's content was fully processed
        begin
            synch_seq_br_h.wait_for();  // let the next sequence to proceed
        end
endtask

