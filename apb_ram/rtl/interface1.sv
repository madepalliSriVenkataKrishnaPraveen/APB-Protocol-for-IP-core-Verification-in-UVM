interface interface1(input bit clk);
// properties
    logic presetn, psel, penable, pwrite, pready, pslverr;
    logic [31:0] prdata, paddr, pwdata;

    clocking write_drv_cb@(posedge clk);
        default input #1 output #1;
        output presetn, psel, penable, pwrite, pwdata, paddr;
        input prdata, pready, pslverr;
    endclocking
    clocking write_mon_cb@(posedge clk);
        default input #1 output #1;
        input presetn, psel, penable, pwrite, pwdata, paddr,prdata,pready, pslverr;
    endclocking
//--------------------------------------------------------
    clocking read_drv_cb@(posedge clk);
        default input #1 output #1;

    endclocking
    clocking read_mon_cb@(posedge clk);
        default input #1 output #1;

    endclocking



    modport WRTIE_DRV_MP(clocking write_drv_cb);
    modport WRITE_MON_MP(clocking write_mon_cb);

    modport READ_DRV_MP(clocking read_drv_cb);
    modport READ_MON_MP(clocking read_mon_cb);
endinterface