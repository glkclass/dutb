class dut_env #(type    t_din_txn   = dut_txn_base,
                        t_dout_txn  = dut_txn_base,
                        t_pout_txn  = dut_txn_base)
extends uvm_env;
    `uvm_component_param_utils(dut_env #(t_din_txn, t_dout_txn, t_pout_txn))

    dut_env_cfg cfg_h;

    dut_agent #(t_din_txn)          din_agent_h;  // dut in
    dut_agent #(t_dout_txn)         dout_agent_h;  // dut out
    dut_agent #(t_pout_txn)         pout_agent_h;  // probe out

    dut_v_sqncr #(t_din_txn)        v_sqncr_h;  // virtual sequencer

    dut_scb #(  t_din_txn,
                t_dout_txn,
                t_pout_txn)         scb_h;

    uvm_barrier                     synch_seq_br_h;

    extern function new(string name = "dut_env", uvm_component parent = null);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
endclass


function dut_env::new(string name = "dut_env", uvm_component parent = null);
    super.new(name, parent);
    synch_seq_br_h = new ("synch_seq_br_h", 2);
endfunction


function void dut_env::build_phase(uvm_phase phase);
    // create stuff
    v_sqncr_h = dut_v_sqncr #(t_din_txn)::type_id::create("v_sqncr_h", this);
    uvm_config_db #(uvm_barrier)::set(this, "*", "synch_seq_barrier", synch_seq_br_h);

    // create two active and one passive agent
    din_agent_h = dut_agent #(t_din_txn)::type_id::create("din_agent_h", this);
    cfg_h.din_agent_cfg_h = dut_agent_cfg::type_id::create("cfg_h.din_agent_cfg_h", this);
    cfg_h.din_agent_cfg_h.dut_vif = cfg_h.dut_vif;
    din_agent_h.cfg_h = cfg_h.din_agent_cfg_h;
    dut_driver_base #(t_din_txn)::type_id::set_type_override(dut_xds_in_frame_driver #(t_din_txn)::get_type());
    dut_monitor_base #(t_din_txn)::type_id::set_type_override(dut_xds_in_frame_monitor #(t_din_txn)::get_type());

    dout_agent_h = dut_agent #(t_dout_txn)::type_id::create("dout_agent_h", this);
    cfg_h.dout_agent_cfg_h = dut_agent_cfg::type_id::create("cfg_h.dout_agent_cfg_h", this);
    cfg_h.dout_agent_cfg_h.dut_vif = cfg_h.dut_vif;
    dout_agent_h.cfg_h = cfg_h.dout_agent_cfg_h;
    dut_driver_base #(t_dout_txn)::type_id::set_type_override(dut_xds_out_driver #(t_dout_txn)::get_type());

    pout_agent_h = dut_agent #(t_pout_txn)::type_id::create("pout_agent_h", this);
    cfg_h.pout_agent_cfg_h = dut_agent_cfg::type_id::create("cfg_h.pout_agent_cfg_h", this);
    cfg_h.pout_agent_cfg_h.dut_vif = cfg_h.dut_vif;
    cfg_h.pout_agent_cfg_h.is_active = UVM_PASSIVE;
    pout_agent_h.cfg_h = cfg_h.pout_agent_cfg_h;

    // create scb and save synchro barrier to be used by its components
    scb_h = dut_scb #(  t_din_txn, t_dout_txn, t_pout_txn)::type_id::create("scb_h", this);
endfunction


function void dut_env::connect_phase(uvm_phase phase);
    // init virtual sequencer handle
    if (UVM_ACTIVE == din_agent_h.cfg_h.is_active)
        begin
            v_sqncr_h.din_sqncr_h = din_agent_h.sqncr_h;
        end

    // connect ports
    din_agent_h.monitor_aport.connect(scb_h.din_export);
    dout_agent_h.monitor_aport.connect(scb_h.dout_export);
    pout_agent_h.monitor_aport.connect(scb_h.pout_export);
endfunction
