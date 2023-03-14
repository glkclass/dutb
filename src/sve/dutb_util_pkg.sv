/******************************************************************************************************************************
    Project         :   dutb
    Creation Date   :   Dec 2015
    Package         :   dutb_util_pkg
    Description     :   Contain utils used.
******************************************************************************************************************************/


// ****************************************************************************************************************************
`timescale 1ps/1ps


package dutb_util_pkg;
    `include "uvm_macros.svh"
    import uvm_pkg::*;

    import dutb_param_pkg::*;
    import dutb_typedef_pkg::*;
    import dutb_macro_pkg::*;


    function string int2str(int n);
        return $sformatf("%0d", n);
    endfunction


    function string vec2str(vector vec, string prefix = "");
        string s;
        s = prefix;
        foreach (vec[i])
            begin
                s = {s, $sformatf("0x%4H ", vec[i]), eol(i)};
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
        return ( ( (0 != P_DISPLAY_LINE_SIZE) && ( (P_DISPLAY_LINE_SIZE-1) == (i % P_DISPLAY_LINE_SIZE) ) ) ? "\n" : "" );
    endfunction


    // Terminate simulation after given time period (to resolve potential 'freeze' issue)
    task automatic timeout_sim(input time tme, milestone=0);
        if (milestone == 0)
            begin
                #(tme);
            end
        else
            begin
                int n_iter = tme/milestone;
                for (int i = 0; i < n_iter; i++)
                    #(milestone) `uvm_debug($sformatf("*-*-*-*-*-*-*milestone #%0d of %0d*-*-*-*-*-*-*", i, n_iter))
            end
        `uvm_warning("UTIL", "Time out. Simulation terminated!")
        $finish();
    endtask


    // Print Debug msg to stdout
    function void log_debug(string foo="", logic en = 1'b1);
        if (en)
            $display("%s\t\tat %0t", $sformatf("[LOG] %s", foo), $realtime);
    endfunction : log_debug


    // CRC calculation
    // polynomial: x^12 + x^10 + x^7 + x^4 + x^3 + x^2 + x^1 + 1
    // data width: 1
    // convention: the first serial bit is D[0]
    function [11:0] nextCRC12_D1;
        input Data;
        input [11:0] crc;
        reg [0:0] d;
        reg [11:0] c;
        reg [11:0] newcrc;
        begin
            d[0] = Data;
            c = crc;

            newcrc[0] = d[0] ^ c[11];
            newcrc[1] = d[0] ^ c[0] ^ c[11];
            newcrc[2] = d[0] ^ c[1] ^ c[11];
            newcrc[3] = d[0] ^ c[2] ^ c[11];
            newcrc[4] = d[0] ^ c[3] ^ c[11];
            newcrc[5] = c[4];
            newcrc[6] = c[5];
            newcrc[7] = d[0] ^ c[6] ^ c[11];
            newcrc[8] = c[7];
            newcrc[9] = c[8];
            newcrc[10] = d[0] ^ c[9] ^ c[11];
            newcrc[11] = c[10];
            nextCRC12_D1 = newcrc;
        end
    endfunction
endpackage 
// ****************************************************************************************************************************

