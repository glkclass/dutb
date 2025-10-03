/******************************************************************************************************************************
    Project         :   dutb
    Creation Date   :   Dec 2015
    Class           :   dutb_env
    Description     :
******************************************************************************************************************************/


// ****************************************************************************************************************************
class dutb_env#(parameter integer N_AGNT = 2, N_SCB = 1) extends uvm_env;
    `uvm_component_param_utils(dutb_env)

    dutb_if_proxy_base                                          dutb_if_h;
    dutb_agent                                                  agent_h[N_AGNT];
    dut_scb                                                     scb_h[N_SCB];

    uvm_barrier                                                 synch_seq_br_h;

    extern function                                             new(string name, uvm_component parent = null);
    extern function void                                        build_phase(uvm_phase phase);
    extern function void                                        connect_phase(uvm_phase phase);
    extern task                                                 run_phase(uvm_phase phase);
endclass
// ****************************************************************************************************************************


// ****************************************************************************************************************************
function dutb_env::new(string name, uvm_component parent = null);
    super.new(name, parent);
    synch_seq_br_h = new ("synch_seq_br_h", 2);
endfunction


function void dutb_env::build_phase(uvm_phase phase);
    // create dut_if_proxy and provide env members with it
    dutb_if_h = dutb_if_proxy_base::type_id::create("dutb_if_h", this);
    uvm_config_db #(dutb_if_proxy_base)::set(this, "*", "dutb_if_h", dutb_if_h);

    // create number of agents and configure them
    for (int i = 0; i < N_AGNT; i++)
        begin
            bit foo;
            agent_h[i] = dutb_agent::type_id::create($sformatf("agent_h[%0d]", i), this);

            if (uvm_config_db #(bit)::get(this, "", $sformatf("agent_h[%0d]_has_driver", i), foo))
                agent_h[i].has_driver = foo;

            if (uvm_config_db #(bit)::get(this, "", $sformatf("agent_h[%0d]_has_monitor", i), foo))
                agent_h[i].has_monitor = foo;
        end

    // create number of scoreboards
    for (int i = 0; i < N_SCB; i++)
        begin
            scb_h[i] = dut_scb::type_id::create($sformatf("scb_h[%0d]", i), this);
        end
endfunction


function void dutb_env::connect_phase(uvm_phase phase);
    // subscribe scoreboards on agents according to db config
    for (int i = 0; i < N_SCB; i++)
        begin
            int agent_idx[2], scb_configured;

            agent_idx[0] = 0;
            agent_idx[1] = 0;
            scb_configured =    (uvm_config_db #(int)::get(this, "", $sformatf("scb_h[%0d]_in_port[0]", i), agent_idx[0])) &
                                (uvm_config_db #(int)::get(this, "", $sformatf("scb_h[%0d]_in_port[1]", i), agent_idx[1]));

            if (
                (1'b1 == scb_configured) &&
                (agent_idx[0] >= 0 && agent_idx[0] < N_AGNT) &&
                (agent_idx[1] >= 0 && agent_idx[1] < N_AGNT) &&
                agent_h[agent_idx[0]].has_monitor &&
                agent_h[agent_idx[1]].has_monitor
                )
                begin
                    // `uvm_debug($sformatf("%0d %0d", agent_idx[0], agent_idx[1]))
                    agent_h[agent_idx[0]].monitor_h.aport.connect(scb_h[i].in_port[0]);
                    agent_h[agent_idx[1]].monitor_h.aport.connect(scb_h[i].in_port[1]);
                end
            else
                begin
                    `uvm_error("ENV", $sformatf("Scb #%0d is not fully connected!", i))
                    `uvm_debug($sformatf("%0d %0d %0d", scb_configured, agent_idx[0], agent_idx[1]))
                end
        end
endfunction


task dutb_env::run_phase(uvm_phase phase);
endtask





// ****************************************************************************************************************************
