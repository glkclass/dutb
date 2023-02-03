class dut_env_cfg extends uvm_object;
    `uvm_object_utils(dut_env_cfg)

    virtual dut_if  dut_vif;

    dut_agent_cfg   din_agent_cfg_h;
    dut_agent_cfg   dout_agent_cfg_h;
    dut_agent_cfg   pout_agent_cfg_h;
    dut_scb_cfg     scb_cfg_h;

    extern function new(string name = "dut_env_cfg");
endclass


function dut_env_cfg::new(string name = "dut_env_cfg");
    super.new(name);
endfunction
