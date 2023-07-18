`timescale 1ns/1ns
module iris_center_tb();
reg [11:0] theta;
reg [11:0] phi;
reg [12:0] rE; //小數點後4bit
reg [13:0] x;
reg [13:0] y;
reg clk;
wire [13:0] iris_center_x;
wire [13:0] iris_center_y;
//assign rI_shift = tb.td.rI_shift;
//assign tau_reg = tb.td.tau_reg;

IrisCenter_cal ic(.theta(theta),
						.phi(phi),
						.rE(rE), //小數點後4bit
						.x(x),
						.y(y),
						.clk(clk),
						.iris_center_x(iris_center_x),
						.iris_center_y(iris_center_y));			 

always#10 clk = ~clk;
initial
begin
	rE <= 13'd1320; // 82.5084
	clk <= 1'b0;
	theta <= 12'd0;
	phi <= 12'd0;
	x <= 14'd3255; // 203.447
	y <= 14'd1389; // 86.8368
end

endmodule