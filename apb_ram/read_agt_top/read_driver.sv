class read_driver extends uvm_driver #(packet);
    `uvm_component_utils(read_driver)

    read_agent_cfg cfg;
    virtual interface1.READ_DRV_MP vif;  // interface connection

    function new(string name, uvm_component parent = null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(! uvm_config_db #(read_agent_cfg)::get(this,"","read_agent_cfg",cfg))
            `uvm_fatal(get_type_name,"unable to get the config db")
        
    endfunction

    

    task run_phase(uvm_phase phase);
        forever begin
            seq_item_port.get_next_item(req);
                `uvm_info(get_type_name,$sformatf("printing from the driver \n %s",req.sprint()),UVM_LOW)
            // drive(req);
            seq_item_port.item_done();
        end

    endtask

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        vif = cfg.vif;

    endfunction

endclass