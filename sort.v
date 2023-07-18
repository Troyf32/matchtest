module sort(clk, 
				rst,
				theta,
				phi,
				score_rdy,
				score_alpha_num,
				score,
				compare_num,
				last_angle, // need to wait until angle arrive sort
				candidate_angle_buffer);
				
input clk, rst, score_rdy;
input [11:0] theta;
input [11:0] phi;
input [8:0] score_alpha_num;
input [16:0] score;
input [3:0] compare_num;
input last_angle;
output reg [24*10-1:0] candidate_angle_buffer;
reg [24*10-1:0] angle_buffer;
reg [16:0] score_tem;
reg [2:0] stall_cnt; //use for waiting
reg [7:0] score_in;  //use only 8 bit to compare
wire compare_rdy;
wire [3:0] index;
reg[8:0] score_alpha_cnt;
reg compare_data_rdy;
reg [8*10-1:0] score_buffer;
wire [23:0] angle_top;
reg score_rdy_flag;
wire last_angle_compared;

shift_reg #(.shift_num(20),
				.width(24))
			sr(.clk(clk),
			   .rst(rst),
			   .in({theta, phi}),
				.out(angle_top));

always@(posedge clk, negedge rst)
begin
	if(!rst)
	begin
		stall_cnt <= 3'd0;
	end
	else if(score_rdy&(stall_cnt<3'd4))
	begin
		stall_cnt <= stall_cnt + 1'b1;
	end
	else
	begin
		stall_cnt <= 3'd0;
	end
end

always@(posedge clk, negedge rst)
begin
	if(!rst)
	begin
		score_tem <= 17'd0;
		score_alpha_cnt <= 9'd0;
	end
	else if((score_alpha_cnt == score_alpha_num)&(stall_cnt == 3'd0))
	begin
		score_tem <= 17'd0 + score;
		score_alpha_cnt <= 9'd0;
	end
	else if(score_rdy&(stall_cnt==3'd0))
	begin
		score_tem <= score_tem + score;
		score_alpha_cnt <= score_alpha_cnt + 1'b1;
	end
	else
	begin
		score_tem <= score_tem;
		score_alpha_cnt <= score_alpha_cnt;
	end
end

always@(posedge clk, negedge rst)
begin
	if(!rst)
	begin
		score_rdy_flag <= score_rdy_flag;
		compare_data_rdy <= 1'b0;
		score_in <= 8'd0;
	end
	else if((score_alpha_cnt == score_alpha_num)&(score_rdy_flag == 1'b0))
	begin
		score_rdy_flag <= 1'b1;
		compare_data_rdy <= 1'b1;
		score_in <= score_tem[16:9];
	end
	else if(score_rdy&(stall_cnt==3'd0))
	begin	
		score_rdy_flag <= 1'b0;
		compare_data_rdy <= 1'b0;
		score_in <= 8'd0;
	end
	else
	begin
		score_rdy_flag <= score_rdy_flag;
		compare_data_rdy <= 1'b0;
		score_in <= score_in;
	end
end

compare #(.width(8),
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
		score_buffer = 80'd0;
		angle_buffer = 240'd0;
	end
	else if(compare_rdy)
	begin
	case(index)
		4'd0 : 
		begin	
			score_buffer <= {score_buffer[8*9-1:0],score_in};
			angle_buffer <= {angle_buffer[24*9-1:0],angle_top};
		end
		4'd1 : 
		begin
			score_buffer <= {score_buffer[8*9-1:8*1],score_in,score_buffer[8*1-1:0]};
			angle_buffer <= {angle_buffer[24*9-1:24*1],angle_top,angle_buffer[24*1-1:0]};
		end
		4'd2 : 
		begin
			score_buffer <= {score_buffer[8*9-1:8*2],score_in,score_buffer[8*2-1:0]};
			angle_buffer <= {angle_buffer[24*9-1:24*2],angle_top,angle_buffer[24*2-1:0]};
		end
		4'd3 : 
		begin
			score_buffer <= {score_buffer[8*9-1:8*3],score_in,score_buffer[8*3-1:0]};
			angle_buffer <= {angle_buffer[24*9-1:24*3],angle_top,angle_buffer[24*3-1:0]};
		end
		4'd4 : 
		begin
			score_buffer <= {score_buffer[8*9-1:8*4],score_in,score_buffer[8*4-1:0]};
			angle_buffer <= {angle_buffer[24*9-1:24*4],angle_top,angle_buffer[24*4-1:0]};
		end
		4'd5 : 
		begin
			score_buffer <= {score_buffer[8*9-1:8*5],score_in,score_buffer[8*5-1:0]};
			angle_buffer <= {angle_buffer[24*9-1:24*5],angle_top,angle_buffer[24*5-1:0]};
		end
		4'd6 : 
		begin
			score_buffer <= {score_buffer[8*9-1:8*6],score_in,score_buffer[8*6-1:0]};
			angle_buffer <= {angle_buffer[24*9-1:24*6],angle_top,angle_buffer[24*6-1:0]};
		end
		4'd7 : 
		begin
			score_buffer <= {score_buffer[8*9-1:8*7],score_in,score_buffer[8*7-1:0]};
			angle_buffer <= {angle_buffer[24*9-1:24*7],angle_top,angle_buffer[24*7-1:0]};
		end
		4'd8 : 
		begin
			score_buffer <= {score_buffer[8*9-1:8*8],score_in,score_buffer[8*8-1:0]};
			angle_buffer <= {angle_buffer[24*9-1:24*8],angle_top,angle_buffer[24*8-1:0]};
		end
		4'd9 : 
		begin
			score_buffer <= {score_in,score_buffer[8*9-1:0]};
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

assign last_angle_compared = (last_angle&compare_rdy)?1'b1:1'b0;
			
always@(posedge clk, negedge rst)
begin
	if(!rst)
	begin
		candidate_angle_buffer <= 240'd0;;
	end
	else if(last_angle_compared)
	begin
		candidate_angle_buffer <= angle_buffer;
	end
	else
	begin
		candidate_angle_buffer <=candidate_angle_buffer;
	end
end

endmodule