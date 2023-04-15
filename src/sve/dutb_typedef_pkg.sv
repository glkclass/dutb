/******************************************************************************************************************************
    Project         :   dutb
    Creation Date   :   Dec 2015
    Package         :   dutb_pkg
    Description     :   Contain user defined types
******************************************************************************************************************************/


// ****************************************************************************************************************************
package dutb_typedef_pkg;
    import uvm_pkg::*;
    
    typedef     uvm_sequence #(uvm_sequence_item)   uvm_virtual_sequence;
    
    typedef     logic   [7 : 0]                     byte_4st;
    typedef     int                                 vector [];
    typedef     byte                                byte_vector [];
    typedef     real                                map_flt [string];
    typedef     int                                 map_int [string];

    typedef     enum    {
                            IDLE = 0,
                            READ = 1,
                            WRITE = 2
                        }                           t_db_mode;
endpackage
// ****************************************************************************************************************************

