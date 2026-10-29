/******************************************************************************************************************************
    Project         :   dutb
    Class           :   dut_scb.
    Description     :   Interface   -   Two 'analysss exports' to accept DUT 'input', 'output' txn.
                        Task        -   Implement: predictor, checker, coverage collector.
******************************************************************************************************************************/


// ****************************************************************************************************************************
class dut_scb extends uvm_scoreboard;
  `uvm_component_utils(dut_scb)

  // dutb_handler                                dutb_handler_h;

  uvm_analysis_export #(dutb_txn_base)        in_port[2];

  // DUT and predictor data fifo
  uvm_tlm_analysis_fifo #(dutb_txn_base)      in_port_fifo[2];


  extern          function                new(string name, uvm_component parent=null);
  extern          function void           build_phase(uvm_phase phase);
  extern          function void           connect_phase(uvm_phase phase);
  extern          task                    run_phase (uvm_phase phase);
  extern virtual  task                    check_txn();
  /* sample/analyze/report coverage */
  extern virtual  function void           do_coverage(dutb_txn_base txn_0, dutb_txn_base txn_1);
endclass
// *************************************************************************************************


// *************************************************************************************************
function dut_scb::new(string name, uvm_component parent=null);
  super.new(name, parent);
endfunction


function void dut_scb::build_phase(uvm_phase phase);
  // ports to recieve DUT input & output txn
  in_port[0]                   = new("in_port[0]", this);
  in_port[1]                   = new("in_port[1]", this);

  in_port_fifo[0]              = new ("in_port_fifo[0]", this);
  in_port_fifo[1]              = new ("in_port_fifo[1]", this);

  // if (!uvm_config_db #(dutb_handler)::get(this, "", "dutb_handler_h", dutb_handler_h))
  //     `uvm_fatal("CFG_DB_ERROR", "Unable to get \"dutb_handler_h\" from config db")
endfunction


function void dut_scb::connect_phase(uvm_phase phase);
  // connect input ports to appropriate fifo buffers
  in_port[0].connect(in_port_fifo[0].analysis_export);
  in_port[1].connect(in_port_fifo[1].analysis_export);
endfunction


task dut_scb::run_phase(uvm_phase phase);
  forever begin
    check_txn();
    // synch_seq();// finish processing of all content of the previous sequence before let the next one to proceed...
    // progress_bar_h.display($sformatf("Success/Fails = %0d/%0d", dutb_handler_h.n_success, dutb_handler_h.n_fails));
  end
endtask


// Maybe overridden in a child class to perform better check
task dut_scb::check_txn();
  dutb_txn_base   txn_in, txn_out, txn_gold;

  in_port_fifo[0].get(txn_in);
  in_port_fifo[1].get(txn_out);
  `ASSERT_TYPE_CAST(txn_gold, txn_in.gold());
  `uvm_info_f("SCB", $sformatf("Check: <%s> / <%s>", txn_in.get_type_name(), txn_out.get_type_name()))

  if (txn_out.compare(txn_gold)) begin
    // do_coverage()
  end else begin
    // dutb_handler_h.fail(din_txn_h);
  end
endtask


// Use txn methods to handle coverage.
// Maybe overridden in case of need.
function void dut_scb::do_coverage(dutb_txn_base txn_0, dutb_txn_base txn_1);
  // input txn coverage
  txn_0.sample_coverage();
  txn_1.analyze_coverage_results();
  // output txn coverage
  // txn[1].sample_coverage();
  // txn[1].analyze_coverage_results();
endfunction

// ****************************************************************************************************************************
