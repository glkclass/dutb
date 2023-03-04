/******************************************************************************************************************************
    Project         :   dutb
    Creation Date   :   Dec 2015
    Package         :   dutb_macro_pkg
    Description     :   Contain macros used.
******************************************************************************************************************************/


// ****************************************************************************************************************************
package dutb_macro_pkg;
    // briefer form of assert
    `define ASSERT(val, msg="") \
        assert(val) else $fatal(0, msg)

    // Wait for an input 'in' is True and assert False. Use to catch improper events in forks.
    `define ASSERT_WAIT(in, msg="")\
        wait(in)\
            assert(FALSE)\
                else $fatal(0, msg)

    // briefer form of separate debug report macro
    `define uvm_debug(a, b) `uvm_info(a, b, UVM_HIGH)

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

