/*
    Package:    dutb_util
    Content:    Utils used.
*/
// - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
function string vec2str(vector vec, string prefix = "");
    string s;
    s = prefix;
    foreach (vec[i])
        begin
            s = {s, $sformatf("%4d ", vec[i]), eol(i)};
        end
    return s;
endfunction


function string map_flt2str(map_flt map);
    string s;
    int i;
    s = "";
    i = 0;    
    foreach (map[key])
        begin
            s = {s, $sformatf("%.2f ", map[key]), eol(i)};
            i++;
        end
    return s;
endfunction


function string map_int2str(map_int map);
    string s;
    int i;
    s = "";
    i = 0;
    foreach (map[key])
        begin
            s = {s, $sformatf("%4d ", map[key]), eol(i)};
            i++;
        end
    return s;
endfunction


function string eol(int i);
    return ( ( (0 != p_display_line_size) && ( (p_display_line_size-1) == (i % p_display_line_size) ) ) ? "\n" : "" );
endfunction


// Terminate simulation after given time period (to resolve potential 'freeze' issue)
task automatic timeout_sim(input time tme, step=0);
    if (step == 0)
        begin
            #(tme);
        end
    else
        begin
            int n_iter = tme/step;
            for (int i = 0; i < n_iter; i++)
                #(step) `uvm_debug("UTIL", $sformatf("Sim checkpoint #%0d of %0d", i, n_iter))
        end
    `uvm_warning("UTIL", "Time off. Simulation terminated!")
    $finish();
endtask
// - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
