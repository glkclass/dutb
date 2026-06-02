/******************************************************************************************************************************
    Project         :   dutb
    Modules         :   iserdes2 model
    Description     :   Util modules used fot TB
******************************************************************************************************************************/



// ****************************************************************************************************************************
module iserdes_2
    (
        input                                       RST,
        input                                       CLK,
        input                                       CLKB,
        input                                       OCLK,
        input                                       OCLKB,
        input                                       CLKDIV,
        input                                       D,
        input                                       CLKDIVP,
        input                                       BITSLIP,
        input                                       CE1,

        output                                      Q1,
        output                                      Q2,
        output                                      Q3,
        output                                      Q4
    );

    parameter string
        SERDES_MODE = "MASTER",
        INTERFACE_TYPE = "MASTER",
        DATA_RATE = "MASTER",
        IOBDELAY = "MASTER";

    parameter int
        DATA_WIDTH = 4,
        NUM_CE = 1;


    reg ff0, ff1, ff2, ff3, ff4, ff5, ff6, ff7, ff8, ff9;


    always @(posedge CLK)
        begin
            ff0 <=  D;
        end

    always @(negedge CLK)
        begin
            ff1 <=  D;
        end

    always @(posedge OCLK)
        begin
            ff2 <=  ff0;
            ff4 <=  ff2;
            ff5 <=  ff3;
        end

    always @(negedge OCLK)
        begin
            ff3 <=  ff1;
        end

    always @(posedge CLKDIV)
        begin
            ff6 <=  ff3;
            ff7 <=  ff2;
            ff8 <=  ff5;
            ff9 <=  ff4;
        end


    assign {Q1, Q2, Q3, Q4} = {ff6, ff7, ff8, ff9};

endmodule
// ****************************************************************************************************************************


// ****************************************************************************************************************************
module iserdes_2_bus # (
    parameter
        integer
            W  = 16,
            DATA_WIDTH = 4,
            NUM_CE = 1,

        string
            SERDES_MODE = "MASTER",
            INTERFACE_TYPE = "MASTER",
            DATA_RATE = "MASTER",
            IOBDELAY = "MASTER"
    )
    (
        input                                       RST,
        input                                       CLK,
        input                                       CLKB,
        input                                       OCLK,
        input                                       OCLKB,
        input                                       CLKDIV,
        input   [W - 1    : 0]                      D,
        input                                       CLKDIVP,
        input                                       BITSLIP,
        input                                       CE1,

        output  [W - 1    : 0]                      Q1,
        output  [W - 1    : 0]                      Q2,
        output  [W - 1    : 0]                      Q3,
        output  [W - 1    : 0]                      Q4
    );


    reg [W - 1    : 0] ff0, ff1, ff2, ff3, ff4, ff5, ff6, ff7, ff8, ff9;

    always @(posedge CLK)
        begin
            ff0 <=  D;
        end

    always @(negedge CLK)
        begin
            ff1 <=  D;
        end

    always @(posedge OCLK)
        begin
            ff2 <=  ff0;
            ff4 <=  ff2;
            ff5 <=  ff3;
        end

    always @(negedge OCLK)
        begin
            ff3 <=  ff1;
        end

    always @(posedge CLKDIV)
        begin
            ff6 <=  ff3;
            ff7 <=  ff2;
            ff8 <=  ff5;
            ff9 <=  ff4;
        end


    assign {Q1, Q2, Q3, Q4} = {ff6, ff7, ff8, ff9};

endmodule
// ****************************************************************************************************************************
