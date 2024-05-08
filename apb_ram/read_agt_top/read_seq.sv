class read_base_seq extends uvm_sequence #(packet);
    `uvm_object_utils(read_base_seq)


    function new(string name = "read_base_seq");
        super.new(name);
    endfunction

    task body();
        req = packet::type_id::create("req");
    endtask
endclass

class read_sequence1 extends read_base_seq;
    `uvm_object_utils(read_sequence1)


    function new(string name = "read_sequence1");
        super.new(name);
    endfunction

    task body();
        super.body();
        repeat(1) begin
            start_item(req);
            req.seq_name = get_type_name;
            `uvm_info(get_type_name,$sformatf("printing from the read sequences : \n %s",req.sprint()),UVM_LOW)
            #3;
            finish_item(req);
        end
    endtask
endclass