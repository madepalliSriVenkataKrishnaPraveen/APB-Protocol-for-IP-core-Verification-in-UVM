class read_agent_cfg extends uvm_object;  // agent2 configuration
    `uvm_object_utils(read_agent_cfg)

    uvm_active_passive_enum is_active;
   virtual interface1 vif; 

    function new(string name = "read_agent_cfg");
        super.new(name);
    endfunction

endclass