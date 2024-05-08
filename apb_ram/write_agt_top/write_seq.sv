class write_base_seq extends uvm_sequence #(packet);
    `uvm_object_utils(write_base_seq)

    function new(string name = "write_base_seq");
        super.new(name);
    endfunction


    task body();
        req = packet::type_id::create("req"); 
       
    endtask
endclass

class write_sequence1 extends write_base_seq;
    `uvm_object_utils(write_sequence1)


    function new(string name = "write_sequence1");
        super.new(name);
    endfunction


    task body();
        super.body();
        start_item(req);
        assert(req.randomize());
        req.seq_name = get_type_name();
        `uvm_info("write_seq",$sformatf("printing from sequence \n %s",req.sprint()),UVM_LOW)
        finish_item(req);
    endtask
endclass

class write_data extends write_base_seq;
    `uvm_object_utils(write_data)

    function new(string name = "write_data");
        super.new(name);
    endfunction
    task body();
        super.body();
        repeat(2) begin
        start_item(req);
        assert(req.randomize() with {op == writed;
        paddr <= 31;
        });
        req.seq_name = get_type_name;
        `uvm_info("write_seq",$sformatf("printing from sequence \n %s",req.sprint()),UVM_LOW)
        finish_item(req);
    end
    endtask
endclass

class read_data extends write_base_seq;
    `uvm_object_utils(read_data)

    function new(string name = "read_data");
        super.new(name);
    endfunction
    task body();
        super.body();
        repeat(2) begin
        start_item(req);
        assert(req.randomize() with {op == readd;
        paddr <= 31;
        });
        req.seq_name = get_type_name;
        `uvm_info("write_seq",$sformatf("printing from sequence \n %s",req.sprint()),UVM_LOW)
        finish_item(req);
        end
    endtask
endclass

class reset_dut extends write_base_seq;
    `uvm_object_utils(reset_dut)

    function new(string name = "reset_dut");
        super.new(name);
    endfunction
    task body();
        super.body();
        repeat(3) begin
        start_item(req);
        assert(req.randomize() with {op == rst;
        paddr <= 31;
        });
        req.seq_name = get_type_name;
        `uvm_info("write_seq",$sformatf("printing from sequence \n %s",req.sprint()),UVM_LOW)
        finish_item(req);
    end
    endtask
endclass

class pslv_err extends  write_base_seq;
    `uvm_object_utils(pslv_err)

    function new(string name = "pslv_err");
        super.new(name);
    endfunction

    task body();
        super.body();
        repeat(10) begin
            start_item(req);
            assert(req.randomize() with {op inside {writed,readd};
            paddr >= 32;
            });
            req.seq_name = get_type_name;
            `uvm_info("write_seq",$sformatf("printing from sequence \n %s",req.sprint()),UVM_LOW)
            finish_item(req);
        end
    endtask
endclass

//  write bulk and read bulk
class writeb_readb extends write_base_seq;
    `uvm_object_utils(writeb_readb)

    int paddr_ = 1;

    function new(string name = "writeb_readb");
        super.new(name);
    endfunction

    task body();
        super.body();
        // write operation
        repeat(1) begin
            start_item(req);
            assert(req.randomize() with {op == writed;
            paddr == paddr_;
        });
        req.seq_name = get_type_name;
        `uvm_info("write_seq",$sformatf("printing from sequence \n %s",req.sprint()),UVM_LOW)
        finish_item(req);

        // read operation
            start_item(req);
            assert(req.randomize() with {op == readd;
            paddr == paddr_;
        });
        req.seq_name = get_type_name;
        `uvm_info("write_seq",$sformatf("printing from sequence \n %s",req.sprint()),UVM_LOW)
            finish_item(req);
        paddr_++;
        end
    endtask
endclass

