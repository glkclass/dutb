/******************************************************************************************************************************
    Project         :   dutb
    Creation Date   :   Dec 2015
    Class           :   dutb_db
    Description     :   Task        -   provide an interface to db(just a txt file) to store/load data
******************************************************************************************************************************/


// ****************************************************************************************************************************
class dutb_db extends uvm_component;
     // `uvm_component_utils(dutb_db)

    int                     db_fid;
    t_db_mode               db_mode;
    string                  db_name;

    extern function             new(string name = "dutb_db", db_name = "dutb_db.txt", t_db_mode db_mode = IDLE,  uvm_component parent=null);

    extern function int         open ();
    extern function void        close ();

    extern function void        write (vector content);
    extern function int         read (ref vector content);
    extern function void        final_phase(uvm_phase phase);

endclass
// ****************************************************************************************************************************


// ****************************************************************************************************************************
function dutb_db::new(string name = "dutb_db", db_name = "dutb_db.txt", t_db_mode db_mode = IDLE,  uvm_component parent=null);
    super.new(name, parent);
    this.db_name = db_name;
    this.db_mode = db_mode;
    db_fid = open();
endfunction


function int dutb_db::open();
    int fid;
    if (WRITE == db_mode)  // open for write data to 'dutb_db'
        begin
            fid = $fopen(db_name, "w");
            if (0 == fid)
                begin
                    `uvm_fatal("FILEIO", {"Can't create 'dutb_db' file: ", db_name})
                end
            else
                begin
                    `uvm_info("FILEIO", "'dutb_db' is opened for writing", UVM_HIGH)
                end
        end
    else if (READ == db_mode) // open for read data from 'dutb_db'
        begin
            fid = $fopen(db_name, "r");
            if (0 == fid)
                begin
                    `uvm_fatal("FILEIO", {"Can't find 'dutb_db' file: ", db_name, "!!"})
                end
            else
                begin
                    `uvm_info("FILEIO", "'dutb_db' is opened for reading", UVM_HIGH)
                end
        end
    else
        begin
            `uvm_info("FILEIO", "'dutb_db' is disabled", UVM_HIGH)
        end
    return fid;
endfunction


function void dutb_db::close();
    if (0 != db_fid)//'dutb_db' was opened
        begin
            $fclose(db_fid);//close the 'dutb_db'
            `uvm_info("FILEIO", "'dutb_db' was closed", UVM_HIGH)            
        end
endfunction


function void dutb_db::write(vector content);
    if (WRITE == db_mode)
        begin
            if (0 == db_fid)
                begin
                    `uvm_warning("FILEIO", "Can't write to 'dutb_db' since it is disabled!!")
                    return;
                end
            // store data
            foreach (content[i])
                begin
                    $fwrite (db_fid, "%8h", content[i]);
                    $fwrite (db_fid, "\n");
                end
            $fwrite (db_fid, "\n");
            $fflush (db_fid);
        end
    else 
        begin
            `uvm_warning("FILEIO", "Can't write to 'dutb_db' since it isn't opened for writing!!")
        end
endfunction


function int dutb_db::read(ref vector content);
    int ans = 0;
    if (READ == db_mode)  // 'dutb_db' is opened for reading
        begin
            if (0 == db_fid)
                begin
                    `uvm_fatal("FILEIO", "Can't read from 'dutb_db' since it is disabled!!")
                    return 0;  // error
                end

            foreach (content[i])
                begin
                    ans = $fscanf (db_fid, "%8h", content[i]);
                    if (1 != ans)
                        begin
                            `uvm_fatal("FILEIO", "Can't read from 'dutb_db'!!")
                            return 0;  // error
                        end
                end
            return 1;  // success
        end
    else  // wrong 'db_mode'
        begin
            `uvm_fatal("FILEIO", "Can't read from 'dutb_db' since it isn't opened for reading!!")
            return 0;  // error
        end
endfunction


function void dutb_db::final_phase(uvm_phase phase);
    close();
endfunction
// ****************************************************************************************************************************
