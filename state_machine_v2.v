module state_machine_v2(clk,
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
reg [3:0] buffer, next_buffer, buffer_num;
wire [3:0] buffer_choose_min, buffer_choose_max, buffer_choose_min_d, buffer_choose_max_d;
reg [11:0] theta, next_theta, theta_min, theta_max, delta_theta;
reg [11:0] phi, next_phi, phi_min, phi_max, delta_phi;
reg [11:0] alpha, next_alpha, alpha_min, alpha_max, delta_alpha;
reg [3:0] compare_num;
wire [23:0] angle_min_choose, angle_max_choose, angle_min_choose_tem, angle_max_choose_tem, angle_min_choose_tem_line, angle_max_choose_tem_line;
wire [11:0] angle_min_choose_tem_theta, angle_min_choose_tem_phi, angle_max_choose_tem_theta, angle_max_choose_tem_phi, theta_range, phi_range;

reg if_last_buffer, if_last_theta, if_last_phi, if_last_alpha, if_last_alpha_p3;
//wire if_last_buffer, if_last_theta, if_last_phi, if_last_alpha, if_last_alpha_p1;
wire if_last_angle_buffer_line, if_last_angle_buffer, if_last_angle_buffer_d;//, if_last_angle_buffer_dd;

reg [2:0] state, next_state;
reg [8:0] score_alpha_num;
wire s_alpha_choose, s_phi_choose, s_theta_choose, s_buffer_choose, s_stage_choose;
reg [2:0] s_choose;
wire stage_trigger_d;

parameter IDLE     = 3'd0,
			 s_alpha  = 3'd1,
			 s_phi    = 3'd2,
			 s_theta  = 3'd3,
			 s_buffer = 3'd4,
			 s_stage  = 3'd5,
			 s_angle  = 3'd6,
			 stage1   = 3'd0,
			 stage2   = 3'd1,
			 stage3   = 3'd2,
			 stage4   = 3'd3;

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
		if_last_alpha_p3 <= 1'b0;
	end
	else if(sorted_rdy==1'b1)
	begin
		if_last_alpha <= 1'b0;
		if_last_alpha_p3 <= 1'b0;
	end
	else if(if_last_angle)
	begin
		if_last_alpha <= 1'b1;
		if_last_alpha_p3 <= 1'b0;
	end
	else if(alpha == (alpha_max-(delta_alpha*12'd4)))
	begin
		if_last_alpha <= 1'b0;
		if_last_alpha_p3 <= 1'b1;
	end
	else if(alpha == alpha_max)
	begin
		if_last_alpha <= 1'b1;
		if_last_alpha_p3 <= 1'b0;
	end
	else
	begin
		if_last_alpha <= 1'b0;
		if_last_alpha_p3 <= 1'b0;
	end
end

always@(posedge clk, negedge rst)
begin
	if(!rst)
	begin
		stage_q <= 3'd0;
	end
	else
	begin
		stage_q <= stage;
	end
end

//assign if_last_alpha = (alpha == alpha_max) ? 1'b1 : 1'b0;
//assign if_last_alpha_p1 = (alpha == alpha_max-delta_alpha) ? 1'b1 : 1'b0;
//assign if_last_phi = (phi == phi_max) ? 1'b1 : 1'b0;
//assign if_last_theta = (theta == theta_max) ? 1'b1 : 1'b0;
////assign if_last_angle_buffer = (if_last_theta & if_last_phi & if_last_alpha & (buffer!=buffer_num))?1'b1:1'b0;
//assign if_last_buffer = (buffer == buffer_num-1'b1) ? 1'b1 : 1'b0;


assign stage_trigger = (stage_q != stage)?1'b1:1'b0;
assign if_last_angle = if_last_buffer & if_last_theta & if_last_phi & if_last_alpha;  // last angle
assign if_last_angle_buffer = (if_last_theta & if_last_phi & if_last_alpha_p3 & (buffer!=buffer_num))?1'b1:1'b0;
assign if_final_angle = (stage==3'd3) & if_last_angle;

shift_reg #(.shift_num(1),
				.width(1))
			si(.clk(clk),
			   .rst(rst),
			   .in(if_last_angle_buffer),
				.out(if_last_angle_buffer_d));

//shift_reg #(.shift_num(1),
//				.width(1))
//		  si1(.clk(clk),
//			   .rst(rst),
//			   .in(if_last_angle_buffer),
//				.out(if_last_angle_buffer_dd));			

MUX #(.m(4),     // buffer 4 bit
      .n(2),     // 2 input
      .width(1)) // 1 bit select
 buc(.pdata({buffer+4'd1,buffer}),
      .s(if_last_angle_buffer_d),          
      .data_o(buffer_choose_min));	

MUX #(.m(4),     // buffer 4 bit
      .n(2),     // 2 input
      .width(1)) // 1 bit select
 bua(.pdata({buffer,buffer}),
      .s(if_last_angle_buffer_d),          
      .data_o(buffer_choose_max));		
				
//MUX #(.m(24),     // buffer 24 bit   candidate_angle_buffer[(buffer_choose_min+1)*24-1-:12]
//      .n(10),     // 10 input
//      .width(4))  // 4 bit select
//  bai(.pdata(candidate_angle_buffer),
//      .s(buffer_choose_min),       
//      .data_o(angle_min_choose_tem));		
//		
//MUX #(.m(24),     // buffer 24 bit
//      .n(10),     // 10 input
//      .width(4))  // 4 bit select
//  baa(.pdata(candidate_angle_buffer),
//      .s(buffer_choose_max),
//      .data_o(angle_max_choose_tem));
		
assign angle_min_choose_tem_line = candidate_angle_buffer[(buffer_choose_min+1)*24-1-:24];
assign angle_max_choose_tem_line = candidate_angle_buffer[(buffer_choose_max+1)*24-1-:24];

shift_reg #(.shift_num(1),
				.width(24))
		 amin(.clk(clk),
			   .rst(rst),
			   .in(angle_min_choose_tem_line),
				.out(angle_min_choose_tem));
		
shift_reg #(.shift_num(1),
				.width(24))
		 amax(.clk(clk),
			   .rst(rst),
			   .in(angle_max_choose_tem_line),
				.out(angle_max_choose_tem));
		
MUX #(.m(12),     // buffer 12 bit
      .n(3),      // 3 input
      .width(3))  // 3 bit select
   tr(.pdata({12'd2,12'd10,12'd20}),
      .s(stage-1'b1),       
      .data_o(theta_range));		
		
MUX #(.m(12),     // buffer 12 bit
      .n(3),      // 3 input
      .width(3))  // 3 bit select
   pr(.pdata({12'd4,12'd20,12'd40}),
      .s(stage-1'b1),
      .data_o(phi_range));
			

assign angle_min_choose_tem_theta = (angle_min_choose_tem[23:12]<theta_range)?12'd0:angle_min_choose_tem[23:12]-theta_range;
assign angle_min_choose_tem_phi = (angle_min_choose_tem[11:0]<phi_range)?12'd0:angle_min_choose_tem[11:0]-phi_range;
assign angle_max_choose_tem_theta = angle_max_choose_tem[23:12]+theta_range;
assign angle_max_choose_tem_phi = angle_max_choose_tem[11:0]+phi_range;

shift_reg #(.shift_num(1),
				.width(24))
			sa(.clk(clk),
			   .rst(rst),
			   .in({angle_min_choose_tem_theta,angle_min_choose_tem_phi}),
				.out(angle_min_choose));
		
shift_reg #(.shift_num(1),
				.width(24))
			sb(.clk(clk),
			   .rst(rst),
			   .in({angle_max_choose_tem_theta,angle_max_choose_tem_phi}),
				.out(angle_max_choose));


always@(posedge clk, negedge rst)
begin
	if(!rst)
	begin
		state <= IDLE; //start from alpha
		stage <= stage1;
		buffer <= 4'd0;
		theta <= theta_min;
		phi <= phi_min;
		alpha <= alpha_min;
	end
	else if(start)
	begin
		state <= next_state;
		stage <= next_stage;
		buffer <= next_buffer;
		theta <= next_theta;
		phi <= next_phi;
		alpha <= next_alpha;
	end
	else
	begin
		state <= state;
		stage <= stage;
		buffer <= buffer;
		theta <= theta;
		phi <= phi;
		alpha <= alpha;
	end
end

// (alpha < 12'd3600 - delta_alpha) ? s_alpha : (phi < phi_max) ? s_phi : (theta < theta_max) ? s_theta : (buffer < buffer_num-1) ? s_buffer : (stage < 3'd3) ? s_stage : s_angle;ji
assign s_alpha_choose = (alpha < 12'd3600 - delta_alpha) ? 1'b1 : 1'b0;
assign s_phi_choose = (phi < phi_max) ? 1'b1 : 1'b0;
assign s_theta_choose = (theta < theta_max) ? 1'b1 : 1'b0;
assign s_buffer_choose = (buffer < buffer_num-1) ? 1'b1 : 1'b0;
assign s_stage_choose = (stage < 3'd3) ? 1'b1 : 1'b0;

always@(*)
begin	
	casex({s_stage_choose,s_buffer_choose,s_theta_choose,s_phi_choose,s_alpha_choose})
		5'bxxxx1:
		begin
			s_choose <= s_alpha;
		end
		5'bxxx10:
		begin
			s_choose <= s_phi;
		end
		5'bxx100:
		begin
			s_choose <= s_theta;
		end
		5'bx1000:
		begin
			s_choose <= s_buffer;
		end
		5'b10000:
		begin
			s_choose <= s_stage;
		end
		5'b00000:
		begin
			s_choose <= s_angle;
		end
		default:
		begin
			s_choose <= state;
		end
	endcase
end



always@(*)
begin
	case(state)
		IDLE: // initial value
		begin
			next_state <= (start) ? s_alpha : state;
			next_stage <= stage1;
			next_buffer <= 4'd0;
			next_theta <= theta_min;
			next_phi <= phi_min;
			next_alpha <= alpha_min;
		end
		s_alpha: //alpha
		begin
			next_state <= s_choose;
			next_stage <= stage;
			next_buffer <= buffer;
			next_theta <= theta;
			next_phi <= phi;
			next_alpha <= alpha + delta_alpha;	
		end
		s_phi: //phi
		begin		
			next_state <= s_alpha;
			next_stage <= stage;
			next_buffer <= buffer;
			next_theta <= theta;
			next_phi <= phi + delta_phi;
			next_alpha <= alpha_min;
		end
		s_theta: //theta
		begin
			next_state <= s_alpha;
			next_stage <= stage;
			next_buffer <= buffer;
			next_theta <= theta + delta_theta;
			next_phi <= phi_min;
			next_alpha <= alpha_min;
		end
		s_buffer: //buffer
		begin
			next_state <= s_alpha;
			next_stage <= stage;
			next_buffer <= buffer + 1'b1;
			next_theta <= theta_min;
			next_phi <= phi_min;
			next_alpha <= alpha_min;
		end	
		s_stage: //stage sort
		begin
			next_state <= (sorted_rdy) ? s_angle : state;
			next_stage <= (sorted_rdy) ? stage+1'b1 : stage;
			next_buffer <= buffer;
			next_theta <= theta;
			next_phi <= phi;
			next_alpha <= alpha;
		end
		s_angle: //
		begin
			next_state <= (stage_trigger_d) ? s_alpha : state;
			next_stage <= stage;
			next_buffer <= (stage_trigger) ? 4'd0 : buffer;
			next_theta <= (stage_trigger_d) ? theta_min : theta;
			next_phi <= (stage_trigger_d) ? phi_min : phi;
			next_alpha <= (stage_trigger_d) ? alpha_min : alpha;
		end
		default:
		begin
			next_state <= state;
			next_stage <= stage;
			next_buffer <= buffer;
			next_theta <= theta;
			next_phi <= phi;
			next_alpha <= alpha;
		end
	endcase
end

always@(*)
begin
	case(stage)
		stage1: //stage1
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
		stage2: //stage2
		begin
			theta_min 		<= angle_min_choose[23:12];//((angle_min_choose[23:12]) > 12'd20) ? angle_min_choose[23:12] - 12'd20 : 12'd0;
			theta_max 		<= angle_max_choose[23:12];//angle_max_choose[23:12] + 12'd20;
			delta_theta 	<= 12'd10;
			phi_min   		<= angle_min_choose[11:0];//((angle_min_choose[11:0]) > 12'd40) ? angle_min_choose[11:0] - 12'd40 : 12'd0;
			phi_max	 		<= angle_max_choose[11:0];//angle_max_choose[11:0] + 12'd40;
			delta_phi		<= 12'd20;
			alpha_min 		<= 12'd60;
			alpha_max 		<= 12'd3600;
			delta_alpha 	<= 12'd60;
			buffer_num		<= 4'd10;
			score_alpha_num <= 9'd60;
			compare_num		<= 4'd6;
		end
		stage3: //stage3
		begin
			theta_min 		<= angle_min_choose[23:12];//((angle_min_choose[23:12]) > 12'd10) ? angle_min_choose[23:12] - 12'd10 : 12'd0;
			theta_max 		<= angle_max_choose[23:12];//angle_max_choose[23:12] + 12'd10;
			delta_theta 	<= 12'd5;
			phi_min   		<= angle_min_choose[11:0];//((angle_min_choose[11:0]) > 12'd20) ? angle_min_choose[11:0] - 12'd20 : 12'd0;
			phi_max	 		<= angle_max_choose[11:0];//angle_max_choose[11:0] + 12'd20;
			delta_phi		<= 12'd10;
			alpha_min 		<= 12'd30;
			alpha_max 		<= 12'd3600;
			delta_alpha 	<= 12'd30;
			buffer_num		<= 4'd6;
			score_alpha_num <= 9'd120;
			compare_num		<= 4'd3;
		end
		stage4: //stage4
		begin
			theta_min 		<= angle_min_choose[23:12];//((angle_min_choose[23:12]) > 12'd2) ? angle_min_choose[23:12] - 12'd2 : 12'd0;
			theta_max 		<= angle_max_choose[23:12];//angle_max_choose[23:12] + 12'd2;
			delta_theta 	<= 12'd1;
			phi_min   		<= angle_min_choose[11:0];//((angle_min_choose[11:0]) > 12'd4) ? angle_min_choose[11:0] - 12'd4 : 12'd0;
			phi_max	 		<= angle_max_choose[11:0];//angle_max_choose[11:0] + 12'd4;
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

endmodule 