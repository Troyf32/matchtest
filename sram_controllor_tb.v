`timescale 1ns/1ns
module sram_controllor_tb();
reg start;
reg clk;
reg rst;
reg best_angle_rdy; 
wire [19:0] addr;
wire CE_n, OE_n, WE_n, UB_n, LB_n;

sram_controllor sctb(.start(start),
						   .clk(clk),
						   .rst(rst),
						   .addr(addr),
						   .CE_n(CE_n),
						   .OE_n(OE_n),
						   .WE_n(WE_n),
						   .UB_n(UB_n),
						   .LB_n(LB_n),
						   .best_angle_rdy(best_angle_rdy));

always#10 clk = ~clk;						
initial
begin
	clk <= 1'b1;
	rst <= 1'b1;
	start <= 1'b0;
	#10
	rst <= 1'b0;
	#10
	rst <= 1'b1;
	#90
	start <= 1'b1;
	#270100
	best_angle_rdy <= 1'b1;
	#100
	$stop;
end

endmodule