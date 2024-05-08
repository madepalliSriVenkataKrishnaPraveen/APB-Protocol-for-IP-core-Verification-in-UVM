class packet extends uvm_sequence_item;
    `uvm_object_utils(packet)
    
    rand oper_mode op;
    rand bit presetn;
    bit pwrite;
    bit psel;
    bit penable;

    rand bit [31:0] pwdata;
    rand bit [31:0] paddr;

    // output signals of dut for apb uart's transaction

    bit pready; 
    bit pslverr;
    bit [31:0] prdata;
    
    string seq_name;

    function new(string name = "packet");
        super.new(name);
    endfunction

    function void do_print(uvm_printer printer);
        super.do_print(printer);
        //             string_name   bit_stream  size  radix for printing
        //printer.print_field_int("data_in" , this.d_in,  $bits(d_in) ,UVM_DEC);
        printer.print_field("presetn",this.presetn,1,UVM_BIN);
        printer.print_field("pwrite",this.pwrite,1,UVM_BIN);
        printer.print_field("psel",this.psel,1,UVM_BIN);
        printer.print_field("penable",this.penable,1,UVM_BIN);
        printer.print_field("pwdata", this.pwdata, 32 ,UVM_DEC);
        printer.print_field("prdata", this.prdata, 32 ,UVM_DEC);
        printer.print_field("paddr", this.paddr, 32 ,UVM_DEC);
        printer.print_field("pready", this.pready,1,UVM_BIN);
        printer.print_field("pslverr", this.pslverr,1, UVM_BIN);
        // for printing the enum.
        // printer.print_generic( "property_name", 		"enum_name",$bits(property_name),property_name.name);
        printer.print_generic( "op","oper_mode",$bits(op),		op.name);
        printer.print_string("seq_name",seq_name);
      //  printer.print_object();
    endfunction

endclass