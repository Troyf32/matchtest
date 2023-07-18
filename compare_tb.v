`timescale 1ns/1ns
module compare_tb();
reg [7:0] score_in;
reg clk, rst;
reg compare_data_rdy;
reg [10*8-1:0] score_buffer;
wire [3:0] insert_index;
wire compare_rdy;

compare #(.width(8),
			 .quantity(10))
		 cc(.clk(clk),
			 .rst(rst),
			 .compare_data_rdy(compare_data_rdy),
			 .score_in(score_in),
			 .score_buffer(score_buffer),
			 .compare_num(4'd10),
			 .compare_rdy(compare_rdy),
			 .insert_index(insert_index));

			 

always#10 clk = ~clk;
initial
begin
	clk <= 1'b0;
	rst <= 1'b1;
	compare_data_rdy <= 1'b0;
	#20
	rst <= 1'b0;
	#20
	rst <= 1'b1;
	compare_data_rdy <= 1'b1;
	score_buffer[1*8-1-:8] <= 8'd14;
	score_buffer[2*8-1-:8] <= 8'd12;
	score_buffer[3*8-1-:8] <= 8'd11;
	score_buffer[4*8-1-:8] <= 8'd10;
	score_buffer[5*8-1-:8] <= 8'd8;
	score_buffer[6*8-1-:8] <= 8'd7;
	score_buffer[7*8-1-:8] <= 8'd7;
	score_buffer[8*8-1-:8] <= 8'd6;
	score_buffer[9*8-1-:8] <= 8'd5;
	score_buffer[10*8-1-:8] <= 8'd4;
	score_in <= 8'd9;
	#20
	compare_data_rdy <= 1'b0;
	#500
	compare_data_rdy <= 1'b1;
	score_buffer[1*8-1-:8] <= 8'd15;
	score_buffer[2*8-1-:8] <= 8'd12;
	score_buffer[3*8-1-:8] <= 8'd10;
	score_buffer[4*8-1-:8] <= 8'd9;
	score_buffer[5*8-1-:8] <= 8'd5;
	score_buffer[6*8-1-:8] <= 8'd4;
	score_buffer[7*8-1-:8] <= 8'd3;
	score_buffer[8*8-1-:8] <= 8'd0;
	score_buffer[9*8-1-:8] <= 8'd0;
	score_buffer[10*8-1-:8] <= 8'd0;
	score_in <= 8'd14;
	#20
	compare_data_rdy <= 1'b0;
	

end

endmodule