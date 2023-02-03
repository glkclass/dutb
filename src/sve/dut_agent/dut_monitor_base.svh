class dut_monitor_base #(type t_dut_txn = dut_txn_base) extends uvm_monitor;
    `uvm_component_param_utils (dut_monitor_base #(t_dut_txn))

    uvm_analysis_port #(t_dut_txn)  aport;
    virtual dut_if                  dut_vif;

    extern function new(string name = "dut_monitor_base", uvm_component parent=null);
    extern function void build_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);
endclass


function dut_monitor_base::new(string name = "dut_monitor_base", uvm_component parent=null);
    super.new(name, parent);
endfunction


function void dut_monitor_base::build_phase(uvm_phase phase);
    aport = new("aport", this);

    // connect to dut interface
    if (!uvm_config_db #(virtual dut_if)::get(this, "", "dut_vif", dut_vif))
        `uvm_fatal("dut_monitor_base", "Unable to get 'dut_vif' from config db}")
endfunction


task dut_monitor_base::run_phase(uvm_phase phase);
    @(posedge dut_vif.rstn)
    forever
        begin
            t_dut_txn txn;
            txn = t_dut_txn::type_id::create("txn");
            do
                begin
                    @(posedge dut_vif.clk)
                    txn.read(dut_vif);
                end
            while (1'b1 != txn.content_valid);
            aport.write(txn);
            //`uvm_info("MONITOR: content", {"\n", txn.convert2string()}, UVM_HIGH)
        end
endtask
