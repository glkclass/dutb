class dut_agent #(type t_dut_txn = dut_txn_base) extends uvm_agent;
    `uvm_component_param_utils(dut_agent #(t_dut_txn))

    uvm_analysis_port #(t_dut_txn) monitor_aport;

    dut_agent_cfg cfg_h;
    dut_driver_base #(t_dut_txn) driver_h;
    dut_monitor_base #(t_dut_txn) monitor_h;
    uvm_sequencer #(t_dut_txn) sqncr_h;

    extern function new(string name = "dut_agent", uvm_component parent = null);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
endclass

function dut_agent::new(string name = "dut_agent", uvm_component parent = null);
    super.new(name, parent);
endfunction

function void dut_agent::build_phase(uvm_phase phase);
    uvm_config_db #(virtual dut_if)::set(this, "*", "dut_vif", cfg_h.dut_vif);

    monitor_aport = new ("monitor_aport", this);

    monitor_h = dut_monitor_base #(t_dut_txn)::type_id::create("monitor_h", this);

    if (UVM_ACTIVE == cfg_h.is_active)
        begin
            driver_h = dut_driver_base #(t_dut_txn)::type_id::create("driver_h", this);
            sqncr_h = uvm_sequencer #(t_dut_txn)::type_id::create("sqncr_h", this);
        end
endfunction

function void dut_agent::connect_phase(uvm_phase phase);
    if (UVM_ACTIVE == cfg_h.is_active)
        begin
            driver_h.seq_item_port.connect(sqncr_h.seq_item_export);
        end

        monitor_h.aport.connect(monitor_aport);
endfunction
