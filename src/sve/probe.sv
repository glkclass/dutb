/******************************************************************************************************************************
    Project         :   dutb
    Creation Date   :   June 2021
    Module          :   probe
    Description     :   Allocate probes to DUT internal signals in single place.
******************************************************************************************************************************/


// ****************************************************************************************************************************
`include "dutb_macros.svh"

module probe ();
    genvar          ii;
    int             i;

    `define UNIT foo.qux
    `define PREFIX bar
    `add_probe_wave(`UNIT, `PREFIX, quxx)
endmodule
// ****************************************************************************************************************************

