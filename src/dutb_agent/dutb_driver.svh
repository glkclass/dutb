/******************************************************************************************************************************
    Project         :   dutb
    Creation Date   :   Dec 2015
    Class           :   dutb_driver
    Description     :
******************************************************************************************************************************/


// ****************************************************************************************************************************
class dutb_driver extends uvm_driver #(dutb_txn_base);
    `uvm_component_utils (dutb_driver)

    dutb_if_proxy_base                      dutb_if_h;
    uvm_sequencer #(dutb_txn_base)          sqncr_h;

    extern function                 new(string name, uvm_component parent=null);
    extern function void            build_phase(uvm_phase phase);
    extern function void            connect_phase(uvm_phase phase);
    extern task                     run_phase(uvm_phase phase);

endclass
// ****************************************************************************************************************************


// ****************************************************************************************************************************
function dutb_driver::new(string name, uvm_component parent=null);
    super.new(name, parent);
endfunction


function void dutb_driver::build_phase(uvm_phase phase);
    // get dutb_if_proxy
    if (!uvm_config_db #(dutb_if_proxy_base)::get(this, "", "dutb_if_h", dutb_if_h))
        `uvm_fatal(get_type_name(), "Unable to get 'dutb_if_proxy_base' from config db}")

    sqncr_h = new("sqncr_h", this);
endfunction


function void dutb_driver::connect_phase(uvm_phase phase);
    seq_item_port.connect(sqncr_h.seq_item_export);
endfunction


task dutb_driver::run_phase(uvm_phase phase);

    forever
        begin
            // dutb_txn_base txn = dutb_txn_base::type_id::create("txn", this);
            dutb_txn_base txn;
            // `uvm_debug ($sformatf ("%s", txn.get_type_name()))
            seq_item_port.get_next_item(txn);  // check whether we have txn to transmitt
            if (null != txn)
                begin
                    // `uvm_debug ($sformatf ("%s", txn.get_type_name()))
                    // real 'drive' procedure should be defined in txn class
                    txn.drive(dutb_if_h);
                    // `uvm_debug({"Content driven:\n", txn.convert2string()})
                    seq_item_port.item_done();
                end
        end
endtask
// ****************************************************************************************************************************
