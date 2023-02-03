function string vec2str(vector vec);
    static string s = "";
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
// - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
