package dutb_macro_pkg;
     // briefer form for separate debug report macro
    `define uvm_debug(a, b) `uvm_info(a, b, UVM_HIGH)

    // store waves if `NO_WAVE underfined
    `define STORE_WAVE \
        begin \
            `ifndef NO_WAVE \
                $shm_open("./sim"); \
                $shm_probe ("ACTFM"); \
            `endif \
        end
endpackage

