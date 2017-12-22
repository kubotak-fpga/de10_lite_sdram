`default_nettype none

  module avm_write_control
    (
     input wire 	  clk,
     input wire 	  reset,

     input wire 	  start_triger,
     //avl interface
     input wire 	  avl_wait_req_in,

     output wire 	  avl_write_out,
     output wire [15: 0] avl_wdata_out,
     output wire [7: 0]   avl_size_out,
     output wire [24: 0]  avl_addr_out



     );

   localparam BURST_SIZE = 8'd32;
   
   reg 			  start_meta;
   reg 			  start_1d;
   reg 			  start_2d;
   

   always @(posedge clk) begin
      start_meta <= start_triger;
      start_1d <= start_meta;
      start_2d <= start_1d;
   end

   wire det_posedge_start;
   assign det_posedge_start = start_1d & ~start_2d;


   localparam WR_READY = 3'd0;
   localparam WR_SET = 3'd1;
   localparam WR_EXE = 3'd2;
   

   reg [15: 0] wdata;
   
   
   reg [2: 0] 	wseq_state;
   reg 		avl_write_reg;
   reg [7: 0] 	avl_size_reg;

   reg [7: 0] 	burst_cnt_internal;
   
   
   always @(posedge clk) begin

      if (reset) begin
	 wseq_state <= WR_READY;
	 
	 avl_write_reg <= 1'b0;
	 wdata <= 0;
	 burst_cnt_internal <= BURST_SIZE - 1'b1;
	 avl_size_reg <= BURST_SIZE;
	 
      end
      else begin

	 case (wseq_state)

	   WR_READY: begin

	      burst_cnt_internal <= BURST_SIZE - 1'b1;

	      if (det_posedge_start) begin
		 wseq_state <= WR_SET;
	      end
	   end

	   WR_SET: begin

    	      avl_write_reg <= 1'b1;
	      wdata <= 16'd100;
	      
	      wseq_state <= WR_EXE;
	   end

	   WR_EXE : begin

	      if (avl_wait_req_in == 1'b0) begin
		 if (burst_cnt_internal != 7'd0) begin
		    burst_cnt_internal <= burst_cnt_internal -1'd1;

		    wdata <= wdata + 1'b1;
		 end
		 else begin
		    wseq_state <= WR_READY;
		    avl_write_reg <= 1'b0;
		 end
              end
	   end
	   
	   default : wseq_state <= WR_READY;
	   
	 endcase
      end

   end


   //output assign
   assign avl_write_out = avl_write_reg;
   assign avl_size_out = avl_size_reg;
   assign avl_wdata_out = wdata;

   assign avl_addr_out = 25'd0;
   
   
endmodule


`default_nettype wire
