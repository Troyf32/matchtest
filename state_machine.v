module state_machine(clk,
							rst,
							start,
							sorted_rdy,
							candidate_angle_buffer,
							theta,
							phi,
							alpha,
							score_alpha_num,
							compare_num,
							stage_trigger,
							if_last_angle,
							if_final_angle);

input clk, rst, start;
input sorted_rdy;

input [24*10-1:0] candidate_angle_buffer;
output [11:0] theta;
output [11:0] phi;
output [11:0] alpha;
output [8:0] score_alpha_num;
output[3:0] compare_num;
output stage_trigger;
output if_last_angle;
output if_final_angle;

reg [2:0] stage, next_stage, stage_q;
reg [3:0] buffer, buffer_num;
wire [3:0] buffer_choose;
reg [11:0] theta, theta_min, theta_max, delta_theta;
reg [11:0] phi, phi_min, phi_max, delta_phi;
reg [11:0] alpha, alpha_min, alpha_max, delta_alpha;
reg [3:0] compare_num;

reg if_last_buffer, if_last_theta, if_last_phi, if_last_alpha, if_last_alpha_p1;
wire if_last_angle_buffer, if_buffer_change;

reg theta_c, phi_c, alpha_c;
reg [15:0] total_cnt;
reg [8:0] score_alpha_num;
wire stage_trigger_d;


shift_reg #(.shift_num(1),
				.width(1))
			sr(.clk(clk),
			   .rst(rst),
			   .in(stage_trigger),
				.out(stage_trigger_d));
							

always@(posedge clk, negedge rst)
begin
	if(!rst)
	begin
		if_last_buffer <= 1'b0;
	end
	else if(sorted_rdy==1'b1)
	begin
		if_last_buffer <= 1'b0;
	end
	else if(buffer == (buffer_num-4'd1))
	begin
		if_last_buffer <= 1'b1;
	end
	else
	begin
		if_last_buffer <= if_last_buffer;
	end
end

always@(posedge clk, negedge rst)
begin
	if(!rst)
	begin
		if_last_theta <= 1'b0;
	end
	else if(sorted_rdy==1'b1)
	begin
		if_last_theta <= 1'b0;
	end
	else if(if_last_angle)
	begin
		if_last_theta <= 1'b1;
	end
	else if(theta == theta_max)
	begin
		if_last_theta <= 1'b1;
	end
	else
	begin
		if_last_theta <= 1'b0;
	end
end

always@(posedge clk, negedge rst)
begin
	if(!rst)
	begin
		if_last_phi <= 1'b0;
	end
	else if(sorted_rdy==1'b1)
	begin
		if_last_phi <= 1'b0;
	end
	else if(if_last_angle)
	begin
		if_last_phi <= 1'b1;
	end
	else if(phi == phi_max)
	begin
		if_last_phi <= 1'b1;
	end
	else
	begin
		if_last_phi <= 1'b0;
	end
end

always@(posedge clk, negedge rst)
begin
	if(!rst)
	begin
		if_last_alpha <= 1'b0;
		if_last_alpha_p1 <= 1'b0;
	end
	else if(sorted_rdy==1'b1)
	begin
		if_last_alpha <= 1'b0;
		if_last_alpha_p1 <= 1'b0;
	end
	else if(if_last_angle)
	begin
		if_last_alpha <= 1'b1;
		if_last_alpha_p1 <= 1'b0;
	end
	else if(alpha == (alpha_max-delta_alpha))
	begin
		if_last_alpha <= 1'b0;
		if_last_alpha_p1 <= 1'b1;
	end
	else if(alpha == alpha_max)
	begin
		if_last_alpha <= 1'b1;
		if_last_alpha_p1 <= 1'b0;
	end
	else
	begin
		if_last_alpha <= 1'b0;
		if_last_alpha_p1 <= 1'b0;
	end
end

always@(posedge clk, negedge rst)
begin
	if(!rst)
		total_cnt <= 16'd0;
	else	if(total_cnt < 16'd30)
		total_cnt <= total_cnt + 1'b1;
	else
		total_cnt <= 16'd0;
end

always@(posedge clk, negedge rst)
begin
	if(!rst)
	begin
		stage_q <= 3'd000;
	end
	else
	begin
		stage_q <= stage;
	end
end

assign stage_trigger = (stage_q != stage)?1'b1:1'b0;
assign if_last_angle = if_last_buffer & if_last_theta & if_last_phi & if_last_alpha;  // last angle
assign if_buffer_change = if_last_theta & if_last_phi & if_last_alpha;
assign if_last_angle_buffer = (if_last_theta & if_last_phi & if_last_alpha_p1 & (buffer!=buffer_num))?1'b1:1'b0;
assign if_final_angle = (stage==3'd3) & if_last_angle;


///////////////////////////////////////////////////////////use for stall 5 clk //////////////////////////////////////

//reg [2:0] stall_cnt;
//always@(posedge clk, negedge rst)
//begin
//	if(!rst)
//	begin
//		stall_cnt <= 3'd0;
//	end
//	else if(stall_cnt == 3'd4)
//	begin
//		stall_cnt <= 3'd0;
//	end
//	else if(start)
//	begin
//		stall_cnt <= stall_cnt + 1'b1;
//	end
//	else
//	begin
//		stall_cnt <= stall_cnt;
//	end
//end

//always@(posedge clk, posedge stage_trigger, negedge rst)
//begin
//	if(!rst)
//	begin
//		alpha <= alpha_min;
//		alpha_c <= 1'b0;
//	end
//	else if(stage_trigger)
//	begin
//		alpha <= alpha_min;
//		alpha_c <= 1'b0;
//	end
//	else if(if_last_angle) //最後一個buffer run完後
//	begin
//		alpha <= alpha;
//		alpha_c <= 1'b0;
//	end
//	else if((alpha < alpha_max) & start & (stall_cnt==3'd4))
//	begin	
//		alpha <= alpha + delta_alpha;
//		alpha_c <= 1'b0;
//	end
//	else
//	begin
//		alpha <= alpha_min;
//		alpha_c <= 1'b1;
//	end
//end
///////////////////////////////////////////////////////////use for stall 5 clk end //////////////////////////////////////
always@(posedge clk, negedge rst)
begin
	if(!rst)
	begin
		alpha <= alpha_min;
		alpha_c <= 1'b0;
	end
	else if(stage_trigger_d==1'b1)
	begin
		alpha <= alpha_min;
		alpha_c <= 1'b0;
	end
	else if(if_last_angle==1'b1) //最後一個buffer run完後
	begin
		alpha <= alpha_max;
		alpha_c <= 1'b0;
	end
	else if(((alpha < alpha_max) && start)==1'b1)
	begin	
		alpha <= alpha + delta_alpha;
		alpha_c <= 1'b0;
	end
	else
	begin
		alpha <= alpha_min;
		alpha_c <= 1'b1;
	end
end

always@(posedge alpha_c, posedge stage_trigger_d, posedge if_buffer_change, negedge rst)
begin
	if(!rst)
	begin
		phi <= phi_min;
		phi_c <= 1'b0;
	end
	else if(stage_trigger_d|if_buffer_change)
	begin
		phi <= phi_min;
		phi_c <= 1'b0;
	end
	else if(if_last_angle==1'b1) //最後一個buffer run完後
	begin
		phi <= phi_max;
		phi_c <= 1'b0;
	end
	else if(phi < phi_max)
	begin	
		phi <= ((phi + delta_phi)<phi_max)?phi + delta_phi:phi_max;
		phi_c <= 1'b0;
	end
	else
	begin
		phi <= phi_min;
		phi_c <= 1'b1;
	end
end

always@(posedge phi_c, posedge stage_trigger_d, posedge if_buffer_change, negedge rst)
begin
	if(!rst)
	begin
		theta <= theta_min;
		theta_c <= 1'b0;
	end
	else if(stage_trigger_d|if_buffer_change)
	begin
		theta <= theta_min;
		theta_c <= 1'b1;
	end
	else if(if_last_angle==1'b1) //最後一個buffer run完後
	begin
		theta <= theta_max;
		theta_c <= 1'b0;
	end
	else if(theta < theta_max)
	begin	
		theta <= ((theta + delta_theta)<theta_max)?theta + delta_theta:theta_max;
		theta_c <= 1'b0;
	end
	else
	begin
		theta <= theta_min;
		theta_c <= 1'b1;
	end
end

always@(posedge theta_c, posedge stage_trigger, negedge rst)
begin
	if(!rst)
	begin
		buffer <= 4'd0;
	end
	else if(stage_trigger)
	begin
		buffer <= 4'd0;
	end
	else if((buffer < buffer_num)&(if_buffer_change))
	begin	
		buffer <= buffer + 1'd1;
	end
	else
	begin
		buffer <= buffer;
	end
end

MUX #(.m(4),     // buffer 4 bit
      .n(2),     // 2 input
      .width(1)) // 1 bit select
 buc(.pdata({buffer+4'd1,buffer}),
      .s(if_last_angle_buffer),          
      .data_o(buffer_choose));	

//always@(posedge clk, negedge rst)
//begin
//	if(!rst)
//	begin
//		stage <= 4'd0;
//	end
//	else if(sorted_rdy)
//	begin	
//		stage <= stage + 1'd1;
//	end
//	else
//	begin
//		stage <= stage;
//	end
//end



always@(*)
begin
	case(stage)
		3'b000: //stage1
		begin
			theta_min 		<= 12'd0;
			theta_max 		<= 12'd300;
			delta_theta		<= 12'd10;
			phi_min   		<= 12'd0;
			phi_max	 		<= 12'd1800;
			delta_phi		<= 12'd40;
			alpha_min 		<= 12'd200; 
			alpha_max 		<= 12'd3600;
			delta_alpha 	<= 12'd200;
			buffer_num		<= 4'd1;
			score_alpha_num <= 9'd18;
			compare_num		<= 4'd10;
		end
		3'b001: //stage2
		begin
			theta_min 		<= ((candidate_angle_buffer[(buffer_choose+1)*24-1-:12]) > 12'd20) ? candidate_angle_buffer[(buffer_choose+1)*24-1-:12] - 12'd20 : 12'd0;
			//theta_max 		<= ((candidate_angle_buffer[(buffer+1)*24-1-:12]) < 12'd280) ? candidate_angle_buffer[(buffer+1)*24-1-:12] + 12'd20 : 12'd300;
			theta_max 		<= candidate_angle_buffer[(buffer+1)*24-1-:12] + 12'd20;
			delta_theta 	<= 12'd10;
			phi_min   		<= ((candidate_angle_buffer[(buffer_choose+1)*24-13-:12]) > 12'd40) ? candidate_angle_buffer[(buffer_choose+1)*24-13-:12] - 12'd40 : 12'd0;
			//phi_max	 		<= ((candidate_angle_buffer[(buffer+1)*24-13-:12]) < 12'd1760) ? candidate_angle_buffer[(buffer+1)*24-13-:12] + 12'd40 : 12'd1800;
			phi_max	 		<= candidate_angle_buffer[(buffer+1)*24-13-:12] + 12'd40;
			delta_phi		<= 12'd20;
			alpha_min 		<= 12'd60;
			alpha_max 		<= 12'd3600;
			delta_alpha 	<= 12'd60;
			buffer_num		<= 4'd10;
			score_alpha_num <= 9'd60;
			compare_num		<= 4'd6;
		end
		3'b010: //stage3
		begin
			theta_min 		<= ((candidate_angle_buffer[(buffer_choose+1)*24-1-:12]) > 12'd10) ? candidate_angle_buffer[(buffer_choose+1)*24-1-:12] - 12'd10 : 12'd0;
			//theta_max 		<= ((candidate_angle_buffer[(buffer+1)*24-1-:12]) < 12'd290) ? candidate_angle_buffer[(buffer+1)*24-1-:12] + 12'd10 : 12'd300;
			theta_max 		<= candidate_angle_buffer[(buffer+1)*24-1-:12] + 12'd10;
			delta_theta 	<= 12'd5;
			phi_min   		<= ((candidate_angle_buffer[(buffer_choose+1)*24-13-:12]) > 12'd20) ? candidate_angle_buffer[(buffer_choose+1)*24-13-:12] - 12'd20 : 12'd0;
			//phi_max	 		<= ((candidate_angle_buffer[(buffer+1)*24-13-:12]) < 12'd1780) ? candidate_angle_buffer[(buffer+1)*24-13-:12] + 12'd20 : 12'd1800;
			phi_max	 		<= candidate_angle_buffer[(buffer+1)*24-13-:12] + 12'd20;
			delta_phi		<= 12'd10;
			alpha_min 		<= 12'd30;
			alpha_max 		<= 12'd3600;
			delta_alpha 	<= 12'd30;
			buffer_num		<= 4'd6;
			score_alpha_num <= 9'd120;
			compare_num		<= 4'd3;
		end
		3'b011: //stage4
		begin
			theta_min 		<= ((candidate_angle_buffer[(buffer_choose+1)*24-1-:12]) > 12'd2) ? candidate_angle_buffer[(buffer_choose+1)*24-1-:12] - 12'd2 : 12'd0;
			//theta_max 		<= ((candidate_angle_buffer[(buffer+1)*24-1-:12]) < 12'd298) ? candidate_angle_buffer[(buffer+1)*24-1-:12] + 12'd2 : 12'd300;
			theta_max 		<= candidate_angle_buffer[(buffer+1)*24-1-:12] + 12'd2;
			delta_theta 	<= 12'd1;
			phi_min   		<= ((candidate_angle_buffer[(buffer_choose+1)*24-13-:12]) > 12'd4) ? candidate_angle_buffer[(buffer_choose+1)*24-13-:12] - 12'd4 : 12'd0;
			//phi_max	 		<= ((candidate_angle_buffer[(buffer+1)*24-13-:12]) < 12'd1796) ? candidate_angle_buffer[(buffer+1)*24-13-:12] + 12'd4 : 12'd1800;
			phi_max	 		<= candidate_angle_buffer[(buffer+1)*24-13-:12] + 12'd4;
			delta_phi		<= 12'd2;
			alpha_min 		<= 12'd10;
			alpha_max 		<= 12'd3600;
			delta_alpha 	<= 12'd10;
			buffer_num		<= 4'd3;
			score_alpha_num <= 9'd360;
			compare_num		<= 4'd1;
		end
		default:
		begin
			theta_min 		<= 12'd0;
			theta_max 		<= 12'd300;
			delta_theta		<= 12'd10;
			phi_min   		<= 12'd0;
			phi_max	 		<= 12'd1800;
			delta_phi		<= 12'd40;
			alpha_min 		<= 12'd200; 
			alpha_max 		<= 12'd3600;
			delta_alpha 	<= 12'd200;
			buffer_num		<= 4'd1;
			score_alpha_num <= 9'd18;
			compare_num		<= 4'd10;
		end
	endcase 
end

always@(*)
begin
	case(stage)
		3'b000: //stage1
		begin
			next_stage <= (sorted_rdy)?stage+1'b1:stage;
		end
		3'b001: //stage2
		begin
			next_stage <= (sorted_rdy)?stage+1'b1:stage;
		end
		3'b010: //stage3
		begin
			next_stage <= (sorted_rdy)?stage+1'b1:stage;
		end
		3'b011: //stage4
		begin
			next_stage <= (sorted_rdy)?stage+1'b1:stage;
		end
		default:
		begin
			next_stage <= stage;
		end
	endcase
end

always@(posedge clk, negedge rst)
begin
	if(!rst)
		stage <= 3'd0;
	else 
	begin
		stage <= next_stage;
	end
end

endmodule


//assign state_trigger = (state_q != state)?1'b1:1'b0;
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
//		3'b000: //stage
//		begin
//			next_state <= 3'b100;
//			next_stage <= stage;
//			next_buffer <= 4'd0;
//			next_theta <= theta;
//			next_phi <= phi;
//			next_alpha <= alpha + delta_alpha;
//		end
//		3'b001: //buffer
//		begin
//			next_state <= 3'b100;
//			next_stage <= stage;
//			next_buffer <= buffer;
//			next_theta <= theta_min;
//			next_phi <= phi;
//			next_alpha <= alpha + delta_alpha;
//		end
//		3'b010: //theta
//		begin
//			next_state <= 3'b100;
//			next_stage <= stage;
//			next_buffer <= buffer;
//			next_theta <= theta;
//			next_phi <= phi_min;
//			next_alpha <= alpha + delta_alpha;
//		end
//		3'b011: //phi
//		begin		
//			next_state <= 3'b100;
//			next_stage <= stage;
//			next_buffer <= buffer;
//			next_theta <= theta;
//			next_phi <= phi;
//			next_alpha <= alpha + delta_alpha;
//		end
//		3'b100: //alpha
//		begin
//			next_state <= (alpha < 12'd3600) ? 3'b100 : (phi < phi_max) ? 3'b011 : (theta < theta_max) ? 3'b010 : (buffer < buffer_num) ? 3'b001 : (stage < 3'd3) ? 3'b100 : 3'b110;
//			next_stage <= (next_buffer == buffer_num) ? stage + 1'b1 : stage;
//			next_buffer <= (theta == theta_max) ? buffer :  buffer + 1'b1;
//			next_theta <= (phi == phi_max) ? theta + delta_theta : theta;
//			next_phi <= (alpha == 12'd3600) ? phi + delta_phi : phi;
//			next_alpha <= (alpha < 12'd3600) ? alpha + delta_alpha : alpha_min;		
//		end
//		3'b101: //sort
//		begin
//			next_state <= (sorted_rdy) ? 3'b000 : state;
//			next_stage <= stage;
//			next_buffer <= buffer;
//			next_theta <= theta;
//			next_phi <= phi;
//			next_alpha <= alpha;
//		end
//		3'b110: //
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