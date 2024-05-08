class environment extends uvm_env;
    `uvm_component_utils(environment)

    env_cfg m_cfg;
    scoreboard sbh;
   // virtual_sequencer vseqrh;

    write_agent_top wr_agt_top;
    read_agent_top rd_agt_top;

    function new(string name = "environment", uvm_component parent = null);
        super.new(name,parent);
    endfunction

function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(! uvm_config_db #(env_cfg)::get(this,"","env_cfg",m_cfg))
            `uvm_fatal("CONFIG","unable to get the config db")

        if(m_cfg.has_write_agent)
            wr_agt_top = write_agent_top::type_id::create("wr_agt_top",this);
        if(m_cfg.has_read_agent)
            rd_agt_top = read_agent_top::type_id::create("rd_agt_top",this);
        if(m_cfg.has_vseqr)
           // vseqrh = virtual_sequencer::type_id::create("vseqrh",this);
        if(m_cfg.has_sb)
            sbh = scoreboard::type_id::create("sbh",this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase); 
                if(m_cfg.has_sb) begin
                        // scoreboard connection
                        if(m_cfg.has_write_agent)
                            for(int i=0;i<m_cfg.num_write_agent;i++) begin
                                wr_agt_top.agth[i].monh.ana_write.connect(sbh.fifo_write[i].analysis_export);
                            end
                        if(m_cfg.has_read_agent)
                            for(int i=0;i<m_cfg.num_read_agent;i++) begin
                                rd_agt_top.agth[i].monh.ana_read.connect(sbh.fifo_read[i].analysis_export);
                        end
                end
    endfunction

endclass