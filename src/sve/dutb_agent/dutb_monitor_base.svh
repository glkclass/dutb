class dutb_monitor_base #(type T_DUT_TXN = dutb_txn_base) extends uvm_monitor;
    `uvm_component_param_utils (dutb_monitor_base #(T_DUT_TXN))

    uvm_analysis_port #(T_DUT_TXN)  aport;
    dutb_if_proxy_base              dutb_if_h;

    extern function                 new(string name = "dutb_monitor_base", uvm_component parent=null);
    extern function void            build_phase(uvm_phase phase);
    extern task                     run_phase(uvm_phase phase);
endclass


function dutb_monitor_base::new(string name = "dutb_monitor_base", uvm_component parent=null);
    super.new(name, parent);
endfunction


function void dutb_monitor_base::build_phase(uvm_phase phase);
    aport = new("aport", this);

    // get dutb_if_proxy
    if (!uvm_config_db #(dutb_if_proxy_base)::get(this, "", "dutb_if_h", dutb_if_h))
        `uvm_fatal("dutb_monitor_base", "Unable to get 'dutb_if_proxy_base' from config db}")
endfunction


task dutb_monitor_base::run_phase(uvm_phase phase);
    @(posedge dutb_if_h.dutb_vif.rstn)
    forever
        begin
            T_DUT_TXN txn;
            txn = T_DUT_TXN::type_id::create("txn");
            // wait until data is valid, read it and send 
            do
                begin
                    @(posedge dutb_if_h.dutb_vif.clk)
                    txn.read(dutb_if_h);
                end
            while (1'b1 != txn.content_valid);
            aport.write(txn);
            `uvm_info("MONITOR: content", {"\n", txn.convert2string()}, UVM_HIGH)
        end
endtask
