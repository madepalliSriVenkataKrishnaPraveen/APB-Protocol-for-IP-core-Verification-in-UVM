class read_agent_top extends uvm_env;
    `uvm_component_utils(read_agent_top)
    env_cfg m_cfg;
    read_agent agth[];

    function new(string name = "read_agent_top", uvm_component parent = null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(! uvm_config_db #(env_cfg)::get(this,"","env_cfg",m_cfg))
            `uvm_fatal("CONFIG","Cannot get the handle to environment configuration")

        agth = new[m_cfg.num_read_agent];
        foreach(agth[i]) begin
            uvm_config_db #(read_agent_cfg)::set(this,$sformatf("agth[%0d]*",i),"read_agent_cfg",m_cfg.m_rd_agent_cfg[i]); 
            agth[i] = read_agent::type_id::create($sformatf("agth[%0d]",i),this);
        end
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);


    endfunction

endclass