class virtual_seq extends uvm_sequence #(uvm_sequence_item);
    `uvm_object_utils(virtual_seq)

    write_sequencer wr_seqrh[];
    read_sequencer rd_seqrh[];

    virtual_sequencer vseqrh;
    env_cfg m_cfg;

    write_base_seq  seq_test;////
    read_base_seq seq_test_r; /////

    function new(string name = "virtual_seq");
        super.new(name);
    endfunction 

    task body();
        if(! uvm_config_db #(env_cfg)::get(null,get_full_name(),"env_cfg",m_cfg))
            `uvm_fatal("BRIDGE VIRTUAL SEQS","cannot get the env_cfg.")

        wr_seqrh = new[m_cfg.num_write_agent];
        rd_seqrh = new[m_cfg.num_read_agent];

        assert($cast(vseqrh,m_sequencer))///////////////////

        foreach(wr_seqrh[i]) 
                wr_seqrh[i] = vseqrh.wr_seqrh[i];

        foreach(rd_seqrh[i])
                rd_seqrh[i] = vseqrh.rd_seqrh[i];

    endtask

endclass

class demo_seq extends virtual_seq;
    `uvm_object_utils(demo_seq)

    function new(string name = "demo_seq");
        super.new(name);
    endfunction

    task body();
        super.body();

        seq_test = write_base_seq::type_id::create("seq_test"); // from the write sequence
        seq_test_r = read_base_seq::type_id::create("seq_test_r");  // from the read sequence
        fork begin
            if(m_cfg.has_write_agent) begin
               foreach(wr_seqrh[i])  begin
                    seq_test.start(wr_seqrh[i]);
               end
            end
            if(m_cfg.has_read_agent) begin
                foreach(rd_seqrh[i]) begin
                    seq_test_r.start(rd_seqrh[i]);
                end
            end
        end
    join
    endtask
endclass