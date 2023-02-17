// - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
class dutb_env_base_cfg extends uvm_object;
    `uvm_object_utils(dutb_env_base_cfg)

    dutb_if_proxy_base      dutb_if_h;

    dutb_agent_base_cfg     din_agent_cfg_h;
    dutb_agent_base_cfg     dout_agent_cfg_h;
    dutb_agent_base_cfg     pout_agent_cfg_h;
    dutb_scb_base_cfg       scb_cfg_h;

    extern function new(string name = "dut_env_cfg");
endclass
// - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


// - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
function dutb_env_base_cfg::new(string name = "dut_env_cfg");
    super.new(name);
endfunction
// - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
