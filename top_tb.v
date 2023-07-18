`timescale 1ns/1ns
module top_tb();
reg [2:0] state, next_state; // Stage buffer theta phi alpha sort
reg [2:0] stage, next_stage, stage_q;
reg [3:0] buffer, next_buffer, buffer_num, buffer_next;
reg [11:0] theta, next_theta, theta_min, theta_max, delta_theta, buffer_theta;
reg [11:0] phi, next_phi, phi_min, phi_max, delta_phi, buffer_phi;
reg [11:0] alpha, next_alpha, alpha_min, alpha_max, delta_alpha, buffer_alpha;
reg sorted_rdy, rst, start;
wire stage_trigger;



endmodule