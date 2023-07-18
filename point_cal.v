module point_cal #(parameter width = 14)
					 (
					  input [width-1:0] xc,       //皝脫bits
					  input [width-1:0] yc,
					  input [width-1:0] xb,
					  input [width-1:0] yb,
					  input clk,
					  input rst,
					  output reg [width*4-1:0] new_xi,
					  output reg [width*4-1:0] new_yi,
					  output reg [width*4-1:0] new_xo,
					  output reg [width*4-1:0] new_yo,
					  output reg [width-1:0] xb_o,
					  output reg [width-1:0] yb_o
					  );   
wire [width-1:0] x_dis, y_dis;
wire ifout_line;
wire [9:0] co_value_line, si_value_line;
wire [11:0] degree;
wire [width-1:0] xb_d;
wire [width-1:0] yb_d;
wire [width-1:0] xi_line [3:0], yi_line [3:0];// xi_line_tem [3:0], yi_line_tem [3:0];
wire [width-1:0] xo_line [4:0], yo_line [4:0];
reg [9:0] co_value, si_value;
wire [15:0] co_value_tem0, co_value_tem1, co_value_tem2, co_value_tem3, co_value_tem4, si_value_tem0, si_value_tem1, si_value_tem2, si_value_tem3, si_value_tem4, ex_co_value, ex_si_value;
wire [width-1:0] final_co_value [4:0], final_si_value [4:0];

assign x_dis = (xb-xc);   // {x_dis,y_dis} 剝 
assign y_dis = (yb-yc);

assign ex_co_value = {{6{co_value[9]}},co_value};
assign ex_si_value = {{6{si_value[9]}},si_value};

assign co_value_tem0 = (ex_co_value * 16'd3) ;
assign si_value_tem0 = (ex_si_value * 16'd3) ;
assign co_value_tem1 = (ex_co_value * 16'd6) ;
assign si_value_tem1 = (ex_si_value * 16'd6) ;
assign co_value_tem2 = (ex_co_value * 16'd9) ;
assign si_value_tem2 = (ex_si_value * 16'd9) ;
assign co_value_tem3 = (ex_co_value * 16'd12);
assign si_value_tem3 = (ex_si_value * 16'd12);
assign co_value_tem4 = (ex_co_value * 16'd0);
assign si_value_tem4 = (ex_si_value * 16'd0);

assign final_co_value[0] = {{2{co_value_tem0[15]}},co_value_tem0[15:18-width]};
assign final_si_value[0] = {{2{si_value_tem0[15]}},si_value_tem0[15:18-width]};
assign final_co_value[1] = {{2{co_value_tem1[15]}},co_value_tem1[15:18-width]};
assign final_si_value[1] = {{2{si_value_tem1[15]}},si_value_tem1[15:18-width]};
assign final_co_value[2] = {{2{co_value_tem2[15]}},co_value_tem2[15:18-width]};
assign final_si_value[2] = {{2{si_value_tem2[15]}},si_value_tem2[15:18-width]};
assign final_co_value[3] = {{2{co_value_tem3[15]}},co_value_tem3[15:18-width]};
assign final_si_value[3] = {{2{si_value_tem3[15]}},si_value_tem3[15:18-width]};
assign final_co_value[4] = {{2{co_value_tem4[15]}},co_value_tem4[15:18-width]};
assign final_si_value[4] = {{2{si_value_tem4[15]}},si_value_tem4[15:18-width]};

shift_reg #(.shift_num(3),
				.width(width))
		  rxb(.clk(clk),
			   .rst(rst),
			   .in(xb),
				.out(xb_d));

shift_reg #(.shift_num(3),
				.width(width))
		  ryb(.clk(clk),
			   .rst(rst),
			   .in(yb),
				.out(yb_d));				

assign xo_line[0] = xb_d + final_co_value[0];    // 1 * 3 
assign yo_line[0] = yb_d + final_si_value[0];    // 1 * 3 
assign xi_line[0] = xb_d - final_co_value[0];    // 1 * 3 
assign yi_line[0] = yb_d - final_si_value[0];    // 1 * 3 
assign xo_line[1] = xb_d + final_co_value[1];    // 2 * 3 
assign yo_line[1] = yb_d + final_si_value[1];    // 2 * 3 
assign xi_line[1] = xb_d - final_co_value[1];    // 2 * 3 
assign yi_line[1] = yb_d - final_si_value[1];    // 2 * 3 
assign xo_line[2] = xb_d + final_co_value[2];    // 3 * 3 
assign yo_line[2] = yb_d + final_si_value[2];    // 3 * 3 
assign xi_line[2] = xb_d - final_co_value[2];    // 3 * 3 
assign yi_line[2] = yb_d - final_si_value[2];    // 3 * 3
assign xo_line[3] = xb_d + final_co_value[3];    // 4 * 3 
assign yo_line[3] = yb_d + final_si_value[3];    // 4 * 3
assign xi_line[3] = xb_d - final_co_value[3];    // 4 * 3 
assign yi_line[3] = yb_d - final_si_value[3];    // 4 * 3 
assign xo_line[4] = xb_d + final_co_value[4];    // 0 * 3   
assign yo_line[4] = yb_d + final_si_value[4];    // 0 * 3    

always@(posedge clk, negedge rst)
begin
	if(!rst)
	begin
		//reg0
		co_value <= 10'd0; 
		si_value <= 10'd0;
		//reg1
		new_xo[width-1:0] 			<= {width{1'b0}};
		new_yo[width-1:0] 			<= {width{1'b0}};
		new_xi[width-1:0] 			<= {width{1'b0}};
		new_yi[width-1:0] 			<= {width{1'b0}};
		new_xo[width*2-1:width]		<= {width{1'b0}};
		new_yo[width*2-1:width]		<= {width{1'b0}};
		new_xi[width*2-1:width]		<= {width{1'b0}};
		new_yi[width*2-1:width]		<= {width{1'b0}};
		new_xo[width*3-1:width*2] 	<= {width{1'b0}};
		new_yo[width*3-1:width*2] 	<= {width{1'b0}};
		new_xi[width*3-1:width*2] 	<= {width{1'b0}};
		new_yi[width*3-1:width*2] 	<= {width{1'b0}};
		new_xo[width*4-1:width*3] 	<= {width{1'b0}};
		new_yo[width*4-1:width*3] 	<= {width{1'b0}};
		new_xi[width*4-1:width*3] 	<= {width{1'b0}};
		new_yi[width*4-1:width*3] 	<= {width{1'b0}};
		xb_o <= {width{1'b0}};								
		yb_o <= {width{1'b0}};
	end
	else
	begin
		//reg0
		co_value <= co_value_line; 
		si_value <= si_value_line;
		//reg1
		new_xo[width-1:0] 			<= xo_line[0];
		new_yo[width-1:0] 			<= yo_line[0];
		new_xi[width-1:0] 			<= xi_line[0];
		new_yi[width-1:0] 			<= yi_line[0];
		new_xo[width*2-1:width]		<= xo_line[1];
		new_yo[width*2-1:width]		<= yo_line[1];
		new_xi[width*2-1:width]		<= xi_line[1];
		new_yi[width*2-1:width]		<= yi_line[1];
		new_xo[width*3-1:width*2] 	<= xo_line[2];
		new_yo[width*3-1:width*2] 	<= yo_line[2];
		new_xi[width*3-1:width*2] 	<= xi_line[2];
		new_yi[width*3-1:width*2] 	<= yi_line[2];
		new_xo[width*4-1:width*3] 	<= xo_line[3];
		new_yo[width*4-1:width*3] 	<= yo_line[3];
		new_xi[width*4-1:width*3] 	<= xi_line[3];
		new_yi[width*4-1:width*3] 	<= yi_line[3];
		xb_o <= xo_line[4];								
		yb_o <= yo_line[4];
	end
end


atan at(.y(y_dis[width-1:width-10]),			// 10bits (-512~511)
		  .x(x_dis[width-1:width-10]),			// 10bits (-512~511)
		  .clk(clk),
		  .degree(degree));	// 10bits (0~900) theta 0~90 * 10

trigonometric co(.degree(degree),
					  .clk(clk),
					  .value(co_value_line),
					  .iscos(1'b1));

trigonometric si(.degree(degree),
					  .clk(clk),
					  .value(si_value_line),
					  .iscos(1'b0));

endmodule  