class dut_pout_monitor #(type t_dut_txn = dut_txn_base) extends dut_monitor_base #(t_dut_txn);

    `uvm_component_param_utils (dut_pout_monitor #(t_dut_txn))

    extern function new(string name = "dut_pout_monitor", uvm_component parent=null);
    extern function void build_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);

endclass


function dut_pout_monitor::new(string name = "dut_pout_monitor", uvm_component parent=null);
    super.new(name, parent);
endfunction


function void dut_pout_monitor::build_phase(uvm_phase phase);
    super.build_phase(phase);
endfunction


task dut_pout_monitor::run_phase(uvm_phase phase);
    t_dut_txn txn_ppln;
    @(posedge dut_vif.rstn)
    txn_ppln = t_dut_txn::type_id::create("txn_ppln");
    forever
        begin
            t_dut_txn txn;
            do
                begin
                    @(posedge dut_vif.clk)
                    txn_ppln.read(dut_vif);
                end
            while (1'b1 != txn_ppln.content_valid);
            txn = txn_ppln.pop_front();
            aport.write(txn);
            `uvm_info("dut_pout_monitor: content", {"\n", txn.convert2string()}, UVM_HIGH)
        end
endtask
