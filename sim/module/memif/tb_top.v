`default_nettype none
   
`timescale 1ps / 1ps
   
  module tb_top();

   localparam PERIOD_50MHz = 20000; //50MHz
   localparam PERIOD_100MHz = 10000; //100MHz

   

   reg ref_clk;
   reg reset;

   reg w0_triger;
   reg r0_triger;
   

   always #(PERIOD_100MHz / 2) begin
      ref_clk <= ~ref_clk;
   end


   wire [0:0] e0_memory_mem_cas_n;              // e0:mem_cas_n -> m0:mem_cas_n
   wire [1:0] e0_memory_mem_ba;                 // e0:mem_ba -> m0:mem_ba
   wire [0:0] e0_memory_mem_we_n;               // e0:mem_we_n -> m0:mem_we_n
   
   wire [15:0] e0_memory_mem_dq;                 // [] -> [e0:mem_dq, m0:mem_dq]
   wire [1: 0] e0_memory_mem_dqm;
   
   wire [0:0]  e0_memory_mem_cs_n;               // e0:mem_cs_n -> m0:mem_cs_n
   wire [12:0] e0_memory_mem_a;                  // e0:mem_a -> m0:mem_a
   wire [0:0]  e0_memory_mem_ras_n;              // e0:mem_ras_n -> m0:mem_ras_n
   wire [0:0]  e0_memory_mem_cke;                // e0:mem_cke -> m0:mem_cke

   //wire        local_init_done;
   

   memif_top u_memif_top
     (
      .ref_clk(ref_clk), //100MHz
      .reset(reset),
      .write_start_triger(w0_triger),
      .read_start_triger(r0_triger),

      //.local_init_done(local_init_done),  //for sim
      
      //SDRInterface
      .memory_mem_a(e0_memory_mem_a),  //[12: 0]
      .memory_mem_ba(e0_memory_mem_ba), //[1: 0]
      .memory_mem_cke(e0_memory_mem_cke),
      .memory_mem_cs_n(e0_memory_mem_cs_n),
      .memory_mem_ras_n(e0_memory_mem_ras_n),
      .memory_mem_cas_n(e0_memory_mem_cas_n),
      .memory_mem_we_n(e0_memory_mem_we_n),
      .memory_mem_dq(e0_memory_mem_dq), //[15: 0]
      .memory_mem_dqm(e0_memory_mem_dqm) //[1: 0]
      );



   //SDRAM Model(Micron Sim file)
   sdr u_sdr_model 
     (
      .Dq(e0_memory_mem_dq), 
      .Addr(e0_memory_mem_a),
      .Ba(e0_memory_mem_ba),
      .Clk(ref_clk),
      .Cke(e0_memory_mem_cke),
      .Cs_n(e0_memory_mem_cs_n),
      .Ras_n(e0_memory_mem_ras_n),
      .Cas_n(e0_memory_mem_cas_n),
      .We_n(e0_memory_mem_we_n),
      .Dqm(e0_memory_mem_dqm)
      );



   
   initial begin

      ref_clk <= 0;
      reset <= 1'b1;
      
      w0_triger <= 1'b0;
      r0_triger <= 1'b0;
      
      repeat(100) @(posedge ref_clk);

      reset <= 1'b0;

      repeat(10) @(posedge ref_clk);

      //wait(local_init_done);  //wait mem init

      repeat(10000) @(posedge ref_clk);
      

      
      repeat(1) @(posedge ref_clk);

      w0_triger <= 1'b1;

      repeat(2) @(posedge ref_clk);

      w0_triger <= 1'b0;


      repeat(10) @(posedge ref_clk);


      //w0_triger <= 1'b1;
      
      r0_triger <= 1'b1;


      repeat(2) @(posedge ref_clk);

      //w0_triger <= 1'b0;

      r0_triger <= 1'b0;


      

      repeat(1000000) @(posedge ref_clk);


      //$finish;
      
   end

   
endmodule

`default_nettype wire
   
