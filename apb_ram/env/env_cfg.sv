class env_cfg extends uvm_object;
    `uvm_object_utils(env_cfg)

    bit has_write_agent;
    int num_write_agent;  // for no.of agent1's

    bit has_read_agent;
    int num_read_agent;  // for no.of agent2's

    bit has_sb;
    bit has_vseqr;

    write_agent_cfg  m_wr_agent_cfg[];   // write config
    read_agent_cfg  m_rd_agent_cfg[];       // read  config
  

    function new(string name = "env_cfg");
        super.new(name);
    endfunction

endclass