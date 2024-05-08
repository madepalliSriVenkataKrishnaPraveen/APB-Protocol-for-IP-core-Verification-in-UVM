class write_driver extends uvm_driver #(packet);  // write_driver 
    `uvm_component_utils(write_driver)
   virtual interface1.WRITE_DRV_MP vif;  // interface connection
    write_agent_cfg cfg;

    function new(string name = "write_driver", uvm_component parent = null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(! uvm_config_db #(write_agent_cfg)::get(this,"","write_agent_cfg",cfg))
        `uvm_fatal("TF","cannot get the config")  // here the config db is for future use.

    endfunction


    task run_phase(uvm_phase phase);  //////////////////-----1
        reset_dut();
        forever begin
            seq_item_port.get_next_item(req);    
                 drive(req);   // task  
                //  `uvm_info("DRIVER",$sformatf("Printing from the driver \n %s",req.sprint()),UVM_LOW)
            seq_item_port.item_done();
        end
    endtask

    task drive(packet pkt);
       if(pkt.op == rst) begin
        reset_dut();
       end
       else if(pkt.op == writed) begin
        vif.write_drv_cb.psel <= 1'b1;
        vif.write_drv_cb.paddr <= pkt.paddr;
        vif.write_drv_cb.pwdata <= pkt.pwdata;
        vif.write_drv_cb.presetn <= 1'b1;
        vif.write_drv_cb.pwrite <= 1'b1;
        @(vif.write_drv_cb);
        vif.write_drv_cb.penable <= 1'b1;
        while(vif.write_drv_cb.pready == 0)
            @(vif.write_drv_cb);
        vif.write_drv_cb.penable <= 1'b0;
        pkt.pslverr = vif.write_drv_cb.pslverr;
        @(vif.write_drv_cb);
       end
       else if(pkt.op == readd) begin
        vif.write_drv_cb.psel <= 1'b1;
        vif.write_drv_cb.paddr <= pkt.paddr;
        vif.write_drv_cb.presetn <= 1'b1;
        vif.write_drv_cb.pwrite <= 1'b0;
        @(vif.write_drv_cb);
        vif.write_drv_cb.penable <= 1'b1;
        while(vif.write_drv_cb.pready == 0)
            @(vif.write_drv_cb);
        vif.write_drv_cb.penable <= 1'b0;
        pkt.prdata = vif.write_drv_cb.prdata;
        pkt.pslverr = vif.write_drv_cb.pslverr;
        @(vif.write_drv_cb);
       end
    endtask

    task reset_dut();
        repeat(1) begin
            vif.write_drv_cb.presetn <= 1'b0;
            vif.write_drv_cb.paddr <= 'h0;
            vif.write_drv_cb.pwdata <= 'h0;
            vif.write_drv_cb.pwrite <= 'b0;
            vif.write_drv_cb.psel <= 'b0;
            vif.write_drv_cb.penable <= 'b0;
            `uvm_info("DRV", "System Reset : Start of Simulation", UVM_MEDIUM);
            @(vif.write_drv_cb);
        end
    endtask
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        vif = cfg.vif;  // configuration connection
    endfunction
endclass