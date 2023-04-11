/******************************************************************************************************************************
    Project         :   dutb
    Creation Date   :   Dec 2015
    Class           :   dutb_txn_base
    Description     :   Interface   -   
                        Task        -   
******************************************************************************************************************************/


// ****************************************************************************************************************************
class dutb_txn_base extends uvm_sequence_item;
    `uvm_object_utils (dutb_txn_base)

    bit content_valid; // validates transaction content
    string str;
    int i;
    bit ans, empty;

    string check_str;
    int check_idx;

    extern          function                new                         (string name = "dutb_txn_base");
    // extern static   function string         get_class_name              ();
    extern virtual  function void           display_check               (bit reset, bit eq);
    extern virtual  function void           do_copy                     (uvm_object rhs);                           // make a deep copy
    extern virtual  function bit            do_compare                  (uvm_object rhs, uvm_comparer comparer);
    extern virtual  function void           do_print                    (uvm_printer printer);                      // print transaction content
    extern virtual  function string         convert2string              ();                                         // represent 'txn content' as string
    extern virtual  function string         convert2string_pair         (dutb_txn_base txn);                        // represent content of pair of txn as string
    extern virtual  function vector         pack2vector                 ();                                         // pack 'txn content' to 'vector of int'
    extern virtual  function void           unpack4vector               (vector packed_txn);                        // unpack 'txn content' from 'vector of int'
    extern virtual  function void           sample_coverage             ();                                         // sample covergroups
    extern virtual  function void           analyze_coverage_results    ();                                         // store coverage data (to hashmap), report results
    extern virtual  function dutb_txn_base  gold                        ();                                         // generate and return 'gold' output txn
    extern virtual  task                    drive                       (input dutb_if_proxy_base dutb_if);         // drive 'txn content' to interface lines
    extern virtual  task                    drive_x                     (input dutb_if_proxy_base dutb_if);         // drive 'x' values to interface lines
    extern virtual  task                    monitor                     (input dutb_if_proxy_base dutb_if);         // monitor 'txn content' from interface lines
    extern virtual  function void           push                        ();                                         // store 'txn content' to the buffer
    extern virtual  function void           pop                         ();                                         // extract 'txn content' from buffer (if 'fifo txn structure' used)
    extern virtual  function int            size                        ();                                         // size of txn (in int-parrot). Actually size of txn packed to vector of int.
endclass    
// ****************************************************************************************************************************


// ****************************************************************************************************************************
function dutb_txn_base::new (string name = "dutb_txn_base");
    super.new(name);
    empty = 1'b0;
    check_str = ""; 
    check_idx = 0;
endfunction

// function string dutb_txn_base::get_class_name();
//     return "dutb_txn_base";
// endfunction

// base methods

function void dutb_txn_base::display_check(bit reset, bit eq);
    check_str = (reset) ? "" : check_str;
    check_idx = (reset) ? 0 : check_idx;
    check_str = {check_str, (eq) ? "__________ " : "XXXXXXXXXX ", eol(check_idx)};
    check_idx++;
endfunction

function void dutb_txn_base::do_copy (uvm_object rhs);
    dutb_txn_base _txn;

    if(!$cast(_txn, rhs))
        begin
            `uvm_error("TXN_DO_COPY", "Txn cast was failed")
            return;
        end
    super.do_copy(_txn); // chain the copy with parent classes

    unpack4vector (_txn.pack2vector());
endfunction


function bit dutb_txn_base::do_compare(uvm_object rhs, uvm_comparer comparer);
    dutb_txn_base _txn;
    vector packed_txn[2];
    bit eq;

    // If the cast fails, comparison has also failed
    // A check for null is not needed because that is done in the compare() function which calls do_compare()
    if(!$cast(_txn, rhs))
        begin
            `uvm_error("TXN_DO_COMPARE", "Txn cast was failed")
            return 1'b0;
        end

    if (size() != _txn.size())
        begin
            `uvm_error ( "TXN_DO_COMPARE", $sformatf ( "Txn size mismatch: %0d vs %0d", size(), _txn.size() ) )
            return (1'b0);
        end

    packed_txn[0] = pack2vector();
    packed_txn[1] = _txn.pack2vector();

    ans = super.do_compare (_txn, comparer);
    foreach (packed_txn[0][i])
        begin
            eq = (packed_txn[0][i] == packed_txn[1][i]);
            display_check((i == 0), eq);
            ans = ans & eq;
        end

    return (ans);
endfunction


function void dutb_txn_base::do_print (uvm_printer printer);
    super.do_print (printer);
    str = "\n-------------------\n";
    printer.m_string = {get_type_name(), " ",  get_name(), str, convert2string(), "\n"};
endfunction


function string dutb_txn_base::convert2string ();
    return ( vector2str(pack2vector()) );
endfunction


function string dutb_txn_base::convert2string_pair (dutb_txn_base txn);
    str = {convert2string(), "\n", txn.convert2string(), "\n", check_str};
    return str;
endfunction


function int dutb_txn_base::size ();
    vector packed_txn;
    int size_int;

    packed_txn = pack2vector();
    size_int = packed_txn.size();

    return size_int;
endfunction


//  next methods should be overrided
function vector dutb_txn_base::pack2vector ();
    if ("dutb_txn_base" != get_type_name())
        `uvm_fatal("VFNOTOVRDN", "Override method")
    else 
        `uvm_info("VFNOTOVRDN", "'dutb_txn_base' method used", UVM_DEBUG)
    return ({});
endfunction


function void dutb_txn_base::unpack4vector (vector packed_txn);
    if ("dutb_txn_base" != get_type_name())
        `uvm_fatal("VFNOTOVRDN", "Override method")
    else 
        `uvm_info("VFNOTOVRDN", "'dutb_txn_base' method used", UVM_DEBUG)

endfunction


function void dutb_txn_base::sample_coverage();
    `uvm_fatal("VFNOTOVRDN", "Override method")
endfunction


function void dutb_txn_base::analyze_coverage_results();
    `uvm_fatal("VFNOTOVRDN", "Override method")
endfunction


function dutb_txn_base dutb_txn_base::gold ();
    if ("dutb_txn_base" != get_type_name())
        `uvm_fatal("VFNOTOVRDN", "Override method")
    else 
        `uvm_info("VFNOTOVRDN", "'dutb_txn_base' method used", UVM_DEBUG)

endfunction


task dutb_txn_base::drive (input dutb_if_proxy_base dutb_if);
    if ("dutb_txn_base" != get_type_name())
        `uvm_fatal("VFNOTOVRDN", "Override method")
    else 
        `uvm_info("VFNOTOVRDN", "'dutb_txn_base' method used", UVM_DEBUG)
endtask


task dutb_txn_base::drive_x (input dutb_if_proxy_base dutb_if);
    if ("dutb_txn_base" != get_type_name())
        `uvm_fatal("VFNOTOVRDN", "Override method")
    else 
        `uvm_info("VFNOTOVRDN", "'dutb_txn_base' method used", UVM_DEBUG)
endtask


task dutb_txn_base::monitor (input dutb_if_proxy_base dutb_if);
    if ("dutb_txn_base" != get_type_name())
        `uvm_fatal("VFNOTOVRDN", "Override method")
    else 
        `uvm_info("VFNOTOVRDN", "'dutb_txn_base' method used", UVM_DEBUG)
endtask


function void dutb_txn_base::push ();
endfunction


function void dutb_txn_base::pop ();
    empty = 1'b1;
endfunction
// ****************************************************************************************************************************
