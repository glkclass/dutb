/******************************************************************************************************************************
    Project         :   dutb
    Creation Date   :   Dec 2015
    Class           :   dutb_handler
    Description     :   Interface   -   
                        Task        -   handle possible fails:
                                        count fails/success
                                        stop test when given condition (max number of fails, coverage target achieved, ...) detected 
******************************************************************************************************************************/


// ****************************************************************************************************************************
typedef dutb_txn_base;
class dutb_handler extends uvm_component;
    `uvm_component_utils(dutb_handler)

    string                  txn_db_mode;           // working mode of txn_db (WRITE, READ or IDLE)
    dutb_db                 txn_db_h;

    dutb_progress_bar       progress_bar_h;

    int                     n_fails, n_success;

    uvm_barrier             stop_test_h;
    uvm_event               stop_test_evnt_h;
    string                  stop_test_info;

    extern function         new(string name, uvm_component parent=null);
    extern task             run_phase(uvm_phase phase);
    extern function void    report_phase(uvm_phase phase);

    extern function void    fail(dutb_txn_base txn);
    extern function void    success();

    extern task             wait_for_stop_test();
    extern function void    stop_test(string message);

    // extern function string util_sprint(vector vec);
endclass
// ****************************************************************************************************************************


// ****************************************************************************************************************************
function dutb_handler::new(string name, uvm_component parent=null);
    super.new(name, parent);
    
    // maybe it should be defined in sequence or somewhere else..
    progress_bar_h = new ("progress_bar_h");
    
    stop_test_evnt_h = new ("stop_test_evnt_h");
    stop_test_h = new ("stop_test_h", 2);

    // create dut_db, working mode is according to "+DUTB_DB_MODE" arg
    if (!$value$plusargs("TXN_DB_MODE=%s", txn_db_mode))
        begin
            txn_db_mode = "IDLE";
        end
    txn_db_h = new(.name("dutb_db_h"), .db_name("txn_db.txt"), .db_mode(txn_db_mode));
    
    n_fails = 0;
    n_success = 0;
    stop_test_info = "";
endfunction


task dutb_handler::run_phase(uvm_phase phase);
    forever
        begin
            stop_test_evnt_h.wait_trigger();  // wait for the 'stop current test' condition
            stop_test_evnt_h.reset();  // reset 'stop current test' flag
            #P_TCO

            `uvm_info("STOP TEST", $sformatf("Test was stopped due to \'%s\'", stop_test_info), UVM_HIGH)
            stop_test_h.wait_for();  // stop current test
        end
endtask


function void dutb_handler::fail(dutb_txn_base txn);
    n_fails++;

    if ("WRITE" == txn_db_h.mode)  // write failed txn (packed) to 'txn_db'
        begin
            txn_db_h.write (txn.pack2vector());
        end

    if (n_fails > P_MAX_FAIL_NUM)  // terminate current test due to 'max error number' exceed
        begin
            stop_test("Max number of fails detected");
        end
endfunction


function void dutb_handler::success();
    n_success++;
endfunction


function void dutb_handler::report_phase (uvm_phase phase);
    if (n_fails > P_MAX_FAIL_NUM)  // terminate current test due to 'max error number' exceed
        begin
            `uvm_error("STOP_TEST", $sformatf("Max number (%0d) of fails was exceeded. Simulation was terminated!", P_MAX_FAIL_NUM))
        end

    if (n_fails > 0)
        begin
            `uvm_error("FINAL_RESLT", $sformatf("Success: %0d. Fails: %0d!!!", n_success, n_fails))
        end
    else
        begin
            `uvm_info("FINAL_RESLT", $sformatf("Success: %0d, Fails: %0d.", n_success, n_fails), UVM_HIGH)
        end
endfunction


task dutb_handler::wait_for_stop_test();
    stop_test_h.wait_for();
endtask


function void dutb_handler::stop_test(string message);
    stop_test_evnt_h.trigger();  // stop current test
    stop_test_info = message;
endfunction
