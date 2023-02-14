`timescale 1ns/1ns
package dutb_sequence_pkg;
    `include "uvm_macros.svh"
    import uvm_pkg::*;

    import dutb_typedef_pkg::*;
    import dutb_param_pkg::*;
    import dutb_util_pkg::*;
    import dutb_if_proxy_pkg::*;

    `include "dutb_txn_base.svh"
    `include "dutb_v_sqncr.svh"
    `include "dutb_v_seq.svh"
endpackage

