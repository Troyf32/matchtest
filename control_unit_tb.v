`timescale 1ns/1ns
module control_unit_tb();
reg start;
reg clk;
reg rst;
reg [19:0] addr;
//reg [24*10-1:0] candidate_angle_buffer;
reg [23:0] candidate_angle_buffer [9:0];
wire sorted_rdy;
wire [11:0] theta;
wire [11:0] phi;
wire [11:0] alpha; 
wire [8:0] score_alpha_num;
//output reg cal_point_rdy;  //use for stall 5 clk
wire  score_rdy;
wire [3:0] compare_num;
wire if_last_angle;
wire best_angle_rdy;
integer i;

wire [2:0] stage;

assign stage = control_unit_tb.cu.ss.stage;
assign sorted_rdy = control_unit_tb.cu.sorted_rdy;

control_unit cu(.start(start), 
				    .clk(clk),
				    .rst(rst),
					 .addr(addr),
					 .candidate_angle_buffer({candidate_angle_buffer[9], candidate_angle_buffer[8], candidate_angle_buffer[7], candidate_angle_buffer[6], candidate_angle_buffer[5],
													  candidate_angle_buffer[4], candidate_angle_buffer[3], candidate_angle_buffer[2], candidate_angle_buffer[1], candidate_angle_buffer[0]}),
				    .theta(theta),
					 .phi(phi),
					 .alpha(alpha),
					 .score_alpha_num(score_alpha_num),
					 //.cal_point_rdy(cal_point_rdy), //use for stall 5 clk
					 .score_rdy(score_rdy),
					 .compare_num(compare_num),
					 .if_last_angle(if_last_angle),   ///////////// not defined yet////////////////
					 .best_angle_rdy(best_angle_rdy));
					 
always#10 clk = ~clk;
initial
begin
	clk <= 1'b1;
	rst <= 1'b1;
	start <= 1'b0;
	addr <= 20'd0;
	for(i=0;i<10;i=i+1)
	begin
		candidate_angle_buffer[i] <= {12'd1*i,12'd2*i};
	end
	#20
	rst <= 1'b0;
	#20
	rst <= 1'b1;
	start <= 1'b1;
	for(i=0;i<13505;i=i+1)
	begin
		#20
		addr <= i;
	end
end					 
				 
endmodule					 