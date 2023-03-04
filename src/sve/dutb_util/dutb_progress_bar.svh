/******************************************************************************************************************************
    Project         :   dutb
    Creation Date   :   Dec 2015
    Class           :   dutb_progress_bar
    Description     :   Interface   -   
                        Task        -   display 'progress bar
                                        Can be instantiated in the any uvm_component and 
                                        used to 'log information' about progress (num of txn, checks, statistics, ...)
******************************************************************************************************************************/


// ****************************************************************************************************************************
class dutb_progress_bar #(parameter uvm_verbosity P_UVM_VERBOSITY = UVM_HIGH, int MILESTONE = 10) extends uvm_component;
    `uvm_component_param_utils(dutb_progress_bar #(P_UVM_VERBOSITY, MILESTONE))

    int cnt;
    extern function             new(string name = "dutb_progress_bar", uvm_component parent=null);
    extern function void        display (string message = "");
endclass
// ****************************************************************************************************************************


// ****************************************************************************************************************************
function dutb_progress_bar::new(string name = "dutb_progress_bar", uvm_component parent=null);
    super.new(name, parent);
    cnt = 0;
endfunction


// display 'progress bar' information every `MILESTONE ticks
function void dutb_progress_bar::display (string message="");
    if (MILESTONE > 0)
        begin
            cnt++;
            if (0 == cnt%MILESTONE)
                begin
                    `uvm_info("PROGRESS", {$sformatf("%0d... ", cnt), message}, P_UVM_VERBOSITY)
                end
        end
endfunction
// ****************************************************************************************************************************
