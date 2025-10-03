/******************************************************************************************************************************
    Project         :   dutb
    Creation Date   :   Dec 2015
    Package         :   dutb_util_pkg
    Description     :   Contain utils used.
******************************************************************************************************************************/


// ****************************************************************************************************************************


package dutb_util_pkg;
`ifdef DUTB_USE_UVM
    `include "uvm_macros.svh"
    import uvm_pkg::*;

    `include "dutb_macros.svh"
`endif

// Params******************************************************
    // General param
    parameter
        TRUE                                =   1'b1,
        FALSE                               =   1'b0,
        X                                   =   1'bx,

        //dutb params
        P_TCO                               =   1,    // 'update gap' (to avoid race conditions)
        P_MAX_FAIL_NUM                      =   16,   // max number of failed transactions after which TB will be stopped
        P_DISPLAY_LINE_SIZE                 =   16;   // max size of line when vector is being displayed. '0' value - display as single line


// Types*******************************************************
`ifdef DUTB_USE_UVM
    typedef     uvm_sequence #(uvm_sequence_item)   uvm_virtual_sequence;
`endif

    typedef     bit [32 -1 : 0]                     u_int;
    typedef     bit [16 -1 : 0]                     u_shortint;
    typedef     bit [8 - 1 : 0]                     u_byte;


    typedef     int                                 vector_t [];
    typedef     byte                                byte_vector_t [];
    typedef     real                                map_flt_t [string];
    typedef     int                                 map_int_t [string];

    typedef     enum    {
                            IDLE = 0,
                            READ = 1,
                            WRITE = 2
                        }                           db_mode_t;

db_mode_t foo;

// Funcs*******************************************************


    function reg [32*8 - 1 : 0] string2bytes(input string str);
        int i;
        automatic int len = str.len();

        string2bytes = '0; // All null characters

        // Copy characters
        assert(len <= 32);
        for (i = 0; i < len; i++)
            begin
                string2bytes[8*(len - i - 1) +: 8] = str.getc(i);
            end
    endfunction


    // convert int to string
    function string int2str(int n, string frmt="%0d");
        return $sformatf(frmt, n);
    endfunction


    // convert vector of int to string using given format
    function string vector2str(vector_t vec, string frmt = "0x%8H ", prefix = "");
        string s;
        s = prefix;
        foreach (vec[i])
            begin
                s = {s, $sformatf(frmt, vec[i]), eol(i)};
            end
        return s;
    endfunction

    // extrcat slice of given length
    function byte_vector_t get_byte_slice(byte_vector_t vec, int vec_size);
        byte_vector_t foo;

        assert(vec.size() >= vec_size);
        
        foo = new[vec_size];
        for (int i = 0; i < vec_size; i = i + 1)
            begin
                foo[i] = vec[i];  
            end
        return foo;
    endfunction


    // convert byte_vector to string using given format
    function string byte_vector2str(byte_vector_t vec, string frmt = "%2Hh ", prefix = "");
        string s;
        s = prefix;
        foreach (vec[i])
            begin
                s = {s, $sformatf(frmt, vec[i]), eol(i)};
            end
        return s;
    endfunction

    // convert list of map int values to string
    function string map_int2str(map_int_t map);
        int i, arr[];
        arr = new[map.num()];
        i = 0;
        foreach (map[key])
            begin
                arr[i] = map[key];
                i++;
            end
        return vector2str(arr, .frmt("%0d "));
    endfunction


    // convert list of map key/values pairs to string
    function string map_int_display(map_int_t map);
        string s;
        s = "";
        foreach (map[key])
            begin
                s = {s, $sformatf("%-32s : %0d\n", key, map[key])};
            end
        return s;
    endfunction


    // convert list of map float values to string
    function string map_flt2str(real map[string]);
        string s;
        int i;
        s = "";
        i = 0;
        foreach (map[key])
            begin
                s = $sformatf("%s%.2f%s", s, map[key], eol(i));
                i++;
            end
        return s;
    endfunction


    // convert list of map key/values pairs to string
    function string display_float_map(real map[string]);
        string s;
        s = "";
        foreach (map[key])
            begin
                s = $sformatf("%s%s : %.2f %%\n", s, key, map[key]);
            end
        return s;
    endfunction


    // return '\n' at the end of line '' otherwise 
    function string eol(int i);
        return ( ( (0 != P_DISPLAY_LINE_SIZE) && ( (P_DISPLAY_LINE_SIZE-1) == (i % P_DISPLAY_LINE_SIZE) ) ) ? "\n" : " " );
    endfunction

    function string get_time();
        int    file_pointer;

        //Stores time and date to file sys_time
        void'($system("date +%T > sys_time"));
        //Open the file sys_time with read access
        file_pointer = $fopen("sys_time","r");
        //assin the value from file to variable
        void'($fscanf(file_pointer,"%s",get_time));
        //close the file
        $fclose(file_pointer);
        void'($system("rm sys_time"));
    endfunction    

    // Print Debug msg to stdout
    function void log_debug(string msg="", logic en = 1'b1);
        if (en)
            begin
                $display("[LOG] %s\t\t @ %0t", msg, $realtime);
            end
    endfunction : log_debug


    // Print Info msg to stdout
    function void log_info(string msg="", logic en = 1'b1, logic print_sys_time = 1'b0);
        if (en)
            begin
                automatic string sys_time = (print_sys_time) ? get_time() : "";
                $display("[INFO] %s\t\t @ %0t\t\t%s", msg, $realtime, sys_time);
            end
    endfunction : log_info


    // Print Warning msg to stdout
    function void log_warning(string msg="", logic en = 1'b1);
        if (en)
            begin
                $display("[WARNING] %s\t\t @ %0t", msg, $realtime);
            end
    endfunction : log_warning


    // Print Error msg to stdout
    function void log_error(string msg="", logic en = 1'b1, string location="");
        if (en)
            begin
                $display("[ERROR] %s\t\t%s @ %0t", msg, location, $realtime);
            end
    endfunction : log_error


    // Print Error msg to stdout and terminate
    function void log_fatal(string msg="", string location="");
        $display("[FATAL] %s\t\t%s @ %0t", msg, location, $realtime);
        $finish();        
    endfunction : log_fatal


    // Terminate simulation after given time period (to resolve potential 'freeze' issue)
    `ifdef DUTB_USE_UVM
        task automatic timeout_sim(input realtime tme, int milestones=0);
            `uvm_warning("UTL", $sformatf("Sim timeout: %t", tme))
            if (milestones == 0)
                begin
                    #(tme);
                end
            else
                begin
                    for (int i = 0; i < milestones; i++)
                        #(tme/milestones) `uvm_debug_m($sformatf("*-*-*-*-*-*-*milestone #%0d of %0d*-*-*-*-*-*-*", i, milestones))
                end
            `uvm_warning("UTL", "Time out. Simulation terminated!")
            $finish();
        endtask
    `else
        task automatic timeout_sim(input time tme, int milestones=0);
            if (milestones == 0)
                begin
                    #(tme);
                end
            else
                begin
                    for (int i = 0; i < milestones; i++)
                        #(tme/milestones) log_info($sformatf("*-*-*-*-*-*-*milestone #%0d of %0d*-*-*-*-*-*-*", i, milestones), .print_sys_time(1'b1));
                end
            log_warning("Time out. Simulation terminated!");
            $finish();
        endtask
    `endif
    
    function byte get_hash(byte value, key = 0);
        automatic byte    base_key = 8'hAB;
        base_key = (0 != key) ? (base_key ^ key) : base_key;
        return (value ^ base_key);
    endfunction


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

    // polynomial: G(x)=x^16+x^12+x^5+1
    // data width: 1
    // convention: the first serial bit is D[0]
    function [15:0] nextCRC16_D1;
        input Data;
        input [15:0] crc;
        reg [0:0] d;
        reg [15:0] c;
        reg [15:0] newcrc;
        begin
            d[0] = Data;
            c = crc;

            newcrc[0] = d[0] ^ c[15];
            newcrc[1] = c[0];
            newcrc[2] = c[1];
            newcrc[3] = c[2];
            newcrc[4] = c[3];
            newcrc[5] = d[0] ^ c[15] ^ c[4];
            newcrc[6] = c[5];
            newcrc[7] = c[6];
            newcrc[8] = c[7];
            newcrc[9] = c[8];
            newcrc[10] = c[9];
            newcrc[11] = c[10];
            newcrc[12] = d[0] ^ c[15] ^ c[11];
            newcrc[13] = c[12];
            newcrc[14] = c[13];
            newcrc[15] = c[14];

            nextCRC16_D1 = newcrc;
        end
    endfunction


    // calculate 16-bit(word) crc of word array of arbitrary size 
    function [15:0] word_crc([15:0] word, crc_init);
        logic   [15 : 0]    
            foo,
            bar;
        
        bar = crc_init;
        foo = word;
        for (int j = 0; j < 16; j++) 
            begin
                bar = nextCRC16_D1(foo, bar);
                foo >>= 1;
            end
        // `uvm_debug(int2str(bar))
        return bar;
    endfunction : word_crc


    // calculate 16-bit(word) crc of word array of arbitrary size 
    function [15:0] word_arr_crc([15:0] word_arr[], crc_init);
        logic   [15 : 0]    bar;
        bar = crc_init;
        foreach (word_arr[i]) 
            begin
                bar = nextCRC16_D1(word_arr[i], bar);
            end
        // `uvm_debug(int2str(bar))
        return bar;
    endfunction : word_arr_crc


    // calculate 8-bit crc of byte array of arbitrary size using 12-bit crc algorithm. 
    function [7:0] byte_arr_crc([7:0] crc_init, byte_arr[]);
        logic       [7:0]       foo;
        logic       [11 : 0]    bar;

        bar = {4'h0, crc_init};
        foreach (byte_arr[i])
            begin
                foo = byte_arr[i];
                for (int j = 0; j < 8; j++)
                    begin
                        bar = nextCRC12_D1(foo, bar);
                        foo >>= 1;
                    end
            end
        // `uvm_debug(int2str(bar[7:0]))
        return bar [7:0];
    endfunction : byte_arr_crc


    // calculate xor of byte array of arbitrary size
    function byte byte_xor(byte check_sum, vec[]);
        byte    bar;
        bar = check_sum;
        foreach (vec[i])
            begin
                bar = bar ^ vec[i];
            end
        return bar;
    endfunction : byte_xor

endpackage
// ****************************************************************************************************************************


// ****************************************************************************************************************************
// Module to provide 'clock' and 'rst' signals

`ifdef DUTB_USE_UVM
    `include "uvm_macros.svh"
    import uvm_pkg::*;

    `include "dutb_macros.svh"
`endif

module clk_gen (output logic clk);
    parameter   time        T_CLK_PERIOD = 10ns;
    parameter   integer     PHASE = 0;
    localparam  realtime    T_CLK_HALF_PERIOD = T_CLK_PERIOD / 2;
    localparam  realtime    T_PHASE_SHIFT = (T_CLK_PERIOD * PHASE) / 360;

    initial
        begin
            #T_PHASE_SHIFT;
            clk = 1'b1;
            while (1)
                #(T_CLK_HALF_PERIOD) clk = ~clk;
        end
endmodule


module rst_gen  (input logic clk = 1'b0, output logic rst_n);
    parameter string RST_TYPE = "ASYNC";
    parameter time T_RST_LENGTH = 22ns;

    initial
        begin
            rst_n = 1'b0;
            #T_RST_LENGTH;
            if ("SYNC" == RST_TYPE)
                begin
                    @(posedge clk);
                end
            rst_n = 1'b1;
            `uvm_debug($sformatf("Reset off at %t", $time));
        end
endmodule
// ****************************************************************************************************************************
