/******************************************************************************************************************************
    Project         :   dutb
    Date            :   June 2025
    Class           :   dutb_covergroup_base
    Description     :
******************************************************************************************************************************/


// ****************************************************************************************************************************
class dutb_covergroup_base extends uvm_object;
    `uvm_object_utils(dutb_covergroup_base)

    // coverage map
    real coverage[string];

    extern function new(string name="");
    extern virtual function void sample(dutb_txn_base txn);
    extern virtual function void analyze_coverage_results();
endclass
// ****************************************************************************************************************************


// ****************************************************************************************************************************
    function dutb_covergroup_base::new(string name="");
        super.new(name);
    endfunction


    function void dutb_covergroup_base::sample(dutb_txn_base txn);
        if ("dutb_covergroup_base" != get_type_name())
            `uvm_fatal("VFNOTOVRDN", "Override method")
        else
            `uvm_info("VFNOTOVRDN", "'dutb_covergroup_base' method used", UVM_DEBUG)
    endfunction


    function void dutb_covergroup_base::analyze_coverage_results();
        `uvm_info("COVERAGE", {"\n", float_map_display(coverage)}, UVM_HIGH)

        // progress_bar_h.display();
        // if (34 == progress_bar_h.cnt)
        //     begin
        //         dut_handler_h.stop_test("FCC target achieved");  // finish current test
        //     end

    endfunction
// ****************************************************************************************************************************
