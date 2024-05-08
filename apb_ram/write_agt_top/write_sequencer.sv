class write_sequencer extends uvm_sequencer #(packet);  // write_sequencer
    `uvm_component_utils(write_sequencer)

    function new(string name = "write_sequencer", uvm_component parent = null);
        super.new(name,parent);
    endfunction
        
        
endclass