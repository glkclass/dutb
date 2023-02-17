package dutb_param_pkg;
    parameter
    //tb params
    P_CLK_PERIOD        = 10, // single clk cycle duration
    P_RSTN_LENGTH       = 33, // rst signal duration
    p_tco  = 1, // 'update gap' (to avoid race conditions)
    p_max_fail_num  = 16, // max number of failed transactions after which TB will be stopped
    p_xds_dist  = 100, // percentage of 'active' xds transactions
    p_display_line_size = 32, // max size of line when vector is being displayed. '0' value - display as single line
    p_log_buffer_size = 4096, // size of DPI log buffer

    //'report server' message(UVM_INFO/WARNING/ERROR/FATAL) field widths
    p_rpt_msg_severity_width = 11,
    p_rpt_msg_filename_width = 60,
    p_rpt_msg_objectname_width = 30,
    p_rpt_msg_id_width = 11,
    p_rpt_msg_filename_nesting_level = 0,  // define 'filename max nesting level'. '0' - 'display full hierarchial name'
    p_rpt_msg_objectname_nesting_level = 2;  // define 'objectname max nesting level'. '0' - 'display full hierarchial path'
endpackage

