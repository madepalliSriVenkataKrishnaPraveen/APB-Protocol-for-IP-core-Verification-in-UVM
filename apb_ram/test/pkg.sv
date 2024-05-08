//  Package: pkg
//
package pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

//////////////////////////////////////////////
typedef enum bit [1:0]   {readd = 0, writed = 1, rst = 2} oper_mode;
//////////////////////////////////////////////


`include"packet.sv"   

`include "write_agent_cfg.sv" 
`include "read_agent_cfg.sv"
`include "env_cfg.sv"

`include "write_sequencer.sv"    
`include "write_driver.sv"
`include "write_monitor.sv"
`include "write_agent.sv"
`include "write_agt_top.sv"
`include "write_seq.sv"

`include "read_sequencer.sv"
`include "read_driver.sv"
`include "read_monitor.sv"   
`include "read_agent.sv"
`include "read_agt_top.sv"
`include "read_seq.sv"

`include "scoreboard.sv"    
// `include "virtual_sequencer.sv"
// `include "virtual_seq.sv"  
`include "env.sv"  


`include "test.sv"    
endpackage
