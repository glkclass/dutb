/******************************************************************************************************************************
    Project         :   dutb
    Creation Date   :   Dec 2015
    Class           :   dutb_db
    Description     :   Task        -   provide an interface to db(just a txt file) to store/load data
******************************************************************************************************************************/


// ****************************************************************************************************************************
class dutb_db extends uvm_object;
    `uvm_object_utils(dutb_db)

    int                     _fid;
    string                  _name;
    string                  mode;

    extern function             new(string name = "dutb_db", db_name = "dutb_db.txt", string db_mode = "IDLE");

    extern function int         open ();
    extern function void        close ();

    extern function void        write (vector content);
    extern function int         read (ref vector content);
    extern function void        final_phase(uvm_phase phase);

endclass
// ****************************************************************************************************************************


// ****************************************************************************************************************************
function dutb_db::new(string name = "dutb_db", db_name = "dutb_db.txt", string db_mode = "IDLE");
    super.new(name);
    _name = db_name;
    mode = db_mode;
    _fid = open();
endfunction


function int dutb_db::open();
    int fid;
    if ("WRITE" == mode)  // open for write data to 'dutb_db'
        begin
            fid = $fopen(_name, "w");
            if (0 == fid)
                begin
                    `uvm_fatal("FILEIO", {"Can't create 'dutb_db' file: ", _name})
                end
            else
                begin
                    `uvm_info("FILEIO", "'dutb_db' is opened for writing", UVM_HIGH)
                end
        end
    else if ("READ" == mode) // open for read data from 'dutb_db'
        begin
            fid = $fopen(_name, "r");
            if (0 == fid)
                begin
                    `uvm_fatal("FILEIO", {"Can't find 'dutb_db' file: ", _name, "!!"})
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
    if (0 != _fid)//'dutb_db' was opened
        begin
            $fclose(_fid);//close the 'dutb_db'
            `uvm_info("FILEIO", "'dutb_db' was closed", UVM_HIGH)            
        end
endfunction


function void dutb_db::write(vector content);
    if ("WRITE" == mode)
        begin
            if (0 == _fid)
                begin
                    `uvm_warning("FILEIO", "Can't write to 'dutb_db' since it is disabled!!")
                    return;
                end
            // store data
            foreach (content[i])
                begin
                    $fwrite (_fid, "%8h", content[i]);
                    $fwrite (_fid, "\n");
                end
            $fwrite (_fid, "\n");
            $fflush (_fid);
        end
    else 
        begin
            `uvm_warning("FILEIO", "Can't write to 'dutb_db' since it isn't opened for writing!!")
        end
endfunction


function int dutb_db::read(ref vector content);
    int ans = 0;
    if ("READ" == mode)  // 'dutb_db' is opened for reading
        begin
            if (0 == _fid)
                begin
                    `uvm_fatal("FILEIO", "Can't read from 'dutb_db' since it is disabled!!")
                    return 0;  // error
                end

            foreach (content[i])
                begin
                    ans = $fscanf (_fid, "%8h", content[i]);
                    if (1 != ans)
                        begin
                            `uvm_warning("FILEIO", "Can't read from 'dutb_db'!!")
                            return 0;  // error
                        end
                end
            // `uvm_debug({"Read\n", vector2str(content)})
            return 1;  // success
        end
    else  // wrong 'mode'
        begin
            `uvm_fatal("FILEIO", "Can't read from 'dutb_db' since it isn't opened for reading!!")
            return 0;  // error
        end
endfunction


function void dutb_db::final_phase(uvm_phase phase);
    close();
endfunction
// ****************************************************************************************************************************
