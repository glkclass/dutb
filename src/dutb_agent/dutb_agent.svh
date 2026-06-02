/******************************************************************************************************************************
    Project         :   dutb
    Class           :   dutb_agent
    Description     :
******************************************************************************************************************************/


// ****************************************************************************************************************************
class dutb_agent extends uvm_agent;
    `uvm_component_utils(dutb_agent)

    bit                                     has_driver, has_monitor;
    // uvm_analysis_port #(dutb_txn_base)      monitor_aport;
    dutb_driver                             driver_h;
    dutb_monitor                            monitor_h;
    // uvm_sequencer #(dutb_txn_base)          sqncr_h;

    extern function                         new(string name, uvm_component parent = null);
    extern function void                    build_phase(uvm_phase phase);
    // extern function void                    connect_phase(uvm_phase phase);
    extern task                             run_phase(uvm_phase phase);

endclass
// ****************************************************************************************************************************


// ****************************************************************************************************************************
function dutb_agent::new(string name, uvm_component parent = null);
    super.new(name, parent);
    has_driver = 1'b1;
    has_monitor = 1'b1;
endfunction

function void dutb_agent::build_phase(uvm_phase phase);
    if (has_driver)
        begin
            driver_h = dutb_driver::type_id::create("driver_h", this);
            // sqncr_h = uvm_sequencer::type_id::create("sqncr_h", this);
        end

    if (has_monitor)
        begin
            // monitor_aport = new ("monitor_aport", this);
            monitor_h = dutb_monitor::type_id::create("monitor_h", this);
        end

endfunction

// function void dutb_agent::connect_phase(uvm_phase phase);
//     if (has_monitor)
//         begin
//             monitor_h.aport.connect(monitor_aport);
//         end

//     if (has_driver)
//         begin
//             driver_h.seq_item_port.connect(sqncr_h.seq_item_export);
//         end
// endfunction


task dutb_agent::run_phase(uvm_phase phase);
    // dutb_txn_base txn = dutb_txn_base::type_id::create("txn", this);
    // `uvm_debug ($sformatf ("%s", txn.get_type_name()))
endtask
// ****************************************************************************************************************************
