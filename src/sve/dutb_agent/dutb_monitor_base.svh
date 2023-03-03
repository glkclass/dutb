// ****************************************************************************************************************************
class dutb_monitor_base #(type T_DUT_TXN = dutb_txn_base) extends uvm_monitor;
    `uvm_component_param_utils (dutb_monitor_base #(T_DUT_TXN))

    uvm_analysis_port #(T_DUT_TXN)  aport;
    dutb_if_proxy_base              dutb_if_h;

    extern function                 new(string name = "dutb_monitor_base", uvm_component parent=null);
    extern function void            build_phase(uvm_phase phase);
    extern task                     run_phase(uvm_phase phase);
endclass
// ****************************************************************************************************************************


// ****************************************************************************************************************************
function dutb_monitor_base::new(string name = "dutb_monitor_base", uvm_component parent=null);
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
            txn = T_DUT_TXN::type_id::create("txn");
            if ("dutb_txn_base" != txn.get_type_name())
                begin
                    // 'read txn' procedure is defined in txn class
                    txn.monitor(dutb_if_h);
                    `uvm_debug("MNTR", {"Content:", txn.convert2string()})
                    aport.write(txn);
                end
            else
                begin
                    `uvm_debug("MNTR", "Monitoring of 'dutb_txn_base' forbidden!")                    
                    wait(0);
                end
        end
endtask
// ****************************************************************************************************************************
