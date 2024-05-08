module top;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import pkg::*;
bit clock;
always begin : CLOCK
    #5 clock = ~clock;
end

interface1 write_vif(clock);
interface1 read_vif(clock);

// dut instantiation
apb_ram DUT(.presetn(write_vif.presetn) , .pclk(clock) , .psel(write_vif.psel) , .penable(write_vif.penable) , .pwrite(write_vif.pwrite) , .paddr(write_vif.paddr) , . pwdata(write_vif.pwdata) , . prdata(write_vif.prdata) , .pready(write_vif.pready) , .pslverr(write_vif.pslverr) ); 

initial begin
    uvm_config_db #(virtual interface1)::set(null,"*","write_vif",write_vif);
    uvm_config_db #(virtual interface1)::set(null,"*","read_vif",read_vif);
    run_test();
end

endmodule