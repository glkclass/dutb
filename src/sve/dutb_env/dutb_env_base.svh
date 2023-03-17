/******************************************************************************************************************************
    Project         :   dutb
    Creation Date   :   Dec 2015
    Class           :   dutb_env_base
    Description     :   Interface   -   
                        Task        -   
******************************************************************************************************************************/


// ****************************************************************************************************************************
class dutb_env_base #(type  T_DIN_TXN   = dutb_txn_base,
                            T_DOUT_TXN  = dutb_txn_base)
extends uvm_env;
    `uvm_component_param_utils(dutb_env_base #(T_DIN_TXN, T_DOUT_TXN))

    dutb_env_base_cfg cfg_h;

    dutb_agent_base #(T_DIN_TXN)                                din_agent_h;    // DUT in
    dutb_agent_base #(T_DOUT_TXN)                               dout_agent_h;   // DUT out

    dutb_v_sqncr #(T_DIN_TXN, T_DOUT_TXN)                       v_sqncr_h;      // virtual sequencer

    dut_scb_base #(T_DIN_TXN, T_DOUT_TXN)                       scb_h;

    uvm_barrier                                                 synch_seq_br_h;

    extern function                                             new(string name = "dutb_env_base", uvm_component parent = null);
    extern function void                                        build_phase(uvm_phase phase);
    extern function void                                        connect_phase(uvm_phase phase);
endclass
// ****************************************************************************************************************************


// ****************************************************************************************************************************
function dutb_env_base::new(string name = "dutb_env_base", uvm_component parent = null);
    super.new(name, parent);
    synch_seq_br_h = new ("synch_seq_br_h", 2);
endfunction


function void dutb_env_base::build_phase(uvm_phase phase);
    // create stuff
    v_sqncr_h = dutb_v_sqncr #(T_DIN_TXN, T_DOUT_TXN)::type_id::create("v_sqncr_h", this);
    uvm_config_db #(uvm_barrier)::set(this, "*", "synch_seq_barrier", synch_seq_br_h);

    if (!uvm_config_db #(dutb_env_base_cfg)::get(this, "", "cfg_h", cfg_h))
        `uvm_fatal("CFG_DB_ERROR", "Unable to get \"cfg_h\" from config db")

    // create two active and one passive agents

    din_agent_h                         = dutb_agent_base #(T_DIN_TXN)::type_id::create("din_agent_h", this);
    cfg_h.din_agent_cfg_h               = dutb_agent_base_cfg::type_id::create("cfg_h.din_agent_cfg_h", this);
    cfg_h.din_agent_cfg_h.dutb_if_h     = cfg_h.dutb_if_h;
    // enable/disable driver & monitor
    void'(uvm_config_db #(bit)::get(this, "", "din_agent_has_driver", cfg_h.din_agent_cfg_h.has_driver));
    void'(uvm_config_db #(bit)::get(this, "", "din_agent_has_monitor", cfg_h.din_agent_cfg_h.has_monitor));
    // pass config to agent 
    uvm_config_db #(dutb_agent_base_cfg)::set(this, "din_agent_h", "cfg_h", cfg_h.din_agent_cfg_h);

    dout_agent_h                        = dutb_agent_base #(T_DOUT_TXN)::type_id::create("dout_agent_h", this);
    cfg_h.dout_agent_cfg_h              = dutb_agent_base_cfg::type_id::create("cfg_h.dout_agent_cfg_h", this);
    cfg_h.dout_agent_cfg_h.dutb_if_h    = cfg_h.dutb_if_h;
    // enable/disable driver & monitor
    void'(uvm_config_db #(bit)::get(this, "", "dout_agent_has_driver", cfg_h.dout_agent_cfg_h.has_driver));
    void'(uvm_config_db #(bit)::get(this, "", "dout_agent_has_monitor", cfg_h.dout_agent_cfg_h.has_monitor));
    // pass config to agent 
    uvm_config_db #(dutb_agent_base_cfg)::set(this, "dout_agent_h", "cfg_h", cfg_h.dout_agent_cfg_h);

    // create scoreboard and save synchro barrier to be used by its components
    scb_h                               = dut_scb_base #(  T_DIN_TXN, T_DOUT_TXN)::type_id::create("scb_h", this);
endfunction


function void dutb_env_base::connect_phase(uvm_phase phase);
    // init virtual sequencer handle
    if (din_agent_h.cfg_h.has_driver)
        begin
            v_sqncr_h.din_sqncr_h = din_agent_h.sqncr_h;
        end

    if (dout_agent_h.cfg_h.has_driver)
        begin
            v_sqncr_h.dout_sqncr_h = dout_agent_h.sqncr_h;
        end

    // connect ports
    if (din_agent_h.cfg_h.has_monitor)
        begin
            din_agent_h.monitor_aport.connect(scb_h.din_export);
        end

    if (dout_agent_h.cfg_h.has_monitor)
        begin
            dout_agent_h.monitor_aport.connect(scb_h.dout_export);
        end
endfunction
// ****************************************************************************************************************************
