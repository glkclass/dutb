/******************************************************************************************************************************
    Project         :   dutb
    Creation Date   :   Dec 2015
    Description     :   Contain dutb macros used.
******************************************************************************************************************************/


// ****************************************************************************************************************************
`ifndef DUTB_MACROS_SVH
`define DUTB_MACROS_SVH

    `define assert_x(var) \
        if($isunknown(var)) \
            `uvm_error("XVALERR", "'X' value was detected")

    `define assert_type_cast(dst, src) \
        if(!$cast(dst, src)) \
            `uvm_fatal("TPYERR", "Type cast was failed")

    // briefer form of assert
    `define assert(val, msg="") \
        assert(val) else `uvm_fatal("ASSRT", msg)

    // Wait for an input 'in' is True and assert False. Use to catch improper events in forks.
    `define assert_wait(in, msg="")\
        wait(in)\
            assert(FALSE)\
                else `uvm_fatal("ASSRT", msg)

    // briefer form of separate debug report macro
    `define uvm_debug(a) `uvm_info("UVMDBG", a, UVM_HIGH)

    // briefer form of separate debug report macro
    `define uvm_debug_m(a) `uvm_info("UVMDBG", a, UVM_MEDIUM)

    // store waves if `NO_WAVE underfined
    `define store_wave \
        begin \
            `ifndef NO_WAVE \
                $shm_open("./sim"); \
                $shm_probe ("ACTFM"); \
            `endif \
        end

    // Probes
    `define add_probe_wave(unit, prefix, probe) \
        wire prefix``probe; \
        assign prefix``probe = unit``.probe;

    `define add_probe_bus(unit, prefix, probe, width) \
        wire [width-1:0] prefix``probe; \
        assign prefix``probe = unit``.probe;

    `define add_probe_pck_unpck_arr(unit, prefix, probe, width, n)\
        generate\
            wire [width-1:0] prefix``probe[n];\
            for (ii = 0; ii < n; ii++)\
                begin\
                    assign prefix``probe[ii] = unit``.probe[ii*width +: width];\
                end\
        endgenerate

    `define add_probe_unpck_arr(unit, prefix, probe, width, n)\
        generate\
            wire [width-1:0] prefix``probe[n];\
            for (ii = 0; ii < n; ii++)\
                begin\
                    assign prefix``probe[ii] = unit``.probe[ii];\
                end\
        endgenerate
`endif
// ****************************************************************************************************************************

