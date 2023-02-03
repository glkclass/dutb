class dut_agent_cfg extends uvm_object;
    `uvm_object_utils(dut_agent_cfg)

    uvm_active_passive_enum is_active;
    bit has_monitor;

    virtual dut_if dut_vif;

    extern function new(string name = "dut_agent_cfg");
endclass

function dut_agent_cfg::new(string name = "dut_agent_cfg");
    super.new(name);
    is_active = UVM_ACTIVE;
    has_monitor = 1'b1;
endfunction



