module compare#(parameter width = 8,
					 parameter quantity = 10)
					(input clk,
					 input rst,
					 input compare_data_rdy,
					 input [width-1:0] score_in,
					 input [quantity*width-1:0] score_buffer,
					 input [3:0] compare_num,
					 output reg compare_rdy,
					 output [3:0] insert_index);

reg [3:0] index_cnt;
reg [3:0] compare_cnt;
wire [width-1:0] score_buffer_line [quantity-1:0];
integer i;

genvar j;
generate
for(j=0;j<quantity;j=j+1)
begin: d
	assign score_buffer_line[j] = score_buffer[j*width+7-:8];
end
endgenerate
	
always@(posedge clk, negedge rst)
begin
	if(!rst)
	begin
		compare_cnt <= 4'd11;
	end
	else if(compare_data_rdy)
	begin
		compare_cnt <= 4'd0;
	end
	else if(compare_cnt < compare_num)
	begin
		compare_cnt <= compare_cnt + 1'b1;
	end
	else
	begin
		compare_cnt <= 4'd11;
	end
end
	
always@(posedge clk, negedge rst)
begin
	if(!rst)
	begin
		index_cnt <= 4'd0;
	end
	else if(compare_data_rdy)
	begin
		index_cnt <= 4'd0;
	end
	else if(score_in < score_buffer_line[index_cnt])
	begin
		index_cnt <= index_cnt + 1'b1;
	end
	else
	begin
		index_cnt <= index_cnt;
	end
end

always@(posedge clk, negedge rst)
begin
	if(!rst)	
	begin
		compare_rdy <= 1'b0;
	end
	else if(compare_data_rdy)
	begin
		compare_rdy <= 1'b0;
	end
	else if(compare_cnt == compare_num)
	begin
		compare_rdy <= 1'b1;
	end
	else
	begin
		compare_rdy <= 1'b0;
	end
end

assign insert_index = (compare_rdy==1'b1)?index_cnt:4'dx;
			

endmodule