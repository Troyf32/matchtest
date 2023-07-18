module sort_5(clk,            				////	use 5 ram copy image
				  rst,
				  theta,
				  phi,
				  score_rdy,
				  score_alpha_num,
				  score,
				  compare_num,
				  if_last_angle, // need to wait until angle arrive sort
				  candidate_angle_buffer);

parameter score_width = 21; // origin 17
parameter compare_width = 8; // origin 8
input clk, rst, score_rdy;
input [11:0] theta;
input [11:0] phi;
input [8:0] score_alpha_num;
//input [16:0] score;
input [score_width-1:0] score;
input [3:0] compare_num;
input if_last_angle;
output reg [24*10-1:0] candidate_angle_buffer;
wire [2:0] angle_shift_choose;
reg [24*10-1:0] angle_buffer;
reg [score_width-1:0] score_tem;
wire [score_width*2-1:0] score_mul;
reg [compare_width-1:0] score_in;
wire [compare_width-1:0] score_in_shift, score_in_shift0, score_in_shift6, score_in_shift3, score_in_shift1;
wire compare_rdy;
wire [3:0] index;
reg[8:0] score_alpha_cnt;
reg compare_data_rdy;
reg [compare_width*10-1:0] score_buffer;
//reg [23:0] angle_top;
//reg [8:0] angle_change_cnt;
wire [23:0] angle_top;
//wire [23:0] angle_top_line [3:0];
wire last_angle_compared, last_angle_compared_d;
reg [1:0] compare_s;

shift_reg #(.shift_num(50),        //need to be adjusted
				.width(24))
		  sa3(.clk(clk),
			   .rst(rst),
			   .in({theta, phi}),
				.out(angle_top));		
				
assign score_mul = {{score_width{1'b0}},score_tem} + {{score_width{1'b0}},score};
	
always@(posedge clk, negedge rst)
begin
	if(!rst)
	begin
		score_tem <= {{score_width{1'b0}}};
		score_alpha_cnt <= 9'd0;
	end
	else if((score_alpha_cnt == 9'd0)&if_last_angle)
	begin
		score_tem <= score;
		score_alpha_cnt <= 9'd0;
	end
	else if(score_alpha_cnt == score_alpha_num-1'b1)
	begin
		score_tem <= score;
		score_alpha_cnt <= 9'd0;
	end
	else if(score_rdy)
	begin
		score_tem <= score_mul[score_width-1:0];
		score_alpha_cnt <= score_alpha_cnt + 1'b1;
	end
	else
	begin
		score_tem <= {{score_width{1'b0}}};
		score_alpha_cnt <= 9'd0;
	end
end

always@(posedge clk, negedge rst) // only compare when alpha circle ready
begin
	if(!rst)
	begin
		compare_data_rdy <= 1'b0;
	end
	else if(score_alpha_cnt == score_alpha_num-1'b1)
	begin
		compare_data_rdy <= 1'b1;
	end
	else if(score_rdy)
	begin
		compare_data_rdy <= 1'b0;
	end
	else
	begin
		compare_data_rdy <= 1'b0;
	end
end

always@(posedge clk, negedge rst)
begin
	if(!rst)
	begin
		score_in <= {{compare_width{1'b0}}};
	end
	else if(score_alpha_cnt == score_alpha_num-1'b1)
	begin
		//score_in <= score_tem[score_width-1-:compare_width];  //// score precision
		score_in <= score_tem[score_width-2-:compare_width];  //// score precision
	end
	else if(score_rdy)
	begin
		score_in <= score_in;
	end
	else
	begin
		score_in <= {{compare_width{1'b0}}};
	end
end

shift_reg #(.shift_num(12),        //compare_num = 10
				.width(compare_width))
			s0(.clk(clk),
			   .rst(rst),
			   .in(score_in),
				.out(score_in_shift0));

shift_reg #(.shift_num(8),        //compare_num = 6
				.width(compare_width))
			s6(.clk(clk),
			   .rst(rst),
			   .in(score_in),
				.out(score_in_shift6));
				
shift_reg #(.shift_num(5),        //compare_num = 3
				.width(compare_width))
			s3(.clk(clk),
			   .rst(rst),
			   .in(score_in),
				.out(score_in_shift3));	

shift_reg #(.shift_num(3),        //compare_num = 1
				.width(compare_width))
			s1(.clk(clk),
			   .rst(rst),
			   .in(score_in),
				.out(score_in_shift1));	

always@(*)
begin
	if(!rst)
	begin
		compare_s <= 2'd0;
	end
	else if(compare_num == 3'd10)
	begin
		compare_s <= 2'd3;
	end
	else if(compare_num == 3'd6)
	begin
		compare_s <= 2'd2;
	end
	else if(compare_num == 3'd3)
	begin
		compare_s <= 2'd1;
	end
	else if(compare_num == 3'd1)
	begin
		compare_s <= 2'd0;
	end
	else
	begin
		compare_s <= compare_s;
	end
end

MUX #(.m(compare_width),   // score_in_shift 8 bit
      .n(4),     // 4 input
      .width(2)) // 2 bit select
  adc(.pdata({score_in_shift0,score_in_shift6,score_in_shift3,score_in_shift1}),
      .s(compare_s),          
      .data_o(score_in_shift));			
				
compare #(.width(compare_width),
			 .quantity(10))//(buffer_next))
		 c1(.clk(clk),
			 .rst(rst),
			 .compare_data_rdy(compare_data_rdy),
			 .score_in(score_in),
			 .score_buffer(score_buffer),
			 .compare_num(compare_num),
			 .compare_rdy(compare_rdy),
			 .insert_index(index));
			 
always@(posedge clk, negedge rst)
begin
	
	if(!rst)//(stage_trigger)
	begin
		score_buffer = {(compare_width*10-1){1'b0}};
		angle_buffer = 240'd0;
	end
	else if(compare_rdy)
	begin
	case(index)
		4'd0 : 
		begin	
			score_buffer <= {score_buffer[compare_width*9-1:0],score_in_shift};
			angle_buffer <= {angle_buffer[24*9-1:0],angle_top};
		end
		4'd1 : 
		begin
			score_buffer <= {score_buffer[compare_width*9-1:compare_width*1],score_in_shift,score_buffer[compare_width*1-1:0]};
			angle_buffer <= {angle_buffer[24*9-1:24*1],angle_top,angle_buffer[24*1-1:0]};
		end
		4'd2 : 
		begin
			score_buffer <= {score_buffer[compare_width*9-1:compare_width*2],score_in_shift,score_buffer[compare_width*2-1:0]};
			angle_buffer <= {angle_buffer[24*9-1:24*2],angle_top,angle_buffer[24*2-1:0]};
		end
		4'd3 : 
		begin
			score_buffer <= {score_buffer[compare_width*9-1:compare_width*3],score_in_shift,score_buffer[compare_width*3-1:0]};
			angle_buffer <= {angle_buffer[24*9-1:24*3],angle_top,angle_buffer[24*3-1:0]};
		end
		4'd4 : 
		begin
			score_buffer <= {score_buffer[compare_width*9-1:compare_width*4],score_in_shift,score_buffer[compare_width*4-1:0]};
			angle_buffer <= {angle_buffer[24*9-1:24*4],angle_top,angle_buffer[24*4-1:0]};
		end
		4'd5 : 
		begin
			score_buffer <= {score_buffer[compare_width*9-1:compare_width*5],score_in_shift,score_buffer[compare_width*5-1:0]};
			angle_buffer <= {angle_buffer[24*9-1:24*5],angle_top,angle_buffer[24*5-1:0]};
		end
		4'd6 : 
		begin
			score_buffer <= {score_buffer[compare_width*9-1:compare_width*6],score_in_shift,score_buffer[compare_width*6-1:0]};
			angle_buffer <= {angle_buffer[24*9-1:24*6],angle_top,angle_buffer[24*6-1:0]};
		end
		4'd7 : 
		begin
			score_buffer <= {score_buffer[compare_width*9-1:compare_width*7],score_in_shift,score_buffer[compare_width*7-1:0]};
			angle_buffer <= {angle_buffer[24*9-1:24*7],angle_top,angle_buffer[24*7-1:0]};
		end
		4'd8 : 
		begin
			score_buffer <= {score_buffer[compare_width*9-1:compare_width*8],score_in_shift,score_buffer[compare_width*8-1:0]};
			angle_buffer <= {angle_buffer[24*9-1:24*8],angle_top,angle_buffer[24*8-1:0]};
		end
		4'd9 : 
		begin
			score_buffer <= {score_in_shift,score_buffer[compare_width*9-1:0]};
			angle_buffer <= {angle_top,angle_buffer[24*9-1:0]};
		end
		default : 
		begin
			score_buffer <= score_buffer;
			angle_buffer <= angle_buffer;
		end
	endcase
	end
	else
	begin
		score_buffer <= score_buffer;
		angle_buffer <= angle_buffer;
	end
end 

assign last_angle_compared = (if_last_angle&(score_alpha_cnt == 9'd0))?1'b1:1'b0;

shift_reg #(.shift_num(2),        //compare_num = 1
				.width(1))
			lc(.clk(clk),
			   .rst(rst),
			   .in(last_angle_compared),
				.out(last_angle_compared_d));	
			
always@(*)
begin
	if(!rst)
	begin
		candidate_angle_buffer <= 240'd0;
	end
	else if(last_angle_compared_d)
	begin
		candidate_angle_buffer <= angle_buffer;
	end
	else
	begin
		candidate_angle_buffer <=candidate_angle_buffer;
	end
end

endmodule