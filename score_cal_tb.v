`timescale 1ns/1ns
module score_cal_tb();
parameter width = 8;
reg [width-1:0] out4, out3, out2, out1, in4, in3, in2, in1, boundary;
reg clk, rst;
wire [width+12:0] score;


score_cal#(.width(width))
				 sct(.point_val({out4, out3, out2, out1, in4, in3, in2, in1, boundary}),  // out4, out3, out2, out1, in4, in3, in2, in1, boundary    
					  .clk(clk),
					  .rst(rst),
					  .score(score) // 取小數點後8bit
					  );
					  
always#10 clk = ~clk;
initial
begin
	clk <= 1'b0;
	rst <= 1'b1;
	#20
	rst <= 1'b0;
	#20
	rst <= 1'b1;
	#20
	out4 <= 8'd255; 
	out3 <= 8'd255;
	out2 <= 8'd255; 
	out1 <= 8'd255; 
	in4 <= 8'd0;
	in3 <= 8'd0;
	in2 <= 8'd0; 
	in1 <= 8'd0; 
	boundary <= 8'd255;
	#100
	out4 <= 8'd255; 
	out3 <= 8'd255;
	out2 <= 8'd255; 
	out1 <= 8'd255; 
	in4 <= 8'd0;
	in3 <= 8'd0;
	in2 <= 8'd0; 
	in1 <= 8'd0; 
	boundary <= 8'd0;
	#10000
	$stop;
end

				 					  
endmodule					  