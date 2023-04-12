/******************************************************************************************************************************
    Project         :   dutb
    Creation Date   :   Dec 2015
    Package         :   dutb_macro_pkg
    Description     :   Contain macros used.
******************************************************************************************************************************/


// ****************************************************************************************************************************
package dutb_macro_pkg;

    `define ASSERT_X(var) \
        if($isunknown(var)) \
            `uvm_error("XVALERR", "'X' value was detected")

    `define ASSERT_TYPE_CAST(dst, src) \
        if(!$cast(dst, src)) \
            `uvm_fatal("TPYERR", "Type cast was failed")

    // briefer form of assert
    `define ASSERT(val, msg="") \
        assert(val) else `uvm_fatal("ASSRT", msg)

    // Wait for an input 'in' is True and assert False. Use to catch improper events in forks.
    `define ASSERT_WAIT(in, msg="")\
        wait(in)\
            assert(FALSE)\
                else `uvm_fatal("ASSRT", msg)

    // briefer form of separate debug report macro
    `define uvm_debug(a) `uvm_info("UVMDBG", a, UVM_HIGH)

    // briefer form of separate debug report macro
    `define uvm_debug_m(a) `uvm_info("UVMDBG", a, UVM_MEDIUM)

    // store waves if `NO_WAVE underfined
    `define STORE_WAVE \
        begin \
            `ifndef NO_WAVE \
                $shm_open("./sim"); \
                $shm_probe ("ACTFM"); \
            `endif \
        end

    // Probes
    `define ADD_PROBE_WIRE(unit, prefix, probe) \
        wire prefix``probe; \
        assign prefix``probe = unit``.probe;

    `define ADD_PROBE_BUS(unit, prefix, probe, width) \
        wire [width-1:0] prefix``probe; \
        assign prefix``probe = unit``.probe;

    `define ADD_PROBE_PCK_UNPCK_ARR(unit, prefix, probe, width, n)\
        generate\
            wire [width-1:0] prefix``probe[n];\
            for (ii = 0; ii < n; ii++)\
                begin\
                    assign prefix``probe[ii] = unit``.probe[ii*width +: width];\
                end\
        endgenerate

    `define ADD_PROBE_UNPCK_ARR(unit, prefix, probe, width, n)\
        generate\
            wire [width-1:0] prefix``probe[n];\
            for (ii = 0; ii < n; ii++)\
                begin\
                    assign prefix``probe[ii] = unit``.probe[ii];\
                end\
        endgenerate
endpackage
// ****************************************************************************************************************************

