class write_agent_cfg extends uvm_object;   // agent1 configuration
    `uvm_object_utils(write_agent_cfg)

    uvm_active_passive_enum is_active;
    virtual interface1 vif;

    function new(string name = "write_agent_cfg");
        super.new(name);
    endfunction

endclass