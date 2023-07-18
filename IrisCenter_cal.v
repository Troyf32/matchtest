module IrisCenter_cal #(parameter width = 10)
							  (input [11:0] theta,
							   input [11:0] phi,
								input [12:0] rE, //小數點後4bit
								input [13:0] x,
								input [13:0] y,
								input clk,
								input rst,
								output reg [13:0] iris_center_x,
								output reg [13:0] iris_center_y);

wire [width-1:0] sth_value_line, sph_value_line, cph_value_line;
wire [19:0] stcp_line, stsp_line;
reg [19:0] stcp, stsp;
wire [24:0] x_dis, y_dis;  
wire [13:0] iris_center_x_line, iris_center_y_line;
reg [width-1:0] sth_value, sph_value, cph_value;
reg [12:0] rEr [1:0];
reg [13:0] xr [1:0], yr [1:0];
reg [13:0] iris_center_x_tem [5:0], iris_center_y_tem [5:0];
integer i;

always@(posedge clk, negedge rst)
begin
	if(!rst)
	begin
		sth_value <= {width{1'b0}};
		sph_value <= {width{1'b0}};
		cph_value <= {width{1'b0}};
		rEr[0] <= 13'd0;
		rEr[1] <= 13'd0;
		xr[0] <= 14'd0;
		xr[1] <= 14'd0;
		yr[0] <= 14'd0;
		yr[1] <= 14'd0;
		stcp <= 20'd0;
		stsp <= 20'd0;
		iris_center_x_tem[0] <= 14'd0;
		iris_center_y_tem[0] <= 14'd0;
		for(i=1;i<6;i=i+1)
		begin
			iris_center_x_tem[i] <= 14'd0;
			iris_center_y_tem[i] <= 14'd0;
		end
		iris_center_x <= 14'd0;
		iris_center_y <= 14'd0;
	end
	else
	begin
		sth_value <= sth_value_line;
		sph_value <= sph_value_line;
		cph_value <= cph_value_line;
		rEr[0] <= rE;
		rEr[1] <= rEr[0];
		xr[0] <= x;
		xr[1] <= xr[0];
		yr[0] <= y;
		yr[1] <= yr[0];
		stcp <= stcp_line;
		stsp <= stsp_line;
		iris_center_x_tem[0] <= iris_center_x_line;
		iris_center_y_tem[0] <= iris_center_y_line;
		for(i=1;i<6;i=i+1)
		begin
			iris_center_x_tem[i] <= iris_center_x_tem[i-1];
			iris_center_y_tem[i] <= iris_center_y_tem[i-1];
		end
		iris_center_x <= iris_center_x_tem[5];
		iris_center_y <= iris_center_y_tem[5];
	end
end

assign stcp_line = {{10{sth_value[9]}},sth_value} * {{10{cph_value[9]}},cph_value};
assign stsp_line = {{10{sth_value[9]}},sth_value} * {{10{sph_value[9]}},sph_value};
assign x_dis = {{13{stcp[19]}},stcp[19:8]} * {12'd0,rEr[1]};
assign y_dis = {{13{stsp[19]}},stsp[19:8]} * {12'd0,rEr[1]};
assign iris_center_x_line = xr[1] + x_dis[21:8];
assign iris_center_y_line = yr[1] - y_dis[21:8];

trigonometric sth(.degree(theta),
					   .clk(clk),
					   .value(sth_value_line),
					   .iscos(1'b0));
	
trigonometric sph(.degree(phi),
					   .clk(clk),
					   .value(sph_value_line),
					   .iscos(1'b0));
						
trigonometric cph(.degree(phi),
					   .clk(clk),
					   .value(cph_value_line),
					   .iscos(1'b1));
			 
endmodule 								