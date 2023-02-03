// - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
class dut_xds_in_frame_monitor #(type t_dut_txn = dut_txn_base) extends dut_monitor_base #(t_dut_txn);
    `uvm_component_param_utils (dut_xds_in_frame_monitor #(t_dut_txn))

    extern function new(string name = "dut_xds_in_frame_monitor", uvm_component parent=null);
    extern function void build_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);
endclass
// - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


// - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
function dut_xds_in_frame_monitor::new(string name = "dut_xds_in_frame_monitor", uvm_component parent=null);
    super.new(name, parent);
endfunction


function void dut_xds_in_frame_monitor::build_phase(uvm_phase phase);
    super.build_phase(phase);
endfunction


task dut_xds_in_frame_monitor::run_phase(uvm_phase phase);
    @(posedge dut_vif.rstn)
    forever
        begin
            t_dut_txn txn;
            txn = t_dut_txn::type_id::create("txn");

            do
                begin
                    @(posedge dut_vif.clk)
                    ;
                end
            while (1'b1 != dut_vif.frame_start);

            do
                begin
                    @(posedge dut_vif.clk)
                    txn.read(dut_vif);
                    txn.push();
                end
            while (1'b1 != dut_vif.frame_finish);
            txn.width = dut_vif.width;
            txn.height = dut_vif.height;
            aport.write(txn);
            `uvm_info("MONITOR", {"content\n", txn.convert2string()}, UVM_FULL)
        end
endtask
// - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
