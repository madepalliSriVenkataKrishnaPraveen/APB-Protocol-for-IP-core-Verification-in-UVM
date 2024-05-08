class scoreboard extends uvm_scoreboard;
    `uvm_component_utils(scoreboard)
    uvm_tlm_analysis_fifo #(packet) fifo_write[];
    uvm_tlm_analysis_fifo #(packet) fifo_read[];

    env_cfg m_env_cfg;

    packet pkt;

    bit[31:0] arr[32] = '{default: 0}; // array to keep track of the data written/read by each address
    bit [31:0] addr = 0;
    bit [31:0] data_rd = 0;

    function new(string name = "scoreboard",uvm_component parent = null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(! uvm_config_db #(env_cfg)::get(this,"","env_cfg",m_env_cfg))
            `uvm_fatal("CONFIG","cannot get the env_cfg")

        fifo_read = new[m_env_cfg.num_read_agent];
        fifo_write = new[m_env_cfg.num_write_agent];

        // create the tlm analysis fifo
        foreach(fifo_read[i]) 
                fifo_read[i] = new($sformatf("fifo_read[%0d]",i),this);
        foreach(fifo_write[i])
                fifo_write[i] = new($sformatf("fifo_write[%0d]",i),this);
        
    endfunction
        
        task run_phase(uvm_phase phase);
            forever begin
                foreach(fifo_write[i]) begin
                      fifo_write[i].get(pkt);
                      pkt.seq_name = "write_seq";
                end
                foreach(fifo_read[i]) begin
                    //   fifo_read[i].get(pkt);
                    //   pkt.seq_name = "read_seq";
                end
      
                compare(); // it has to be included in the forever loop.
              end
        endtask

        task compare();
            if(pkt.op == rst) begin
                `uvm_info(get_type_name(),"system reset detected",UVM_LOW)
            end
            else if(pkt.op == writed) begin
                if(pkt.pslverr == 1'b1) begin
                    `uvm_info("SCO", "SLV ERROR during WRITE OP", UVM_NONE);
                end
                else begin
                    arr[pkt.paddr] = pkt.pwdata;
                    `uvm_info("SCO",$sformatf("DATA WRITE OP paddr:%0d, pwdata:%0d, arr_wr:%0d",pkt.paddr,pkt.pwdata,arr[pkt.paddr]),UVM_LOW)
                    //`uvm_info("SCO", "WRITE OKAY", UVM_NONE)
                end
            end
            else if(pkt.op == readd) begin
                if(pkt.pslverr == 1'b1) begin
                    `uvm_info("SCO", "SLV ERROR during READ OP", UVM_NONE);
                end
                else begin
                    data_rd = arr[pkt.paddr];
                    if(data_rd == pkt.prdata)
                        `uvm_info(get_type_name(), $sformatf("DATA MATCHED : paddr:%0d, prdata: %0d",pkt.paddr, pkt.prdata),UVM_LOW)
                    else
                    `uvm_fatal(get_type_name(), $sformatf("TEST FAILED : paddr:%0d, prdata: %0d, data_rd_arr:%0d",pkt.paddr, pkt.prdata,data_rd)) 
                // `uvm_info("SCO", "READ OKAY", UVM_NONE)
            end
        end
            $display("----------------------------------------------------------------");  
        endtask
endclass