`timescale 1ns/1ns
module state_tb();
reg clk, rst, start;
reg sorted_rdy;
reg [24*10-1:0] candidate_angle_buffer;							
wire [2:0] stage;
integer i;

wire [11:0] theta, phi, alpha, alpha_min, alpha_max, delta_theta, delta_phi, delta_alpha;
wire stage_trigger, stage_trigger_d, state_trigger;
wire [2:0] stage_q;
wire [3:0] buffer;
wire theta_c, phi_c, alpha_c;
wire [8:0] score_alpha_num;
wire [3:0] compare_num;
wire [11:0] theta_min, phi_min;
wire [11:0] theta_max, phi_max;


assign delta_theta = state_tb.ss.delta_theta;
assign delta_phi = state_tb.ss.delta_phi;
assign delta_alpha = state_tb.ss.delta_alpha;
assign alpha_min = state_tb.ss.alpha_min;
assign alpha_max = state_tb.ss.alpha_max;
assign stage_q = state_tb.ss.stage_q;
assign theta_c = state_tb.ss.theta_c;
assign phi_c = state_tb.ss.phi_c;
assign alpha_c = state_tb.ss.alpha_c;
assign theta_min = state_tb.ss.theta_min;
assign theta_max = state_tb.ss.theta_max;
assign phi_min = state_tb.ss.phi_min;
assign phi_max = state_tb.ss.phi_max;
assign stage_trigger_d = state_tb.ss.stage_trigger_d;

always#10 clk = ~clk;
initial
begin
	for(i=1;i<11;i=i+1)
	begin
		candidate_angle_buffer[24*i-1-:24] <= i*24'd21;
	end
	clk <= 1'b1;
	rst <= 1'b1;
	sorted_rdy <= 1'b0;
	start <= 1'b0;
	#20
	rst <= 1'b0;
	#20
	rst <= 1'b1;
	start <= 1'b1;
	#1500000
	sorted_rdy <= 1'b1;
	#20
	sorted_rdy <= 1'b0;
	#1500000
	sorted_rdy <= 1'b1;
	#20
	sorted_rdy <= 1'b0;
end

state_machine ss(.clk(clk),
				     .rst(rst),
				     .start(start),
				     .sorted_rdy(sorted_rdy),
				     .stage(stage),
				     .candidate_angle_buffer(candidate_angle_buffer),
					  .buffer(buffer),
					  .theta(theta),
					  .phi(phi),
					  .alpha(alpha),
					  .score_alpha_num(score_alpha_num),
					  .compare_num(compare_num),
					  .stage_trigger(stage_trigger),
					  .state_trigger(state_trigger));					  
endmodule