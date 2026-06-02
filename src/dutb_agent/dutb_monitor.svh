/******************************************************************************************************************************
    Project         :   dutb
    Class           :   dutb_monitor
    Description     :
******************************************************************************************************************************/


// ****************************************************************************************************************************
class dutb_monitor extends uvm_monitor;
    `uvm_component_utils (dutb_monitor)

    dutb_if_proxy_base                  dutb_if_h;
    uvm_analysis_port #(dutb_txn_base)  aport;

    extern function                 new(string name, uvm_component parent=null);
    extern function void            build_phase(uvm_phase phase);
    extern task                     run_phase(uvm_phase phase);
endclass
// ****************************************************************************************************************************


// ****************************************************************************************************************************
function dutb_monitor::new(string name, uvm_component parent=null);
    super.new(name, parent);
endfunction


function void dutb_monitor::build_phase(uvm_phase phase);
    aport = new("aport", this);
    // get dutb_if_proxy
    if (!uvm_config_db #(dutb_if_proxy_base)::get(this, "", "dutb_if_h", dutb_if_h))
        `uvm_fatal("dutb_monitor", "Unable to get 'dutb_if_proxy_base' from config db}")

endfunction


task dutb_monitor::run_phase(uvm_phase phase);
    dutb_txn_base txn = dutb_txn_base::type_id::create("txn", this);
    txn.set_verbosity_level(get_report_verbosity_level());
    // `uvm_debug ($sformatf ("%s", txn.get_type_name()))
    forever
        begin
            if ("dutb_txn_base" != txn.get_type_name())
                begin
                    // `uvm_debug ($sformatf ("%s", txn.get_type_name()))
                    // 'monitor txn' procedure should be defined in txn class
                    txn.monitor(dutb_if_h);
                    // `uvm_debug({"Content monitored:\n", txn.convert2string()})
                    aport.write(txn);
                end
            else
                begin
                    `uvm_info("MNTR", "Monitoring of 'abstract' 'dutb_txn_base' doesn't make any sense!", UVM_HIGH)
                    wait(0);
                end
        end
endtask
// ****************************************************************************************************************************
