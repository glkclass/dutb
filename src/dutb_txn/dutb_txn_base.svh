/***************************************************************************************************
    Project         :   dutb
    Class           :   dutb_txn_base
    Description     :
***************************************************************************************************/


// *************************************************************************************************
class dutb_txn_base extends uvm_sequence_item;
  `uvm_object_utils (dutb_txn_base)

  // static dutb_covergroup_base  covergroup_wrapper;

  uvm_component parent;
  bit_vector_t  txn_diff;
  dutb_txn_base txn_rival;

  extern          function        new (string name = "dutb_txn_base", uvm_component parent = null);
  extern virtual  function void   init_vif (input dutb_if_proxy_base dutb_if_proxy_h);;
  extern          function void   set_parent (uvm_component parent=null);
  extern virtual  function string txn_diff_convert2string();
  extern virtual  function void process_compare_fail();
  extern virtual  function void do_copy (uvm_object rhs);
  extern virtual  function bit do_compare (uvm_object rhs, uvm_comparer comparer);
  extern virtual  function void do_print (uvm_printer printer);
  extern virtual  function string convert2string();
  extern virtual  function vector_t pack2vector();
  extern virtual  function void   unpack4vector (vector_t txn_packed);
  extern virtual  function void   sample_coverage();
  extern virtual  function void   analyze_coverage_results();
  extern virtual  function dutb_txn_base  gold();
  extern virtual  task                    drive (input dutb_if_proxy_base dutb_if_proxy_h);
  extern virtual  task                    drive_x (input dutb_if_proxy_base dutb_if_proxy_h);
  extern virtual  task                    monitor (input dutb_if_proxy_base dutb_if_proxy_h);
  extern virtual  function int            size();
  extern          function void           load_txn_db (dutb_db txn_db);
  // extern virtual  function void           push();
  // extern virtual  function void           pop();
endclass    
// *************************************************************************************************


// *************************************************************************************************
function dutb_txn_base::new (string name = "dutb_txn_base", uvm_component parent = null);
  super.new(name);
  set_parent(parent);
endfunction

/*  Initialize txn virtual if handlers  */
function void dutb_txn_base::init_vif(input dutb_if_proxy_base dutb_if_proxy_h);;
  if ("dutb_txn_base" != get_type_name())
    `uvm_warning("VFNOTOVRDN", "Override method")
  return;
endfunction


function dutb_txn_base::set_parent(uvm_component parent = null);
  this.parent = parent;
endfunction


/* base methods */
function string dutb_txn_base::txn_diff_convert2string();
    string txn_diff_str = "";
    foreach (this.txn_diff[i]) begin
        txn_diff_str = $sformatf(
          "%s%s%s", txn_diff_str, (this.txn_diff[i]) ? "__________ " : "XXXXXXXXXX ", eol(i));
    end
    return txn_diff_str;
endfunction


function void dutb_txn_base::do_copy (uvm_object rhs);
  dutb_txn_base _txn;
  // add check for real txns type consistency
  if(!$cast(_txn, rhs)) begin
    `uvm_error("TXN_DO_COPY", "Txn cast was failed")
    return;
  end
  super.do_copy(_txn); // chain the copy with parent classes
  unpack4vector (_txn.pack2vector());
endfunction

/*  Override if need to analyze txn fails    */
function void dutb_txn_base::process_compare_fail();
  /*  Print content of two txn being compared and their diff map  */
  `uvm_txn_info_f("TXN_CMP", $sformatf("Get \n%s\n", this.convert2string()))
  `uvm_txn_info_f("TXN_CMP", $sformatf("Gold \n%s\n", txn_rival.convert2string()))
  `uvm_txn_info_f("TXN_CMP", $sformatf("Diff \n%s\n", this.txn_diff_convert2string()))
endfunction


function bit dutb_txn_base::do_compare(uvm_object rhs, uvm_comparer comparer);
  dutb_txn_base _txn;
  vector_t txn_packed_0, txn_packed_1;
  bit eq, ans;

  `ASSERT_TYPE_CAST(txn_rival, rhs)
  `uvm_txn_info_d("TXN_CMP", "Compare using base method")

  // Check txn size
  if (size() != txn_rival.size()) begin
    `uvm_error ( "TXN_CMP", $sformatf ("Compare size failed: <%s %0d> vs <%s %0d>",
      this.get_type_name(), this.size(), txn_rival.get_type_name(), txn_rival.size() ) )
    return 1'b0;
  end

  // this.print();
  // _txn.print();

  // Check txn content
  txn_packed_0 = this.pack2vector();
  txn_packed_1 = txn_rival.pack2vector();
  this.txn_diff = new[size()];

  ans = super.do_compare (txn_rival, comparer);
  foreach (txn_packed_0[i]) begin
    eq = (txn_packed_0[i] == txn_packed_1[i]);
    this.txn_diff[i] = eq;
    ans = ans & eq;
  end

  if (1'b0 == ans) begin
    `uvm_error("TXN_CMP", $sformatf("Compare content <%s>: Fail", this.get_type_name()))
    process_compare_fail();
  end else begin
    `uvm_txn_info_f("TXN_CMP", $sformatf("Compare content <%s>: OK", this.get_type_name()))
  end

  return ans;
endfunction


function void dutb_txn_base::do_print (uvm_printer printer);
  string foo;
  super.do_print (printer);
  foo = "\n-------------------\n";
  printer.m_string = $sformatf("\n%s %s%s%s\n\n", get_type_name(),  get_name(), foo, convert2string());
endfunction


function string dutb_txn_base::convert2string ();
  return ( vector2str(pack2vector()) );
endfunction


function int dutb_txn_base::size ();
  vector_t txn_packed;
  int txn_size;
  txn_packed = pack2vector();
  txn_size = txn_packed.size();
  return txn_size;
endfunction


//  next methods should be overrided
function vector_t dutb_txn_base::pack2vector ();
  if ("dutb_txn_base" != get_type_name())
    `uvm_warning("VFNOTOVRDN", "Override method")
  else
    `uvm_txn_info_d("VFNOTOVRDN", "'dutb_txn_base' method used")
  return ({});
endfunction


function void dutb_txn_base::unpack4vector (vector_t txn_packed);
  if ("dutb_txn_base" != get_type_name())
    `uvm_fatal("VFNOTOVRDN", "Override method")
  else
    `uvm_txn_info_d("VFNOTOVRDN", "'dutb_txn_base' method used")
endfunction


function void dutb_txn_base::sample_coverage();
  // covergroup_wrapper.sample (this);
endfunction


function void dutb_txn_base::analyze_coverage_results();
  // covergroup_wrapper.analyze_coverage_results ();
endfunction


function dutb_txn_base dutb_txn_base::gold ();
  if ("dutb_txn_base" != get_type_name())
    `uvm_fatal("VFNOTOVRDN", "Override method")
  else
    `uvm_txn_info_d("VFNOTOVRDN", "'dutb_txn_base' method used")
endfunction


task dutb_txn_base::drive (input dutb_if_proxy_base dutb_if_proxy_h);
  if ("dutb_txn_base" != get_type_name())
    `uvm_fatal("VFNOTOVRDN", "Override method")
  else
    `uvm_txn_info_d("VFNOTOVRDN", "'dutb_txn_base' method used")
endtask


task dutb_txn_base::drive_x (input dutb_if_proxy_base dutb_if_proxy_h);
  if ("dutb_txn_base" != get_type_name())
    `uvm_fatal("VFNOTOVRDN", "Override method")
  else
    `uvm_txn_info_d("VFNOTOVRDN", "'dutb_txn_base' method used")
endtask


task dutb_txn_base::monitor (input dutb_if_proxy_base dutb_if_proxy_h);
  if ("dutb_txn_base" != get_type_name())
    `uvm_fatal("VFNOTOVRDN", "Override method")
  else
    `uvm_txn_info_d("VFNOTOVRDN", "'dutb_txn_base' method used")
endtask


function void dutb_txn_base::load_txn_db (dutb_db txn_db);
  vector_t foo;
  if ("READ" == txn_db.mode) begin
    foo = pack2vector();
    void'(txn_db.read(foo));
    unpack4vector(foo);
  end else begin
    `uvm_error("FILEIO", {"Wrong txn_db mode: '", txn_db.mode, "' instead of 'READ'!!"})
  end
endfunction


// ****************************************************************************************************************************
