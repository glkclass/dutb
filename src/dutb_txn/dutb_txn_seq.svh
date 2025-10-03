/******************************************************************************************************************************
    Project         :   DUTB
    Creation Date   :   Jun 2025
    Class           :   dutb_txn_seq
    Description     :
******************************************************************************************************************************/


// ****************************************************************************************************************************
class dutb_txn_seq  #(parameter type T_DUT_TXN = dutb_txn_base) extends uvm_sequence #(T_DUT_TXN);
    `uvm_object_param_utils(dutb_txn_seq)

    // uvm_barrier         synch_seq_br_h;
    // dutb_db             txn_db_h;

    extern function     new(string name="dutb_txn_seq");
    extern task         body();
endclass
// ****************************************************************************************************************************


// ****************************************************************************************************************************
function dutb_txn_seq::new(string name="dutb_txn_seq");
    super.new(name);
endfunction


task dutb_txn_seq::body();
    T_DUT_TXN txn;

    // extract barrier for sequence synchronization
    // if (!uvm_config_db #(uvm_barrier)::get(get_sequencer(), "", "synch_seq_barrier", synch_seq_br_h))
    //     `uvm_fatal("CFG_DB_ERROR", "Unable to get 'synch_seq_barrier' from config db")

    // if (!uvm_config_db #(dutb_db)::get(get_sequencer(), "", "txn_db_h", txn_db_h))
    //     `uvm_fatal("CFG_DB_ERROR", "Unable to get 'txn_db_h' from config db")

    txn = new("txn");
    `uvm_debug($sformatf("Run sequence of <%s>", txn.get_type_name()));

    forever
        begin
            txn = new("txn");
            start_item(txn);
            assert (txn.randomize());
            // txn.load_txn_db(txn_db_h);
            // `uvm_debug("Txn sent")
            finish_item (txn);
            // synch_seq_br_h.wait_for();
        end

endtask
// ****************************************************************************************************************************
