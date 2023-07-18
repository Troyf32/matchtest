`timescale 1ns/1ns
module score_cal_point_buffer_tb();
reg clk, rst, cal_point_rdy;
reg [7:0] data_out_a_tem, data_out_b_tem;
wire [7:0] data_out_a [4:0], data_out_b [4:0];
wire [1:0] data_delay;

assign data_delay[0] = score_cal_point_buffer_tb.scpb.data_delay[0];
assign data_delay[1] = score_cal_point_buffer_tb.scpb.data_delay[1];

always#10 clk = ~clk;
initial
begin
	clk <= 1'b1;
	rst <= 1'b1;
	cal_point_rdy <= 1'b0;
	#20
	rst <= 1'b0;
	#20
	rst <= 1'b1;
	cal_point_rdy <= 1'b1;
	data_out_a_tem <= 8'd12;
	data_out_b_tem <= 8'd24;
	#20
	data_out_a_tem <= 8'd33;
	data_out_b_tem <= 8'd66;
	#20
	data_out_a_tem <= 8'd156;
	data_out_b_tem <= 8'd224;
	#20
	data_out_a_tem <= 8'd26;
	data_out_b_tem <= 8'd99;
	#20
	data_out_a_tem <= 8'd199;
	data_out_b_tem <= 8'd96;
	#20
	data_out_a_tem <= 8'd2;
	data_out_b_tem <= 8'd137;
	#20
	data_out_a_tem <= 8'd51;
	data_out_b_tem <= 8'd8;
	#200
	$stop;
end


score_cal_point_buffer scpb(.clk(clk),
									 .rst(rst),
									 .cal_point_rdy(cal_point_rdy),
									 .data_out_a_tem(data_out_a_tem),
									 .data_out_b_tem(data_out_b_tem),
									 .data_out_a_all({data_out_a[4], data_out_a[3], data_out_a[2], data_out_a[1], data_out_a[0]}),
									 .data_out_b_all({data_out_b[4], data_out_b[3], data_out_b[2], data_out_b[1], data_out_b[0]}));
									 										
endmodule											