`timescale 1ns/1ns
module sqrt_tb();
//reg clk_en, clock;
//reg [31:0] data;
//wire [31:0] result;
reg clk;
reg [15:0] radical;
wire [7:0]  q;
wire [8:0]  remainder;



//sqrt_altfp_sqrt_ued sq(.clk_en(clk_en),
//							  .clock(clock),
//							  .data(data),
//							  .result(result));
always #10 clk = ~clk;							  
initial 
begin
	//clock = 1'b0;
	//clk_en = 1'b1;
	clk = 1'b1;
	#20 radical = 16'd4;
	#20 radical = 16'd6;
	#20 radical = 16'd9;
	#20 radical = 16'd144;
	#20 radical = 16'd21549;
end

endmodule
	
	
	
	