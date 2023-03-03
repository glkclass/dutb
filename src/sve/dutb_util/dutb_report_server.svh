// ****************************************************************************************************************************
class dutb_report_server extends uvm_default_report_server;
    `uvm_object_utils(dutb_report_server)
    string report_format_str[string];

    extern function new(string name = "dutb_report_server");

    extern virtual function string compose_report_message (
        uvm_report_message report_message,
        string report_object_name = "" );

    // reduce 'long hierarchical name'
    extern function string remove_hier_path (
        string s,                   // long hierarchical name to be reduced
        string delimiter_list[],    // list of delimiter symbols: "/", "\\", ".", etc
        int nesting_level );        // '0' - return full path, 'n' - return path containing 'n' nesting items
endclass
// ****************************************************************************************************************************


// ****************************************************************************************************************************
function dutb_report_server::new(string name = "dutb_report_server");
    super.new(name);
    uvm_default_report_server::set_server( this );//substitute default report server
endfunction

// UVM_INFO ../../dutb/src/sve/dutb_agent/dutb_monitor_base.svh(45) @ 0ns: uvm_test_top.env_h.pout_agent_h.monitor_h [MNTR] Monitoring of 'dutb_txn_base' forbidden!
// UVM_INFO    ../../dutb/src/sve/dutb_agent/dutb_monitor_base.svh(45)      @ 0ns  pout_agent_h.monitor_h         [MNTR       ] Monitoring of 'dutb_txn_base' forbidden!

function string dutb_report_server::compose_report_message(uvm_report_message report_message, string report_object_name = "");
    string sev_string;
    // uvm_verbosity l_verbosity;
    string filename_line_str;
    string context_str;
    // string verbosity_str;
    string msg_body_str;
    uvm_report_message_element_container el_container;
    string prefix;
    uvm_report_handler l_report_handler;

    // verbosity_str = ($cast(l_verbosity, report_message.get_verbosity())) ? l_verbosity.name(): int2str(report_message.get_verbosity());
    // sev_string = report_message.get_severity().name();

    filename_line_str = $sformatf ("%s(%0d)", report_message.get_filename(), report_message.get_line());
    context_str = ("" != report_message.get_context()) ? $sformatf ({"*\%-s* "}, report_message.get_context()) : "";

    el_container = report_message.get_element_container();
    if (el_container.size() == 0)
        msg_body_str = report_message.get_message();
    else
        begin
            prefix = uvm_default_printer.knobs.prefix;
            uvm_default_printer.knobs.prefix = " +";
            msg_body_str = {report_message.get_message(), "\n", el_container.sprint()};
            uvm_default_printer.knobs.prefix = prefix;
        end

    if (report_object_name == "")
        begin
            l_report_handler = report_message.get_report_handler();
            report_object_name = l_report_handler.get_full_name();
        end

    compose_report_message =
        {
            $sformatf({"\%-", int2str(P_RPT_MSG_SEVERITY_WIDTH), "s "}, report_message.get_severity().name()),
            $sformatf({"\%-", int2str(P_RPT_MSG_FILENAME_WIDTH), "s "}, remove_hier_path(filename_line_str, '{"/", "\\"}, P_RPT_MSG_FILENAME_NESTING_LEVEL)),
            "@ ", $sformatf("\%0t  ", $time),
            $sformatf({"\%-", int2str(P_RPT_MSG_OBJECTNAME_WIDTH), "s "}, remove_hier_path(report_object_name, '{"."}, P_RPT_MSG_OBJECTNAME_NESTING_LEVEL)),
            $sformatf({"[\%-", int2str(P_RPT_MSG_ID_WIDTH), "s] "}, report_message.get_id()),
            context_str,
            msg_body_str
        };
endfunction


function string dutb_report_server::remove_hier_path(string s, string delimiter_list[], int nesting_level);
    int last_char_idx;
    int slash_position = -1;
    int n = 0;

    if (0 == nesting_level)
        begin
            return( s );
        end

    last_char_idx = s.len()-1;
    for (int i = last_char_idx; i >= 0; i--)
        begin
            if (s.getc(i) inside {delimiter_list} && (nesting_level == ++n))
                begin
                    slash_position = i;
                    break;
                end
        end
    return( s.substr(slash_position+1, last_char_idx) );
endfunction
// ****************************************************************************************************************************













