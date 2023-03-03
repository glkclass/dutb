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


    // Print Debug msg to stdout
    function void log_debug(string foo="", logic en = 1'b1);
        if (en)
            $display("%s\t\tat %0t", $sformatf("[LOG] %s", foo), $realtime);
    endfunction : log_debug


    // CRC calculation
    // polynomial: x^12 + x^10 + x^7 + x^4 + x^3 + x^2 + x^1 + 1
    // data width: 1
    // convention: the first serial bit is D[0]
    function [11:0] nextCRC12_D1;
        input Data;
        input [11:0] crc;
        reg [0:0] d;
        reg [11:0] c;
        reg [11:0] newcrc;
        begin
            d[0] = Data;
            c = crc;

            newcrc[0] = d[0] ^ c[11];
            newcrc[1] = d[0] ^ c[0] ^ c[11];
            newcrc[2] = d[0] ^ c[1] ^ c[11];
            newcrc[3] = d[0] ^ c[2] ^ c[11];
            newcrc[4] = d[0] ^ c[3] ^ c[11];
            newcrc[5] = c[4];
            newcrc[6] = c[5];
            newcrc[7] = d[0] ^ c[6] ^ c[11];
            newcrc[8] = c[7];
            newcrc[9] = c[8];
            newcrc[10] = d[0] ^ c[9] ^ c[11];
            newcrc[11] = c[10];
            nextCRC12_D1 = newcrc;
        end
    endfunction

endpackage

