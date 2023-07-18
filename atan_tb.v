`timescale 1ns/1ns
module atan_tb();
reg [9:0] x;
reg [9:0] y;
reg clk;
wire [11:0] degree;

atan alut(.y(y), 
		    .x(x), 
		    .clk(clk), 
		    .degree(degree));
	
always#10 clk = ~clk;
initial
begin
	x = 10'd0;
	y = 10'd0;
	clk = 1'b0;

	#20
	x = -3*16;
	y = 4*16;
//	for(i=0;i<128;i=i+1)
//	begin
//		y <= y +1'b1;
//		for(j=0;j<128;j=j+1)
//		begin
//			x <= x +1'b1;
//		#40
//		end
//	end
	#20
	x = -3*16;
	y = 4*16;
	#20
	x = -3*16;
	y = -4*16;
	#20
	x = 3*16;
	y = -4*16;
	#100
	$stop;
end
					  
endmodule