`default_nettype none

  module memif_top
    (
     input wire 	ref_clk, //100MHz
     input wire 	reset,
     input wire 	write_start_triger,
     input wire 	read_start_triger,
     //output wire 	local_init_done,

     //SDRAM Interface
     output wire [12:0] memory_mem_a,
     output wire [1:0] 	memory_mem_ba,

     output wire [0:0] 	memory_mem_cke,
     output wire [0:0] 	memory_mem_cs_n,

     output wire [0:0] 	memory_mem_ras_n,
     output wire [0:0] 	memory_mem_cas_n,
     output wire [0:0] 	memory_mem_we_n,

     inout wire [15:0] 	memory_mem_dq,
     output wire [1:0] 	memory_mem_dqm


     );



   
   
   
   wire 		avl_wait_requeset_w0;
   wire 		avl_write_w0;
   wire [7: 0] 		avl_size_w0;
   wire [24: 0] 	avl_addr_w0;  
   wire [15: 0] 	avl_wdata_w0;


   wire 		afi_reset;
   

   avm_write_control u_avm_write_control
     (
      .clk(ref_clk),
      .reset(afi_reset),
      .start_triger(write_start_triger),
      
      //avl interface
      .avl_wait_req_in(avl_wait_requeset_w0),

      .avl_write_out(avl_write_w0),
      .avl_wdata_out(avl_wdata_w0), //[15: 0]
      .avl_size_out(avl_size_w0), //[7: 0]
      .avl_addr_out(avl_addr_w0) //[24: 0]



      );

   wire 		avl_readvalid_r0;
   
   wire 		avl_wait_request_r0;
   wire 		avl_read_r0;
   wire [7: 0] 		avl_size_r0;
   wire [24: 0] 	avl_addr_r0;
   wire [15: 0] 	avl_rdata_r0;
   
   
   avm_read_control u_avm_read_control
     (
      .clk(ref_clk),
      .reset(afi_reset),
      .start_triger(read_start_triger),
      
      //avl interface
      .avl_wait_req_in(avl_wait_request_r0),

      .avl_read_valid_in(avl_readvalid_r0),
      .rdata_in(avl_rdata_r0),  //[15: 0]

      .avl_read_out(avl_read_r0),
      .avl_size_out(avl_size_r0), //[7: 0]
      .avl_addr_out(avl_addr_r0)  //[24: 0]
      
      );

   //SDRAM
   sdram_qsys u_sdram_qsys
     (
      //read
      .avm_simple_read_0_avm_m0_address({avl_addr_r0, 1'b0}), //[25: 0]
      .avm_simple_read_0_avm_m0_read(avl_read_r0), 
      .avm_simple_read_0_avm_m0_waitrequest(avl_wait_request_r0), 
      .avm_simple_read_0_avm_m0_readdata(avl_rdata_r0), //[15: 0]
      .avm_simple_read_0_avm_m0_readdatavalid(avl_readvalid_r0), //    
      .avm_simple_read_0_avm_m0_burstcount(avl_size_r0), // [7: 0]
      .avm_simple_read_0_reset_reset(), //  
      //write
      .avm_simple_write_0_avm_m0_address({avl_addr_w0, 1'b0}), // [25: 0]
      .avm_simple_write_0_avm_m0_waitrequest(avl_wait_requeset_w0), //
      .avm_simple_write_0_avm_m0_write(avl_write_w0), // 
      .avm_simple_write_0_avm_m0_writedata(avl_wdata_w0), // [15: 0]
      .avm_simple_write_0_avm_m0_burstcount(avl_size_w0), // [7: 0]
      .avm_simple_write_0_reset_reset(afi_reset), // output

      //SDR Interface
      .new_sdram_controller_0_wire_addr(memory_mem_a), // [12: 0] output
      .new_sdram_controller_0_wire_ba(memory_mem_ba), //  [1: 0] output
      .new_sdram_controller_0_wire_cas_n(memory_mem_cas_n), //  output
      .new_sdram_controller_0_wire_cke(memory_mem_cke), //    output       
      .new_sdram_controller_0_wire_cs_n(memory_mem_cs_n), //  output                  
      .new_sdram_controller_0_wire_dq(memory_mem_dq), //  [15: 0] inout
      .new_sdram_controller_0_wire_dqm(memory_mem_dqm), //  [1: 0] output
      .new_sdram_controller_0_wire_ras_n(memory_mem_ras_n), // output     
      .new_sdram_controller_0_wire_we_n(memory_mem_we_n), // output

      //clock
      .clk_clk(ref_clk), // input 		       
      .reset_reset_n(~reset)                   //input
      );

   




endmodule


`default_nettype wire

   
