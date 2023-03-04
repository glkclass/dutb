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
    HIGH                                =   1'b1,
    LOW                                 =   1'b0,
    TRUE                                =   1'b1,
    FALSE                               =   1'b0,
    X                                   =   1'bx,

    //tb params
    P_TCO                               =   1,    // 'update gap' (to avoid race conditions)
    P_MAX_FAIL_NUM                      =   16,   // max number of failed transactions after which TB will be stopped
    P_DISPLAY_LINE_SIZE                 =   32,   // max size of line when vector is being displayed. '0' value - display as single line

    //'report server' message field widths
    P_RPT_MSG_SEVERITY_WIDTH            =   11,
    P_RPT_MSG_FILENAME_WIDTH            =   60,
    P_RPT_MSG_OBJECTNAME_WIDTH          =   30,
    P_RPT_MSG_ID_WIDTH                  =   11,
    P_RPT_MSG_FILENAME_NESTING_LEVEL    =   0,    // define 'filename max nesting level'. '0' - 'display full hierarchial name'
    P_RPT_MSG_OBJECTNAME_NESTING_LEVEL  =   2;    // define 'objectname max nesting level'. '0' - 'display full hierarchial path'
endpackage  
// ****************************************************************************************************************************
    
