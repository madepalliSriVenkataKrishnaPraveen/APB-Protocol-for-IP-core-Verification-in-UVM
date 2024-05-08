class read_agent extends uvm_agent;
    `uvm_component_utils(read_agent)

    read_driver drvh;
    read_monitor monh;
    read_sequencer seqrh;
    read_agent_cfg read_agt_cfg;


    function new(string name = "read_agent", uvm_component parent = null);
        super.new(name,parent);
    endfunction


    function  void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(! uvm_config_db #(read_agent_cfg)::get(this,"","read_agent_cfg",read_agt_cfg))
            `uvm_fatal("TF","cannot get")

        monh = read_monitor::type_id::create("monh",this);

        if(read_agt_cfg.is_active == UVM_ACTIVE) begin
        drvh = read_driver::type_id::create("drvh", this);
        seqrh = read_sequencer::type_id::create("seqrh",this);
        end

    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        // driver to seqr connection
        if(read_agt_cfg.is_active == UVM_ACTIVE)
            drvh.seq_item_port.connect(seqrh.seq_item_export);  ///////////////////

    endfunction
endclass