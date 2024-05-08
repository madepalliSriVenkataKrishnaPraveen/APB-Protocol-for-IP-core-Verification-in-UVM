class test extends uvm_test;
`uvm_component_utils(test)
    environment envh;

    // configuration handles as we are configuring from the test class
    env_cfg m_cfg;
    //-----------------------------
    read_sequence1 read_seq1;
    write_sequence1 write_seq1;

    write_data write_datah;

    read_data read_datah;

    reset_dut reset_duth;

    pslv_err pslv_errh;  // for pslverr checking

    writeb_readb writeb_readbh;
    //-----------------------------
    // configuring the test bench hierarchy.
    bit has_write_agent = 1'b1;
    bit has_read_agent = 1'b0;
    bit has_sb = 1'b1;
    bit has_vseqr = 1'b1;
    int num_write_agent = 1;
    int num_read_agent = 1;

    function new(string name = "test", uvm_component parent = null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        m_cfg = env_cfg::type_id::create("m_cfg");  // obj for the env_cfg

        if(has_write_agent) begin
            m_cfg.m_wr_agent_cfg = new[num_write_agent];
            foreach(m_cfg.m_wr_agent_cfg[i]) begin
                m_cfg.m_wr_agent_cfg[i] = write_agent_cfg::type_id::create($sformatf("m_write_agent_cfg[%0d]",i));

                if(! uvm_config_db #(virtual interface1)::get(this,"","write_vif",m_cfg.m_wr_agent_cfg[i].vif))  // getting the config and setting it in the write agent configuration.
                    `uvm_fatal(get_type_name,"unable to get the config db, have you set it ?")

                
                m_cfg.m_wr_agent_cfg[i].is_active = UVM_ACTIVE;
            end

        end
        if(has_read_agent) begin
            m_cfg.m_rd_agent_cfg = new[num_read_agent];
            foreach(m_cfg.m_rd_agent_cfg[i]) begin
                m_cfg.m_rd_agent_cfg[i] = read_agent_cfg::type_id::create($sformatf("m_read_agent_cfg[%0d]", i));

                if(! uvm_config_db #(virtual interface1)::get(this,"","read_vif",m_cfg.m_rd_agent_cfg[i].vif))  // getting the config and setting it in the read agent configuration.
                    `uvm_fatal(get_type_name,"unable to get the config db, have you set it ?")

                m_cfg.m_rd_agent_cfg[i].is_active = UVM_ACTIVE;
            end

        end

        m_cfg.has_write_agent = has_write_agent;
        m_cfg.has_read_agent = has_read_agent;
        m_cfg.has_sb = has_sb;
        m_cfg.has_vseqr = has_vseqr;
        m_cfg.num_write_agent = num_write_agent;
        m_cfg.num_read_agent = num_read_agent;

        uvm_config_db #(env_cfg)::set(this,"*","env_cfg",m_cfg);   // setting the obj for the env_cfg
        envh = environment::type_id::create("envh",this);
    endfunction

    virtual function void end_of_elaboration_phase(uvm_phase phase);
        uvm_top.print_topology();
    endfunction

endclass

class demo_test extends test;
    `uvm_component_utils(demo_test)

    function new(string name = "demo_test",uvm_component parent);
        super.new(name,parent);
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
            write_seq1 = write_sequence1::type_id::create("write_seq1");
            read_seq1 = read_sequence1::type_id::create("read_seq1");
            if(has_write_agent)
            write_seq1.start(envh.wr_agt_top.agth[0].seqrh);
            if(has_read_agent)
            read_seq1.start(envh.rd_agt_top.agth[0].seqrh);
            #60;            
        phase.drop_objection(this);
    endtask
endclass

class write_data_test extends test;
    `uvm_component_utils(write_data_test)

    function new(string name = "write_data_test",uvm_component parent=null);
        super.new(name,parent);
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        write_datah = write_data::type_id::create("write_datah");
        write_datah.start(envh.wr_agt_top.agth[0].seqrh);
        #60;
        phase.drop_objection(this);
    endtask
endclass

class read_data_test extends test;
    `uvm_component_utils(read_data_test)

    function new(string name = "read_data_test", uvm_component parent = null);
        super.new(name,parent);
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        read_datah = read_data::type_id::create("read_datah");
        read_datah.start(envh.wr_agt_top.agth[0].seqrh);
        #60;
        phase.drop_objection(this);
    endtask
endclass

class reset_dut_test extends test;
    `uvm_component_utils(reset_dut_test)

    function new(string name = "reset_dut_test", uvm_component parent = null);
        super.new(name,parent);
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        reset_duth = reset_dut::type_id::create("reset_duth");
        reset_duth.start(envh.wr_agt_top.agth[0].seqrh);
        #60;
        phase.drop_objection(this);
    endtask
endclass

class pslv_err_test extends test;
    `uvm_component_utils(pslv_err_test)

    function new(string name = "pslv_err_test",uvm_component parent=null);
        super.new(name,parent);
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        pslv_errh = pslv_err::type_id::create("pslv_errh");
        pslv_errh.start(envh.wr_agt_top.agth[0].seqrh);
        #60;
        phase.drop_objection(this);
    endtask
endclass

class writeb_readb_test extends test;  // run_test9
    `uvm_component_utils(writeb_readb_test)

    function new(string name = "writeb_readb",uvm_component parent = null);
        super.new(name,parent);
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        writeb_readbh = writeb_readb::type_id::create("writeb_readbh");
        writeb_readbh.start(envh.wr_agt_top.agth[0].seqrh);
        #130;
        phase.drop_objection(this);
    endtask
endclass