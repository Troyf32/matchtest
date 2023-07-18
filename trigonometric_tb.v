`timescale 1ns/1ns
module trigonometric_tb();
reg [11:0] degree;
reg clk, iscos;
wire [9:0] value;
integer i;

//sinLUT_test tr(.degree(degree), 
//					.clk(clk), 
//					.value(value), 
//					.iscos(iscos));
					
trigonometric tr(.degree(degree), 
					  .clk(clk), 
					  .value(value), 
					  .iscos(iscos));

always#10 clk = ~clk;
initial
begin
	degree = 12'd0;
	clk = 1'b1;
	iscos = 1'b0;
	#20
		degree = 12'd800;
	#20
		degree = 12'd1000;
	#20
		degree = 12'd1100;
	#20
		degree = 12'd1700;
	#20
		iscos = 1'b1;
		degree = 12'd800;
	#20
		degree = 12'd1000;
	#20
		degree = 12'd1100;
	#20
		degree = 12'd1700;
	#180
//	for(i=0;i<3600;i=i+1)
//	begin
//		#40
//		degree <= degree+1'b1;
//	end
//	#40
//	degree = 12'd0;
//	iscos = 1'b1;
//	for(i=0;i<3600;i=i+1)
//	begin
//		#40
//		degree <= degree+1'b1;
//	end
	$stop;
end
					  
endmodule