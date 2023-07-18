module tau_cal #(parameter N=21, parameter M=13)(rE, rI, clk, res_rdy, rst, tau);
input clk, rst;
input [M-1:0] rI, rE;		// 512  取小數點後4bit(9+4bit)
output [7:0] tau;				// 取小數點後8bit
output res_rdy;
wire [N-1:0] tau_reg;		// 取小數點後8bit
wire data_rdy; 	// tau cal finished
wire [N-1:0] rI_shift;

divider_man #(.N(N), .M(M))
	 u_divider(.clk (clk),
				  .rstn (rst),
				  .data_rdy (1'b1),
				  .dividend (rI_shift),
				  .divisor (rE),
				  .res_rdy (res_rdy),
				  .merchant (tau_reg),
				  .remainder ());

assign rI_shift = rI << 8;
assign tau = tau_reg[7:0];

endmodule 