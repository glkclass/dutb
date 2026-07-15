/******************************************************************************************************************************
    Project         :   dutb
    Description     :   Contain dutb macros used.
******************************************************************************************************************************/


// ****************************************************************************************************************************
`ifndef DUTB_MACRO_SVH
`define DUTB_MACRO_SVH
    `define DUTB_AGNT(idx)                                      $sformatf("uvm_test_top.env_h.agent_h[%0d]*",idx)
    `define DUTB_AGNT_HAS_DRIVER(idx)                           $sformatf("agent_h[%0d]_has_driver",idx)
    `define DUTB_AGNT_HAS_MONITOR(idx)                          $sformatf("agent_h[%0d]_has_monitor",idx)

    `define STR(x) `"x`"

    `define GET_MASK(offs)                                      (1 << (offs))
    `define GET_BIT(bus, offs)                                  ((bus >> offs) & 1)
    `define GET_FIELD(bus, offs, width)                         ((bus >> offs) & width)
    `define GET_FIELD_R(bus, offs, width)                       (((bus >> offs) + (get_bit(bus, (offs - 1))) & (width))
    `define GET_BYTE(bus,idx)                                   ((bus >> 8*idx) & 0xFF)

    `define SET_BIT(bus, offs)                                  (bus) |= (1 << (offs))
    `define CLR_BIT(bus, offs)                                  (bus) &= ~(1 << (offs))

    `define UPDATE_BIT(bus, offs, bit)                          if (bit) \
                                                                    begin \
                                                                        set_bit(bus, offs); \
                                                                    end \
                                                                else \
                                                                    begin \
                                                                        clr_bit(bus, offs); \
                                                                    end

    `define UPDATE_BIT_FIELD(bus, offs, width, bf_val)          for (integer ubf_i = 0; ubf_i < (width); ++ubf_i) \
                                                                    begin \
                                                                        update_bit(bus, offs + ubf_i, ((bf_val) >> ubf_i) & 1); \
                                                                    end


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

    //
    `define log_debug(msg) $display("INFO: %s %s(%0d)", msg, `__FILE__, `__LINE__);

    // conditional txn log message
    `define uvm_debug_txn(a)\
        if (verbosity_level <= UVM_HIGH)\
            begin\
                `uvm_info("DBG", a, UVM_HIGH)\
            end

    // briefer form of separate debug report macro
    `define uvm_debug(msg, id="DBG") `uvm_info(id, msg, UVM_HIGH)

    // briefer form of separate debug report macro
    `define uvm_debug_m(a) `uvm_info("DBG", a, UVM_MEDIUM)

    `define uvm_info_2(a,b,c,d)     `uvm_info(a, b, d) \
                                    $display(c);

    // store waves if "+STORE_WAVE" arg defined
    `define store_wave(top, waveform_file)\
        begin\
            if ($test$plusargs("STORE_WAVE"))\
                begin\
                    if ($value$plusargs("TOOLS=%s", "VIVADO"))\
                        begin\
                           $dumpfile(waveform_file);\
                           $dumpvars(0, top);\
                        end\
                    else if ($value$plusargs("TOOLS==%s", "CADENCE"))\
                        begin\
                            $shm_open("./sim");\
                            $shm_probe ("ACTFM");\
                        end\
                end\
        end

    // Probes
    `define ADD_PROBE_WAVE(unit, prefix, probe) \
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


    `define     init_artefacts(waveform) \
        initial begin \
            $timeformat(-9, 3, " ns", 13); \
            `store_wave(ttb, waveform) \
        end


    `define     start_test(if_h,test_len) \
        initial begin \
            // Provide DUT interfaces to UVM infra \
            uvm_config_db #(virtual dut_if)::set(null, "uvm_test_top", "dut_vif", if_h); \
            fork \
                run_test(); \
                timeout_sim(test_len, 10); \
           join_any \
        end


    `define     provide_func_proxy(top_func_proxy) \
        initial begin \
            // Provide ttb static funcs to UVM infra \
            static top_func_proxy foo = new(); \
            uvm_config_db #(base_func_proxy)::set(null, "*", "top_func_proxy", foo); \
        end


    `define     get_arg_value(arg_frmt, container, default_value) (($value$plusargs(arg_frmt, container)) ? container : default_value)

`endif
// ****************************************************************************************************************************

