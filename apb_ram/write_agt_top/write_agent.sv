class write_agent extends uvm_agent;  // write_agent
    `uvm_component_utils(write_agent)

    write_driver drvh;
    write_monitor monh;
    write_sequencer seqrh;
    write_agent_cfg write_agt_cfg;

    function new(string name = "write_agent", uvm_component parent = null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(! uvm_config_db #(write_agent_cfg)::get(this,"","write_agent_cfg",write_agt_cfg))
	        `uvm_fatal("CONFIG","cannot get() write_agt_cfg from uvm_config_db. Have you set() it?")
        monh = write_monitor::type_id::create("monh",this);
        if(write_agt_cfg.is_active == UVM_ACTIVE) begin
            drvh = write_driver::type_id::create("drvh",this);
            seqrh = write_sequencer::type_id::create("seqrh",this);
        end
endfunction

function void connect_phase(uvm_phase phase);
super.connect_phase(phase);

// driver to seqr connection
if(write_agt_cfg.is_active == UVM_ACTIVE)
    drvh.seq_item_port.connect(seqrh.seq_item_export);  ///////////////////
endfunction

endclass