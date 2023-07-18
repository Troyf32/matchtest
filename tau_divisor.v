module tau_divisor(rI, rE, clk, tau);
input clk;
input [12:0] rI, rE;			// 512  取小數點後4bit   21bits / 13bits
output [7:0] tau;	
reg [12:0] rI_reg, rE_reg;	
reg [10:0] tau_reg;			// 取小數點後8bit
wire [20:0] rI_shift;

assign rI_shift = rI_reg<<8;
assign tau = tau_reg[7:0];

always@(posedge clk)
begin
	rI_reg <= rI;
	rE_reg <= rE;
	tau_reg <= rI_shift/rE_reg;
end
				
endmodule