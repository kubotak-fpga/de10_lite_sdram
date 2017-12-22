`default_nettype none

  module avm_read_control
    (
     input wire 	 clk,
     input wire 	 reset,
     input wire 	 start_triger,
    
     //avl interface
     input wire 	 avl_wait_req_in,

     input wire 	 avl_read_valid_in,
     input wire [15: 0] rdata_in,

     output wire 	 avl_read_out,
     output wire [7: 0]  avl_size_out,
     output wire [24: 0] avl_addr_out
    
     );


   localparam BURST_SIZE = 8'd32;



   reg 			 start_meta;
   reg 			 start_1d;
   reg 			 start_2d;
   

   always @(posedge clk) begin
      start_meta <= start_triger;
      start_1d <= start_meta;
      start_2d <= start_1d;
   end

   wire det_posedge_start;
   assign det_posedge_start = start_1d & ~start_2d;

   localparam RD_READY = 3'd0;
   localparam RD_SET = 3'd1;
   localparam RD_EXE = 3'd2;
   localparam RD_BURST_COUNT = 3'd3;


   reg [2: 0] rseq_state;
   reg 	      avl_read_reg;
   reg [7: 0] 	avl_size_reg;
   
   reg [7: 0] 	burst_cnt_internal;
   
   always @(posedge clk) begin

      if (reset) begin
	 rseq_state <= RD_READY;
	 
	 avl_read_reg <= 1'b0;
	 burst_cnt_internal <= BURST_SIZE - 1'b1;
	 avl_size_reg <= BURST_SIZE;
	 
      end
      else begin

	 case (rseq_state)

	   RD_READY : begin

	      if (det_posedge_start) begin
		 rseq_state <= RD_SET;
	      end
	   end

	   RD_SET : begin

	      avl_read_reg <= 1'b1;
	      rseq_state <= RD_EXE;
	   end

	   RD_EXE : begin

	      if (avl_wait_req_in == 1'b0) begin
		 avl_read_reg <= 1'b0;
		 rseq_state <= RD_BURST_COUNT;
	      end
	   end

	   RD_BURST_COUNT : begin

	      if (avl_read_valid_in) begin

		 if (burst_cnt_internal != 0) begin
		    burst_cnt_internal <= burst_cnt_internal -1'b1;
		 end
		 else begin
		    rseq_state <= RD_READY;
		 end
	      end
	   end

	 endcase
      end
   end // always @ (posedge clk)


   //output assign
   assign avl_read_out = avl_read_reg;
   assign avl_size_out = avl_size_reg;

   assign avl_addr_out = 25'd0;


endmodule // avm_read_control



`default_nettype wire
   
