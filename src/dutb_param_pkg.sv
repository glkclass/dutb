/******************************************************************************************************************************
    Project         :   dutb
    Creation Date   :   Dec 2015
    Package         :   dutb_param_pkg
    Description     :   Contain params used.
******************************************************************************************************************************/


// ****************************************************************************************************************************
package dutb_param_pkg;
    parameter

    // General param
    TRUE                                =   1'b1,
    FALSE                               =   1'b0,
    X                                   =   1'bx,

    //tb params
    P_TCO                               =   1,    // 'update gap' (to avoid race conditions)
    P_MAX_FAIL_NUM                      =   16,   // max number of failed transactions after which TB will be stopped
    P_DISPLAY_LINE_SIZE                 =   16;   // max size of line when vector is being displayed. '0' value - display as single line

endpackage
// ****************************************************************************************************************************

