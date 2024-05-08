class write_monitor extends uvm_monitor;  // write_monitor 
    `uvm_component_utils(write_monitor)
    uvm_analysis_port #(packet) ana_write;   // To send data to scoreboard
    write_agent_cfg cfg;

   virtual interface1.WRITE_MON_MP vif;

   packet pkt;

    function new(string name = "write_monitor", uvm_component parent = null);
        super.new(name,parent);
        ana_write=new("ana_write",this);  // use ana_write.write(xtn); for sending the data to the scoreboard.
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(! uvm_config_db #(write_agent_cfg)::get(this,"","write_agent_cfg",cfg))
        `uvm_fatal("TF","cannot get the config")  // here the config db is for future use.

        pkt = packet::type_id::create("pkt");
    endfunction


    task run_phase(uvm_phase phase);
         @(vif.write_mon_cb);
        forever begin
            @(vif.write_mon_cb);
            $display("----------- in the write monitor : %t ",$time);
            collect();
        end
    endtask

    task collect();
        if(vif.write_mon_cb.presetn == 1'b0) begin
            pkt.op = rst;
            `uvm_info("MON", "SYSTEM RESET DETECTED", UVM_NONE);
            ana_write.write(pkt);
        end
        else if(vif.write_mon_cb.presetn && vif.write_mon_cb.pwrite) begin :  WRITED
            while(vif.write_mon_cb.pready == 0)
            @(vif.write_mon_cb);

            pkt.op = writed;
            pkt.pwdata = vif.write_mon_cb.pwdata;
            pkt.paddr = vif.write_mon_cb.paddr;
            pkt.pslverr = vif.write_mon_cb.pslverr;
            `uvm_info("MON", $sformatf("DATA WRITE addr:%0d data:%0d slverr:%0d",pkt.paddr,pkt.pwdata,pkt.pslverr), UVM_NONE); 
            ana_write.write(pkt);
        end : WRITED
        else if(vif.write_mon_cb.presetn && !vif.write_mon_cb.pwrite) begin : READD
            while(vif.write_mon_cb.pready == 0)
            @(vif.write_mon_cb);

            pkt.op = readd;
            pkt.paddr = vif.write_mon_cb.paddr;
            pkt.prdata = vif.write_mon_cb.prdata;
            pkt.pslverr = vif.write_mon_cb.pslverr;
            `uvm_info("MON", $sformatf("DATA READ addr:%0d data:%0d slverr:%0d",pkt.paddr,pkt.prdata,pkt.pslverr), UVM_NONE); 
            ana_write.write(pkt);
        end : READD
    endtask

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        vif = cfg.vif;  // interface connection
    endfunction
endclass