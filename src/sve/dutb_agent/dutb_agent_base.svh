/******************************************************************************************************************************
    Project         :   dutb
    Creation Date   :   Dec 2015
    Class           :   dutb_agent_base
    Description     :   Interface   -   
                        Task        -   
******************************************************************************************************************************/


// ****************************************************************************************************************************
class dutb_agent_base #(type T_DUT_TXN = dutb_txn_base) extends uvm_agent;
    `uvm_component_param_utils(dutb_agent_base #(T_DUT_TXN))

    uvm_analysis_port #(T_DUT_TXN)      monitor_aport;

    dutb_agent_base_cfg                 cfg_h;
    dutb_driver_base #(T_DUT_TXN)       driver_h;
    dutb_monitor_base #(T_DUT_TXN)      monitor_h;
    uvm_sequencer #(T_DUT_TXN)          sqncr_h;

    extern function                     new(string name = "dutb_agent_base", uvm_component parent = null);
    extern function void                build_phase(uvm_phase phase);
    extern function void                connect_phase(uvm_phase phase);
endclass
// ****************************************************************************************************************************


// ****************************************************************************************************************************
function dutb_agent_base::new(string name = "dutb_agent_base", uvm_component parent = null);
    super.new(name, parent);
endfunction

function void dutb_agent_base::build_phase(uvm_phase phase);
    if (!uvm_config_db #(dutb_agent_base_cfg)::get(this, "", "cfg_h", cfg_h))
        `uvm_fatal("CFG_DB_ERROR", "Unable to get \"cfg_h\" from config db")

    uvm_config_db #(dutb_if_proxy_base)::set(this, "*", "dutb_if_h", cfg_h.dutb_if_h);

    if (cfg_h.has_driver)
        begin
            driver_h = dutb_driver_base #(T_DUT_TXN)::type_id::create("driver_h", this);
            sqncr_h = uvm_sequencer #(T_DUT_TXN)::type_id::create("sqncr_h", this);
        end

    if (cfg_h.has_monitor)
        begin
            monitor_aport = new ("monitor_aport", this);
            monitor_h = dutb_monitor_base #(T_DUT_TXN)::type_id::create("monitor_h", this);
        end
endfunction

function void dutb_agent_base::connect_phase(uvm_phase phase);
    if (cfg_h.has_monitor)
        begin
            monitor_h.aport.connect(monitor_aport);
        end

    if (cfg_h.has_driver)
        begin
            driver_h.seq_item_port.connect(sqncr_h.seq_item_export);
        end
endfunction
// ****************************************************************************************************************************
