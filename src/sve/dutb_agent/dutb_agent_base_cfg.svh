class dutb_agent_base_cfg extends uvm_object;
    `uvm_object_utils(dutb_agent_base_cfg)

    uvm_active_passive_enum     is_active;
    bit                         has_monitor;

    dutb_if_proxy_base          dutb_if_h;

    extern function         new(string name = "dutb_agent_base_cfg");
endclass

function dutb_agent_base_cfg::new(string name = "dutb_agent_base_cfg");
    super.new(name);
    is_active = UVM_ACTIVE;
    has_monitor = 1'b1;
endfunction



