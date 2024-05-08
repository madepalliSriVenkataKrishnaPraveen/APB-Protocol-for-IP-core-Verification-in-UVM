class write_agent_top extends uvm_env;  // write_agent_top----3---
    `uvm_component_utils(write_agent_top)

    env_cfg m_cfg;  // env config handle
    write_agent agth[];  // write_agent handle

    function new(string name = "write_agent_top", uvm_component parent = null);
        super.new(name,parent);

    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(! uvm_config_db #(env_cfg)::get(this,"","env_cfg",m_cfg))
            `uvm_fatal("CONFIG","cannot get the m_cfg")
        agth = new[m_cfg.num_write_agent];
        foreach(agth[i]) begin
            uvm_config_db #(write_agent_cfg)::set(this,$sformatf("agth[%0d]*",i),"write_agent_cfg",m_cfg.m_wr_agent_cfg[i]);
            agth[i] = write_agent::type_id::create($sformatf("agth[%0d]",i),this);
        end
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);


    endfunction
endclass