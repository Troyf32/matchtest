module score_cal_point_buffer(clk,
										rst,
										cal_point_rdy,
										data_out_a_tem,
										data_out_b_tem,
										data_out_a_all,
										data_out_b_all);

input clk, rst, cal_point_rdy;
input [7:0] data_out_a_tem, data_out_b_tem;
output reg [39:0] data_out_a_all, data_out_b_all;

reg [1:0] data_delay;
reg [2:0] data_cnt;

always@(posedge clk, negedge rst)
begin
	if(!rst)
	begin
		data_delay[0] <= 1'b0;
		data_delay[1] <= 1'b0;
	end
	else if(cal_point_rdy)
	begin
		data_delay[0] <= cal_point_rdy;
		data_delay[1] <= data_delay[0];
	end
	else
	begin
		data_delay[0] <= data_delay[0];
		data_delay[1] <= data_delay[1];
	end
end

always@(posedge clk, negedge rst)
begin
	if(!rst)
	begin
		data_cnt <= 3'd0;
	end
	else if((data_delay[1])&(data_cnt<3'd4))
	begin
		data_cnt <= data_cnt + 1'b1;
	end
	else
	begin
		data_cnt <= 3'd0;
	end
end

always@(posedge clk, negedge rst)
begin
	if(!rst)
	begin
		data_out_a_all <= 40'd0;
		data_out_b_all <= 40'd0;
	end
	else if(data_delay[1])
	begin
		data_out_a_all[(data_cnt+1)*8-1-:8] <= data_out_a_tem;
		data_out_b_all[(data_cnt+1)*8-1-:8] <= data_out_b_tem;
	end
	else
	begin
		data_out_a_all <= data_out_a_all;
		data_out_b_all <= data_out_b_all;
	end
end
										
endmodule