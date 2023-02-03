// - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
class dut_predictor_base    #(type  t_din_txn   = dut_txn_base,
                                    t_dout_txn  = dut_txn_base,
                                    t_pout_txn  = dut_txn_base)
extends uvm_subscriber      #(t_din_txn);
    `uvm_component_param_utils (dut_predictor_base #(t_din_txn, t_dout_txn, t_pout_txn))

    dut_handler                             dut_handler_h;

    uvm_analysis_port   #(t_dout_txn)       dout_gold_aport;
    uvm_analysis_port   #(t_pout_txn)       pout_gold_aport;

    chandle                                 gold_ref_h;
    int                                     log[p_log_buffer_size];
    int                                     in_vec[2 + p_depth_size], out_vec[p_th_num];

    extern function new(string name = "dut_predictor_base", uvm_component parent=null);
    extern function void build_phase(uvm_phase phase);
    // extern function void connect_phase (uvm_phase phase);
    // extern task run_phase (uvm_phase phase);
    extern function void send_pout();
    extern function void write(t_din_txn t);
    // extern virtual function void gold_ref (chandle gold_ref_h);
endclass
// - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


// - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
function dut_predictor_base::new(string name = "dut_predictor_base", uvm_component parent=null);
    super.new(name, parent);
endfunction


function void dut_predictor_base::build_phase(uvm_phase phase);
    dout_gold_aport = new("dout_gold_aport", this);
    pout_gold_aport = new("pout_gold_aport", this);

    // gold_ref_h = dut_gold_ref_new(); // create cpp-class containing cpp-references
    
    // extract dut_handler
    if (!uvm_config_db #(dut_handler)::get(this, "", "dut_handler", dut_handler_h))
        `uvm_fatal("CFG_DB_ERROR", "Unable to get 'dut_handler' from config db")
endfunction


function void dut_predictor_base::write(t_din_txn t);
    t_din_txn       din_txn;
    t_dout_txn      dout_txn;
    vector          packed_txn;

    $cast(din_txn, t.clone());
    `uvm_info("PREDICTOR", {"content\n", din_txn.convert2string()}, UVM_FULL)

    packed_txn = din_txn.pack2vector();

    foreach (packed_txn[i])
        begin
            in_vec[i] = packed_txn[i];
        end

    // Depth_Rect_dpi (gold_ref_h, in_vec, out_vec, log);
    send_pout();  // send gold probe txn

    // send dout gold txn
    dout_txn = t_dout_txn::type_id::create("dout_txn");
    dout_txn.unpack4vector(out_vec);
    dout_gold_aport.write(dout_txn);
endfunction


function void dut_predictor_base::send_pout();
    int log_queue[$], n;
    t_pout_txn txn;

    n = log[0];  // log size
    for (int i=0; i<n; i++)
        begin
            log_queue.push_back(log[1+i]);
        end
    // `uvm_info("PREDICTOR", {"Log size: ", dut_handler_h.util.vec2str({n})}, UVM_HIGH)
    // `uvm_info("PREDICTOR", {"Log: \n", dut_handler_h.util.vec2str(log_queue)}, UVM_HIGH)
    txn = t_pout_txn::type_id::create("txn");
    txn.unpack4vector(log_queue);
    pout_gold_aport.write(txn);
endfunction
// - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -









