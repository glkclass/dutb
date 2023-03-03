/******************************************************************************************************************************
    Project         :   dutb
    Author          :   glkclass@gmail.com
    Creation Date   :   June 2021
    Module          :   probe
    Description     :   Allocate probes to DUT internal signals in single place.
*******************************************************************************************************************************/


// ****************************************************************************************************************************
import tb_util_pkg::*;

module probe ();
    genvar          ii;
    int             i;

    `define UNIT foo.qux
    `define PREFIX bar
    `ADD_PROBE_WIRE(`UNIT, `PREFIX, quxx)
endmodule
// ****************************************************************************************************************************

