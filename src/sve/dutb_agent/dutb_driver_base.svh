// ****************************************************************************************************************************
class dutb_driver_base #(type T_DUT_TXN = dutb_txn_base) extends uvm_driver #(T_DUT_TXN);
    `uvm_component_param_utils (dutb_driver_base #(T_DUT_TXN))

    dutb_if_proxy_base              dutb_if_h;
    dutb_progress_bar               progress_bar_h;

    extern function                 new(string name = "dutb_driver_base", uvm_component parent=null);
    extern function void            build_phase(uvm_phase phase);
    extern task                     run_phase(uvm_phase phase);

endclass
// ****************************************************************************************************************************


// ****************************************************************************************************************************
function dutb_driver_base::new(string name = "dutb_driver_base", uvm_component parent=null);
    super.new(name, parent);
endfunction


function void dutb_driver_base::build_phase(uvm_phase phase);
    progress_bar_h = new("progress_bar_h", this);

    // get dutb_if_proxy
    if (!uvm_config_db #(dutb_if_proxy_base)::get(this, "", "dutb_if_h", dutb_if_h))
        `uvm_fatal(get_type_name(), "Unable to get 'dutb_if_proxy_base' from config db}")
endfunction


task dutb_driver_base::run_phase(uvm_phase phase);
    forever
        begin
            T_DUT_TXN txn;
            seq_item_port.get_next_item(txn);  // check whether we have txn to transmitt
            if (null != txn)
                begin
                    // 'write' procedure is defined in txn class
                    txn.drive(dutb_if_h);
                    seq_item_port.item_done();
                end
        end
endtask
// ****************************************************************************************************************************
