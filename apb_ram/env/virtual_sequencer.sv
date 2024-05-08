class virtual_sequencer extends uvm_sequencer #(uvm_sequence_item);  // virtual sequencer-------
    `uvm_component_utils(virtual_sequencer)

    env_cfg m_cfg;
    write_sequencer wr_seqrh[];
    read_sequencer rd_seqrh[];

function new(string name = "virtual_sequencer",uvm_component parent = null);
    super.new(name,parent);
endfunction

virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(! uvm_config_db #(env_cfg)::get(this,"","env_cfg",m_cfg))
        `uvm_fatal("VIRTUAL SEQUENCER","unable to get the config db.")
    wr_seqrh = new[m_cfg.num_write_agent];
    rd_seqrh = new[m_cfg.num_read_agent];
endfunction
endclass

