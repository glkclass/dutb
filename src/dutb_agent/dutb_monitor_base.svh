/******************************************************************************************************************************
    Project         :   dutb
    Creation Date   :   Dec 2015
    Class           :   dutb_monitor_base
    Description     :   Interface   -   
                        Task        -   
******************************************************************************************************************************/


// ****************************************************************************************************************************
class dutb_monitor_base #(type T_DUT_TXN = dutb_txn_base) extends uvm_monitor;
    `uvm_component_param_utils (dutb_monitor_base #(T_DUT_TXN))

    uvm_analysis_port #(T_DUT_TXN)  aport;
    dutb_if_proxy_base              dutb_if_h;

    extern function                 new(string name, uvm_component parent=null);
    extern function void            build_phase(uvm_phase phase);
    extern task                     run_phase(uvm_phase phase);
endclass
// ****************************************************************************************************************************


// ****************************************************************************************************************************
function dutb_monitor_base::new(string name, uvm_component parent=null);
    super.new(name, parent);
endfunction


function void dutb_monitor_base::build_phase(uvm_phase phase);
    aport = new("aport", this);

    // get dutb_if_proxy
    if (!uvm_config_db #(dutb_if_proxy_base)::get(this, "", "dutb_if_h", dutb_if_h))
        `uvm_fatal("dutb_monitor_base", "Unable to get 'dutb_if_proxy_base' from config db}")
endfunction


task dutb_monitor_base::run_phase(uvm_phase phase);
    // `uvm_debug ("TXNTPE", T_DUT_TXN::type_id::get_type_name())
    forever
        begin
            T_DUT_TXN txn;
            txn = new();
            if ("dutb_txn_base" != txn.get_type_name())
                begin
                    // 'monitor txn' procedure should be defined in txn class
                    txn.monitor(dutb_if_h);
                    // `uvm_debug({"Content monitored:\n", txn.convert2string()})
                    aport.write(txn);
                end
            else
                begin
                    `uvm_info("MNTR", "Monitoring of 'abstarct' 'dutb_txn_base' doesn't make any sense!", UVM_HIGH)                    
                    wait(0);
                end
        end
endtask
// ****************************************************************************************************************************
