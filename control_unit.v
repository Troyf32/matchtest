module control_unit(start, 
						  clk,
						  rst,
						  addr,
						  candidate_angle_buffer,
						  theta,
						  phi,
						  alpha,
						  score_alpha_num,
						  //cal_point_rdy, //use for stall 5 clk
						  score_rdy,   	 /////////// score_rdy -> calculate match score start ///////////
						  compare_num,
						  if_last_angle,   ///////////// not defined yet////////////////
						  best_angle_rdy);

input start;
input clk;
input rst;
input [19:0] addr;
input [24*10-1:0] candidate_angle_buffer;
output [11:0] theta;
output [11:0] phi;
output [11:0] alpha; 
output [8:0] score_alpha_num;
//output reg cal_point_rdy;  //use for stall 5 clk
output reg  score_rdy;
output [3:0] compare_num;
output if_last_angle;
output best_angle_rdy;

wire if_final_angle;  //// last stage and last angle
reg start_cal;
wire start_cal_d;
reg final_flag;
wire stage_trigger;
reg [7:0] cal_point_rdy_cnt, score_rdy_cnt, sorted_rdy_cnt, final_cnt; 
wire [7:0] sorted_rdy_cnt_num;
reg cal_point_rdy, if_final_angle_rdy;
wire compare_rdy;
reg sorted_rdy;
wire [8*9-1:0] point_val;
wire [16:0] score_line;

// reg [14:0] data_input_addr; // 27000/2 + eye data (13500+4)

always@(posedge clk, negedge rst)
begin
	if(!rst)
	begin
		score_rdy <= 1'b0;
		score_rdy_cnt <= 8'd0;
	end
	else if(stage_trigger)
	begin
		score_rdy <= 1'b0;
		score_rdy_cnt <= 8'd0;
	end
	else if(!start_cal_d)
	begin
		score_rdy <= 1'b0;
		score_rdy_cnt <= 8'd0;
	end
	else if(start_cal_d&(score_rdy_cnt<29))  ////score_rdy_cnt not ready yet
	begin
		score_rdy <= 1'b0;
		score_rdy_cnt <= score_rdy_cnt + 1'b1;
	end
	else
	begin
		score_rdy <= 1'b1;
		score_rdy_cnt <= score_rdy_cnt;  /////////// score_rdy -> calculate match score start /////////// 
	end
end
assign sorted_rdy_cnt_num = {4'd0,compare_num} + 8'd37;  //// sorted_rdy_cnt_num is different at 5ram and 1ram

always@(posedge clk, negedge rst)
begin
	if(!rst)
	begin
		sorted_rdy <= 1'b0;
		sorted_rdy_cnt <= 8'd0;
	end
	else if(stage_trigger)
	begin
		sorted_rdy <= 1'b0;
		sorted_rdy_cnt <= 8'd0;
	end
	else if(start_cal_d&(sorted_rdy_cnt<(sorted_rdy_cnt_num))&if_last_angle)  
	begin
		sorted_rdy <= 1'b0;
		sorted_rdy_cnt <= sorted_rdy_cnt + 1'b1;
	end
	else if(sorted_rdy_cnt == sorted_rdy_cnt_num)
	begin
		sorted_rdy <= 1'b1;
		sorted_rdy_cnt <= sorted_rdy_cnt + 1'b1;
	end
	else
	begin
		sorted_rdy <= 1'b0;
		sorted_rdy_cnt <= 8'd0;
	end
end

always@(posedge clk, negedge rst)
begin
	if(!rst)
	begin
		start_cal <= 1'b0;
	end
	else if(final_flag)
	begin
		start_cal <= 1'b0;
	end
	else if((start)&(addr<20'h34bf)) // (13504-1)
	begin
		start_cal <= 1'b0;
	end	
	else
	begin
		start_cal <= 1'b1;
	end
end

shift_reg #(.shift_num(1),
				.width(1))
			sr(.clk(clk),
			   .rst(rst),
			   .in(start_cal),
				.out(start_cal_d));

always@(posedge clk, negedge rst)
begin
	if(!rst)
	begin
		final_flag <= 1'b0;
	end
	else if(if_final_angle)
	begin
		final_flag <= 1'b1;
	end
	else
	begin
		final_flag <= final_flag;
	end
end

always@(posedge clk, negedge rst)
begin
	if(!rst)
	begin
		final_cnt <= 1'b0;
		if_final_angle_rdy <= 1'b0;
	end
	else if(final_flag&(final_cnt<8'd100))  ////// final_cnt not right yet
	begin
		final_cnt <= final_cnt + 1'b1;
		if_final_angle_rdy <= 1'b0;
	end
	else if(final_flag)
	begin
		final_cnt <= final_cnt;
		if_final_angle_rdy <= 1'b1;
	end
	else
	begin
		final_cnt <= 1'b0;
		if_final_angle_rdy <= 1'b0;
	end
end

						 
assign best_angle_rdy = (if_final_angle_rdy)?1'b1:1'b0;   ///////////not right yet/////////////////

state_machine ss(.clk(clk),
					  .rst(rst),
					  .start(start_cal_d),
					  .sorted_rdy(sorted_rdy),
					  .candidate_angle_buffer(candidate_angle_buffer),
					  .theta(theta),
					  .phi(phi),
					  .alpha(alpha),
					  .score_alpha_num(score_alpha_num),
					  .compare_num(compare_num),
					  .stage_trigger(stage_trigger),
					  .if_last_angle(if_last_angle),
					  .if_final_angle(if_final_angle));

always@(posedge clk, negedge rst)
begin
	if(!rst)
	begin
		cal_point_rdy_cnt <= 8'd0;
	end
	else if(stage_trigger)
	begin
		cal_point_rdy_cnt <= 8'd0;
	end
	else if(cal_point_rdy_cnt<8'd15)
	begin
		cal_point_rdy_cnt <= cal_point_rdy_cnt + 1'b1;
	end
	else
	begin
		cal_point_rdy_cnt <= cal_point_rdy_cnt;
	end
end

always@(posedge clk, negedge rst) 
begin
	if(!rst)
	begin
		cal_point_rdy <= 1'b0;
	end
	else if(stage_trigger)
	begin
		cal_point_rdy <= 1'b0;
	end
	else if(cal_point_rdy_cnt==8'd14)   //temp(cal_point_rdy_cnt==15)
	begin
		cal_point_rdy <= 1'b1;
	end
	else
	begin
		cal_point_rdy <= cal_point_rdy;
	end
end
//.........................................................................//
//seven_seg s1(.Din(angle_buffer[3:0]),
//				 .Dout(seven1));
//
//seven_seg s2(.Din(angle_buffer[7:4]),
//				 .Dout(seven2)); 
//
//seven_seg s3(.Din(angle_buffer[11:8]),
//				 .Dout(seven3));
//
//seven_seg s4(.Din(angle_buffer[15:12]),
//				 .Dout(seven4)); 
//
//seven_seg s5(.Din(angle_buffer[19:16]),
//				 .Dout(seven5));
//
//seven_seg s6(.Din(angle_buffer[23:20]),
//				 .Dout(seven6)); 				 
//
//seven_seg s7(.Din(addr[11:8]),
//				 .Dout(seven7));
//
//seven_seg s8(.Din(addr[15:12]),
//				 .Dout(seven8));		
endmodule

// 380*200
//assign addr_a_line[0] = {{7'b0,{new_yi[(width-1)-:10]}}*17'd380+{7'b0,new_xi[(width-1)-:10]}};
//assign addr_a_line[1] = {{7'b0,{new_yi[(width*2-1)-:10]}}*17'd380+{7'b0,new_xi[(width*2-1)-:10]}};
//assign addr_a_line[2] = {{7'b0,{new_yi[(width*3-1)-:10]}}*17'd380+{7'b0,new_xi[(width*3-1)-:10]}};
//assign addr_a_line[3] = {{7'b0,{new_yi[(width*4-1)-:10]}}*17'd380+{7'b0,new_xi[(width*4-1)-:10]}};l
//assign addr_a_line[4] = {{7'b0,{yb_o[13:4]}}*17'd380+{7'b0,xb_o[13:4]}};
//assign addr_b_line[0] = {{7'b0,{new_yo[(width-1)-:10]}}*17'd380+{7'b0,new_xo[(width-1)-:10]}};
//assign addr_b_line[1] = {{7'b0,{new_yo[(width*2-1)-:10]}}*17'd380+{7'b0,new_xo[(width*2-1)-:10]}};
//assign addr_b_line[2] = {{7'b0,{new_yo[(width*3-1)-:10]}}*17'd380+{7'b0,new_xo[(width*3-1)-:10]}};
//assign addr_b_line[3] = {{7'b0,{new_yo[(width*4-1)-:10]}}*17'd380+{7'b0,new_xo[(width*4-1)-:10]}};
//assign addr_b_line[4] = {{7'b0,{yb_o[13:4]}}*17'd380+{7'b0,xb_o[13:4]}};


//reg [2:0] state, next_state, state_q; // Stage buffer theta phi alpha sort
//reg [2:0] stage, next_stage, stage_q;
//reg [3:0] buffer, buffer_num, next_buffer, buffer_next;
//reg [11:0] theta, next_theta, theta_min, theta_max, delta_theta, buffer_theta;
//reg [11:0] phi, next_phi, phi_min, phi_max, delta_phi, buffer_phi;
//reg [11:0] alpha, next_alpha, alpha_min, alpha_max, delta_alpha, buffer_alpha;

//always@(posedge clk, negedge rst)
//begin
//	if(!rst)
//	begin
//		stage_q <= 3'd000;
//	end
//	else
//	begin
//		stage_q <= stage;
//	end
//end
//
//assign stage_trigger = (stage_q != stage)?1'b1:1'b0;
//
//always@(posedge clk, negedge rst)
//begin
//	if(!rst)
//	begin
//		state <= 3'b100; //start from alpha
//	end
//	else if(start)
//	begin
//		state <= next_state;
//	end
//	else
//	begin
//		state <= state;
//	end
//end
//
//always@(*)
//begin
//	case(state)
//		3'b000:
//		begin
//			next_state <= (stage < 3'd3) ? 3'b100 : 3'b110;
//			next_stage <= (stage < 3'd3) ? stage + 1'b1 : stage;
//			next_buffer <= buffer;
//			next_theta <= theta;
//			next_phi <= phi;
//			next_alpha <= alpha;
//		end
//		3'b001:
//		begin
//			next_state <= (buffer < buffer_num) ? 3'b010 : 3'b101;
//			next_stage <= stage;
//			next_buffer <= (buffer < buffer_num) ? buffer + 1'b1 : buffer;
//			next_theta <= theta;
//			next_phi <= phi;
//			next_alpha <= alpha;
//		end
//		3'b010:
//		begin
//			next_state <= (theta < theta_max) ? 3'b011 : 3'b001;
//			next_stage <= stage;
//			next_buffer <= buffer;
//			next_theta <= (theta < theta_max) ? theta + delta_theta : theta;
//			next_phi <= phi;
//			next_alpha <= alpha;
//		end
//		3'b011:
//		begin		
//			next_state <= (phi < phi_max) ? 3'b100 : 3'b010;
//			next_stage <= stage;
//			next_buffer <= buffer;
//			next_theta <= theta;
//			next_phi <= (phi < phi_max) ? phi + delta_phi : phi;
//			next_alpha <= alpha;
//		end
//		3'b100:
//		begin
//			next_state <= (alpha < 12'd3600) ? 3'b100 : 3'b011;
//			next_stage <= stage;
//			next_buffer <= buffer;
//			next_theta <= theta;
//			next_phi <= phi;
//			next_alpha <= (alpha < 12'd3600) ? alpha + delta_alpha : alpha_min;		
//		end
//		3'b101:
//		begin
//			next_state <= (sorted_rdy) ? 3'b000 : state;
//			next_stage <= stage;
//			next_buffer <= buffer;
//			next_theta <= theta;
//			next_phi <= phi;
//			next_alpha <= alpha;
//		end
//		3'b110:
//		begin
//			next_state <= state;
//			next_stage <= stage;
//			next_buffer <= buffer;
//			next_theta <= theta;
//			next_phi <= phi;
//			next_alpha <= alpha;
//		end
//		default:
//		begin
//			next_state <= state;
//			next_stage <= stage;
//			next_buffer <= buffer;
//			next_theta <= theta;
//			next_phi <= phi;
//			next_alpha <= alpha;
//		end
//	endcase
//end
//
//always@(*)
//begin
//	case(stage)
//		3'b000: //stage1
//		begin
//			theta_min 		<= 12'd0;
//			theta_max 		<= 12'd300;
//			delta_theta		<= 12'd10;
//			phi_min   		<= 12'd0;
//			phi_max	 		<= 12'd1800;
//			delta_phi		<= 12'd40;
//			alpha_min 		<= 12'd200; 
//			alpha_max 		<= 12'd3600;
//			delta_alpha 	<= 12'd200;
//			buffer_num		<= 4'd1;
//			buffer_next 	<= 4'd10;
//			score_alpha_num <= 9'd18;
//		end
//		3'b001: //stage2
//		begin
//			theta_min 		<= candidate_angle_buffer[(buffer+1)*24-1-:12] - 12'd20;
//			theta_max 		<= candidate_angle_buffer[(buffer+1)*24-1-:12] + 12'd20;
//			delta_theta 	<= 12'd10;
//			phi_min   		<= candidate_angle_buffer[(buffer+1)*24-13-:12] - 12'd40;
//			phi_max	 		<= candidate_angle_buffer[(buffer+1)*24-13-:12] + 12'd40;
//			delta_phi		<= 12'd20;
//			alpha_min 		<= 12'd60;
//			alpha_max 		<= 12'd3600;
//			delta_alpha 	<= 12'd60;
//			buffer_num		<= 4'd10;
//			buffer_next 	<= 4'd6;
//			score_alpha_num <= 9'd60;
//		end
//		3'b010: //stage3
//		begin
//			theta_min 		<= candidate_angle_buffer[(buffer+1)*24-1-:12] - 12'd10;
//			theta_max 		<= candidate_angle_buffer[(buffer+1)*24-1-:12] + 12'd10;
//			delta_theta 	<= 12'd5;
//			phi_min   		<= candidate_angle_buffer[(buffer+1)*24-13-:12] - 12'd20;  
//			phi_max	 		<= candidate_angle_buffer[(buffer+1)*24-13-:12] + 12'd20;
//			delta_phi		<= 12'd10;
//			alpha_min 		<= 12'd30;
//			alpha_max 		<= 12'd3600;
//			delta_alpha 	<= 12'd30;
//			buffer_num		<= 4'd6;
//			buffer_next 	<= 4'd3;
//			score_alpha_num <= 9'd120;
//		end
//		3'b011: //stage4
//		begin
//			theta_min 		<= candidate_angle_buffer[(buffer+1)*24-1-:12] - 12'd2;
//			theta_max 		<= candidate_angle_buffer[(buffer+1)*24-1-:12] + 12'd2;
//			delta_theta 	<= 12'd1;
//			phi_min   		<= candidate_angle_buffer[(buffer+1)*24-13-:12] - 12'd4;  
//			phi_max	 		<= candidate_angle_buffer[(buffer+1)*24-13-:12] + 12'd4;
//			delta_phi		<= 12'd2;
//			alpha_min 		<= 12'd10;
//			alpha_max 		<= 12'd3600;
//			delta_alpha 	<= 12'd10;
//			buffer_num		<= 4'd3;
//			buffer_next 	<= 4'd1;
//			score_alpha_num <= 9'd360;
//		end
//		default:
//		begin
//			theta_min 		<= 12'd0;
//			theta_max 		<= 12'd300;
//			delta_theta 	<= 12'd10;
//			phi_min   		<= 12'd0;  
//			phi_max	 		<= 12'd1800;
//			delta_phi		<= 12'd40;
//			alpha_min 		<= 12'd200;
//			alpha_max 		<= 12'd3600;
//			delta_alpha 	<= 12'd200;
//			buffer_num		<= 4'd1;
//			buffer_next 	<= 4'd10;
//			score_alpha_num <= 9'd18;
//		end
//	endcase 
//end
//
//always@(posedge clk, negedge rst)
//begin
//	if(!rst)
//		stage <= 3'd0;
//	else if(sorted_rdy)
//	begin
//		stage <= next_stage;
//	end
//	else
//	begin
//		stage <= stage;
//	end
//end
//
//
//always@(posedge clk, negedge rst)
//begin
//	if(!rst)
//	begin
//		buffer  <= 4'd0;
//		theta	  <= 12'd0;
//		phi 	  <= 12'd0;
//		alpha   <= 12'd0;
//	end
//	else if(start&stage_trigger)
//	begin
//		buffer  <= 4'd0;
//		theta	  <= theta_min;
//		phi 	  <= phi_min;
//		alpha   <= alpha_min;
//	end
//	else
//	begin
//		buffer  <= next_buffer;
//		theta	  <= next_theta;
//		phi 	  <= next_phi;
//		alpha   <= next_alpha;
//	end
//end