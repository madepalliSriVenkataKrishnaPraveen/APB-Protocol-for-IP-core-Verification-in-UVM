class read_monitor extends uvm_monitor;
    `uvm_component_utils(read_monitor)
    uvm_analysis_port #(packet) ana_read;
    virtual interface1.READ_MON_MP vif;  // interface connection
    read_agent_cfg cfg;

    function new(string name = "read_monitor",uvm_component parent = null);
        super.new(name,parent);
        ana_read=new("ana_read",this);  //creating analysis port
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(! uvm_config_db #(read_agent_cfg)::get(this,"","read_agent_cfg",cfg))
            `uvm_fatal(get_type_name,"unable to get the config db")
    endfunction


    task run_phase(uvm_phase phase);
        forever 
            begin
            $display("------------- in the read monitor ------------------ : %t",$time);
            @(vif.read_mon_cb);
            // collect_data();
            end

    endtask

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        vif = cfg.vif;
    endfunction

endclass